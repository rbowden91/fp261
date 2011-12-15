
obj/user/echotest:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL3diePKc>:

const char *msg = "Hello world!\n";

static void
die(const char *m)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  80003a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003e:	c7 04 24 20 43 80 00 	movl   $0x804320,(%esp)
  800045:	e8 d4 02 00 00       	call   80031e <_Z7cprintfPKcz>
	exit();
  80004a:	e8 05 02 00 00       	call   800254 <_Z4exitv>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <_Z5umainiPPc>:

void umain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 5c             	sub    $0x5c,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  80005a:	c7 04 24 24 43 80 00 	movl   $0x804324,(%esp)
  800061:	e8 b8 02 00 00       	call   80031e <_Z7cprintfPKcz>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800066:	c7 04 24 34 43 80 00 	movl   $0x804334,(%esp)
  80006d:	e8 12 40 00 00       	call   804084 <inet_addr>
  800072:	89 44 24 08          	mov    %eax,0x8(%esp)
  800076:	c7 44 24 04 34 43 80 	movl   $0x804334,0x4(%esp)
  80007d:	00 
  80007e:	c7 04 24 3e 43 80 00 	movl   $0x80433e,(%esp)
  800085:	e8 94 02 00 00       	call   80031e <_Z7cprintfPKcz>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  80008a:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800099:	00 
  80009a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8000a1:	e8 ae 35 00 00       	call   803654 <_Z6socketiii>
  8000a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	79 0a                	jns    8000b7 <_Z5umainiPPc+0x66>
		die("Failed to create socket");
  8000ad:	b8 53 43 80 00       	mov    $0x804353,%eax
  8000b2:	e8 7d ff ff ff       	call   800034 <_ZL3diePKc>

	cprintf("opened socket\n");
  8000b7:	c7 04 24 6b 43 80 00 	movl   $0x80436b,(%esp)
  8000be:	e8 5b 02 00 00       	call   80031e <_Z7cprintfPKcz>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8000ca:	00 
  8000cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000d2:	00 
  8000d3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000d6:	89 1c 24             	mov    %ebx,(%esp)
  8000d9:	e8 a3 09 00 00       	call   800a81 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000de:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000e2:	c7 04 24 34 43 80 00 	movl   $0x804334,(%esp)
  8000e9:	e8 96 3f 00 00       	call   804084 <inet_addr>
  8000ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000f1:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000f8:	e8 2c 3d 00 00       	call   803e29 <htons>
  8000fd:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  800101:	c7 04 24 7a 43 80 00 	movl   $0x80437a,(%esp)
  800108:	e8 11 02 00 00       	call   80031e <_Z7cprintfPKcz>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  80010d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800114:	00 
  800115:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800119:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 e3 34 00 00       	call   803607 <_Z7connectiPK8sockaddrj>
  800124:	85 c0                	test   %eax,%eax
  800126:	79 0a                	jns    800132 <_Z5umainiPPc+0xe1>
		die("Failed to connect with server");
  800128:	b8 97 43 80 00       	mov    $0x804397,%eax
  80012d:	e8 02 ff ff ff       	call   800034 <_ZL3diePKc>

	cprintf("connected to server\n");
  800132:	c7 04 24 b5 43 80 00 	movl   $0x8043b5,(%esp)
  800139:	e8 e0 01 00 00       	call   80031e <_Z7cprintfPKcz>

	// Send the word to the server
	echolen = strlen(msg);
  80013e:	a1 00 50 80 00       	mov    0x805000,%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 b5 07 00 00       	call   800900 <_Z6strlenPKc>
  80014b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if ((unsigned int)write(sock, msg, echolen) != echolen)
  80014e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800152:	a1 00 50 80 00       	mov    0x805000,%eax
  800157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80015e:	89 04 24             	mov    %eax,(%esp)
  800161:	e8 13 16 00 00       	call   801779 <_Z5writeiPKvj>
  800166:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  800169:	74 0a                	je     800175 <_Z5umainiPPc+0x124>
		die("Mismatch in number of sent bytes");
  80016b:	b8 e4 43 80 00       	mov    $0x8043e4,%eax
  800170:	e8 bf fe ff ff       	call   800034 <_ZL3diePKc>

	// Receive the word back from the server
	cprintf("Received: \n");
  800175:	c7 04 24 ca 43 80 00 	movl   $0x8043ca,(%esp)
  80017c:	e8 9d 01 00 00       	call   80031e <_Z7cprintfPKcz>
	while ((unsigned int)received < echolen) {
  800181:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  800185:	74 43                	je     8001ca <_Z5umainiPPc+0x179>
{
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800187:	be 00 00 00 00       	mov    $0x0,%esi

	// Receive the word back from the server
	cprintf("Received: \n");
	while ((unsigned int)received < echolen) {
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018c:	8d 7d b8             	lea    -0x48(%ebp),%edi
  80018f:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
  800196:	00 
  800197:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80019b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80019e:	89 04 24             	mov    %eax,(%esp)
  8001a1:	e8 e8 14 00 00       	call   80168e <_Z4readiPvj>
  8001a6:	89 c3                	mov    %eax,%ebx
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	7f 0a                	jg     8001b6 <_Z5umainiPPc+0x165>
			die("Failed to receive bytes from server");
  8001ac:	b8 08 44 80 00       	mov    $0x804408,%eax
  8001b1:	e8 7e fe ff ff       	call   800034 <_ZL3diePKc>
		}
		received += bytes;
  8001b6:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  8001b8:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  8001bd:	89 3c 24             	mov    %edi,(%esp)
  8001c0:	e8 59 01 00 00       	call   80031e <_Z7cprintfPKcz>
	if ((unsigned int)write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while ((unsigned int)received < echolen) {
  8001c5:	39 75 b0             	cmp    %esi,-0x50(%ebp)
  8001c8:	77 c5                	ja     80018f <_Z5umainiPPc+0x13e>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8001ca:	c7 04 24 d4 43 80 00 	movl   $0x8043d4,(%esp)
  8001d1:	e8 48 01 00 00       	call   80031e <_Z7cprintfPKcz>

	close(sock);
  8001d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 04 13 00 00       	call   8014e5 <_Z5closei>
}
  8001e1:	83 c4 5c             	add    $0x5c,%esp
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5f                   	pop    %edi
  8001e7:	5d                   	pop    %ebp
  8001e8:	c3                   	ret    
  8001e9:	00 00                	add    %al,(%eax)
	...

008001ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8001f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8001fb:	e8 b8 0b 00 00       	call   800db8 <_Z12sys_getenvidv>
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	6b c0 78             	imul   $0x78,%eax,%eax
  800208:	05 00 00 00 ef       	add    $0xef000000,%eax
  80020d:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 ff                	test   %edi,%edi
  800214:	7e 07                	jle    80021d <libmain+0x31>
		binaryname = argv[0];
  800216:	8b 06                	mov    (%esi),%eax
  800218:	a3 04 50 80 00       	mov    %eax,0x805004

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80021d:	b8 6d 4f 80 00       	mov    $0x804f6d,%eax
  800222:	3d 6d 4f 80 00       	cmp    $0x804f6d,%eax
  800227:	76 0f                	jbe    800238 <libmain+0x4c>
  800229:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80022b:	83 eb 04             	sub    $0x4,%ebx
  80022e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800230:	81 fb 6d 4f 80 00    	cmp    $0x804f6d,%ebx
  800236:	77 f3                	ja     80022b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800238:	89 74 24 04          	mov    %esi,0x4(%esp)
  80023c:	89 3c 24             	mov    %edi,(%esp)
  80023f:	e8 0d fe ff ff       	call   800051 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800244:	e8 0b 00 00 00       	call   800254 <_Z4exitv>
}
  800249:	83 c4 1c             	add    $0x1c,%esp
  80024c:	5b                   	pop    %ebx
  80024d:	5e                   	pop    %esi
  80024e:	5f                   	pop    %edi
  80024f:	5d                   	pop    %ebp
  800250:	c3                   	ret    
  800251:	00 00                	add    %al,(%eax)
	...

00800254 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80025a:	e8 bf 12 00 00       	call   80151e <_Z9close_allv>
	sys_env_destroy(0);
  80025f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800266:	e8 f0 0a 00 00       	call   800d5b <_Z15sys_env_destroyi>
}
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    
  80026d:	00 00                	add    %al,(%eax)
	...

00800270 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
  800276:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800279:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80027c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80027f:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800281:	8b 03                	mov    (%ebx),%eax
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
  800286:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80028a:	83 c0 01             	add    $0x1,%eax
  80028d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80028f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800294:	75 19                	jne    8002af <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800296:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80029d:	00 
  80029e:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a1:	89 04 24             	mov    %eax,(%esp)
  8002a4:	e8 4b 0a 00 00       	call   800cf4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8002a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002af:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8002b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8002b6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8002b9:	89 ec                	mov    %ebp,%esp
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    

008002bd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cd:	00 00 00 
	b.cnt = 0;
  8002d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f2:	c7 04 24 70 02 80 00 	movl   $0x800270,(%esp)
  8002f9:	e8 a9 01 00 00       	call   8004a7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8002fe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800304:	89 44 24 04          	mov    %eax,0x4(%esp)
  800308:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	e8 de 09 00 00       	call   800cf4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800316:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800324:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	89 04 24             	mov    %eax,(%esp)
  800331:	e8 87 ff ff ff       	call   8002bd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    
	...

00800340 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 4c             	sub    $0x4c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d6                	mov    %edx,%esi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800354:	8b 55 0c             	mov    0xc(%ebp),%edx
  800357:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80035a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80035d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	39 d0                	cmp    %edx,%eax
  800367:	72 11                	jb     80037a <_ZL8printnumPFviPvES_yjii+0x3a>
  800369:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80036c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80036f:	76 09                	jbe    80037a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800371:	83 eb 01             	sub    $0x1,%ebx
  800374:	85 db                	test   %ebx,%ebx
  800376:	7f 5d                	jg     8003d5 <_ZL8printnumPFviPvES_yjii+0x95>
  800378:	eb 6c                	jmp    8003e6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80037e:	83 eb 01             	sub    $0x1,%ebx
  800381:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800385:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800388:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80038c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800390:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800394:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800397:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80039a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003a1:	00 
  8003a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003a5:	89 14 24             	mov    %edx,(%esp)
  8003a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003af:	e8 0c 3d 00 00       	call   8040c0 <__udivdi3>
  8003b4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003b7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003ba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c2:	89 04 24             	mov    %eax,(%esp)
  8003c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c9:	89 f2                	mov    %esi,%edx
  8003cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ce:	e8 6d ff ff ff       	call   800340 <_ZL8printnumPFviPvES_yjii>
  8003d3:	eb 11                	jmp    8003e6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d9:	89 3c 24             	mov    %edi,(%esp)
  8003dc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003df:	83 eb 01             	sub    $0x1,%ebx
  8003e2:	85 db                	test   %ebx,%ebx
  8003e4:	7f ef                	jg     8003d5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003ea:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003fc:	00 
  8003fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800400:	89 14 24             	mov    %edx,(%esp)
  800403:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800406:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80040a:	e8 c1 3d 00 00       	call   8041d0 <__umoddi3>
  80040f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800413:	0f be 80 36 44 80 00 	movsbl 0x804436(%eax),%eax
  80041a:	89 04 24             	mov    %eax,(%esp)
  80041d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800420:	83 c4 4c             	add    $0x4c,%esp
  800423:	5b                   	pop    %ebx
  800424:	5e                   	pop    %esi
  800425:	5f                   	pop    %edi
  800426:	5d                   	pop    %ebp
  800427:	c3                   	ret    

00800428 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042b:	83 fa 01             	cmp    $0x1,%edx
  80042e:	7e 0e                	jle    80043e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800430:	8b 10                	mov    (%eax),%edx
  800432:	8d 4a 08             	lea    0x8(%edx),%ecx
  800435:	89 08                	mov    %ecx,(%eax)
  800437:	8b 02                	mov    (%edx),%eax
  800439:	8b 52 04             	mov    0x4(%edx),%edx
  80043c:	eb 22                	jmp    800460 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80043e:	85 d2                	test   %edx,%edx
  800440:	74 10                	je     800452 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800442:	8b 10                	mov    (%eax),%edx
  800444:	8d 4a 04             	lea    0x4(%edx),%ecx
  800447:	89 08                	mov    %ecx,(%eax)
  800449:	8b 02                	mov    (%edx),%eax
  80044b:	ba 00 00 00 00       	mov    $0x0,%edx
  800450:	eb 0e                	jmp    800460 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800452:	8b 10                	mov    (%eax),%edx
  800454:	8d 4a 04             	lea    0x4(%edx),%ecx
  800457:	89 08                	mov    %ecx,(%eax)
  800459:	8b 02                	mov    (%edx),%eax
  80045b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800468:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046c:	8b 10                	mov    (%eax),%edx
  80046e:	3b 50 04             	cmp    0x4(%eax),%edx
  800471:	73 0a                	jae    80047d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800473:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800476:	88 0a                	mov    %cl,(%edx)
  800478:	83 c2 01             	add    $0x1,%edx
  80047b:	89 10                	mov    %edx,(%eax)
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800485:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800488:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 04 24             	mov    %eax,(%esp)
  8004a0:	e8 02 00 00 00       	call   8004a7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	57                   	push   %edi
  8004ab:	56                   	push   %esi
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 3c             	sub    $0x3c,%esp
  8004b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8004b6:	0f b6 02             	movzbl (%edx),%eax
  8004b9:	89 d3                	mov    %edx,%ebx
  8004bb:	83 c3 01             	add    $0x1,%ebx
  8004be:	83 f8 25             	cmp    $0x25,%eax
  8004c1:	74 2b                	je     8004ee <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	75 10                	jne    8004d7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8004c7:	e9 a5 03 00 00       	jmp    800871 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	66 90                	xchg   %ax,%ax
  8004d0:	75 08                	jne    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8004d2:	e9 9a 03 00 00       	jmp    800871 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004d7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8004da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e3:	0f b6 03             	movzbl (%ebx),%eax
  8004e6:	83 c3 01             	add    $0x1,%ebx
  8004e9:	83 f8 25             	cmp    $0x25,%eax
  8004ec:	75 de                	jne    8004cc <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004ee:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800505:	b9 00 00 00 00       	mov    $0x0,%ecx
  80050a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80050d:	eb 2b                	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800512:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800516:	eb 22                	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800518:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80051b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80051f:	eb 19                	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800521:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800524:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80052b:	eb 0d                	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80052d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800530:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800533:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	0f b6 03             	movzbl (%ebx),%eax
  80053d:	0f b6 d0             	movzbl %al,%edx
  800540:	8d 73 01             	lea    0x1(%ebx),%esi
  800543:	89 75 10             	mov    %esi,0x10(%ebp)
  800546:	83 e8 23             	sub    $0x23,%eax
  800549:	3c 55                	cmp    $0x55,%al
  80054b:	0f 87 d8 02 00 00    	ja     800829 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800551:	0f b6 c0             	movzbl %al,%eax
  800554:	ff 24 85 e0 45 80 00 	jmp    *0x8045e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80055b:	83 ea 30             	sub    $0x30,%edx
  80055e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800561:	8b 55 10             	mov    0x10(%ebp),%edx
  800564:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800567:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80056d:	83 fa 09             	cmp    $0x9,%edx
  800570:	77 4e                	ja     8005c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800575:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800578:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80057b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80057f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800582:	8d 50 d0             	lea    -0x30(%eax),%edx
  800585:	83 fa 09             	cmp    $0x9,%edx
  800588:	76 eb                	jbe    800575 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80058a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80058d:	eb 31                	jmp    8005c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	89 55 14             	mov    %edx,0x14(%ebp)
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005a0:	eb 1e                	jmp    8005c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8005a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a6:	0f 88 75 ff ff ff    	js     800521 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005af:	eb 89                	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005b4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005bb:	e9 7a ff ff ff       	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c4:	0f 89 70 ff ff ff    	jns    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005ca:	e9 5e ff ff ff       	jmp    80052d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005cf:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005d5:	e9 60 ff ff ff       	jmp    80053a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8d 50 04             	lea    0x4(%eax),%edx
  8005e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 04 24             	mov    %eax,(%esp)
  8005ec:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005ef:	e9 bf fe ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 c2                	mov    %eax,%edx
  800601:	c1 fa 1f             	sar    $0x1f,%edx
  800604:	31 d0                	xor    %edx,%eax
  800606:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800608:	83 f8 14             	cmp    $0x14,%eax
  80060b:	7f 0f                	jg     80061c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80060d:	8b 14 85 40 47 80 00 	mov    0x804740(,%eax,4),%edx
  800614:	85 d2                	test   %edx,%edx
  800616:	0f 85 35 02 00 00    	jne    800851 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80061c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800620:	c7 44 24 08 4e 44 80 	movl   $0x80444e,0x8(%esp)
  800627:	00 
  800628:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062c:	8b 75 08             	mov    0x8(%ebp),%esi
  80062f:	89 34 24             	mov    %esi,(%esp)
  800632:	e8 48 fe ff ff       	call   80047f <_Z8printfmtPFviPvES_PKcz>
  800637:	e9 77 fe ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80063c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 50 04             	lea    0x4(%eax),%edx
  80064b:	89 55 14             	mov    %edx,0x14(%ebp)
  80064e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800650:	85 db                	test   %ebx,%ebx
  800652:	ba 47 44 80 00       	mov    $0x804447,%edx
  800657:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80065a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065e:	7e 72                	jle    8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800660:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800664:	74 6c                	je     8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80066a:	89 1c 24             	mov    %ebx,(%esp)
  80066d:	e8 a9 02 00 00       	call   80091b <_Z7strnlenPKcj>
  800672:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80067a:	85 d2                	test   %edx,%edx
  80067c:	7e 54                	jle    8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80067e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800682:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800685:	89 d3                	mov    %edx,%ebx
  800687:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80068a:	89 c6                	mov    %eax,%esi
  80068c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800690:	89 34 24             	mov    %esi,(%esp)
  800693:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800696:	83 eb 01             	sub    $0x1,%ebx
  800699:	85 db                	test   %ebx,%ebx
  80069b:	7f ef                	jg     80068c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80069d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006aa:	eb 26                	jmp    8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006ac:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006af:	83 fa 5e             	cmp    $0x5e,%edx
  8006b2:	76 10                	jbe    8006c4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8006b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006bf:	ff 55 08             	call   *0x8(%ebp)
  8006c2:	eb 0a                	jmp    8006ce <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8006c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c8:	89 04 24             	mov    %eax,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ce:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006d2:	0f be 03             	movsbl (%ebx),%eax
  8006d5:	83 c3 01             	add    $0x1,%ebx
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	74 11                	je     8006ed <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  8006dc:	85 f6                	test   %esi,%esi
  8006de:	78 05                	js     8006e5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8006e0:	83 ee 01             	sub    $0x1,%esi
  8006e3:	78 0d                	js     8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e9:	75 c1                	jne    8006ac <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8006eb:	eb d7                	jmp    8006c4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	eb 03                	jmp    8006f5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8006f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	0f 8e b6 fd ff ff    	jle    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8006fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800700:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800703:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800707:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80070e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800710:	83 eb 01             	sub    $0x1,%ebx
  800713:	85 db                	test   %ebx,%ebx
  800715:	7f ec                	jg     800703 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800717:	e9 97 fd ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80071c:	83 f9 01             	cmp    $0x1,%ecx
  80071f:	90                   	nop
  800720:	7e 10                	jle    800732 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 50 08             	lea    0x8(%eax),%edx
  800728:	89 55 14             	mov    %edx,0x14(%ebp)
  80072b:	8b 18                	mov    (%eax),%ebx
  80072d:	8b 70 04             	mov    0x4(%eax),%esi
  800730:	eb 26                	jmp    800758 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	74 12                	je     800748 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8d 50 04             	lea    0x4(%eax),%edx
  80073c:	89 55 14             	mov    %edx,0x14(%ebp)
  80073f:	8b 18                	mov    (%eax),%ebx
  800741:	89 de                	mov    %ebx,%esi
  800743:	c1 fe 1f             	sar    $0x1f,%esi
  800746:	eb 10                	jmp    800758 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	89 55 14             	mov    %edx,0x14(%ebp)
  800751:	8b 18                	mov    (%eax),%ebx
  800753:	89 de                	mov    %ebx,%esi
  800755:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800758:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80075d:	85 f6                	test   %esi,%esi
  80075f:	0f 89 8c 00 00 00    	jns    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800765:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800769:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800770:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800773:	f7 db                	neg    %ebx
  800775:	83 d6 00             	adc    $0x0,%esi
  800778:	f7 de                	neg    %esi
			}
			base = 10;
  80077a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077f:	eb 70                	jmp    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800781:	89 ca                	mov    %ecx,%edx
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	e8 9d fc ff ff       	call   800428 <_ZL7getuintPPci>
  80078b:	89 c3                	mov    %eax,%ebx
  80078d:	89 d6                	mov    %edx,%esi
			base = 10;
  80078f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800794:	eb 5b                	jmp    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800796:	89 ca                	mov    %ecx,%edx
  800798:	8d 45 14             	lea    0x14(%ebp),%eax
  80079b:	e8 88 fc ff ff       	call   800428 <_ZL7getuintPPci>
  8007a0:	89 c3                	mov    %eax,%ebx
  8007a2:	89 d6                	mov    %edx,%esi
			base = 8;
  8007a4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007a9:	eb 46                	jmp    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007af:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007b6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007c4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d0:	8b 18                	mov    (%eax),%ebx
  8007d2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  8007d7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007dc:	eb 13                	jmp    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007de:	89 ca                	mov    %ecx,%edx
  8007e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e3:	e8 40 fc ff ff       	call   800428 <_ZL7getuintPPci>
  8007e8:	89 c3                	mov    %eax,%ebx
  8007ea:	89 d6                	mov    %edx,%esi
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007f5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800800:	89 44 24 08          	mov    %eax,0x8(%esp)
  800804:	89 1c 24             	mov    %ebx,(%esp)
  800807:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080b:	89 fa                	mov    %edi,%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	e8 2b fb ff ff       	call   800340 <_ZL8printnumPFviPvES_yjii>
			break;
  800815:	e9 99 fc ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081e:	89 14 24             	mov    %edx,(%esp)
  800821:	ff 55 08             	call   *0x8(%ebp)
			break;
  800824:	e9 8a fc ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800829:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800834:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800837:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80083a:	89 d8                	mov    %ebx,%eax
  80083c:	eb 02                	jmp    800840 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80083e:	89 d0                	mov    %edx,%eax
  800840:	8d 50 ff             	lea    -0x1(%eax),%edx
  800843:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800847:	75 f5                	jne    80083e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800849:	89 45 10             	mov    %eax,0x10(%ebp)
  80084c:	e9 62 fc ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800851:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800855:	c7 44 24 08 de 47 80 	movl   $0x8047de,0x8(%esp)
  80085c:	00 
  80085d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800861:	8b 75 08             	mov    0x8(%ebp),%esi
  800864:	89 34 24             	mov    %esi,(%esp)
  800867:	e8 13 fc ff ff       	call   80047f <_Z8printfmtPFviPvES_PKcz>
  80086c:	e9 42 fc ff ff       	jmp    8004b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800871:	83 c4 3c             	add    $0x3c,%esp
  800874:	5b                   	pop    %ebx
  800875:	5e                   	pop    %esi
  800876:	5f                   	pop    %edi
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 28             	sub    $0x28,%esp
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800885:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80088c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800893:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800896:	85 c0                	test   %eax,%eax
  800898:	74 30                	je     8008ca <_Z9vsnprintfPciPKcS_+0x51>
  80089a:	85 d2                	test   %edx,%edx
  80089c:	7e 2c                	jle    8008ca <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b3:	c7 04 24 62 04 80 00 	movl   $0x800462,(%esp)
  8008ba:	e8 e8 fb ff ff       	call   8004a7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8008bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c8:	eb 05                	jmp    8008cf <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 04 24             	mov    %eax,(%esp)
  8008f2:	e8 82 ff ff ff       	call   800879 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    
  8008f9:	00 00                	add    %al,(%eax)
  8008fb:	00 00                	add    %al,(%eax)
  8008fd:	00 00                	add    %al,(%eax)
	...

00800900 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	80 3a 00             	cmpb   $0x0,(%edx)
  80090e:	74 09                	je     800919 <_Z6strlenPKc+0x19>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800917:	75 f7                	jne    800910 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	74 0b                	je     800938 <_Z7strnlenPKcj+0x1d>
  80092d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800931:	74 05                	je     800938 <_Z7strnlenPKcj+0x1d>
		n++;
  800933:	83 c0 01             	add    $0x1,%eax
  800936:	eb f1                	jmp    800929 <_Z7strnlenPKcj+0xe>
	return n;
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800944:	ba 00 00 00 00       	mov    $0x0,%edx
  800949:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800950:	83 c2 01             	add    $0x1,%edx
  800953:	84 c9                	test   %cl,%cl
  800955:	75 f2                	jne    800949 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
  800965:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800968:	85 f6                	test   %esi,%esi
  80096a:	74 18                	je     800984 <_Z7strncpyPcPKcj+0x2a>
  80096c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800971:	0f b6 1a             	movzbl (%edx),%ebx
  800974:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800977:	80 3a 01             	cmpb   $0x1,(%edx)
  80097a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80097d:	83 c1 01             	add    $0x1,%ecx
  800980:	39 ce                	cmp    %ecx,%esi
  800982:	77 ed                	ja     800971 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	8b 75 08             	mov    0x8(%ebp),%esi
  800990:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800993:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800996:	89 f0                	mov    %esi,%eax
  800998:	85 d2                	test   %edx,%edx
  80099a:	74 17                	je     8009b3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80099c:	83 ea 01             	sub    $0x1,%edx
  80099f:	74 18                	je     8009b9 <_Z7strlcpyPcPKcj+0x31>
  8009a1:	80 39 00             	cmpb   $0x0,(%ecx)
  8009a4:	74 17                	je     8009bd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8009a6:	0f b6 19             	movzbl (%ecx),%ebx
  8009a9:	88 18                	mov    %bl,(%eax)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	83 c1 01             	add    $0x1,%ecx
  8009b1:	eb e9                	jmp    80099c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8009b3:	29 f0                	sub    %esi,%eax
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009b9:	89 c2                	mov    %eax,%edx
  8009bb:	eb 02                	jmp    8009bf <_Z7strlcpyPcPKcj+0x37>
  8009bd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009bf:	c6 02 00             	movb   $0x0,(%edx)
  8009c2:	eb ef                	jmp    8009b3 <_Z7strlcpyPcPKcj+0x2b>

008009c4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009cd:	0f b6 01             	movzbl (%ecx),%eax
  8009d0:	84 c0                	test   %al,%al
  8009d2:	74 0c                	je     8009e0 <_Z6strcmpPKcS0_+0x1c>
  8009d4:	3a 02                	cmp    (%edx),%al
  8009d6:	75 08                	jne    8009e0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  8009d8:	83 c1 01             	add    $0x1,%ecx
  8009db:	83 c2 01             	add    $0x1,%edx
  8009de:	eb ed                	jmp    8009cd <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  8009e0:	0f b6 c0             	movzbl %al,%eax
  8009e3:	0f b6 12             	movzbl (%edx),%edx
  8009e6:	29 d0                	sub    %edx,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	53                   	push   %ebx
  8009ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009f4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009f7:	85 d2                	test   %edx,%edx
  8009f9:	74 16                	je     800a11 <_Z7strncmpPKcS0_j+0x27>
  8009fb:	0f b6 01             	movzbl (%ecx),%eax
  8009fe:	84 c0                	test   %al,%al
  800a00:	74 17                	je     800a19 <_Z7strncmpPKcS0_j+0x2f>
  800a02:	3a 03                	cmp    (%ebx),%al
  800a04:	75 13                	jne    800a19 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800a06:	83 ea 01             	sub    $0x1,%edx
  800a09:	83 c1 01             	add    $0x1,%ecx
  800a0c:	83 c3 01             	add    $0x1,%ebx
  800a0f:	eb e6                	jmp    8009f7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800a16:	5b                   	pop    %ebx
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800a19:	0f b6 01             	movzbl (%ecx),%eax
  800a1c:	0f b6 13             	movzbl (%ebx),%edx
  800a1f:	29 d0                	sub    %edx,%eax
  800a21:	eb f3                	jmp    800a16 <_Z7strncmpPKcS0_j+0x2c>

00800a23 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2d:	0f b6 10             	movzbl (%eax),%edx
  800a30:	84 d2                	test   %dl,%dl
  800a32:	74 1f                	je     800a53 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800a34:	38 ca                	cmp    %cl,%dl
  800a36:	75 0a                	jne    800a42 <_Z6strchrPKcc+0x1f>
  800a38:	eb 1e                	jmp    800a58 <_Z6strchrPKcc+0x35>
  800a3a:	38 ca                	cmp    %cl,%dl
  800a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a40:	74 16                	je     800a58 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	0f b6 10             	movzbl (%eax),%edx
  800a48:	84 d2                	test   %dl,%dl
  800a4a:	75 ee                	jne    800a3a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	eb 05                	jmp    800a58 <_Z6strchrPKcc+0x35>
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	0f b6 10             	movzbl (%eax),%edx
  800a67:	84 d2                	test   %dl,%dl
  800a69:	74 14                	je     800a7f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800a6b:	38 ca                	cmp    %cl,%dl
  800a6d:	75 06                	jne    800a75 <_Z7strfindPKcc+0x1b>
  800a6f:	eb 0e                	jmp    800a7f <_Z7strfindPKcc+0x25>
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 0a                	je     800a7f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	0f b6 10             	movzbl (%eax),%edx
  800a7b:	84 d2                	test   %dl,%dl
  800a7d:	75 f2                	jne    800a71 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	89 1c 24             	mov    %ebx,(%esp)
  800a8a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800a9b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aa1:	75 25                	jne    800ac8 <memset+0x47>
  800aa3:	f6 c1 03             	test   $0x3,%cl
  800aa6:	75 20                	jne    800ac8 <memset+0x47>
		c &= 0xFF;
  800aa8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aab:	89 d3                	mov    %edx,%ebx
  800aad:	c1 e3 08             	shl    $0x8,%ebx
  800ab0:	89 d6                	mov    %edx,%esi
  800ab2:	c1 e6 18             	shl    $0x18,%esi
  800ab5:	89 d0                	mov    %edx,%eax
  800ab7:	c1 e0 10             	shl    $0x10,%eax
  800aba:	09 f0                	or     %esi,%eax
  800abc:	09 d0                	or     %edx,%eax
  800abe:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800ac0:	c1 e9 02             	shr    $0x2,%ecx
  800ac3:	fc                   	cld    
  800ac4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac6:	eb 03                	jmp    800acb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800ac8:	fc                   	cld    
  800ac9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800acb:	89 f8                	mov    %edi,%eax
  800acd:	8b 1c 24             	mov    (%esp),%ebx
  800ad0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ad4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ad8:	89 ec                	mov    %ebp,%esp
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	89 34 24             	mov    %esi,(%esp)
  800ae5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800af2:	39 c6                	cmp    %eax,%esi
  800af4:	73 36                	jae    800b2c <memmove+0x50>
  800af6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af9:	39 d0                	cmp    %edx,%eax
  800afb:	73 2f                	jae    800b2c <memmove+0x50>
		s += n;
		d += n;
  800afd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b00:	f6 c2 03             	test   $0x3,%dl
  800b03:	75 1b                	jne    800b20 <memmove+0x44>
  800b05:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0b:	75 13                	jne    800b20 <memmove+0x44>
  800b0d:	f6 c1 03             	test   $0x3,%cl
  800b10:	75 0e                	jne    800b20 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b12:	83 ef 04             	sub    $0x4,%edi
  800b15:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b18:	c1 e9 02             	shr    $0x2,%ecx
  800b1b:	fd                   	std    
  800b1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1e:	eb 09                	jmp    800b29 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b20:	83 ef 01             	sub    $0x1,%edi
  800b23:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b26:	fd                   	std    
  800b27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b29:	fc                   	cld    
  800b2a:	eb 20                	jmp    800b4c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b2c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b32:	75 13                	jne    800b47 <memmove+0x6b>
  800b34:	a8 03                	test   $0x3,%al
  800b36:	75 0f                	jne    800b47 <memmove+0x6b>
  800b38:	f6 c1 03             	test   $0x3,%cl
  800b3b:	75 0a                	jne    800b47 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3d:	c1 e9 02             	shr    $0x2,%ecx
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	fc                   	cld    
  800b43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b45:	eb 05                	jmp    800b4c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b47:	89 c7                	mov    %eax,%edi
  800b49:	fc                   	cld    
  800b4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b4c:	8b 34 24             	mov    (%esp),%esi
  800b4f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b53:	89 ec                	mov    %ebp,%esp
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	89 34 24             	mov    %esi,(%esp)
  800b60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b73:	75 13                	jne    800b88 <memcpy+0x31>
  800b75:	a8 03                	test   $0x3,%al
  800b77:	75 0f                	jne    800b88 <memcpy+0x31>
  800b79:	f6 c1 03             	test   $0x3,%cl
  800b7c:	75 0a                	jne    800b88 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7e:	c1 e9 02             	shr    $0x2,%ecx
  800b81:	89 c7                	mov    %eax,%edi
  800b83:	fc                   	cld    
  800b84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b86:	eb 05                	jmp    800b8d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b88:	89 c7                	mov    %eax,%edi
  800b8a:	fc                   	cld    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800b8d:	8b 34 24             	mov    (%esp),%esi
  800b90:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b94:	89 ec                	mov    %ebp,%esp
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ba1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bac:	85 ff                	test   %edi,%edi
  800bae:	74 38                	je     800be8 <memcmp+0x50>
		if (*s1 != *s2)
  800bb0:	0f b6 03             	movzbl (%ebx),%eax
  800bb3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bb6:	83 ef 01             	sub    $0x1,%edi
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800bbe:	38 c8                	cmp    %cl,%al
  800bc0:	74 1d                	je     800bdf <memcmp+0x47>
  800bc2:	eb 11                	jmp    800bd5 <memcmp+0x3d>
  800bc4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bc9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	38 c8                	cmp    %cl,%al
  800bd3:	74 0a                	je     800bdf <memcmp+0x47>
			return *s1 - *s2;
  800bd5:	0f b6 c0             	movzbl %al,%eax
  800bd8:	0f b6 c9             	movzbl %cl,%ecx
  800bdb:	29 c8                	sub    %ecx,%eax
  800bdd:	eb 09                	jmp    800be8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bdf:	39 fa                	cmp    %edi,%edx
  800be1:	75 e1                	jne    800bc4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	53                   	push   %ebx
  800bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800bf4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800bf6:	89 da                	mov    %ebx,%edx
  800bf8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800bfb:	39 d3                	cmp    %edx,%ebx
  800bfd:	73 15                	jae    800c14 <memfind+0x27>
		if (*s == (unsigned char) c)
  800bff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c03:	38 0b                	cmp    %cl,(%ebx)
  800c05:	75 06                	jne    800c0d <memfind+0x20>
  800c07:	eb 0b                	jmp    800c14 <memfind+0x27>
  800c09:	38 08                	cmp    %cl,(%eax)
  800c0b:	74 07                	je     800c14 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800c0d:	83 c0 01             	add    $0x1,%eax
  800c10:	39 c2                	cmp    %eax,%edx
  800c12:	77 f5                	ja     800c09 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c14:	5b                   	pop    %ebx
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c23:	0f b6 02             	movzbl (%edx),%eax
  800c26:	3c 20                	cmp    $0x20,%al
  800c28:	74 04                	je     800c2e <_Z6strtolPKcPPci+0x17>
  800c2a:	3c 09                	cmp    $0x9,%al
  800c2c:	75 0e                	jne    800c3c <_Z6strtolPKcPPci+0x25>
		s++;
  800c2e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c31:	0f b6 02             	movzbl (%edx),%eax
  800c34:	3c 20                	cmp    $0x20,%al
  800c36:	74 f6                	je     800c2e <_Z6strtolPKcPPci+0x17>
  800c38:	3c 09                	cmp    $0x9,%al
  800c3a:	74 f2                	je     800c2e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c3c:	3c 2b                	cmp    $0x2b,%al
  800c3e:	75 0a                	jne    800c4a <_Z6strtolPKcPPci+0x33>
		s++;
  800c40:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c43:	bf 00 00 00 00       	mov    $0x0,%edi
  800c48:	eb 10                	jmp    800c5a <_Z6strtolPKcPPci+0x43>
  800c4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c4f:	3c 2d                	cmp    $0x2d,%al
  800c51:	75 07                	jne    800c5a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800c53:	83 c2 01             	add    $0x1,%edx
  800c56:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	0f 94 c0             	sete   %al
  800c5f:	74 05                	je     800c66 <_Z6strtolPKcPPci+0x4f>
  800c61:	83 fb 10             	cmp    $0x10,%ebx
  800c64:	75 15                	jne    800c7b <_Z6strtolPKcPPci+0x64>
  800c66:	80 3a 30             	cmpb   $0x30,(%edx)
  800c69:	75 10                	jne    800c7b <_Z6strtolPKcPPci+0x64>
  800c6b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c6f:	75 0a                	jne    800c7b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800c71:	83 c2 02             	add    $0x2,%edx
  800c74:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c79:	eb 13                	jmp    800c8e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800c7b:	84 c0                	test   %al,%al
  800c7d:	74 0f                	je     800c8e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c7f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c84:	80 3a 30             	cmpb   $0x30,(%edx)
  800c87:	75 05                	jne    800c8e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800c89:	83 c2 01             	add    $0x1,%edx
  800c8c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c93:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c95:	0f b6 0a             	movzbl (%edx),%ecx
  800c98:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c9b:	80 fb 09             	cmp    $0x9,%bl
  800c9e:	77 08                	ja     800ca8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800ca0:	0f be c9             	movsbl %cl,%ecx
  800ca3:	83 e9 30             	sub    $0x30,%ecx
  800ca6:	eb 1e                	jmp    800cc6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ca8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800cab:	80 fb 19             	cmp    $0x19,%bl
  800cae:	77 08                	ja     800cb8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800cb0:	0f be c9             	movsbl %cl,%ecx
  800cb3:	83 e9 57             	sub    $0x57,%ecx
  800cb6:	eb 0e                	jmp    800cc6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800cb8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800cbb:	80 fb 19             	cmp    $0x19,%bl
  800cbe:	77 15                	ja     800cd5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800cc0:	0f be c9             	movsbl %cl,%ecx
  800cc3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cc6:	39 f1                	cmp    %esi,%ecx
  800cc8:	7d 0f                	jge    800cd9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800cca:	83 c2 01             	add    $0x1,%edx
  800ccd:	0f af c6             	imul   %esi,%eax
  800cd0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800cd3:	eb c0                	jmp    800c95 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800cd5:	89 c1                	mov    %eax,%ecx
  800cd7:	eb 02                	jmp    800cdb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cd9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 05                	je     800ce6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800ce1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ce4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ce6:	89 ca                	mov    %ecx,%edx
  800ce8:	f7 da                	neg    %edx
  800cea:	85 ff                	test   %edi,%edi
  800cec:	0f 45 c2             	cmovne %edx,%eax
}
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	89 1c 24             	mov    %ebx,(%esp)
  800cfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d01:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d05:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	89 c3                	mov    %eax,%ebx
  800d12:	89 c7                	mov    %eax,%edi
  800d14:	89 c6                	mov    %eax,%esi
  800d16:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d18:	8b 1c 24             	mov    (%esp),%ebx
  800d1b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d1f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d23:	89 ec                	mov    %ebp,%esp
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 0c             	sub    $0xc,%esp
  800d2d:	89 1c 24             	mov    %ebx,(%esp)
  800d30:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d34:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d38:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d42:	89 d1                	mov    %edx,%ecx
  800d44:	89 d3                	mov    %edx,%ebx
  800d46:	89 d7                	mov    %edx,%edi
  800d48:	89 d6                	mov    %edx,%esi
  800d4a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4c:	8b 1c 24             	mov    (%esp),%ebx
  800d4f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d53:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d57:	89 ec                	mov    %ebp,%esp
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 38             	sub    $0x38,%esp
  800d61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d67:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	89 cb                	mov    %ecx,%ebx
  800d79:	89 cf                	mov    %ecx,%edi
  800d7b:	89 ce                	mov    %ecx,%esi
  800d7d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7e 28                	jle    800dab <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d87:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800d96:	00 
  800d97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9e:	00 
  800d9f:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800da6:	e8 11 2d 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db4:	89 ec                	mov    %ebp,%esp
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	89 1c 24             	mov    %ebx,(%esp)
  800dc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dce:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd3:	89 d1                	mov    %edx,%ecx
  800dd5:	89 d3                	mov    %edx,%ebx
  800dd7:	89 d7                	mov    %edx,%edi
  800dd9:	89 d6                	mov    %edx,%esi
  800ddb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ddd:	8b 1c 24             	mov    (%esp),%ebx
  800de0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800de4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800de8:	89 ec                	mov    %ebp,%esp
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	89 1c 24             	mov    %ebx,(%esp)
  800df5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800df9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800e02:	b8 04 00 00 00       	mov    $0x4,%eax
  800e07:	89 d1                	mov    %edx,%ecx
  800e09:	89 d3                	mov    %edx,%ebx
  800e0b:	89 d7                	mov    %edx,%edi
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e11:	8b 1c 24             	mov    (%esp),%ebx
  800e14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e1c:	89 ec                	mov    %ebp,%esp
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 38             	sub    $0x38,%esp
  800e26:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e29:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e2f:	be 00 00 00 00       	mov    $0x0,%esi
  800e34:	b8 08 00 00 00       	mov    $0x8,%eax
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 f7                	mov    %esi,%edi
  800e44:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7e 28                	jle    800e72 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e55:	00 
  800e56:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800e5d:	00 
  800e5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e65:	00 
  800e66:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800e6d:	e8 4a 2c 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e7b:	89 ec                	mov    %ebp,%esp
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 38             	sub    $0x38,%esp
  800e85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e93:	8b 75 18             	mov    0x18(%ebp),%esi
  800e96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7e 28                	jle    800ed0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eac:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eb3:	00 
  800eb4:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec3:	00 
  800ec4:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800ecb:	e8 ec 2b 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ed0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed9:	89 ec                	mov    %ebp,%esp
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 38             	sub    $0x38,%esp
  800ee3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	89 de                	mov    %ebx,%esi
  800f00:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7e 28                	jle    800f2e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f11:	00 
  800f12:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800f19:	00 
  800f1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f21:	00 
  800f22:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800f29:	e8 8e 2b 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f2e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f31:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f34:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f37:	89 ec                	mov    %ebp,%esp
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 38             	sub    $0x38,%esp
  800f41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f47:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	89 df                	mov    %ebx,%edi
  800f5c:	89 de                	mov    %ebx,%esi
  800f5e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f60:	85 c0                	test   %eax,%eax
  800f62:	7e 28                	jle    800f8c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f64:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f68:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f6f:	00 
  800f70:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800f77:	00 
  800f78:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7f:	00 
  800f80:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800f87:	e8 30 2b 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f8c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f92:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f95:	89 ec                	mov    %ebp,%esp
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 38             	sub    $0x38,%esp
  800f9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fa8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fad:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	89 df                	mov    %ebx,%edi
  800fba:	89 de                	mov    %ebx,%esi
  800fbc:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	7e 28                	jle    800fea <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fcd:	00 
  800fce:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  800fd5:	00 
  800fd6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdd:	00 
  800fde:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  800fe5:	e8 d2 2a 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff3:	89 ec                	mov    %ebp,%esp
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 38             	sub    $0x38,%esp
  800ffd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801000:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801003:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801006:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801010:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	89 df                	mov    %ebx,%edi
  801018:	89 de                	mov    %ebx,%esi
  80101a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	7e 28                	jle    801048 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801020:	89 44 24 10          	mov    %eax,0x10(%esp)
  801024:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80102b:	00 
  80102c:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  801033:	00 
  801034:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103b:	00 
  80103c:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  801043:	e8 74 2a 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801048:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801051:	89 ec                	mov    %ebp,%esp
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 38             	sub    $0x38,%esp
  80105b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801061:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801064:	bb 00 00 00 00       	mov    $0x0,%ebx
  801069:	b8 0c 00 00 00       	mov    $0xc,%eax
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	89 df                	mov    %ebx,%edi
  801076:	89 de                	mov    %ebx,%esi
  801078:	cd 30                	int    $0x30

	if(check && ret > 0)
  80107a:	85 c0                	test   %eax,%eax
  80107c:	7e 28                	jle    8010a6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801082:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801089:	00 
  80108a:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  801091:	00 
  801092:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801099:	00 
  80109a:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  8010a1:	e8 16 2a 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010af:	89 ec                	mov    %ebp,%esp
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	89 1c 24             	mov    %ebx,(%esp)
  8010bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010c4:	be 00 00 00 00       	mov    $0x0,%esi
  8010c9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010dc:	8b 1c 24             	mov    (%esp),%ebx
  8010df:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010e3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010e7:	89 ec                	mov    %ebp,%esp
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 38             	sub    $0x38,%esp
  8010f1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010f4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ff:	b8 0e 00 00 00       	mov    $0xe,%eax
  801104:	8b 55 08             	mov    0x8(%ebp),%edx
  801107:	89 cb                	mov    %ecx,%ebx
  801109:	89 cf                	mov    %ecx,%edi
  80110b:	89 ce                	mov    %ecx,%esi
  80110d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80110f:	85 c0                	test   %eax,%eax
  801111:	7e 28                	jle    80113b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801113:	89 44 24 10          	mov    %eax,0x10(%esp)
  801117:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80111e:	00 
  80111f:	c7 44 24 08 94 47 80 	movl   $0x804794,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 b1 47 80 00 	movl   $0x8047b1,(%esp)
  801136:	e8 81 29 00 00       	call   803abc <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80113b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80113e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801141:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801144:	89 ec                	mov    %ebp,%esp
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
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
  801159:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801166:	8b 55 08             	mov    0x8(%ebp),%edx
  801169:	89 df                	mov    %ebx,%edi
  80116b:	89 de                	mov    %ebx,%esi
  80116d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80116f:	8b 1c 24             	mov    (%esp),%ebx
  801172:	8b 74 24 04          	mov    0x4(%esp),%esi
  801176:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80117a:	89 ec                	mov    %ebp,%esp
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	89 1c 24             	mov    %ebx,(%esp)
  801187:	89 74 24 04          	mov    %esi,0x4(%esp)
  80118b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80118f:	ba 00 00 00 00       	mov    $0x0,%edx
  801194:	b8 11 00 00 00       	mov    $0x11,%eax
  801199:	89 d1                	mov    %edx,%ecx
  80119b:	89 d3                	mov    %edx,%ebx
  80119d:	89 d7                	mov    %edx,%edi
  80119f:	89 d6                	mov    %edx,%esi
  8011a1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011a3:	8b 1c 24             	mov    (%esp),%ebx
  8011a6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011aa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ae:	89 ec                	mov    %ebp,%esp
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	89 1c 24             	mov    %ebx,(%esp)
  8011bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011bf:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8011cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d3:	89 df                	mov    %ebx,%edi
  8011d5:	89 de                	mov    %ebx,%esi
  8011d7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8011d9:	8b 1c 24             	mov    (%esp),%ebx
  8011dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011e0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011e4:	89 ec                	mov    %ebp,%esp
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 0c             	sub    $0xc,%esp
  8011ee:	89 1c 24             	mov    %ebx,(%esp)
  8011f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011fe:	b8 13 00 00 00       	mov    $0x13,%eax
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	89 cb                	mov    %ecx,%ebx
  801208:	89 cf                	mov    %ecx,%edi
  80120a:	89 ce                	mov    %ecx,%esi
  80120c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80120e:	8b 1c 24             	mov    (%esp),%ebx
  801211:	8b 74 24 04          	mov    0x4(%esp),%esi
  801215:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801219:	89 ec                	mov    %ebp,%esp
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	89 1c 24             	mov    %ebx,(%esp)
  801226:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80122e:	b8 10 00 00 00       	mov    $0x10,%eax
  801233:	8b 75 18             	mov    0x18(%ebp),%esi
  801236:	8b 7d 14             	mov    0x14(%ebp),%edi
  801239:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80123c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123f:	8b 55 08             	mov    0x8(%ebp),%edx
  801242:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801244:	8b 1c 24             	mov    (%esp),%ebx
  801247:	8b 74 24 04          	mov    0x4(%esp),%esi
  80124b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80124f:	89 ec                	mov    %ebp,%esp
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    
	...

00801260 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801263:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801268:	75 11                	jne    80127b <_ZL8fd_validPK2Fd+0x1b>
  80126a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80126f:	76 0a                	jbe    80127b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801271:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801276:	0f 96 c0             	setbe  %al
  801279:	eb 05                	jmp    801280 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80127b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	53                   	push   %ebx
  801286:	83 ec 14             	sub    $0x14,%esp
  801289:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80128b:	e8 d0 ff ff ff       	call   801260 <_ZL8fd_validPK2Fd>
  801290:	84 c0                	test   %al,%al
  801292:	75 24                	jne    8012b8 <_ZL9fd_isopenPK2Fd+0x36>
  801294:	c7 44 24 0c bf 47 80 	movl   $0x8047bf,0xc(%esp)
  80129b:	00 
  80129c:	c7 44 24 08 cc 47 80 	movl   $0x8047cc,0x8(%esp)
  8012a3:	00 
  8012a4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8012ab:	00 
  8012ac:	c7 04 24 e1 47 80 00 	movl   $0x8047e1,(%esp)
  8012b3:	e8 04 28 00 00       	call   803abc <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8012b8:	89 d8                	mov    %ebx,%eax
  8012ba:	c1 e8 16             	shr    $0x16,%eax
  8012bd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c9:	f6 c2 01             	test   $0x1,%dl
  8012cc:	74 0d                	je     8012db <_ZL9fd_isopenPK2Fd+0x59>
  8012ce:	c1 eb 0c             	shr    $0xc,%ebx
  8012d1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8012d8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8012db:	83 c4 14             	add    $0x14,%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    

008012e1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	89 1c 24             	mov    %ebx,(%esp)
  8012ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8012f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8012fb:	77 18                	ja     801315 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8012fd:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801303:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801306:	84 c0                	test   %al,%al
  801308:	74 21                	je     80132b <_Z9fd_lookupiPP2Fdb+0x4a>
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	e8 71 ff ff ff       	call   801282 <_ZL9fd_isopenPK2Fd>
  801311:	84 c0                	test   %al,%al
  801313:	75 16                	jne    80132b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801315:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80131b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801320:	8b 1c 24             	mov    (%esp),%ebx
  801323:	8b 74 24 04          	mov    0x4(%esp),%esi
  801327:	89 ec                	mov    %ebp,%esp
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80132b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	eb ec                	jmp    801320 <_Z9fd_lookupiPP2Fdb+0x3f>

00801334 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	53                   	push   %ebx
  801338:	83 ec 14             	sub    $0x14,%esp
  80133b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80133e:	89 d8                	mov    %ebx,%eax
  801340:	e8 1b ff ff ff       	call   801260 <_ZL8fd_validPK2Fd>
  801345:	84 c0                	test   %al,%al
  801347:	75 24                	jne    80136d <_Z6fd2numP2Fd+0x39>
  801349:	c7 44 24 0c bf 47 80 	movl   $0x8047bf,0xc(%esp)
  801350:	00 
  801351:	c7 44 24 08 cc 47 80 	movl   $0x8047cc,0x8(%esp)
  801358:	00 
  801359:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801360:	00 
  801361:	c7 04 24 e1 47 80 00 	movl   $0x8047e1,(%esp)
  801368:	e8 4f 27 00 00       	call   803abc <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80136d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801373:	c1 e8 0c             	shr    $0xc,%eax
}
  801376:	83 c4 14             	add    $0x14,%esp
  801379:	5b                   	pop    %ebx
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	e8 a7 ff ff ff       	call   801334 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80138d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801392:	c1 e0 0c             	shl    $0xc,%eax
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	57                   	push   %edi
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	83 ec 2c             	sub    $0x2c,%esp
  8013a0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8013a8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8013ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b2:	00 
  8013b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b7:	89 1c 24             	mov    %ebx,(%esp)
  8013ba:	e8 22 ff ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8013bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c2:	e8 bb fe ff ff       	call   801282 <_ZL9fd_isopenPK2Fd>
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 0c                	jne    8013d7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8013cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ce:	89 07                	mov    %eax,(%edi)
			return 0;
  8013d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d5:	eb 13                	jmp    8013ea <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013d7:	83 c3 01             	add    $0x1,%ebx
  8013da:	83 fb 20             	cmp    $0x20,%ebx
  8013dd:	75 cc                	jne    8013ab <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8013e5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8013ea:	83 c4 2c             	add    $0x2c,%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5e                   	pop    %esi
  8013ef:	5f                   	pop    %edi
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    

008013f2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 14             	sub    $0x14,%esp
  8013f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801404:	39 0d 08 50 80 00    	cmp    %ecx,0x805008
  80140a:	75 16                	jne    801422 <_Z10dev_lookupiPP3Dev+0x30>
  80140c:	eb 06                	jmp    801414 <_Z10dev_lookupiPP3Dev+0x22>
  80140e:	39 0a                	cmp    %ecx,(%edx)
  801410:	75 10                	jne    801422 <_Z10dev_lookupiPP3Dev+0x30>
  801412:	eb 05                	jmp    801419 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801414:	ba 08 50 80 00       	mov    $0x805008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801419:	89 13                	mov    %edx,(%ebx)
			return 0;
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
  801420:	eb 35                	jmp    801457 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801422:	83 c0 01             	add    $0x1,%eax
  801425:	8b 14 85 4c 48 80 00 	mov    0x80484c(,%eax,4),%edx
  80142c:	85 d2                	test   %edx,%edx
  80142e:	75 de                	jne    80140e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801430:	a1 00 60 80 00       	mov    0x806000,%eax
  801435:	8b 40 04             	mov    0x4(%eax),%eax
  801438:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	c7 04 24 08 48 80 00 	movl   $0x804808,(%esp)
  801447:	e8 d2 ee ff ff       	call   80031e <_Z7cprintfPKcz>
	*dev = 0;
  80144c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801457:	83 c4 14             	add    $0x14,%esp
  80145a:	5b                   	pop    %ebx
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    

0080145d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 20             	sub    $0x20,%esp
  801465:	8b 75 08             	mov    0x8(%ebp),%esi
  801468:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80146c:	89 34 24             	mov    %esi,(%esp)
  80146f:	e8 c0 fe ff ff       	call   801334 <_Z6fd2numP2Fd>
  801474:	0f b6 d3             	movzbl %bl,%edx
  801477:	89 54 24 08          	mov    %edx,0x8(%esp)
  80147b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80147e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801482:	89 04 24             	mov    %eax,(%esp)
  801485:	e8 57 fe ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 05                	js     801493 <_Z8fd_closeP2Fdb+0x36>
  80148e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801491:	74 0c                	je     80149f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801493:	80 fb 01             	cmp    $0x1,%bl
  801496:	19 db                	sbb    %ebx,%ebx
  801498:	f7 d3                	not    %ebx
  80149a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80149d:	eb 3d                	jmp    8014dc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80149f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	8b 06                	mov    (%esi),%eax
  8014a8:	89 04 24             	mov    %eax,(%esp)
  8014ab:	e8 42 ff ff ff       	call   8013f2 <_Z10dev_lookupiPP3Dev>
  8014b0:	89 c3                	mov    %eax,%ebx
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 16                	js     8014cc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014bc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	74 07                	je     8014cc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8014c5:	89 34 24             	mov    %esi,(%esp)
  8014c8:	ff d0                	call   *%eax
  8014ca:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014d7:	e8 01 fa ff ff       	call   800edd <_Z14sys_page_unmapiPv>
	return r;
}
  8014dc:	89 d8                	mov    %ebx,%eax
  8014de:	83 c4 20             	add    $0x20,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8014eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8014f2:	00 
  8014f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	89 04 24             	mov    %eax,(%esp)
  801500:	e8 dc fd ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  801505:	85 c0                	test   %eax,%eax
  801507:	78 13                	js     80151c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801509:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801510:	00 
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 41 ff ff ff       	call   80145d <_Z8fd_closeP2Fdb>
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <_Z9close_allv>:

void
close_all(void)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801525:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80152a:	89 1c 24             	mov    %ebx,(%esp)
  80152d:	e8 b3 ff ff ff       	call   8014e5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801532:	83 c3 01             	add    $0x1,%ebx
  801535:	83 fb 20             	cmp    $0x20,%ebx
  801538:	75 f0                	jne    80152a <_Z9close_allv+0xc>
		close(i);
}
  80153a:	83 c4 14             	add    $0x14,%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 48             	sub    $0x48,%esp
  801546:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801549:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80154c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80154f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801552:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801559:	00 
  80155a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 75 fd ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80156c:	89 c3                	mov    %eax,%ebx
  80156e:	85 c0                	test   %eax,%eax
  801570:	0f 88 ce 00 00 00    	js     801644 <_Z3dupii+0x104>
  801576:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80157e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801581:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801585:	89 34 24             	mov    %esi,(%esp)
  801588:	e8 54 fd ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80158d:	89 c3                	mov    %eax,%ebx
  80158f:	85 c0                	test   %eax,%eax
  801591:	0f 89 bc 00 00 00    	jns    801653 <_Z3dupii+0x113>
  801597:	e9 a8 00 00 00       	jmp    801644 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	c1 e8 0c             	shr    $0xc,%eax
  8015a1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8015a8:	f6 c2 01             	test   $0x1,%dl
  8015ab:	74 32                	je     8015df <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015ad:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8015b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015c8:	00 
  8015c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d4:	e8 a6 f8 ff ff       	call   800e7f <_Z12sys_page_mapiPviS_i>
  8015d9:	89 c3                	mov    %eax,%ebx
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 3e                	js     80161d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e2:	89 c2                	mov    %eax,%edx
  8015e4:	c1 ea 0c             	shr    $0xc,%edx
  8015e7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  8015ee:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015f4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801606:	00 
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801612:	e8 68 f8 ff ff       	call   800e7f <_Z12sys_page_mapiPviS_i>
  801617:	89 c3                	mov    %eax,%ebx
  801619:	85 c0                	test   %eax,%eax
  80161b:	79 25                	jns    801642 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80161d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801620:	89 44 24 04          	mov    %eax,0x4(%esp)
  801624:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80162b:	e8 ad f8 ff ff       	call   800edd <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801630:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163b:	e8 9d f8 ff ff       	call   800edd <_Z14sys_page_unmapiPv>
	return r;
  801640:	eb 02                	jmp    801644 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801642:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801644:	89 d8                	mov    %ebx,%eax
  801646:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801649:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80164c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80164f:	89 ec                	mov    %ebp,%esp
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801653:	89 34 24             	mov    %esi,(%esp)
  801656:	e8 8a fe ff ff       	call   8014e5 <_Z5closei>

	ova = fd2data(oldfd);
  80165b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165e:	89 04 24             	mov    %eax,(%esp)
  801661:	e8 16 fd ff ff       	call   80137c <_Z7fd2dataP2Fd>
  801666:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166b:	89 04 24             	mov    %eax,(%esp)
  80166e:	e8 09 fd ff ff       	call   80137c <_Z7fd2dataP2Fd>
  801673:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801675:	89 d8                	mov    %ebx,%eax
  801677:	c1 e8 16             	shr    $0x16,%eax
  80167a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801681:	a8 01                	test   $0x1,%al
  801683:	0f 85 13 ff ff ff    	jne    80159c <_Z3dupii+0x5c>
  801689:	e9 51 ff ff ff       	jmp    8015df <_Z3dupii+0x9f>

0080168e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 24             	sub    $0x24,%esp
  801695:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801698:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80169f:	00 
  8016a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a7:	89 1c 24             	mov    %ebx,(%esp)
  8016aa:	e8 32 fc ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 5f                	js     801712 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016bd:	8b 00                	mov    (%eax),%eax
  8016bf:	89 04 24             	mov    %eax,(%esp)
  8016c2:	e8 2b fd ff ff       	call   8013f2 <_Z10dev_lookupiPP3Dev>
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	79 4d                	jns    801718 <_Z4readiPvj+0x8a>
  8016cb:	eb 45                	jmp    801712 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016cd:	a1 00 60 80 00       	mov    0x806000,%eax
  8016d2:	8b 40 04             	mov    0x4(%eax),%eax
  8016d5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dd:	c7 04 24 ea 47 80 00 	movl   $0x8047ea,(%esp)
  8016e4:	e8 35 ec ff ff       	call   80031e <_Z7cprintfPKcz>
		return -E_INVAL;
  8016e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ee:	eb 22                	jmp    801712 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  8016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016fb:	85 d2                	test   %edx,%edx
  8016fd:	74 13                	je     801712 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	89 44 24 08          	mov    %eax,0x8(%esp)
  801706:	8b 45 0c             	mov    0xc(%ebp),%eax
  801709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170d:	89 0c 24             	mov    %ecx,(%esp)
  801710:	ff d2                	call   *%edx
}
  801712:	83 c4 24             	add    $0x24,%esp
  801715:	5b                   	pop    %ebx
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801718:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80171b:	8b 41 08             	mov    0x8(%ecx),%eax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	83 f8 01             	cmp    $0x1,%eax
  801724:	75 ca                	jne    8016f0 <_Z4readiPvj+0x62>
  801726:	eb a5                	jmp    8016cd <_Z4readiPvj+0x3f>

00801728 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	57                   	push   %edi
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	83 ec 1c             	sub    $0x1c,%esp
  801731:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801734:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801737:	85 f6                	test   %esi,%esi
  801739:	74 2f                	je     80176a <_Z5readniPvj+0x42>
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801740:	89 f0                	mov    %esi,%eax
  801742:	29 d8                	sub    %ebx,%eax
  801744:	89 44 24 08          	mov    %eax,0x8(%esp)
  801748:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80174b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	89 04 24             	mov    %eax,(%esp)
  801755:	e8 34 ff ff ff       	call   80168e <_Z4readiPvj>
		if (m < 0)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 13                	js     801771 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80175e:	85 c0                	test   %eax,%eax
  801760:	74 0d                	je     80176f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801762:	01 c3                	add    %eax,%ebx
  801764:	39 de                	cmp    %ebx,%esi
  801766:	77 d8                	ja     801740 <_Z5readniPvj+0x18>
  801768:	eb 05                	jmp    80176f <_Z5readniPvj+0x47>
  80176a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80176f:	89 d8                	mov    %ebx,%eax
}
  801771:	83 c4 1c             	add    $0x1c,%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5f                   	pop    %edi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80177f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801786:	00 
  801787:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	89 04 24             	mov    %eax,(%esp)
  801794:	e8 48 fb ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 3c                	js     8017d9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	89 04 24             	mov    %eax,(%esp)
  8017ac:	e8 41 fc ff ff       	call   8013f2 <_Z10dev_lookupiPP3Dev>
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	79 26                	jns    8017db <_Z5writeiPKvj+0x62>
  8017b5:	eb 22                	jmp    8017d9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ba:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8017bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017c2:	85 c9                	test   %ecx,%ecx
  8017c4:	74 13                	je     8017d9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	89 14 24             	mov    %edx,(%esp)
  8017d7:	ff d1                	call   *%ecx
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8017db:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  8017de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8017e3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8017e7:	74 f0                	je     8017d9 <_Z5writeiPKvj+0x60>
  8017e9:	eb cc                	jmp    8017b7 <_Z5writeiPKvj+0x3e>

008017eb <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8017f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017f8:	00 
  8017f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	89 04 24             	mov    %eax,(%esp)
  801806:	e8 d6 fa ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 0e                	js     80181d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801812:	8b 55 0c             	mov    0xc(%ebp),%edx
  801815:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	53                   	push   %ebx
  801823:	83 ec 24             	sub    $0x24,%esp
  801826:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801829:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801830:	00 
  801831:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801834:	89 44 24 04          	mov    %eax,0x4(%esp)
  801838:	89 1c 24             	mov    %ebx,(%esp)
  80183b:	e8 a1 fa ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  801840:	85 c0                	test   %eax,%eax
  801842:	78 58                	js     80189c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801844:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80184e:	8b 00                	mov    (%eax),%eax
  801850:	89 04 24             	mov    %eax,(%esp)
  801853:	e8 9a fb ff ff       	call   8013f2 <_Z10dev_lookupiPP3Dev>
  801858:	85 c0                	test   %eax,%eax
  80185a:	79 46                	jns    8018a2 <_Z9ftruncateii+0x83>
  80185c:	eb 3e                	jmp    80189c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80185e:	a1 00 60 80 00       	mov    0x806000,%eax
  801863:	8b 40 04             	mov    0x4(%eax),%eax
  801866:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186e:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801875:	e8 a4 ea ff ff       	call   80031e <_Z7cprintfPKcz>
		return -E_INVAL;
  80187a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187f:	eb 1b                	jmp    80189c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801887:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80188c:	85 d2                	test   %edx,%edx
  80188e:	74 0c                	je     80189c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801890:	8b 45 0c             	mov    0xc(%ebp),%eax
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	89 0c 24             	mov    %ecx,(%esp)
  80189a:	ff d2                	call   *%edx
}
  80189c:	83 c4 24             	add    $0x24,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018a5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8018a9:	75 d6                	jne    801881 <_Z9ftruncateii+0x62>
  8018ab:	eb b1                	jmp    80185e <_Z9ftruncateii+0x3f>

008018ad <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 24             	sub    $0x24,%esp
  8018b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018be:	00 
  8018bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	89 04 24             	mov    %eax,(%esp)
  8018cc:	e8 10 fa ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 3e                	js     801913 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	89 04 24             	mov    %eax,(%esp)
  8018e4:	e8 09 fb ff ff       	call   8013f2 <_Z10dev_lookupiPP3Dev>
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	79 2c                	jns    801919 <_Z5fstatiP4Stat+0x6c>
  8018ed:	eb 24                	jmp    801913 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018ef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018f2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  8018f9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801900:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801906:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	89 04 24             	mov    %eax,(%esp)
  801910:	ff 52 14             	call   *0x14(%edx)
}
  801913:	83 c4 24             	add    $0x24,%esp
  801916:	5b                   	pop    %ebx
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801919:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80191c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801921:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801925:	75 c8                	jne    8018ef <_Z5fstatiP4Stat+0x42>
  801927:	eb ea                	jmp    801913 <_Z5fstatiP4Stat+0x66>

00801929 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 18             	sub    $0x18,%esp
  80192f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801932:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801935:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80193c:	00 
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	89 04 24             	mov    %eax,(%esp)
  801943:	e8 d6 09 00 00       	call   80231e <_Z4openPKci>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 1b                	js     801969 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	89 44 24 04          	mov    %eax,0x4(%esp)
  801955:	89 1c 24             	mov    %ebx,(%esp)
  801958:	e8 50 ff ff ff       	call   8018ad <_Z5fstatiP4Stat>
  80195d:	89 c6                	mov    %eax,%esi
	close(fd);
  80195f:	89 1c 24             	mov    %ebx,(%esp)
  801962:	e8 7e fb ff ff       	call   8014e5 <_Z5closei>
	return r;
  801967:	89 f3                	mov    %esi,%ebx
}
  801969:	89 d8                	mov    %ebx,%eax
  80196b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80196e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801971:	89 ec                	mov    %ebp,%esp
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    
	...

00801980 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801983:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801988:	85 d2                	test   %edx,%edx
  80198a:	78 33                	js     8019bf <_ZL10inode_dataP5Inodei+0x3f>
  80198c:	3b 50 08             	cmp    0x8(%eax),%edx
  80198f:	7d 2e                	jge    8019bf <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801991:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801997:	85 d2                	test   %edx,%edx
  801999:	0f 49 ca             	cmovns %edx,%ecx
  80199c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80199f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8019a3:	c1 e1 0c             	shl    $0xc,%ecx
  8019a6:	89 d0                	mov    %edx,%eax
  8019a8:	c1 f8 1f             	sar    $0x1f,%eax
  8019ab:	c1 e8 14             	shr    $0x14,%eax
  8019ae:	01 c2                	add    %eax,%edx
  8019b0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8019b6:	29 c2                	sub    %eax,%edx
  8019b8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8019bf:	89 c8                	mov    %ecx,%eax
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8019c6:	8b 48 08             	mov    0x8(%eax),%ecx
  8019c9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  8019d1:	c7 82 80 00 00 00 08 	movl   $0x805008,0x80(%edx)
  8019d8:	50 80 00 
}
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  8019e3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	74 08                	je     8019f5 <_ZL9get_inodei+0x18>
  8019ed:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  8019f3:	7e 20                	jle    801a15 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  8019f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019f9:	c7 44 24 08 60 48 80 	movl   $0x804860,0x8(%esp)
  801a00:	00 
  801a01:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801a08:	00 
  801a09:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  801a10:	e8 a7 20 00 00       	call   803abc <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a15:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801a1b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a21:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801a27:	85 d2                	test   %edx,%edx
  801a29:	0f 48 d1             	cmovs  %ecx,%edx
  801a2c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801a2f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801a36:	c1 e0 0c             	shl    $0xc,%eax
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801a43:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801a49:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801a4c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801a52:	76 20                	jbe    801a74 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801a54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a58:	c7 44 24 08 9c 48 80 	movl   $0x80489c,0x8(%esp)
  801a5f:	00 
  801a60:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801a67:	00 
  801a68:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  801a6f:	e8 48 20 00 00       	call   803abc <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801a74:	83 fe 01             	cmp    $0x1,%esi
  801a77:	7e 08                	jle    801a81 <_ZL10bcache_ipcPvi+0x46>
  801a79:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801a7f:	7d 12                	jge    801a93 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801a81:	89 f3                	mov    %esi,%ebx
  801a83:	c1 e3 04             	shl    $0x4,%ebx
  801a86:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801a88:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801a8e:	c1 e6 0c             	shl    $0xc,%esi
  801a91:	eb 20                	jmp    801ab3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801a93:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a97:	c7 44 24 08 cc 48 80 	movl   $0x8048cc,0x8(%esp)
  801a9e:	00 
  801a9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801aa6:	00 
  801aa7:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  801aae:	e8 09 20 00 00       	call   803abc <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ab3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aba:	00 
  801abb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ac2:	00 
  801ac3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ac7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801ace:	e8 3c 22 00 00       	call   803d0f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801ad3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ada:	00 
  801adb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae6:	e8 95 21 00 00       	call   803c80 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801aeb:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801aee:	74 c3                	je     801ab3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 28             	sub    $0x28,%esp
  801afd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b03:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b06:	89 c7                	mov    %eax,%edi
  801b08:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801b0a:	c7 04 24 9d 1d 80 00 	movl   $0x801d9d,(%esp)
  801b11:	e8 75 20 00 00       	call   803b8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801b16:	89 f8                	mov    %edi,%eax
  801b18:	e8 c0 fe ff ff       	call   8019dd <_ZL9get_inodei>
  801b1d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801b1f:	ba 02 00 00 00       	mov    $0x2,%edx
  801b24:	e8 12 ff ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	79 08                	jns    801b35 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801b2d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801b33:	eb 2e                	jmp    801b63 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801b35:	85 c0                	test   %eax,%eax
  801b37:	75 1c                	jne    801b55 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801b39:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801b3f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801b46:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801b49:	ba 06 00 00 00       	mov    $0x6,%edx
  801b4e:	89 d8                	mov    %ebx,%eax
  801b50:	e8 e6 fe ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801b55:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801b5c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b66:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b6c:	89 ec                	mov    %ebp,%esp
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	57                   	push   %edi
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	83 ec 2c             	sub    $0x2c,%esp
  801b79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b7c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801b7f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801b84:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801b8a:	0f 87 3d 01 00 00    	ja     801ccd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801b90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b93:	8b 42 08             	mov    0x8(%edx),%eax
  801b96:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	0f 49 f0             	cmovns %eax,%esi
  801ba1:	c1 fe 0c             	sar    $0xc,%esi
  801ba4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801ba6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801ba9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801baf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801bb2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801bb5:	0f 82 a6 00 00 00    	jb     801c61 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801bbb:	39 fe                	cmp    %edi,%esi
  801bbd:	0f 8d f2 00 00 00    	jge    801cb5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801bc3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801bca:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801bcd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801bd0:	83 3e 00             	cmpl   $0x0,(%esi)
  801bd3:	75 77                	jne    801c4c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801bd5:	ba 02 00 00 00       	mov    $0x2,%edx
  801bda:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801bdf:	e8 57 fe ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801be4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801bea:	83 f9 02             	cmp    $0x2,%ecx
  801bed:	7e 43                	jle    801c32 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801bef:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801bf4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801bf9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801c00:	74 29                	je     801c2b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801c02:	e9 ce 00 00 00       	jmp    801cd5 <_ZL14inode_set_sizeP5Inodej+0x165>
  801c07:	89 c7                	mov    %eax,%edi
  801c09:	0f b6 10             	movzbl (%eax),%edx
  801c0c:	83 c0 01             	add    $0x1,%eax
  801c0f:	84 d2                	test   %dl,%dl
  801c11:	74 18                	je     801c2b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801c13:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c16:	ba 05 00 00 00       	mov    $0x5,%edx
  801c1b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c20:	e8 16 fe ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801c25:	85 db                	test   %ebx,%ebx
  801c27:	79 1e                	jns    801c47 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801c29:	eb 07                	jmp    801c32 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c2b:	83 c3 01             	add    $0x1,%ebx
  801c2e:	39 d9                	cmp    %ebx,%ecx
  801c30:	7f d5                	jg     801c07 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801c32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c35:	8b 50 08             	mov    0x8(%eax),%edx
  801c38:	e8 33 ff ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801c3d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c42:	e9 86 00 00 00       	jmp    801ccd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801c47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c4a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801c4c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801c50:	83 c6 04             	add    $0x4,%esi
  801c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c56:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801c59:	0f 8f 6e ff ff ff    	jg     801bcd <_ZL14inode_set_sizeP5Inodej+0x5d>
  801c5f:	eb 54                	jmp    801cb5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801c61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c64:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801c69:	83 f8 01             	cmp    $0x1,%eax
  801c6c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c6f:	ba 02 00 00 00       	mov    $0x2,%edx
  801c74:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c79:	e8 bd fd ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801c7e:	39 f7                	cmp    %esi,%edi
  801c80:	7d 24                	jge    801ca6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801c82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801c85:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801c89:	8b 10                	mov    (%eax),%edx
  801c8b:	85 d2                	test   %edx,%edx
  801c8d:	74 0d                	je     801c9c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801c8f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801c9c:	83 eb 01             	sub    $0x1,%ebx
  801c9f:	83 e8 04             	sub    $0x4,%eax
  801ca2:	39 fb                	cmp    %edi,%ebx
  801ca4:	75 e3                	jne    801c89 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801ca6:	ba 05 00 00 00       	mov    $0x5,%edx
  801cab:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801cb0:	e8 86 fd ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cbb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801cbe:	ba 04 00 00 00       	mov    $0x4,%edx
  801cc3:	e8 73 fd ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	return 0;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	83 c4 2c             	add    $0x2c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801cd5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cdc:	ba 05 00 00 00       	mov    $0x5,%edx
  801ce1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ce6:	e8 50 fd ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801ceb:	bb 02 00 00 00       	mov    $0x2,%ebx
  801cf0:	e9 52 ff ff ff       	jmp    801c47 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801cf5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	53                   	push   %ebx
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801cfe:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801d04:	83 e8 01             	sub    $0x1,%eax
  801d07:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801d0d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801d11:	75 40                	jne    801d53 <_ZL11inode_closeP5Inode+0x5e>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	75 3c                	jne    801d53 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d17:	ba 02 00 00 00       	mov    $0x2,%edx
  801d1c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d21:	e8 15 fd ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801d2b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801d2f:	85 d2                	test   %edx,%edx
  801d31:	74 07                	je     801d3a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801d33:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801d3a:	83 c0 01             	add    $0x1,%eax
  801d3d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801d42:	75 e7                	jne    801d2b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d44:	ba 05 00 00 00       	mov    $0x5,%edx
  801d49:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d4e:	e8 e8 fc ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801d53:	ba 03 00 00 00       	mov    $0x3,%edx
  801d58:	89 d8                	mov    %ebx,%eax
  801d5a:	e8 dc fc ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
}
  801d5f:	83 c4 04             	add    $0x4,%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    

00801d65 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	53                   	push   %ebx
  801d69:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d72:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d75:	e8 7d fd ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  801d7a:	89 c3                	mov    %eax,%ebx
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	78 15                	js     801d95 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	e8 e5 fd ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
  801d8b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	e8 60 ff ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
	return r;
}
  801d95:	89 d8                	mov    %ebx,%eax
  801d97:	83 c4 14             	add    $0x14,%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    

00801d9d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	53                   	push   %ebx
  801da1:	83 ec 14             	sub    $0x14,%esp
  801da4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801da7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801da9:	89 c2                	mov    %eax,%edx
  801dab:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801db1:	78 32                	js     801de5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801db3:	ba 00 00 00 00       	mov    $0x0,%edx
  801db8:	e8 7e fc ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	74 1c                	je     801ddd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801dc1:	c7 44 24 08 81 48 80 	movl   $0x804881,0x8(%esp)
  801dc8:	00 
  801dc9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801dd0:	00 
  801dd1:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  801dd8:	e8 df 1c 00 00       	call   803abc <_Z6_panicPKciS0_z>
    resume(utf);
  801ddd:	89 1c 24             	mov    %ebx,(%esp)
  801de0:	e8 7b 1e 00 00       	call   803c60 <resume>
}
  801de5:	83 c4 14             	add    $0x14,%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 28             	sub    $0x28,%esp
  801df1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801df4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801dfa:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801dfd:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e00:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e03:	e8 ef fc ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 26                	js     801e32 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801e0c:	83 c3 10             	add    $0x10,%ebx
  801e0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e13:	89 34 24             	mov    %esi,(%esp)
  801e16:	e8 1f eb ff ff       	call   80093a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801e1b:	89 f2                	mov    %esi,%edx
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	e8 9e fb ff ff       	call   8019c3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	e8 c8 fe ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
	return 0;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e32:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e35:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e38:	89 ec                	mov    %ebp,%esp
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 24             	sub    $0x24,%esp
  801e43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e46:	89 1c 24             	mov    %ebx,(%esp)
  801e49:	e8 9e 15 00 00       	call   8033ec <_Z7pagerefPv>
  801e4e:	89 c2                	mov    %eax,%edx
        return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e55:	83 fa 01             	cmp    $0x1,%edx
  801e58:	7f 1e                	jg     801e78 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e5a:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e5d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e60:	e8 92 fc ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 0f                	js     801e78 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801e73:	e8 7d fe ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
}
  801e78:	83 c4 24             	add    $0x24,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 3c             	sub    $0x3c,%esp
  801e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e8a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801e8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e93:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e96:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801e99:	e8 59 fc ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	0f 88 8c 00 00 00    	js     801f32 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801ea6:	8b 53 04             	mov    0x4(%ebx),%edx
  801ea9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801eaf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801eb5:	29 d7                	sub    %edx,%edi
  801eb7:	39 f7                	cmp    %esi,%edi
  801eb9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801ebc:	85 ff                	test   %edi,%edi
  801ebe:	74 16                	je     801ed6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801ec0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec6:	3b 50 08             	cmp    0x8(%eax),%edx
  801ec9:	76 6f                	jbe    801f3a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801ecb:	e8 a0 fc ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	79 66                	jns    801f3a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801ed4:	eb 4e                	jmp    801f24 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801ed6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801edc:	76 24                	jbe    801f02 <_ZL13devfile_writeP2FdPKvj+0x84>
  801ede:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801ee0:	8b 53 04             	mov    0x4(%ebx),%edx
  801ee3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eec:	3b 50 08             	cmp    0x8(%eax),%edx
  801eef:	0f 86 83 00 00 00    	jbe    801f78 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801ef5:	e8 76 fc ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801efa:	85 c0                	test   %eax,%eax
  801efc:	79 7a                	jns    801f78 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801efe:	66 90                	xchg   %ax,%ax
  801f00:	eb 22                	jmp    801f24 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801f02:	85 f6                	test   %esi,%esi
  801f04:	74 1e                	je     801f24 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f06:	89 f2                	mov    %esi,%edx
  801f08:	03 53 04             	add    0x4(%ebx),%edx
  801f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f0e:	3b 50 08             	cmp    0x8(%eax),%edx
  801f11:	0f 86 b8 00 00 00    	jbe    801fcf <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801f17:	e8 54 fc ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	0f 89 ab 00 00 00    	jns    801fcf <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f27:	e8 c9 fd ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801f2c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f2f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801f32:	83 c4 3c             	add    $0x3c,%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5f                   	pop    %edi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801f3a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f3c:	8b 53 04             	mov    0x4(%ebx),%edx
  801f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f42:	e8 39 fa ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  801f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801f4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f58:	89 04 24             	mov    %eax,(%esp)
  801f5b:	e8 f7 eb ff ff       	call   800b57 <memcpy>
        fd->fd_offset += n2;
  801f60:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801f63:	ba 04 00 00 00       	mov    $0x4,%edx
  801f68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f6b:	e8 cb fa ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801f70:	01 7d 0c             	add    %edi,0xc(%ebp)
  801f73:	e9 5e ff ff ff       	jmp    801ed6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f78:	8b 53 04             	mov    0x4(%ebx),%edx
  801f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7e:	e8 fd f9 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  801f83:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801f85:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f8c:	00 
  801f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f94:	89 34 24             	mov    %esi,(%esp)
  801f97:	e8 bb eb ff ff       	call   800b57 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801f9c:	ba 04 00 00 00       	mov    $0x4,%edx
  801fa1:	89 f0                	mov    %esi,%eax
  801fa3:	e8 93 fa ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801fa8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801fae:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801fb5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801fbc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801fc2:	0f 87 18 ff ff ff    	ja     801ee0 <_ZL13devfile_writeP2FdPKvj+0x62>
  801fc8:	89 fe                	mov    %edi,%esi
  801fca:	e9 33 ff ff ff       	jmp    801f02 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801fcf:	8b 53 04             	mov    0x4(%ebx),%edx
  801fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd5:	e8 a6 f9 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  801fda:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  801fdc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe7:	89 3c 24             	mov    %edi,(%esp)
  801fea:	e8 68 eb ff ff       	call   800b57 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801fef:	ba 04 00 00 00       	mov    $0x4,%edx
  801ff4:	89 f8                	mov    %edi,%eax
  801ff6:	e8 40 fa ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  801ffb:	01 73 04             	add    %esi,0x4(%ebx)
  801ffe:	e9 21 ff ff ff       	jmp    801f24 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802003 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	57                   	push   %edi
  802007:	56                   	push   %esi
  802008:	53                   	push   %ebx
  802009:	83 ec 3c             	sub    $0x3c,%esp
  80200c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80200f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802012:	8b 43 04             	mov    0x4(%ebx),%eax
  802015:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802018:	8b 43 0c             	mov    0xc(%ebx),%eax
  80201b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80201e:	e8 d4 fa ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  802023:	85 c0                	test   %eax,%eax
  802025:	0f 88 d3 00 00 00    	js     8020fe <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80202b:	8b 73 04             	mov    0x4(%ebx),%esi
  80202e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802031:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802034:	8b 50 08             	mov    0x8(%eax),%edx
  802037:	29 f2                	sub    %esi,%edx
  802039:	3b 48 08             	cmp    0x8(%eax),%ecx
  80203c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80203f:	89 f2                	mov    %esi,%edx
  802041:	e8 3a f9 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  802046:	85 c0                	test   %eax,%eax
  802048:	0f 84 a2 00 00 00    	je     8020f0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80204e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802054:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80205a:	29 f2                	sub    %esi,%edx
  80205c:	39 d7                	cmp    %edx,%edi
  80205e:	0f 46 d7             	cmovbe %edi,%edx
  802061:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802064:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802066:	01 d6                	add    %edx,%esi
  802068:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80206b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80206f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802073:	8b 45 0c             	mov    0xc(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 d9 ea ff ff       	call   800b57 <memcpy>
    buf = (void *)((char *)buf + n2);
  80207e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802081:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802084:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80208a:	76 3e                	jbe    8020ca <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80208c:	8b 53 04             	mov    0x4(%ebx),%edx
  80208f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802092:	e8 e9 f8 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  802097:	85 c0                	test   %eax,%eax
  802099:	74 55                	je     8020f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80209b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020a2:	00 
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	89 34 24             	mov    %esi,(%esp)
  8020aa:	e8 a8 ea ff ff       	call   800b57 <memcpy>
        n -= PGSIZE;
  8020af:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8020b5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8020bb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8020c2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020c8:	77 c2                	ja     80208c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8020ca:	85 ff                	test   %edi,%edi
  8020cc:	74 22                	je     8020f0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020ce:	8b 53 04             	mov    0x4(%ebx),%edx
  8020d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d4:	e8 a7 f8 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	74 13                	je     8020f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8020dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e5:	89 34 24             	mov    %esi,(%esp)
  8020e8:	e8 6a ea ff ff       	call   800b57 <memcpy>
        fd->fd_offset += n;
  8020ed:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8020f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f3:	e8 fd fb ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8020f8:	8b 43 04             	mov    0x4(%ebx),%eax
  8020fb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8020fe:	83 c4 3c             	add    $0x3c,%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5f                   	pop    %edi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    

00802106 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	57                   	push   %edi
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
  80210c:	83 ec 4c             	sub    $0x4c,%esp
  80210f:	89 c6                	mov    %eax,%esi
  802111:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802114:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802117:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80211d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802126:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	e8 c4 f9 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  802133:	89 c7                	mov    %eax,%edi
  802135:	85 c0                	test   %eax,%eax
  802137:	0f 88 cd 01 00 00    	js     80230a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80213d:	89 f3                	mov    %esi,%ebx
  80213f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802142:	75 08                	jne    80214c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802144:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802147:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80214a:	74 f8                	je     802144 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80214c:	0f b6 03             	movzbl (%ebx),%eax
  80214f:	3c 2f                	cmp    $0x2f,%al
  802151:	74 16                	je     802169 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802153:	84 c0                	test   %al,%al
  802155:	74 12                	je     802169 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802157:	89 da                	mov    %ebx,%edx
		++path;
  802159:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80215c:	0f b6 02             	movzbl (%edx),%eax
  80215f:	3c 2f                	cmp    $0x2f,%al
  802161:	74 08                	je     80216b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802163:	84 c0                	test   %al,%al
  802165:	75 f2                	jne    802159 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802167:	eb 02                	jmp    80216b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802169:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	29 d8                	sub    %ebx,%eax
  80216f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802172:	0f b6 02             	movzbl (%edx),%eax
  802175:	89 d6                	mov    %edx,%esi
  802177:	3c 2f                	cmp    $0x2f,%al
  802179:	75 0a                	jne    802185 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80217b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80217e:	0f b6 06             	movzbl (%esi),%eax
  802181:	3c 2f                	cmp    $0x2f,%al
  802183:	74 f6                	je     80217b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802185:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802189:	75 1b                	jne    8021a6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80218b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802191:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802193:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802196:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80219c:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a1:	e9 64 01 00 00       	jmp    80230a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021a6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8021aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ae:	74 06                	je     8021b6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8021b0:	84 c0                	test   %al,%al
  8021b2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021b9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8021bc:	83 3a 02             	cmpl   $0x2,(%edx)
  8021bf:	0f 85 f4 00 00 00    	jne    8022b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	8b 52 08             	mov    0x8(%edx),%edx
  8021ca:	85 d2                	test   %edx,%edx
  8021cc:	7e 78                	jle    802246 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8021ce:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8021d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021da:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8021dd:	89 fb                	mov    %edi,%ebx
  8021df:	89 75 c0             	mov    %esi,-0x40(%ebp)
  8021e2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8021e4:	89 da                	mov    %ebx,%edx
  8021e6:	89 f0                	mov    %esi,%eax
  8021e8:	e8 93 f7 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  8021ed:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  8021ef:	83 38 00             	cmpl   $0x0,(%eax)
  8021f2:	74 26                	je     80221a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8021f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8021fa:	75 33                	jne    80222f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8021fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  802200:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802203:	89 44 24 04          	mov    %eax,0x4(%esp)
  802207:	8d 47 08             	lea    0x8(%edi),%eax
  80220a:	89 04 24             	mov    %eax,(%esp)
  80220d:	e8 86 e9 ff ff       	call   800b98 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802212:	85 c0                	test   %eax,%eax
  802214:	0f 84 fa 00 00 00    	je     802314 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80221a:	83 3f 00             	cmpl   $0x0,(%edi)
  80221d:	75 10                	jne    80222f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80221f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802223:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802226:	84 c0                	test   %al,%al
  802228:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80222c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80222f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802235:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802237:	8b 56 08             	mov    0x8(%esi),%edx
  80223a:	39 d0                	cmp    %edx,%eax
  80223c:	7c a6                	jl     8021e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80223e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802241:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802244:	eb 07                	jmp    80224d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802246:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80224d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802251:	74 6d                	je     8022c0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802253:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802257:	75 24                	jne    80227d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802259:	83 ea 80             	sub    $0xffffff80,%edx
  80225c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80225f:	e8 0c f9 ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802264:	85 c0                	test   %eax,%eax
  802266:	0f 88 90 00 00 00    	js     8022fc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80226c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80226f:	8b 50 08             	mov    0x8(%eax),%edx
  802272:	83 c2 80             	add    $0xffffff80,%edx
  802275:	e8 06 f7 ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  80227a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80227d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802284:	00 
  802285:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80228c:	00 
  80228d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802290:	89 14 24             	mov    %edx,(%esp)
  802293:	e8 e9 e7 ff ff       	call   800a81 <memset>
	empty->de_namelen = namelen;
  802298:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80229b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80229e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8022a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a9:	83 c0 08             	add    $0x8,%eax
  8022ac:	89 04 24             	mov    %eax,(%esp)
  8022af:	e8 a3 e8 ff ff       	call   800b57 <memcpy>
	*de_store = empty;
  8022b4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8022b7:	eb 5e                	jmp    802317 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8022b9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8022be:	eb 42                	jmp    802302 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8022c0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8022c5:	eb 3b                	jmp    802302 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8022c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ca:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8022cd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8022cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022d2:	89 38                	mov    %edi,(%eax)
			return 0;
  8022d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d9:	eb 2f                	jmp    80230a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8022db:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8022de:	8b 07                	mov    (%edi),%eax
  8022e0:	e8 12 f8 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	78 17                	js     802300 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  8022e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ec:	e8 04 fa ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8022f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8022f7:	e9 41 fe ff ff       	jmp    80213d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	eb 02                	jmp    802302 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802300:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802305:	e8 eb f9 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
	return r;
}
  80230a:	89 f8                	mov    %edi,%eax
  80230c:	83 c4 4c             	add    $0x4c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    
  802314:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802317:	80 3e 00             	cmpb   $0x0,(%esi)
  80231a:	75 bf                	jne    8022db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80231c:	eb a9                	jmp    8022c7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080231e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 3c             	sub    $0x3c,%esp
  802327:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80232a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80232d:	89 04 24             	mov    %eax,(%esp)
  802330:	e8 62 f0 ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  802335:	89 c3                	mov    %eax,%ebx
  802337:	85 c0                	test   %eax,%eax
  802339:	0f 88 16 02 00 00    	js     802555 <_Z4openPKci+0x237>
  80233f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802346:	00 
  802347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802355:	e8 c6 ea ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  80235a:	89 c3                	mov    %eax,%ebx
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	85 db                	test   %ebx,%ebx
  802363:	0f 88 ec 01 00 00    	js     802555 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802369:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80236d:	0f 84 ec 01 00 00    	je     80255f <_Z4openPKci+0x241>
  802373:	83 c0 01             	add    $0x1,%eax
  802376:	83 f8 78             	cmp    $0x78,%eax
  802379:	75 ee                	jne    802369 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80237b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802380:	e9 b9 01 00 00       	jmp    80253e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802385:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802388:	81 e7 00 01 00 00    	and    $0x100,%edi
  80238e:	89 3c 24             	mov    %edi,(%esp)
  802391:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802394:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802397:	89 f0                	mov    %esi,%eax
  802399:	e8 68 fd ff ff       	call   802106 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80239e:	89 c3                	mov    %eax,%ebx
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	0f 85 96 01 00 00    	jne    80253e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8023a8:	85 ff                	test   %edi,%edi
  8023aa:	75 41                	jne    8023ed <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8023ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023af:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8023b4:	75 08                	jne    8023be <_Z4openPKci+0xa0>
            fileino = dirino;
  8023b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023bc:	eb 14                	jmp    8023d2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8023be:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	e8 2f f7 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  8023c8:	89 c3                	mov    %eax,%ebx
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	0f 88 5d 01 00 00    	js     80252f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8023d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d5:	83 38 02             	cmpl   $0x2,(%eax)
  8023d8:	0f 85 d2 00 00 00    	jne    8024b0 <_Z4openPKci+0x192>
  8023de:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  8023e2:	0f 84 c8 00 00 00    	je     8024b0 <_Z4openPKci+0x192>
  8023e8:	e9 38 01 00 00       	jmp    802525 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  8023ed:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8023f4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8023fb:	0f 8e a8 00 00 00    	jle    8024a9 <_Z4openPKci+0x18b>
  802401:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802406:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802409:	89 f8                	mov    %edi,%eax
  80240b:	e8 e7 f6 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  802410:	89 c3                	mov    %eax,%ebx
  802412:	85 c0                	test   %eax,%eax
  802414:	0f 88 15 01 00 00    	js     80252f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80241a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80241d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802421:	75 68                	jne    80248b <_Z4openPKci+0x16d>
  802423:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80242a:	75 5f                	jne    80248b <_Z4openPKci+0x16d>
			*ino_store = ino;
  80242c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80242f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802435:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802438:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80243f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802446:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80244d:	00 
  80244e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802455:	00 
  802456:	83 c0 0c             	add    $0xc,%eax
  802459:	89 04 24             	mov    %eax,(%esp)
  80245c:	e8 20 e6 ff ff       	call   800a81 <memset>
        de->de_inum = fileino->i_inum;
  802461:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802464:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80246a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80246d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80246f:	ba 04 00 00 00       	mov    $0x4,%edx
  802474:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802477:	e8 bf f5 ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80247c:	ba 04 00 00 00       	mov    $0x4,%edx
  802481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802484:	e8 b2 f5 ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
  802489:	eb 25                	jmp    8024b0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80248b:	e8 65 f8 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802490:	83 c7 01             	add    $0x1,%edi
  802493:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802499:	0f 8c 67 ff ff ff    	jl     802406 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80249f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024a4:	e9 86 00 00 00       	jmp    80252f <_Z4openPKci+0x211>
  8024a9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024ae:	eb 7f                	jmp    80252f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8024b0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8024b7:	74 0d                	je     8024c6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8024b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c1:	e8 aa f6 ff ff       	call   801b70 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8024c6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cf:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8024d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8024db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024de:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  8024e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024e4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  8024ea:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  8024ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f1:	83 c0 10             	add    $0x10,%eax
  8024f4:	89 04 24             	mov    %eax,(%esp)
  8024f7:	e8 3e e4 ff ff       	call   80093a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8024fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ff:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802509:	e8 e7 f7 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80250e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802511:	e8 df f7 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 13 ee ff ff       	call   801334 <_Z6fd2numP2Fd>
  802521:	89 c3                	mov    %eax,%ebx
  802523:	eb 30                	jmp    802555 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802525:	e8 cb f7 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80252a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80252f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802532:	e8 be f7 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
  802537:	eb 05                	jmp    80253e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802539:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80253e:	a1 00 60 80 00       	mov    0x806000,%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802549:	89 54 24 04          	mov    %edx,0x4(%esp)
  80254d:	89 04 24             	mov    %eax,(%esp)
  802550:	e8 88 e9 ff ff       	call   800edd <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802555:	89 d8                	mov    %ebx,%eax
  802557:	83 c4 3c             	add    $0x3c,%esp
  80255a:	5b                   	pop    %ebx
  80255b:	5e                   	pop    %esi
  80255c:	5f                   	pop    %edi
  80255d:	5d                   	pop    %ebp
  80255e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80255f:	83 f8 78             	cmp    $0x78,%eax
  802562:	0f 85 1d fe ff ff    	jne    802385 <_Z4openPKci+0x67>
  802568:	eb cf                	jmp    802539 <_Z4openPKci+0x21b>

0080256a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	53                   	push   %ebx
  80256e:	83 ec 24             	sub    $0x24,%esp
  802571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802574:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	e8 78 f5 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  80257f:	85 c0                	test   %eax,%eax
  802581:	78 27                	js     8025aa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802583:	c7 44 24 04 94 48 80 	movl   $0x804894,0x4(%esp)
  80258a:	00 
  80258b:	89 1c 24             	mov    %ebx,(%esp)
  80258e:	e8 a7 e3 ff ff       	call   80093a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802593:	89 da                	mov    %ebx,%edx
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	e8 26 f4 ff ff       	call   8019c3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	e8 50 f7 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
	return 0;
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025aa:	83 c4 24             	add    $0x24,%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    

008025b0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	53                   	push   %ebx
  8025b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8025b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025be:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8025c1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	e8 3a fb ff ff       	call   802106 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8025cc:	89 c3                	mov    %eax,%ebx
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	78 5f                	js     802631 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  8025d2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8025d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	e8 18 f5 ff ff       	call   801af7 <_ZL10inode_openiPP5Inode>
  8025df:	89 c3                	mov    %eax,%ebx
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	78 44                	js     802629 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  8025e5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  8025ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ed:	83 38 02             	cmpl   $0x2,(%eax)
  8025f0:	74 2f                	je     802621 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  8025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  8025fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fe:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802602:	ba 04 00 00 00       	mov    $0x4,%edx
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	e8 2c f4 ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80260f:	ba 04 00 00 00       	mov    $0x4,%edx
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	e8 1f f4 ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
	r = 0;
  80261c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802624:	e8 cc f6 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	e8 c4 f6 ff ff       	call   801cf5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802631:	89 d8                	mov    %ebx,%eax
  802633:	83 c4 24             	add    $0x24,%esp
  802636:	5b                   	pop    %ebx
  802637:	5d                   	pop    %ebp
  802638:	c3                   	ret    

00802639 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
  802641:	5d                   	pop    %ebp
  802642:	c3                   	ret    

00802643 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	57                   	push   %edi
  802647:	56                   	push   %esi
  802648:	53                   	push   %ebx
  802649:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80264f:	c7 04 24 9d 1d 80 00 	movl   $0x801d9d,(%esp)
  802656:	e8 30 15 00 00       	call   803b8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80265b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802660:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802665:	74 28                	je     80268f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802667:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80266e:	4a 
  80266f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802673:	c7 44 24 08 fc 48 80 	movl   $0x8048fc,0x8(%esp)
  80267a:	00 
  80267b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802682:	00 
  802683:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  80268a:	e8 2d 14 00 00       	call   803abc <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  80268f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802694:	83 f8 03             	cmp    $0x3,%eax
  802697:	7f 1c                	jg     8026b5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802699:	c7 44 24 08 30 49 80 	movl   $0x804930,0x8(%esp)
  8026a0:	00 
  8026a1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8026a8:	00 
  8026a9:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  8026b0:	e8 07 14 00 00       	call   803abc <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8026b5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8026bb:	85 d2                	test   %edx,%edx
  8026bd:	7f 1c                	jg     8026db <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8026bf:	c7 44 24 08 60 49 80 	movl   $0x804960,0x8(%esp)
  8026c6:	00 
  8026c7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  8026ce:	00 
  8026cf:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  8026d6:	e8 e1 13 00 00       	call   803abc <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  8026db:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  8026e1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  8026e7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  8026ed:	85 c9                	test   %ecx,%ecx
  8026ef:	0f 48 cb             	cmovs  %ebx,%ecx
  8026f2:	c1 f9 0c             	sar    $0xc,%ecx
  8026f5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  8026f9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  8026ff:	39 c8                	cmp    %ecx,%eax
  802701:	7c 13                	jl     802716 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802703:	85 c0                	test   %eax,%eax
  802705:	7f 3d                	jg     802744 <_Z4fsckv+0x101>
  802707:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80270e:	00 00 00 
  802711:	e9 ac 00 00 00       	jmp    8027c2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802716:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80271c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802720:	89 44 24 10          	mov    %eax,0x10(%esp)
  802724:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802728:	c7 44 24 08 90 49 80 	movl   $0x804990,0x8(%esp)
  80272f:	00 
  802730:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802737:	00 
  802738:	c7 04 24 76 48 80 00 	movl   $0x804876,(%esp)
  80273f:	e8 78 13 00 00       	call   803abc <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802744:	be 00 20 00 50       	mov    $0x50002000,%esi
  802749:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802750:	00 00 00 
  802753:	bb 00 00 00 00       	mov    $0x0,%ebx
  802758:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80275e:	39 df                	cmp    %ebx,%edi
  802760:	7e 27                	jle    802789 <_Z4fsckv+0x146>
  802762:	0f b6 06             	movzbl (%esi),%eax
  802765:	84 c0                	test   %al,%al
  802767:	74 4b                	je     8027b4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802769:	0f be c0             	movsbl %al,%eax
  80276c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802770:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802774:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  80277b:	e8 9e db ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802780:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802787:	eb 2b                	jmp    8027b4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802789:	0f b6 06             	movzbl (%esi),%eax
  80278c:	3c 01                	cmp    $0x1,%al
  80278e:	76 24                	jbe    8027b4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802790:	0f be c0             	movsbl %al,%eax
  802793:	89 44 24 08          	mov    %eax,0x8(%esp)
  802797:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80279b:	c7 04 24 08 4a 80 00 	movl   $0x804a08,(%esp)
  8027a2:	e8 77 db ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  8027a7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8027ae:	80 3e 00             	cmpb   $0x0,(%esi)
  8027b1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8027b4:	83 c3 01             	add    $0x1,%ebx
  8027b7:	83 c6 01             	add    $0x1,%esi
  8027ba:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8027c0:	7f 9c                	jg     80275e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8027c2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8027c9:	0f 8e e1 02 00 00    	jle    802ab0 <_Z4fsckv+0x46d>
  8027cf:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  8027d6:	00 00 00 
		struct Inode *ino = get_inode(i);
  8027d9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8027df:	e8 f9 f1 ff ff       	call   8019dd <_ZL9get_inodei>
  8027e4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  8027ea:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  8027ee:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  8027f5:	75 22                	jne    802819 <_Z4fsckv+0x1d6>
  8027f7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  8027fe:	0f 84 a9 06 00 00    	je     802ead <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802804:	ba 00 00 00 00       	mov    $0x0,%edx
  802809:	e8 2d f2 ff ff       	call   801a3b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 3a                	je     80284c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802812:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802819:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80281f:	8b 02                	mov    (%edx),%eax
  802821:	83 f8 01             	cmp    $0x1,%eax
  802824:	74 26                	je     80284c <_Z4fsckv+0x209>
  802826:	83 f8 02             	cmp    $0x2,%eax
  802829:	74 21                	je     80284c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80282b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80282f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802835:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802839:	c7 04 24 34 4a 80 00 	movl   $0x804a34,(%esp)
  802840:	e8 d9 da ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802845:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80284c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802853:	75 3f                	jne    802894 <_Z4fsckv+0x251>
  802855:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80285b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80285f:	75 15                	jne    802876 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802861:	c7 04 24 58 4a 80 00 	movl   $0x804a58,(%esp)
  802868:	e8 b1 da ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  80286d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802874:	eb 1e                	jmp    802894 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802876:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80287c:	83 3a 02             	cmpl   $0x2,(%edx)
  80287f:	74 13                	je     802894 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802881:	c7 04 24 8c 4a 80 00 	movl   $0x804a8c,(%esp)
  802888:	e8 91 da ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  80288d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802894:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802899:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028a0:	0f 84 93 00 00 00    	je     802939 <_Z4fsckv+0x2f6>
  8028a6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8028ac:	8b 41 08             	mov    0x8(%ecx),%eax
  8028af:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8028b4:	7e 23                	jle    8028d9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8028b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ba:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8028c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c4:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  8028cb:	e8 4e da ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  8028d0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028d7:	eb 09                	jmp    8028e2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  8028d9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028e0:	74 4b                	je     80292d <_Z4fsckv+0x2ea>
  8028e2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8028e8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  8028ee:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  8028f4:	74 23                	je     802919 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  8028f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028fa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802900:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802904:	c7 04 24 e0 4a 80 00 	movl   $0x804ae0,(%esp)
  80290b:	e8 0e da ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802910:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802917:	eb 09                	jmp    802922 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802919:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802920:	74 12                	je     802934 <_Z4fsckv+0x2f1>
  802922:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802928:	8b 78 08             	mov    0x8(%eax),%edi
  80292b:	eb 0c                	jmp    802939 <_Z4fsckv+0x2f6>
  80292d:	bf 00 00 00 00       	mov    $0x0,%edi
  802932:	eb 05                	jmp    802939 <_Z4fsckv+0x2f6>
  802934:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802939:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80293e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802944:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802948:	89 d8                	mov    %ebx,%eax
  80294a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80294d:	39 c7                	cmp    %eax,%edi
  80294f:	7e 2b                	jle    80297c <_Z4fsckv+0x339>
  802951:	85 f6                	test   %esi,%esi
  802953:	75 27                	jne    80297c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802959:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80295d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802963:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802967:	c7 04 24 04 4b 80 00 	movl   $0x804b04,(%esp)
  80296e:	e8 ab d9 ff ff       	call   80031e <_Z7cprintfPKcz>
				++errors;
  802973:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80297a:	eb 36                	jmp    8029b2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80297c:	39 f8                	cmp    %edi,%eax
  80297e:	7c 32                	jl     8029b2 <_Z4fsckv+0x36f>
  802980:	85 f6                	test   %esi,%esi
  802982:	74 2e                	je     8029b2 <_Z4fsckv+0x36f>
  802984:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  80298b:	74 25                	je     8029b2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  80298d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802991:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802995:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80299b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299f:	c7 04 24 48 4b 80 00 	movl   $0x804b48,(%esp)
  8029a6:	e8 73 d9 ff ff       	call   80031e <_Z7cprintfPKcz>
				++errors;
  8029ab:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8029b2:	85 f6                	test   %esi,%esi
  8029b4:	0f 84 a0 00 00 00    	je     802a5a <_Z4fsckv+0x417>
  8029ba:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029c1:	0f 84 93 00 00 00    	je     802a5a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8029c7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8029cd:	7e 27                	jle    8029f6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8029cf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8029d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029d7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8029dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029e1:	c7 04 24 8c 4b 80 00 	movl   $0x804b8c,(%esp)
  8029e8:	e8 31 d9 ff ff       	call   80031e <_Z7cprintfPKcz>
					++errors;
  8029ed:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029f4:	eb 64                	jmp    802a5a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  8029f6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  8029fd:	3c 01                	cmp    $0x1,%al
  8029ff:	75 27                	jne    802a28 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802a01:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a09:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a13:	c7 04 24 d0 4b 80 00 	movl   $0x804bd0,(%esp)
  802a1a:	e8 ff d8 ff ff       	call   80031e <_Z7cprintfPKcz>
					++errors;
  802a1f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a26:	eb 32                	jmp    802a5a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802a28:	3c ff                	cmp    $0xff,%al
  802a2a:	75 27                	jne    802a53 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802a2c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a3e:	c7 04 24 0c 4c 80 00 	movl   $0x804c0c,(%esp)
  802a45:	e8 d4 d8 ff ff       	call   80031e <_Z7cprintfPKcz>
					++errors;
  802a4a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a51:	eb 07                	jmp    802a5a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802a53:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802a5a:	83 c3 01             	add    $0x1,%ebx
  802a5d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802a63:	0f 85 d5 fe ff ff    	jne    80293e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802a69:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802a70:	0f 94 c0             	sete   %al
  802a73:	0f b6 c0             	movzbl %al,%eax
  802a76:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a7c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802a82:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802a89:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802a90:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802a97:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802a9e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802aa4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802aaa:	0f 8f 29 fd ff ff    	jg     8027d9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ab0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802ab7:	0f 8e 7f 03 00 00    	jle    802e3c <_Z4fsckv+0x7f9>
  802abd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802ac2:	89 f0                	mov    %esi,%eax
  802ac4:	e8 14 ef ff ff       	call   8019dd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802ac9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802ad0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802ad7:	c1 e2 08             	shl    $0x8,%edx
  802ada:	09 ca                	or     %ecx,%edx
  802adc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802ae3:	c1 e1 10             	shl    $0x10,%ecx
  802ae6:	09 ca                	or     %ecx,%edx
  802ae8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802aef:	83 e1 7f             	and    $0x7f,%ecx
  802af2:	c1 e1 18             	shl    $0x18,%ecx
  802af5:	09 d1                	or     %edx,%ecx
  802af7:	74 0e                	je     802b07 <_Z4fsckv+0x4c4>
  802af9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802b00:	78 05                	js     802b07 <_Z4fsckv+0x4c4>
  802b02:	83 38 02             	cmpl   $0x2,(%eax)
  802b05:	74 1f                	je     802b26 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b07:	83 c6 01             	add    $0x1,%esi
  802b0a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802b0f:	39 f0                	cmp    %esi,%eax
  802b11:	7f af                	jg     802ac2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802b13:	bb 01 00 00 00       	mov    $0x1,%ebx
  802b18:	83 f8 01             	cmp    $0x1,%eax
  802b1b:	0f 8f ad 02 00 00    	jg     802dce <_Z4fsckv+0x78b>
  802b21:	e9 16 03 00 00       	jmp    802e3c <_Z4fsckv+0x7f9>
  802b26:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802b28:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802b2f:	8b 40 08             	mov    0x8(%eax),%eax
  802b32:	a8 7f                	test   $0x7f,%al
  802b34:	74 23                	je     802b59 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802b36:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802b3d:	00 
  802b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b42:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b46:	c7 04 24 48 4c 80 00 	movl   $0x804c48,(%esp)
  802b4d:	e8 cc d7 ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802b52:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b59:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802b60:	00 00 00 
  802b63:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802b69:	e9 3d 02 00 00       	jmp    802dab <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802b6e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b74:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802b7a:	e8 01 ee ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
  802b7f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802b81:	83 38 00             	cmpl   $0x0,(%eax)
  802b84:	0f 84 15 02 00 00    	je     802d9f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b90:	83 fa 76             	cmp    $0x76,%edx
  802b93:	76 27                	jbe    802bbc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802b95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b99:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802b9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ba3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ba7:	c7 04 24 7c 4c 80 00 	movl   $0x804c7c,(%esp)
  802bae:	e8 6b d7 ff ff       	call   80031e <_Z7cprintfPKcz>
				++errors;
  802bb3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802bba:	eb 28                	jmp    802be4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802bbc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802bc1:	74 21                	je     802be4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802bc3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802bc9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bcd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd1:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  802bd8:	e8 41 d7 ff ff       	call   80031e <_Z7cprintfPKcz>
				++errors;
  802bdd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802be4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802beb:	00 
  802bec:	8d 43 08             	lea    0x8(%ebx),%eax
  802bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802bf9:	89 0c 24             	mov    %ecx,(%esp)
  802bfc:	e8 56 df ff ff       	call   800b57 <memcpy>
  802c01:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802c05:	bf 77 00 00 00       	mov    $0x77,%edi
  802c0a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802c0e:	85 ff                	test   %edi,%edi
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802c18:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802c1f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802c20:	8b 03                	mov    (%ebx),%eax
  802c22:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802c28:	7c 3e                	jl     802c68 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802c2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c2e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c34:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c38:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c42:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c46:	c7 04 24 dc 4c 80 00 	movl   $0x804cdc,(%esp)
  802c4d:	e8 cc d6 ff ff       	call   80031e <_Z7cprintfPKcz>
				++errors;
  802c52:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802c59:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802c60:	00 00 00 
  802c63:	e9 0b 01 00 00       	jmp    802d73 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802c68:	e8 70 ed ff ff       	call   8019dd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802c6d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802c74:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802c7b:	c1 e2 08             	shl    $0x8,%edx
  802c7e:	09 d1                	or     %edx,%ecx
  802c80:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802c87:	c1 e2 10             	shl    $0x10,%edx
  802c8a:	09 d1                	or     %edx,%ecx
  802c8c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802c93:	83 e2 7f             	and    $0x7f,%edx
  802c96:	c1 e2 18             	shl    $0x18,%edx
  802c99:	09 ca                	or     %ecx,%edx
  802c9b:	83 c2 01             	add    $0x1,%edx
  802c9e:	89 d1                	mov    %edx,%ecx
  802ca0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802ca6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802cac:	0f b6 d5             	movzbl %ch,%edx
  802caf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802cb5:	89 ca                	mov    %ecx,%edx
  802cb7:	c1 ea 10             	shr    $0x10,%edx
  802cba:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802cc0:	c1 e9 18             	shr    $0x18,%ecx
  802cc3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802cca:	83 e2 80             	and    $0xffffff80,%edx
  802ccd:	09 ca                	or     %ecx,%edx
  802ccf:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802cd5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802cd9:	0f 85 7a ff ff ff    	jne    802c59 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802cdf:	8b 03                	mov    (%ebx),%eax
  802ce1:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ce5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802ceb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802cef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cfd:	c7 04 24 0c 4d 80 00 	movl   $0x804d0c,(%esp)
  802d04:	e8 15 d6 ff ff       	call   80031e <_Z7cprintfPKcz>
					++errors;
  802d09:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d10:	e9 44 ff ff ff       	jmp    802c59 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d15:	3b 78 04             	cmp    0x4(%eax),%edi
  802d18:	75 52                	jne    802d6c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802d1a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d1e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802d24:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d28:	83 c0 08             	add    $0x8,%eax
  802d2b:	89 04 24             	mov    %eax,(%esp)
  802d2e:	e8 65 de ff ff       	call   800b98 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d33:	85 c0                	test   %eax,%eax
  802d35:	75 35                	jne    802d6c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802d37:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d41:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802d47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d4b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d51:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d59:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802d60:	e8 b9 d5 ff ff       	call   80031e <_Z7cprintfPKcz>
					++errors;
  802d65:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d6c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802d73:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d79:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802d7f:	7e 1e                	jle    802d9f <_Z4fsckv+0x75c>
  802d81:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802d85:	7f 18                	jg     802d9f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802d87:	89 ca                	mov    %ecx,%edx
  802d89:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d8f:	e8 ec eb ff ff       	call   801980 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802d94:	83 38 00             	cmpl   $0x0,(%eax)
  802d97:	0f 85 78 ff ff ff    	jne    802d15 <_Z4fsckv+0x6d2>
  802d9d:	eb cd                	jmp    802d6c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802d9f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802da5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802dab:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802db1:	83 ea 80             	sub    $0xffffff80,%edx
  802db4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802dba:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802dc0:	3b 51 08             	cmp    0x8(%ecx),%edx
  802dc3:	0f 8f e7 fc ff ff    	jg     802ab0 <_Z4fsckv+0x46d>
  802dc9:	e9 a0 fd ff ff       	jmp    802b6e <_Z4fsckv+0x52b>
  802dce:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802dd4:	89 d8                	mov    %ebx,%eax
  802dd6:	e8 02 ec ff ff       	call   8019dd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802ddb:	8b 50 04             	mov    0x4(%eax),%edx
  802dde:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802de5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802dec:	c1 e7 08             	shl    $0x8,%edi
  802def:	09 f9                	or     %edi,%ecx
  802df1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802df8:	c1 e7 10             	shl    $0x10,%edi
  802dfb:	09 f9                	or     %edi,%ecx
  802dfd:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802e04:	83 e7 7f             	and    $0x7f,%edi
  802e07:	c1 e7 18             	shl    $0x18,%edi
  802e0a:	09 f9                	or     %edi,%ecx
  802e0c:	39 ca                	cmp    %ecx,%edx
  802e0e:	74 1b                	je     802e2b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802e10:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e14:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e1c:	c7 04 24 6c 4d 80 00 	movl   $0x804d6c,(%esp)
  802e23:	e8 f6 d4 ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802e28:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802e2b:	83 c3 01             	add    $0x1,%ebx
  802e2e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802e34:	7f 9e                	jg     802dd4 <_Z4fsckv+0x791>
  802e36:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e3c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802e43:	7e 4f                	jle    802e94 <_Z4fsckv+0x851>
  802e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e4a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802e50:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802e57:	3c ff                	cmp    $0xff,%al
  802e59:	75 09                	jne    802e64 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802e5b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802e62:	eb 1f                	jmp    802e83 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802e64:	84 c0                	test   %al,%al
  802e66:	75 1b                	jne    802e83 <_Z4fsckv+0x840>
  802e68:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802e6e:	7c 13                	jl     802e83 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802e70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e74:	c7 04 24 98 4d 80 00 	movl   $0x804d98,(%esp)
  802e7b:	e8 9e d4 ff ff       	call   80031e <_Z7cprintfPKcz>
			++errors;
  802e80:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e83:	83 c3 01             	add    $0x1,%ebx
  802e86:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802e8c:	7f c2                	jg     802e50 <_Z4fsckv+0x80d>
  802e8e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802e94:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802e9b:	19 c0                	sbb    %eax,%eax
  802e9d:	f7 d0                	not    %eax
  802e9f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802ea2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802ea8:	5b                   	pop    %ebx
  802ea9:	5e                   	pop    %esi
  802eaa:	5f                   	pop    %edi
  802eab:	5d                   	pop    %ebp
  802eac:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802ead:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802eb4:	0f 84 92 f9 ff ff    	je     80284c <_Z4fsckv+0x209>
  802eba:	e9 5a f9 ff ff       	jmp    802819 <_Z4fsckv+0x1d6>
	...

00802ec0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ec0:	55                   	push   %ebp
  802ec1:	89 e5                	mov    %esp,%ebp
  802ec3:	83 ec 18             	sub    $0x18,%esp
  802ec6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802ec9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	89 04 24             	mov    %eax,(%esp)
  802ed5:	e8 a2 e4 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  802eda:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802edc:	c7 44 24 04 cb 4d 80 	movl   $0x804dcb,0x4(%esp)
  802ee3:	00 
  802ee4:	89 34 24             	mov    %esi,(%esp)
  802ee7:	e8 4e da ff ff       	call   80093a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802eec:	8b 43 04             	mov    0x4(%ebx),%eax
  802eef:	2b 03                	sub    (%ebx),%eax
  802ef1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802ef4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802efb:	c7 86 80 00 00 00 24 	movl   $0x805024,0x80(%esi)
  802f02:	50 80 00 
	return 0;
}
  802f05:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f0d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f10:	89 ec                	mov    %ebp,%esp
  802f12:	5d                   	pop    %ebp
  802f13:	c3                   	ret    

00802f14 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802f14:	55                   	push   %ebp
  802f15:	89 e5                	mov    %esp,%ebp
  802f17:	53                   	push   %ebx
  802f18:	83 ec 14             	sub    $0x14,%esp
  802f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f29:	e8 af df ff ff       	call   800edd <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802f2e:	89 1c 24             	mov    %ebx,(%esp)
  802f31:	e8 46 e4 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  802f36:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f41:	e8 97 df ff ff       	call   800edd <_Z14sys_page_unmapiPv>
}
  802f46:	83 c4 14             	add    $0x14,%esp
  802f49:	5b                   	pop    %ebx
  802f4a:	5d                   	pop    %ebp
  802f4b:	c3                   	ret    

00802f4c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f4c:	55                   	push   %ebp
  802f4d:	89 e5                	mov    %esp,%ebp
  802f4f:	57                   	push   %edi
  802f50:	56                   	push   %esi
  802f51:	53                   	push   %ebx
  802f52:	83 ec 2c             	sub    $0x2c,%esp
  802f55:	89 c7                	mov    %eax,%edi
  802f57:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802f5a:	a1 00 60 80 00       	mov    0x806000,%eax
  802f5f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802f62:	89 3c 24             	mov    %edi,(%esp)
  802f65:	e8 82 04 00 00       	call   8033ec <_Z7pagerefPv>
  802f6a:	89 c3                	mov    %eax,%ebx
  802f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6f:	89 04 24             	mov    %eax,(%esp)
  802f72:	e8 75 04 00 00       	call   8033ec <_Z7pagerefPv>
  802f77:	39 c3                	cmp    %eax,%ebx
  802f79:	0f 94 c0             	sete   %al
  802f7c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802f7f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802f85:	8b 52 58             	mov    0x58(%edx),%edx
  802f88:	39 d6                	cmp    %edx,%esi
  802f8a:	75 08                	jne    802f94 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802f8c:	83 c4 2c             	add    $0x2c,%esp
  802f8f:	5b                   	pop    %ebx
  802f90:	5e                   	pop    %esi
  802f91:	5f                   	pop    %edi
  802f92:	5d                   	pop    %ebp
  802f93:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 c2                	je     802f5a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802f98:	c7 04 24 d2 4d 80 00 	movl   $0x804dd2,(%esp)
  802f9f:	e8 7a d3 ff ff       	call   80031e <_Z7cprintfPKcz>
  802fa4:	eb b4                	jmp    802f5a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802fa6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	57                   	push   %edi
  802faa:	56                   	push   %esi
  802fab:	53                   	push   %ebx
  802fac:	83 ec 1c             	sub    $0x1c,%esp
  802faf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802fb2:	89 34 24             	mov    %esi,(%esp)
  802fb5:	e8 c2 e3 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  802fba:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fbc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fc5:	75 46                	jne    80300d <_ZL13devpipe_writeP2FdPKvj+0x67>
  802fc7:	eb 52                	jmp    80301b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802fc9:	89 da                	mov    %ebx,%edx
  802fcb:	89 f0                	mov    %esi,%eax
  802fcd:	e8 7a ff ff ff       	call   802f4c <_ZL13_pipeisclosedP2FdP4Pipe>
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	75 49                	jne    80301f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  802fd6:	e8 11 de ff ff       	call   800dec <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802fdb:	8b 43 04             	mov    0x4(%ebx),%eax
  802fde:	89 c2                	mov    %eax,%edx
  802fe0:	2b 13                	sub    (%ebx),%edx
  802fe2:	83 fa 20             	cmp    $0x20,%edx
  802fe5:	74 e2                	je     802fc9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802fe7:	89 c2                	mov    %eax,%edx
  802fe9:	c1 fa 1f             	sar    $0x1f,%edx
  802fec:	c1 ea 1b             	shr    $0x1b,%edx
  802fef:	01 d0                	add    %edx,%eax
  802ff1:	83 e0 1f             	and    $0x1f,%eax
  802ff4:	29 d0                	sub    %edx,%eax
  802ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ff9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  802ffd:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803001:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803005:	83 c7 01             	add    $0x1,%edi
  803008:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80300b:	76 0e                	jbe    80301b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80300d:	8b 43 04             	mov    0x4(%ebx),%eax
  803010:	89 c2                	mov    %eax,%edx
  803012:	2b 13                	sub    (%ebx),%edx
  803014:	83 fa 20             	cmp    $0x20,%edx
  803017:	74 b0                	je     802fc9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803019:	eb cc                	jmp    802fe7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80301b:	89 f8                	mov    %edi,%eax
  80301d:	eb 05                	jmp    803024 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80301f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803024:	83 c4 1c             	add    $0x1c,%esp
  803027:	5b                   	pop    %ebx
  803028:	5e                   	pop    %esi
  803029:	5f                   	pop    %edi
  80302a:	5d                   	pop    %ebp
  80302b:	c3                   	ret    

0080302c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
  80302f:	83 ec 28             	sub    $0x28,%esp
  803032:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803035:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803038:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80303b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80303e:	89 3c 24             	mov    %edi,(%esp)
  803041:	e8 36 e3 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  803046:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803048:	be 00 00 00 00       	mov    $0x0,%esi
  80304d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803051:	75 47                	jne    80309a <_ZL12devpipe_readP2FdPvj+0x6e>
  803053:	eb 52                	jmp    8030a7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803055:	89 f0                	mov    %esi,%eax
  803057:	eb 5e                	jmp    8030b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803059:	89 da                	mov    %ebx,%edx
  80305b:	89 f8                	mov    %edi,%eax
  80305d:	8d 76 00             	lea    0x0(%esi),%esi
  803060:	e8 e7 fe ff ff       	call   802f4c <_ZL13_pipeisclosedP2FdP4Pipe>
  803065:	85 c0                	test   %eax,%eax
  803067:	75 49                	jne    8030b2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803069:	e8 7e dd ff ff       	call   800dec <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80306e:	8b 03                	mov    (%ebx),%eax
  803070:	3b 43 04             	cmp    0x4(%ebx),%eax
  803073:	74 e4                	je     803059 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803075:	89 c2                	mov    %eax,%edx
  803077:	c1 fa 1f             	sar    $0x1f,%edx
  80307a:	c1 ea 1b             	shr    $0x1b,%edx
  80307d:	01 d0                	add    %edx,%eax
  80307f:	83 e0 1f             	and    $0x1f,%eax
  803082:	29 d0                	sub    %edx,%eax
  803084:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80308f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803092:	83 c6 01             	add    $0x1,%esi
  803095:	39 75 10             	cmp    %esi,0x10(%ebp)
  803098:	76 0d                	jbe    8030a7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80309a:	8b 03                	mov    (%ebx),%eax
  80309c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80309f:	75 d4                	jne    803075 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8030a1:	85 f6                	test   %esi,%esi
  8030a3:	75 b0                	jne    803055 <_ZL12devpipe_readP2FdPvj+0x29>
  8030a5:	eb b2                	jmp    803059 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8030a7:	89 f0                	mov    %esi,%eax
  8030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030b0:	eb 05                	jmp    8030b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8030b2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8030b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8030ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8030bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8030c0:	89 ec                	mov    %ebp,%esp
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    

008030c4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 48             	sub    $0x48,%esp
  8030ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8030cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8030d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8030d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8030d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8030d9:	89 04 24             	mov    %eax,(%esp)
  8030dc:	e8 b6 e2 ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  8030e1:	89 c3                	mov    %eax,%ebx
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	0f 88 0b 01 00 00    	js     8031f6 <_Z4pipePi+0x132>
  8030eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030f2:	00 
  8030f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803101:	e8 1a dd ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803106:	89 c3                	mov    %eax,%ebx
  803108:	85 c0                	test   %eax,%eax
  80310a:	0f 89 f5 00 00 00    	jns    803205 <_Z4pipePi+0x141>
  803110:	e9 e1 00 00 00       	jmp    8031f6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803115:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80311c:	00 
  80311d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803120:	89 44 24 04          	mov    %eax,0x4(%esp)
  803124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80312b:	e8 f0 dc ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803130:	89 c3                	mov    %eax,%ebx
  803132:	85 c0                	test   %eax,%eax
  803134:	0f 89 e2 00 00 00    	jns    80321c <_Z4pipePi+0x158>
  80313a:	e9 a4 00 00 00       	jmp    8031e3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80313f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803142:	89 04 24             	mov    %eax,(%esp)
  803145:	e8 32 e2 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  80314a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803151:	00 
  803152:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803156:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80315d:	00 
  80315e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803169:	e8 11 dd ff ff       	call   800e7f <_Z12sys_page_mapiPviS_i>
  80316e:	89 c3                	mov    %eax,%ebx
  803170:	85 c0                	test   %eax,%eax
  803172:	78 4c                	js     8031c0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803174:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80317a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803189:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80318f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803192:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803197:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80319e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a1:	89 04 24             	mov    %eax,(%esp)
  8031a4:	e8 8b e1 ff ff       	call   801334 <_Z6fd2numP2Fd>
  8031a9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8031ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ae:	89 04 24             	mov    %eax,(%esp)
  8031b1:	e8 7e e1 ff ff       	call   801334 <_Z6fd2numP2Fd>
  8031b6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8031b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031be:	eb 36                	jmp    8031f6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8031c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031cb:	e8 0d dd ff ff       	call   800edd <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8031d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031de:	e8 fa dc ff ff       	call   800edd <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8031e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031f1:	e8 e7 dc ff ff       	call   800edd <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8031f6:	89 d8                	mov    %ebx,%eax
  8031f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8031fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8031fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803201:	89 ec                	mov    %ebp,%esp
  803203:	5d                   	pop    %ebp
  803204:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803205:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803208:	89 04 24             	mov    %eax,(%esp)
  80320b:	e8 87 e1 ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  803210:	89 c3                	mov    %eax,%ebx
  803212:	85 c0                	test   %eax,%eax
  803214:	0f 89 fb fe ff ff    	jns    803115 <_Z4pipePi+0x51>
  80321a:	eb c7                	jmp    8031e3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80321c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321f:	89 04 24             	mov    %eax,(%esp)
  803222:	e8 55 e1 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  803227:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803229:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803230:	00 
  803231:	89 44 24 04          	mov    %eax,0x4(%esp)
  803235:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80323c:	e8 df db ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803241:	89 c3                	mov    %eax,%ebx
  803243:	85 c0                	test   %eax,%eax
  803245:	0f 89 f4 fe ff ff    	jns    80313f <_Z4pipePi+0x7b>
  80324b:	eb 83                	jmp    8031d0 <_Z4pipePi+0x10c>

0080324d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80324d:	55                   	push   %ebp
  80324e:	89 e5                	mov    %esp,%ebp
  803250:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803253:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80325a:	00 
  80325b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80325e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	89 04 24             	mov    %eax,(%esp)
  803268:	e8 74 e0 ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80326d:	85 c0                	test   %eax,%eax
  80326f:	78 15                	js     803286 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	89 04 24             	mov    %eax,(%esp)
  803277:	e8 00 e1 ff ff       	call   80137c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80327c:	89 c2                	mov    %eax,%edx
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	e8 c6 fc ff ff       	call   802f4c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803286:	c9                   	leave  
  803287:	c3                   	ret    

00803288 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803288:	55                   	push   %ebp
  803289:	89 e5                	mov    %esp,%ebp
  80328b:	53                   	push   %ebx
  80328c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80328f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803292:	89 04 24             	mov    %eax,(%esp)
  803295:	e8 fd e0 ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  80329a:	89 c3                	mov    %eax,%ebx
  80329c:	85 c0                	test   %eax,%eax
  80329e:	0f 88 be 00 00 00    	js     803362 <_Z18pipe_ipc_recv_readv+0xda>
  8032a4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032ab:	00 
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032ba:	e8 61 db ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  8032bf:	89 c3                	mov    %eax,%ebx
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	0f 89 a1 00 00 00    	jns    80336a <_Z18pipe_ipc_recv_readv+0xe2>
  8032c9:	e9 94 00 00 00       	jmp    803362 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8032ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	75 0e                	jne    8032e3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8032d5:	c7 04 24 30 4e 80 00 	movl   $0x804e30,(%esp)
  8032dc:	e8 3d d0 ff ff       	call   80031e <_Z7cprintfPKcz>
  8032e1:	eb 10                	jmp    8032f3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8032e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e7:	c7 04 24 e5 4d 80 00 	movl   $0x804de5,(%esp)
  8032ee:	e8 2b d0 ff ff       	call   80031e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8032f3:	c7 04 24 ef 4d 80 00 	movl   $0x804def,(%esp)
  8032fa:	e8 1f d0 ff ff       	call   80031e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8032ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803302:	a8 04                	test   $0x4,%al
  803304:	74 04                	je     80330a <_Z18pipe_ipc_recv_readv+0x82>
  803306:	a8 01                	test   $0x1,%al
  803308:	75 24                	jne    80332e <_Z18pipe_ipc_recv_readv+0xa6>
  80330a:	c7 44 24 0c 02 4e 80 	movl   $0x804e02,0xc(%esp)
  803311:	00 
  803312:	c7 44 24 08 cc 47 80 	movl   $0x8047cc,0x8(%esp)
  803319:	00 
  80331a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803321:	00 
  803322:	c7 04 24 1f 4e 80 00 	movl   $0x804e1f,(%esp)
  803329:	e8 8e 07 00 00       	call   803abc <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80332e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803343:	89 04 24             	mov    %eax,(%esp)
  803346:	e8 e9 df ff ff       	call   801334 <_Z6fd2numP2Fd>
  80334b:	89 c3                	mov    %eax,%ebx
  80334d:	eb 13                	jmp    803362 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	89 44 24 04          	mov    %eax,0x4(%esp)
  803356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80335d:	e8 7b db ff ff       	call   800edd <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803362:	89 d8                	mov    %ebx,%eax
  803364:	83 c4 24             	add    $0x24,%esp
  803367:	5b                   	pop    %ebx
  803368:	5d                   	pop    %ebp
  803369:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	89 04 24             	mov    %eax,(%esp)
  803370:	e8 07 e0 ff ff       	call   80137c <_Z7fd2dataP2Fd>
  803375:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803378:	89 54 24 08          	mov    %edx,0x8(%esp)
  80337c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803383:	89 04 24             	mov    %eax,(%esp)
  803386:	e8 f5 08 00 00       	call   803c80 <_Z8ipc_recvPiPvS_>
  80338b:	89 c3                	mov    %eax,%ebx
  80338d:	85 c0                	test   %eax,%eax
  80338f:	0f 89 39 ff ff ff    	jns    8032ce <_Z18pipe_ipc_recv_readv+0x46>
  803395:	eb b8                	jmp    80334f <_Z18pipe_ipc_recv_readv+0xc7>

00803397 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803397:	55                   	push   %ebp
  803398:	89 e5                	mov    %esp,%ebp
  80339a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80339d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8033a4:	00 
  8033a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033af:	89 04 24             	mov    %eax,(%esp)
  8033b2:	e8 2a df ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	78 2f                	js     8033ea <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	89 04 24             	mov    %eax,(%esp)
  8033c1:	e8 b6 df ff ff       	call   80137c <_Z7fd2dataP2Fd>
  8033c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8033cd:	00 
  8033ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033d9:	00 
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	89 04 24             	mov    %eax,(%esp)
  8033e0:	e8 2a 09 00 00       	call   803d0f <_Z8ipc_sendijPvi>
    return 0;
  8033e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ea:	c9                   	leave  
  8033eb:	c3                   	ret    

008033ec <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033ec:	55                   	push   %ebp
  8033ed:	89 e5                	mov    %esp,%ebp
  8033ef:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8033f2:	89 d0                	mov    %edx,%eax
  8033f4:	c1 e8 16             	shr    $0x16,%eax
  8033f7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8033fe:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803403:	f6 c1 01             	test   $0x1,%cl
  803406:	74 1d                	je     803425 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803408:	c1 ea 0c             	shr    $0xc,%edx
  80340b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803412:	f6 c2 01             	test   $0x1,%dl
  803415:	74 0e                	je     803425 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803417:	c1 ea 0c             	shr    $0xc,%edx
  80341a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803421:	ef 
  803422:	0f b7 c0             	movzwl %ax,%eax
}
  803425:	5d                   	pop    %ebp
  803426:	c3                   	ret    
	...

00803430 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803430:	55                   	push   %ebp
  803431:	89 e5                	mov    %esp,%ebp
  803433:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803436:	c7 44 24 04 53 4e 80 	movl   $0x804e53,0x4(%esp)
  80343d:	00 
  80343e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803441:	89 04 24             	mov    %eax,(%esp)
  803444:	e8 f1 d4 ff ff       	call   80093a <_Z6strcpyPcPKc>
	return 0;
}
  803449:	b8 00 00 00 00       	mov    $0x0,%eax
  80344e:	c9                   	leave  
  80344f:	c3                   	ret    

00803450 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
  803453:	53                   	push   %ebx
  803454:	83 ec 14             	sub    $0x14,%esp
  803457:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80345a:	89 1c 24             	mov    %ebx,(%esp)
  80345d:	e8 8a ff ff ff       	call   8033ec <_Z7pagerefPv>
  803462:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803469:	83 fa 01             	cmp    $0x1,%edx
  80346c:	75 0b                	jne    803479 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80346e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803471:	89 04 24             	mov    %eax,(%esp)
  803474:	e8 fe 02 00 00       	call   803777 <_Z11nsipc_closei>
	else
		return 0;
}
  803479:	83 c4 14             	add    $0x14,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5d                   	pop    %ebp
  80347e:	c3                   	ret    

0080347f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80347f:	55                   	push   %ebp
  803480:	89 e5                	mov    %esp,%ebp
  803482:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803485:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80348c:	00 
  80348d:	8b 45 10             	mov    0x10(%ebp),%eax
  803490:	89 44 24 08          	mov    %eax,0x8(%esp)
  803494:	8b 45 0c             	mov    0xc(%ebp),%eax
  803497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	89 04 24             	mov    %eax,(%esp)
  8034a4:	e8 c9 03 00 00       	call   803872 <_Z10nsipc_sendiPKvij>
}
  8034a9:	c9                   	leave  
  8034aa:	c3                   	ret    

008034ab <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034ab:	55                   	push   %ebp
  8034ac:	89 e5                	mov    %esp,%ebp
  8034ae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8034b8:	00 
  8034b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	89 04 24             	mov    %eax,(%esp)
  8034d0:	e8 1d 03 00 00       	call   8037f2 <_Z10nsipc_recviPvij>
}
  8034d5:	c9                   	leave  
  8034d6:	c3                   	ret    

008034d7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8034d7:	55                   	push   %ebp
  8034d8:	89 e5                	mov    %esp,%ebp
  8034da:	83 ec 28             	sub    $0x28,%esp
  8034dd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8034e0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8034e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8034e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034e8:	89 04 24             	mov    %eax,(%esp)
  8034eb:	e8 a7 de ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  8034f0:	89 c3                	mov    %eax,%ebx
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	78 21                	js     803517 <_ZL12alloc_sockfdi+0x40>
  8034f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8034fd:	00 
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	89 44 24 04          	mov    %eax,0x4(%esp)
  803505:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80350c:	e8 0f d9 ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803511:	89 c3                	mov    %eax,%ebx
  803513:	85 c0                	test   %eax,%eax
  803515:	79 14                	jns    80352b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803517:	89 34 24             	mov    %esi,(%esp)
  80351a:	e8 58 02 00 00       	call   803777 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80351f:	89 d8                	mov    %ebx,%eax
  803521:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803524:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803527:	89 ec                	mov    %ebp,%esp
  803529:	5d                   	pop    %ebp
  80352a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80352b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803534:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803540:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803543:	89 04 24             	mov    %eax,(%esp)
  803546:	e8 e9 dd ff ff       	call   801334 <_Z6fd2numP2Fd>
  80354b:	89 c3                	mov    %eax,%ebx
  80354d:	eb d0                	jmp    80351f <_ZL12alloc_sockfdi+0x48>

0080354f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80354f:	55                   	push   %ebp
  803550:	89 e5                	mov    %esp,%ebp
  803552:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803555:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80355c:	00 
  80355d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803560:	89 54 24 04          	mov    %edx,0x4(%esp)
  803564:	89 04 24             	mov    %eax,(%esp)
  803567:	e8 75 dd ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  80356c:	85 c0                	test   %eax,%eax
  80356e:	78 15                	js     803585 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803570:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803573:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803578:	8b 0d 40 50 80 00    	mov    0x805040,%ecx
  80357e:	39 0a                	cmp    %ecx,(%edx)
  803580:	75 03                	jne    803585 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803582:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803585:	c9                   	leave  
  803586:	c3                   	ret    

00803587 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803587:	55                   	push   %ebp
  803588:	89 e5                	mov    %esp,%ebp
  80358a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	e8 ba ff ff ff       	call   80354f <_ZL9fd2sockidi>
  803595:	85 c0                	test   %eax,%eax
  803597:	78 1f                	js     8035b8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803599:	8b 55 10             	mov    0x10(%ebp),%edx
  80359c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035a7:	89 04 24             	mov    %eax,(%esp)
  8035aa:	e8 19 01 00 00       	call   8036c8 <_Z12nsipc_acceptiP8sockaddrPj>
  8035af:	85 c0                	test   %eax,%eax
  8035b1:	78 05                	js     8035b8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8035b3:	e8 1f ff ff ff       	call   8034d7 <_ZL12alloc_sockfdi>
}
  8035b8:	c9                   	leave  
  8035b9:	c3                   	ret    

008035ba <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035ba:	55                   	push   %ebp
  8035bb:	89 e5                	mov    %esp,%ebp
  8035bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	e8 87 ff ff ff       	call   80354f <_ZL9fd2sockidi>
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	78 16                	js     8035e2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8035cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8035cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035da:	89 04 24             	mov    %eax,(%esp)
  8035dd:	e8 34 01 00 00       	call   803716 <_Z10nsipc_bindiP8sockaddrj>
}
  8035e2:	c9                   	leave  
  8035e3:	c3                   	ret    

008035e4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8035e4:	55                   	push   %ebp
  8035e5:	89 e5                	mov    %esp,%ebp
  8035e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	e8 5d ff ff ff       	call   80354f <_ZL9fd2sockidi>
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	78 0f                	js     803605 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8035f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035fd:	89 04 24             	mov    %eax,(%esp)
  803600:	e8 50 01 00 00       	call   803755 <_Z14nsipc_shutdownii>
}
  803605:	c9                   	leave  
  803606:	c3                   	ret    

00803607 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803607:	55                   	push   %ebp
  803608:	89 e5                	mov    %esp,%ebp
  80360a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	e8 3a ff ff ff       	call   80354f <_ZL9fd2sockidi>
  803615:	85 c0                	test   %eax,%eax
  803617:	78 16                	js     80362f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803619:	8b 55 10             	mov    0x10(%ebp),%edx
  80361c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803620:	8b 55 0c             	mov    0xc(%ebp),%edx
  803623:	89 54 24 04          	mov    %edx,0x4(%esp)
  803627:	89 04 24             	mov    %eax,(%esp)
  80362a:	e8 62 01 00 00       	call   803791 <_Z13nsipc_connectiPK8sockaddrj>
}
  80362f:	c9                   	leave  
  803630:	c3                   	ret    

00803631 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803631:	55                   	push   %ebp
  803632:	89 e5                	mov    %esp,%ebp
  803634:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	e8 10 ff ff ff       	call   80354f <_ZL9fd2sockidi>
  80363f:	85 c0                	test   %eax,%eax
  803641:	78 0f                	js     803652 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803643:	8b 55 0c             	mov    0xc(%ebp),%edx
  803646:	89 54 24 04          	mov    %edx,0x4(%esp)
  80364a:	89 04 24             	mov    %eax,(%esp)
  80364d:	e8 7e 01 00 00       	call   8037d0 <_Z12nsipc_listenii>
}
  803652:	c9                   	leave  
  803653:	c3                   	ret    

00803654 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803654:	55                   	push   %ebp
  803655:	89 e5                	mov    %esp,%ebp
  803657:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80365a:	8b 45 10             	mov    0x10(%ebp),%eax
  80365d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803661:	8b 45 0c             	mov    0xc(%ebp),%eax
  803664:	89 44 24 04          	mov    %eax,0x4(%esp)
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	89 04 24             	mov    %eax,(%esp)
  80366e:	e8 72 02 00 00       	call   8038e5 <_Z12nsipc_socketiii>
  803673:	85 c0                	test   %eax,%eax
  803675:	78 05                	js     80367c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803677:	e8 5b fe ff ff       	call   8034d7 <_ZL12alloc_sockfdi>
}
  80367c:	c9                   	leave  
  80367d:	8d 76 00             	lea    0x0(%esi),%esi
  803680:	c3                   	ret    
  803681:	00 00                	add    %al,(%eax)
	...

00803684 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803684:	55                   	push   %ebp
  803685:	89 e5                	mov    %esp,%ebp
  803687:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80368a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803691:	00 
  803692:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803699:	00 
  80369a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80369e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8036a5:	e8 65 06 00 00       	call   803d0f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8036aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036b1:	00 
  8036b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036b9:	00 
  8036ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036c1:	e8 ba 05 00 00       	call   803c80 <_Z8ipc_recvPiPvS_>
}
  8036c6:	c9                   	leave  
  8036c7:	c3                   	ret    

008036c8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036c8:	55                   	push   %ebp
  8036c9:	89 e5                	mov    %esp,%ebp
  8036cb:	53                   	push   %ebx
  8036cc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8036dc:	e8 a3 ff ff ff       	call   803684 <_ZL5nsipcj>
  8036e1:	89 c3                	mov    %eax,%ebx
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	78 27                	js     80370e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  8036e7:	a1 10 70 80 00       	mov    0x807010,%eax
  8036ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036f0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8036f7:	00 
  8036f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fb:	89 04 24             	mov    %eax,(%esp)
  8036fe:	e8 d9 d3 ff ff       	call   800adc <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803703:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803709:	8b 45 10             	mov    0x10(%ebp),%eax
  80370c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80370e:	89 d8                	mov    %ebx,%eax
  803710:	83 c4 14             	add    $0x14,%esp
  803713:	5b                   	pop    %ebx
  803714:	5d                   	pop    %ebp
  803715:	c3                   	ret    

00803716 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
  803719:	53                   	push   %ebx
  80371a:	83 ec 14             	sub    $0x14,%esp
  80371d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803728:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80372c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803733:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80373a:	e8 9d d3 ff ff       	call   800adc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80373f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803745:	b8 02 00 00 00       	mov    $0x2,%eax
  80374a:	e8 35 ff ff ff       	call   803684 <_ZL5nsipcj>
}
  80374f:	83 c4 14             	add    $0x14,%esp
  803752:	5b                   	pop    %ebx
  803753:	5d                   	pop    %ebp
  803754:	c3                   	ret    

00803755 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803755:	55                   	push   %ebp
  803756:	89 e5                	mov    %esp,%ebp
  803758:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803763:	8b 45 0c             	mov    0xc(%ebp),%eax
  803766:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80376b:	b8 03 00 00 00       	mov    $0x3,%eax
  803770:	e8 0f ff ff ff       	call   803684 <_ZL5nsipcj>
}
  803775:	c9                   	leave  
  803776:	c3                   	ret    

00803777 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803777:	55                   	push   %ebp
  803778:	89 e5                	mov    %esp,%ebp
  80377a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803785:	b8 04 00 00 00       	mov    $0x4,%eax
  80378a:	e8 f5 fe ff ff       	call   803684 <_ZL5nsipcj>
}
  80378f:	c9                   	leave  
  803790:	c3                   	ret    

00803791 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803791:	55                   	push   %ebp
  803792:	89 e5                	mov    %esp,%ebp
  803794:	53                   	push   %ebx
  803795:	83 ec 14             	sub    $0x14,%esp
  803798:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80379b:	8b 45 08             	mov    0x8(%ebp),%eax
  80379e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ae:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8037b5:	e8 22 d3 ff ff       	call   800adc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8037ba:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8037c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8037c5:	e8 ba fe ff ff       	call   803684 <_ZL5nsipcj>
}
  8037ca:	83 c4 14             	add    $0x14,%esp
  8037cd:	5b                   	pop    %ebx
  8037ce:	5d                   	pop    %ebp
  8037cf:	c3                   	ret    

008037d0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  8037d0:	55                   	push   %ebp
  8037d1:	89 e5                	mov    %esp,%ebp
  8037d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8037de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8037e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8037eb:	e8 94 fe ff ff       	call   803684 <_ZL5nsipcj>
}
  8037f0:	c9                   	leave  
  8037f1:	c3                   	ret    

008037f2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8037f2:	55                   	push   %ebp
  8037f3:	89 e5                	mov    %esp,%ebp
  8037f5:	56                   	push   %esi
  8037f6:	53                   	push   %ebx
  8037f7:	83 ec 10             	sub    $0x10,%esp
  8037fa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803805:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80380b:	8b 45 14             	mov    0x14(%ebp),%eax
  80380e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803813:	b8 07 00 00 00       	mov    $0x7,%eax
  803818:	e8 67 fe ff ff       	call   803684 <_ZL5nsipcj>
  80381d:	89 c3                	mov    %eax,%ebx
  80381f:	85 c0                	test   %eax,%eax
  803821:	78 46                	js     803869 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803823:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803828:	7f 04                	jg     80382e <_Z10nsipc_recviPvij+0x3c>
  80382a:	39 f0                	cmp    %esi,%eax
  80382c:	7e 24                	jle    803852 <_Z10nsipc_recviPvij+0x60>
  80382e:	c7 44 24 0c 5f 4e 80 	movl   $0x804e5f,0xc(%esp)
  803835:	00 
  803836:	c7 44 24 08 cc 47 80 	movl   $0x8047cc,0x8(%esp)
  80383d:	00 
  80383e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803845:	00 
  803846:	c7 04 24 74 4e 80 00 	movl   $0x804e74,(%esp)
  80384d:	e8 6a 02 00 00       	call   803abc <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803852:	89 44 24 08          	mov    %eax,0x8(%esp)
  803856:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80385d:	00 
  80385e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803861:	89 04 24             	mov    %eax,(%esp)
  803864:	e8 73 d2 ff ff       	call   800adc <memmove>
	}

	return r;
}
  803869:	89 d8                	mov    %ebx,%eax
  80386b:	83 c4 10             	add    $0x10,%esp
  80386e:	5b                   	pop    %ebx
  80386f:	5e                   	pop    %esi
  803870:	5d                   	pop    %ebp
  803871:	c3                   	ret    

00803872 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803872:	55                   	push   %ebp
  803873:	89 e5                	mov    %esp,%ebp
  803875:	53                   	push   %ebx
  803876:	83 ec 14             	sub    $0x14,%esp
  803879:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803884:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80388a:	7e 24                	jle    8038b0 <_Z10nsipc_sendiPKvij+0x3e>
  80388c:	c7 44 24 0c 80 4e 80 	movl   $0x804e80,0xc(%esp)
  803893:	00 
  803894:	c7 44 24 08 cc 47 80 	movl   $0x8047cc,0x8(%esp)
  80389b:	00 
  80389c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8038a3:	00 
  8038a4:	c7 04 24 74 4e 80 00 	movl   $0x804e74,(%esp)
  8038ab:	e8 0c 02 00 00       	call   803abc <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038bb:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8038c2:	e8 15 d2 ff ff       	call   800adc <memmove>
	nsipcbuf.send.req_size = size;
  8038c7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8038cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8038d0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8038d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8038da:	e8 a5 fd ff ff       	call   803684 <_ZL5nsipcj>
}
  8038df:	83 c4 14             	add    $0x14,%esp
  8038e2:	5b                   	pop    %ebx
  8038e3:	5d                   	pop    %ebp
  8038e4:	c3                   	ret    

008038e5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8038e5:	55                   	push   %ebp
  8038e6:	89 e5                	mov    %esp,%ebp
  8038e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8038f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8038fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8038fe:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803903:	b8 09 00 00 00       	mov    $0x9,%eax
  803908:	e8 77 fd ff ff       	call   803684 <_ZL5nsipcj>
}
  80390d:	c9                   	leave  
  80390e:	c3                   	ret    
	...

00803910 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803910:	55                   	push   %ebp
  803911:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803913:	b8 00 00 00 00       	mov    $0x0,%eax
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    

0080391a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80391a:	55                   	push   %ebp
  80391b:	89 e5                	mov    %esp,%ebp
  80391d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803920:	c7 44 24 04 8c 4e 80 	movl   $0x804e8c,0x4(%esp)
  803927:	00 
  803928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80392b:	89 04 24             	mov    %eax,(%esp)
  80392e:	e8 07 d0 ff ff       	call   80093a <_Z6strcpyPcPKc>
	return 0;
}
  803933:	b8 00 00 00 00       	mov    $0x0,%eax
  803938:	c9                   	leave  
  803939:	c3                   	ret    

0080393a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80393a:	55                   	push   %ebp
  80393b:	89 e5                	mov    %esp,%ebp
  80393d:	57                   	push   %edi
  80393e:	56                   	push   %esi
  80393f:	53                   	push   %ebx
  803940:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803946:	bb 00 00 00 00       	mov    $0x0,%ebx
  80394b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80394f:	74 3e                	je     80398f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803951:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803957:	8b 75 10             	mov    0x10(%ebp),%esi
  80395a:	29 de                	sub    %ebx,%esi
  80395c:	83 fe 7f             	cmp    $0x7f,%esi
  80395f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803964:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803967:	89 74 24 08          	mov    %esi,0x8(%esp)
  80396b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396e:	01 d8                	add    %ebx,%eax
  803970:	89 44 24 04          	mov    %eax,0x4(%esp)
  803974:	89 3c 24             	mov    %edi,(%esp)
  803977:	e8 60 d1 ff ff       	call   800adc <memmove>
		sys_cputs(buf, m);
  80397c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803980:	89 3c 24             	mov    %edi,(%esp)
  803983:	e8 6c d3 ff ff       	call   800cf4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803988:	01 f3                	add    %esi,%ebx
  80398a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80398d:	77 c8                	ja     803957 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80398f:	89 d8                	mov    %ebx,%eax
  803991:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803997:	5b                   	pop    %ebx
  803998:	5e                   	pop    %esi
  803999:	5f                   	pop    %edi
  80399a:	5d                   	pop    %ebp
  80399b:	c3                   	ret    

0080399c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8039a2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8039a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8039ab:	75 07                	jne    8039b4 <_ZL12devcons_readP2FdPvj+0x18>
  8039ad:	eb 2a                	jmp    8039d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8039af:	e8 38 d4 ff ff       	call   800dec <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039b4:	e8 6e d3 ff ff       	call   800d27 <_Z9sys_cgetcv>
  8039b9:	85 c0                	test   %eax,%eax
  8039bb:	74 f2                	je     8039af <_ZL12devcons_readP2FdPvj+0x13>
  8039bd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	78 16                	js     8039d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8039c3:	83 f8 04             	cmp    $0x4,%eax
  8039c6:	74 0c                	je     8039d4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8039c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cb:	88 10                	mov    %dl,(%eax)
	return 1;
  8039cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d2:	eb 05                	jmp    8039d9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8039d4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8039d9:	c9                   	leave  
  8039da:	c3                   	ret    

008039db <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8039db:	55                   	push   %ebp
  8039dc:	89 e5                	mov    %esp,%ebp
  8039de:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8039e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8039ee:	00 
  8039ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8039f2:	89 04 24             	mov    %eax,(%esp)
  8039f5:	e8 fa d2 ff ff       	call   800cf4 <_Z9sys_cputsPKcj>
}
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <_Z7getcharv>:

int
getchar(void)
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
  8039ff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a09:	00 
  803a0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a18:	e8 71 dc ff ff       	call   80168e <_Z4readiPvj>
	if (r < 0)
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	78 0f                	js     803a30 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803a21:	85 c0                	test   %eax,%eax
  803a23:	7e 06                	jle    803a2b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803a25:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803a29:	eb 05                	jmp    803a30 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803a2b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803a30:	c9                   	leave  
  803a31:	c3                   	ret    

00803a32 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803a32:	55                   	push   %ebp
  803a33:	89 e5                	mov    %esp,%ebp
  803a35:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803a38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a3f:	00 
  803a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	89 04 24             	mov    %eax,(%esp)
  803a4d:	e8 8f d8 ff ff       	call   8012e1 <_Z9fd_lookupiPP2Fdb>
  803a52:	85 c0                	test   %eax,%eax
  803a54:	78 11                	js     803a67 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a59:	8b 15 5c 50 80 00    	mov    0x80505c,%edx
  803a5f:	39 10                	cmp    %edx,(%eax)
  803a61:	0f 94 c0             	sete   %al
  803a64:	0f b6 c0             	movzbl %al,%eax
}
  803a67:	c9                   	leave  
  803a68:	c3                   	ret    

00803a69 <_Z8openconsv>:

int
opencons(void)
{
  803a69:	55                   	push   %ebp
  803a6a:	89 e5                	mov    %esp,%ebp
  803a6c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a72:	89 04 24             	mov    %eax,(%esp)
  803a75:	e8 1d d9 ff ff       	call   801397 <_Z14fd_find_unusedPP2Fd>
  803a7a:	85 c0                	test   %eax,%eax
  803a7c:	78 3c                	js     803aba <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a7e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a85:	00 
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a94:	e8 87 d3 ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803a99:	85 c0                	test   %eax,%eax
  803a9b:	78 1d                	js     803aba <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803a9d:	8b 15 5c 50 80 00    	mov    0x80505c,%edx
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803ab2:	89 04 24             	mov    %eax,(%esp)
  803ab5:	e8 7a d8 ff ff       	call   801334 <_Z6fd2numP2Fd>
}
  803aba:	c9                   	leave  
  803abb:	c3                   	ret    

00803abc <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803abc:	55                   	push   %ebp
  803abd:	89 e5                	mov    %esp,%ebp
  803abf:	56                   	push   %esi
  803ac0:	53                   	push   %ebx
  803ac1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  803ac4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  803ac7:	a1 00 80 80 00       	mov    0x808000,%eax
  803acc:	85 c0                	test   %eax,%eax
  803ace:	74 10                	je     803ae0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad4:	c7 04 24 98 4e 80 00 	movl   $0x804e98,(%esp)
  803adb:	e8 3e c8 ff ff       	call   80031e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803ae0:	8b 1d 04 50 80 00    	mov    0x805004,%ebx
  803ae6:	e8 cd d2 ff ff       	call   800db8 <_Z12sys_getenvidv>
  803aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aee:	89 54 24 10          	mov    %edx,0x10(%esp)
  803af2:	8b 55 08             	mov    0x8(%ebp),%edx
  803af5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803af9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b01:	c7 04 24 a0 4e 80 00 	movl   $0x804ea0,(%esp)
  803b08:	e8 11 c8 ff ff       	call   80031e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  803b0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b11:	8b 45 10             	mov    0x10(%ebp),%eax
  803b14:	89 04 24             	mov    %eax,(%esp)
  803b17:	e8 a1 c7 ff ff       	call   8002bd <_Z8vcprintfPKcPc>
	cprintf("\n");
  803b1c:	c7 04 24 d4 43 80 00 	movl   $0x8043d4,(%esp)
  803b23:	e8 f6 c7 ff ff       	call   80031e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b28:	cc                   	int3   
  803b29:	eb fd                	jmp    803b28 <_Z6_panicPKciS0_z+0x6c>
  803b2b:	00 00                	add    %al,(%eax)
  803b2d:	00 00                	add    %al,(%eax)
	...

00803b30 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	56                   	push   %esi
  803b34:	53                   	push   %ebx
  803b35:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803b38:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803b3d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  803b44:	85 c0                	test   %eax,%eax
  803b46:	74 08                	je     803b50 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803b48:	8d 55 08             	lea    0x8(%ebp),%edx
  803b4b:	89 14 24             	mov    %edx,(%esp)
  803b4e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803b50:	83 eb 01             	sub    $0x1,%ebx
  803b53:	83 fb ff             	cmp    $0xffffffff,%ebx
  803b56:	75 e5                	jne    803b3d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803b58:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803b5b:	8b 75 08             	mov    0x8(%ebp),%esi
  803b5e:	e8 55 d2 ff ff       	call   800db8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803b63:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803b67:	89 74 24 10          	mov    %esi,0x10(%esp)
  803b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b6f:	c7 44 24 08 c4 4e 80 	movl   $0x804ec4,0x8(%esp)
  803b76:	00 
  803b77:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803b7e:	00 
  803b7f:	c7 04 24 48 4f 80 00 	movl   $0x804f48,(%esp)
  803b86:	e8 31 ff ff ff       	call   803abc <_Z6_panicPKciS0_z>

00803b8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803b8b:	55                   	push   %ebp
  803b8c:	89 e5                	mov    %esp,%ebp
  803b8e:	56                   	push   %esi
  803b8f:	53                   	push   %ebx
  803b90:	83 ec 10             	sub    $0x10,%esp
  803b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803b96:	e8 1d d2 ff ff       	call   800db8 <_Z12sys_getenvidv>
  803b9b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803b9d:	a1 00 60 80 00       	mov    0x806000,%eax
  803ba2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	75 4c                	jne    803bf5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803ba9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803bb0:	00 
  803bb1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803bb8:	ee 
  803bb9:	89 34 24             	mov    %esi,(%esp)
  803bbc:	e8 5f d2 ff ff       	call   800e20 <_Z14sys_page_allociPvi>
  803bc1:	85 c0                	test   %eax,%eax
  803bc3:	74 20                	je     803be5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803bc5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803bc9:	c7 44 24 08 fc 4e 80 	movl   $0x804efc,0x8(%esp)
  803bd0:	00 
  803bd1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803bd8:	00 
  803bd9:	c7 04 24 48 4f 80 00 	movl   $0x804f48,(%esp)
  803be0:	e8 d7 fe ff ff       	call   803abc <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803be5:	c7 44 24 04 30 3b 80 	movl   $0x803b30,0x4(%esp)
  803bec:	00 
  803bed:	89 34 24             	mov    %esi,(%esp)
  803bf0:	e8 60 d4 ff ff       	call   801055 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803bf5:	a1 20 80 80 00       	mov    0x808020,%eax
  803bfa:	39 d8                	cmp    %ebx,%eax
  803bfc:	74 1a                	je     803c18 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803bfe:	85 c0                	test   %eax,%eax
  803c00:	74 20                	je     803c22 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c02:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803c07:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  803c0e:	39 da                	cmp    %ebx,%edx
  803c10:	74 15                	je     803c27 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c12:	85 d2                	test   %edx,%edx
  803c14:	75 1f                	jne    803c35 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803c16:	eb 0f                	jmp    803c27 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c18:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1d:	8d 76 00             	lea    0x0(%esi),%esi
  803c20:	eb 05                	jmp    803c27 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c22:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803c27:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803c2e:	83 c4 10             	add    $0x10,%esp
  803c31:	5b                   	pop    %ebx
  803c32:	5e                   	pop    %esi
  803c33:	5d                   	pop    %ebp
  803c34:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c35:	83 c0 01             	add    $0x1,%eax
  803c38:	83 f8 08             	cmp    $0x8,%eax
  803c3b:	75 ca                	jne    803c07 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803c3d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803c41:	c7 44 24 08 20 4f 80 	movl   $0x804f20,0x8(%esp)
  803c48:	00 
  803c49:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803c50:	00 
  803c51:	c7 04 24 48 4f 80 00 	movl   $0x804f48,(%esp)
  803c58:	e8 5f fe ff ff       	call   803abc <_Z6_panicPKciS0_z>
  803c5d:	00 00                	add    %al,(%eax)
	...

00803c60 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803c60:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803c63:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803c64:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803c67:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803c6b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803c6f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803c72:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803c74:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803c78:	61                   	popa   
    popf
  803c79:	9d                   	popf   
    popl %esp
  803c7a:	5c                   	pop    %esp
    ret
  803c7b:	c3                   	ret    

00803c7c <spin>:

spin:	jmp spin
  803c7c:	eb fe                	jmp    803c7c <spin>
	...

00803c80 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c80:	55                   	push   %ebp
  803c81:	89 e5                	mov    %esp,%ebp
  803c83:	56                   	push   %esi
  803c84:	53                   	push   %ebx
  803c85:	83 ec 10             	sub    $0x10,%esp
  803c88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803c91:	85 c0                	test   %eax,%eax
  803c93:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803c98:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803c9b:	89 04 24             	mov    %eax,(%esp)
  803c9e:	e8 48 d4 ff ff       	call   8010eb <_Z12sys_ipc_recvPv>
  803ca3:	85 c0                	test   %eax,%eax
  803ca5:	79 16                	jns    803cbd <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803ca7:	85 db                	test   %ebx,%ebx
  803ca9:	74 06                	je     803cb1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803cab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803cb1:	85 f6                	test   %esi,%esi
  803cb3:	74 53                	je     803d08 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803cb5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803cbb:	eb 4b                	jmp    803d08 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803cbd:	85 db                	test   %ebx,%ebx
  803cbf:	74 17                	je     803cd8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803cc1:	e8 f2 d0 ff ff       	call   800db8 <_Z12sys_getenvidv>
  803cc6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ccb:	6b c0 78             	imul   $0x78,%eax,%eax
  803cce:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803cd3:	8b 40 60             	mov    0x60(%eax),%eax
  803cd6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803cd8:	85 f6                	test   %esi,%esi
  803cda:	74 17                	je     803cf3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803cdc:	e8 d7 d0 ff ff       	call   800db8 <_Z12sys_getenvidv>
  803ce1:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ce6:	6b c0 78             	imul   $0x78,%eax,%eax
  803ce9:	05 00 00 00 ef       	add    $0xef000000,%eax
  803cee:	8b 40 70             	mov    0x70(%eax),%eax
  803cf1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803cf3:	e8 c0 d0 ff ff       	call   800db8 <_Z12sys_getenvidv>
  803cf8:	25 ff 03 00 00       	and    $0x3ff,%eax
  803cfd:	6b c0 78             	imul   $0x78,%eax,%eax
  803d00:	05 08 00 00 ef       	add    $0xef000008,%eax
  803d05:	8b 40 60             	mov    0x60(%eax),%eax

}
  803d08:	83 c4 10             	add    $0x10,%esp
  803d0b:	5b                   	pop    %ebx
  803d0c:	5e                   	pop    %esi
  803d0d:	5d                   	pop    %ebp
  803d0e:	c3                   	ret    

00803d0f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d0f:	55                   	push   %ebp
  803d10:	89 e5                	mov    %esp,%ebp
  803d12:	57                   	push   %edi
  803d13:	56                   	push   %esi
  803d14:	53                   	push   %ebx
  803d15:	83 ec 1c             	sub    $0x1c,%esp
  803d18:	8b 75 08             	mov    0x8(%ebp),%esi
  803d1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803d1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803d21:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803d23:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803d28:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  803d2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d32:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d36:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803d3a:	89 34 24             	mov    %esi,(%esp)
  803d3d:	e8 71 d3 ff ff       	call   8010b3 <_Z16sys_ipc_try_sendijPvi>
  803d42:	85 c0                	test   %eax,%eax
  803d44:	79 31                	jns    803d77 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803d46:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803d49:	75 0c                	jne    803d57 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803d4b:	90                   	nop
  803d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d50:	e8 97 d0 ff ff       	call   800dec <_Z9sys_yieldv>
  803d55:	eb d4                	jmp    803d2b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803d57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d5b:	c7 44 24 08 56 4f 80 	movl   $0x804f56,0x8(%esp)
  803d62:	00 
  803d63:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803d6a:	00 
  803d6b:	c7 04 24 63 4f 80 00 	movl   $0x804f63,(%esp)
  803d72:	e8 45 fd ff ff       	call   803abc <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803d77:	83 c4 1c             	add    $0x1c,%esp
  803d7a:	5b                   	pop    %ebx
  803d7b:	5e                   	pop    %esi
  803d7c:	5f                   	pop    %edi
  803d7d:	5d                   	pop    %ebp
  803d7e:	c3                   	ret    
	...

00803d80 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  803d80:	55                   	push   %ebp
  803d81:	89 e5                	mov    %esp,%ebp
  803d83:	57                   	push   %edi
  803d84:	56                   	push   %esi
  803d85:	53                   	push   %ebx
  803d86:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  803d89:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  803d8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  803d92:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803d95:	8d 45 ef             	lea    -0x11(%ebp),%eax
  803d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  803d9b:	bb 40 80 80 00       	mov    $0x808040,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da3:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  803da6:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  803dab:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  803db0:	f6 e1                	mul    %cl
  803db2:	66 c1 e8 08          	shr    $0x8,%ax
  803db6:	c0 e8 03             	shr    $0x3,%al
  803db9:	89 c6                	mov    %eax,%esi
  803dbb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  803dbe:	01 c0                	add    %eax,%eax
  803dc0:	28 c1                	sub    %al,%cl
  803dc2:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  803dc4:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  803dc6:	0f b6 fa             	movzbl %dl,%edi
  803dc9:	83 c0 30             	add    $0x30,%eax
  803dcc:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  803dd0:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  803dd3:	84 c9                	test   %cl,%cl
  803dd5:	75 d4                	jne    803dab <inet_ntoa+0x2b>
  803dd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dda:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  803ddc:	84 d2                	test   %dl,%dl
  803dde:	74 24                	je     803e04 <inet_ntoa+0x84>
  803de0:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803de3:	0f b6 fa             	movzbl %dl,%edi
  803de6:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  803dea:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  803dec:	0f b6 ca             	movzbl %dl,%ecx
  803def:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  803df4:	88 08                	mov    %cl,(%eax)
  803df6:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  803df9:	83 ea 01             	sub    $0x1,%edx
  803dfc:	39 f0                	cmp    %esi,%eax
  803dfe:	75 ec                	jne    803dec <inet_ntoa+0x6c>
  803e00:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  803e04:	c6 03 2e             	movb   $0x2e,(%ebx)
  803e07:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  803e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e0d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  803e10:	74 06                	je     803e18 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  803e12:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  803e16:	eb 88                	jmp    803da0 <inet_ntoa+0x20>
  }
  *--rp = 0;
  803e18:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  803e1c:	b8 40 80 80 00       	mov    $0x808040,%eax
  803e21:	83 c4 18             	add    $0x18,%esp
  803e24:	5b                   	pop    %ebx
  803e25:	5e                   	pop    %esi
  803e26:	5f                   	pop    %edi
  803e27:	5d                   	pop    %ebp
  803e28:	c3                   	ret    

00803e29 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  803e29:	55                   	push   %ebp
  803e2a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  803e2c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  803e30:	66 c1 c0 08          	rol    $0x8,%ax
}
  803e34:	5d                   	pop    %ebp
  803e35:	c3                   	ret    

00803e36 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  803e36:	55                   	push   %ebp
  803e37:	89 e5                	mov    %esp,%ebp
  803e39:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  803e3c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  803e40:	89 04 24             	mov    %eax,(%esp)
  803e43:	e8 e1 ff ff ff       	call   803e29 <htons>
}
  803e48:	c9                   	leave  
  803e49:	c3                   	ret    

00803e4a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  803e4a:	55                   	push   %ebp
  803e4b:	89 e5                	mov    %esp,%ebp
  803e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  803e50:	89 d1                	mov    %edx,%ecx
  803e52:	c1 e9 18             	shr    $0x18,%ecx
  803e55:	89 d0                	mov    %edx,%eax
  803e57:	c1 e0 18             	shl    $0x18,%eax
  803e5a:	09 c8                	or     %ecx,%eax
  803e5c:	89 d1                	mov    %edx,%ecx
  803e5e:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  803e64:	c1 e1 08             	shl    $0x8,%ecx
  803e67:	09 c8                	or     %ecx,%eax
  803e69:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  803e6f:	c1 ea 08             	shr    $0x8,%edx
  803e72:	09 d0                	or     %edx,%eax
}
  803e74:	5d                   	pop    %ebp
  803e75:	c3                   	ret    

00803e76 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803e76:	55                   	push   %ebp
  803e77:	89 e5                	mov    %esp,%ebp
  803e79:	57                   	push   %edi
  803e7a:	56                   	push   %esi
  803e7b:	53                   	push   %ebx
  803e7c:	83 ec 28             	sub    $0x28,%esp
  803e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  803e82:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803e85:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  803e88:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803e8d:	80 fb 09             	cmp    $0x9,%bl
  803e90:	0f 87 c4 01 00 00    	ja     80405a <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803e96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803e99:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803e9c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  803e9f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  803ea2:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  803ea9:	83 fa 30             	cmp    $0x30,%edx
  803eac:	75 25                	jne    803ed3 <inet_aton+0x5d>
      c = *++cp;
  803eae:	83 c1 01             	add    $0x1,%ecx
  803eb1:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  803eb4:	83 fa 78             	cmp    $0x78,%edx
  803eb7:	74 0c                	je     803ec5 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  803eb9:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  803ec0:	83 fa 58             	cmp    $0x58,%edx
  803ec3:	75 0e                	jne    803ed3 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  803ec5:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  803ec9:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  803ecc:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  803ed3:	8d 41 01             	lea    0x1(%ecx),%eax
  803ed6:	be 00 00 00 00       	mov    $0x0,%esi
  803edb:	eb 03                	jmp    803ee0 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  803edd:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  803ee0:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  803ee3:	89 d1                	mov    %edx,%ecx
  803ee5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  803ee8:	80 fb 09             	cmp    $0x9,%bl
  803eeb:	77 0d                	ja     803efa <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  803eed:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  803ef1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  803ef5:	0f be 10             	movsbl (%eax),%edx
  803ef8:	eb e3                	jmp    803edd <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  803efa:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  803efe:	0f 85 5e 01 00 00    	jne    804062 <inet_aton+0x1ec>
  803f04:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  803f07:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  803f0a:	80 fb 05             	cmp    $0x5,%bl
  803f0d:	76 0c                	jbe    803f1b <inet_aton+0xa5>
  803f0f:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  803f12:	80 fb 05             	cmp    $0x5,%bl
  803f15:	0f 87 4d 01 00 00    	ja     804068 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803f1b:	89 f1                	mov    %esi,%ecx
  803f1d:	c1 e1 04             	shl    $0x4,%ecx
  803f20:	8d 72 0a             	lea    0xa(%edx),%esi
  803f23:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  803f27:	19 d2                	sbb    %edx,%edx
  803f29:	83 e2 20             	and    $0x20,%edx
  803f2c:	83 c2 41             	add    $0x41,%edx
  803f2f:	29 d6                	sub    %edx,%esi
  803f31:	09 ce                	or     %ecx,%esi
        c = *++cp;
  803f33:	0f be 10             	movsbl (%eax),%edx
  803f36:	eb a5                	jmp    803edd <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f3b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  803f3e:	0f 83 0a 01 00 00    	jae    80404e <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  803f44:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f47:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  803f49:	8d 4f 01             	lea    0x1(%edi),%ecx
  803f4c:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803f50:	8d 42 d0             	lea    -0x30(%edx),%eax
  803f53:	3c 09                	cmp    $0x9,%al
  803f55:	0f 87 fa 00 00 00    	ja     804055 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  803f5b:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  803f5f:	e9 3e ff ff ff       	jmp    803ea2 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  803f64:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  803f69:	80 f9 1f             	cmp    $0x1f,%cl
  803f6c:	0f 86 e8 00 00 00    	jbe    80405a <inet_aton+0x1e4>
  803f72:	84 d2                	test   %dl,%dl
  803f74:	0f 88 e0 00 00 00    	js     80405a <inet_aton+0x1e4>
  803f7a:	83 fa 20             	cmp    $0x20,%edx
  803f7d:	74 1d                	je     803f9c <inet_aton+0x126>
  803f7f:	83 fa 0c             	cmp    $0xc,%edx
  803f82:	74 18                	je     803f9c <inet_aton+0x126>
  803f84:	83 fa 0a             	cmp    $0xa,%edx
  803f87:	74 13                	je     803f9c <inet_aton+0x126>
  803f89:	83 fa 0d             	cmp    $0xd,%edx
  803f8c:	74 0e                	je     803f9c <inet_aton+0x126>
  803f8e:	83 fa 09             	cmp    $0x9,%edx
  803f91:	74 09                	je     803f9c <inet_aton+0x126>
  803f93:	83 fa 0b             	cmp    $0xb,%edx
  803f96:	0f 85 be 00 00 00    	jne    80405a <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  803f9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803f9f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803fa2:	29 c2                	sub    %eax,%edx
  803fa4:	c1 fa 02             	sar    $0x2,%edx
  803fa7:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  803faa:	83 fa 02             	cmp    $0x2,%edx
  803fad:	74 25                	je     803fd4 <inet_aton+0x15e>
  803faf:	83 fa 02             	cmp    $0x2,%edx
  803fb2:	7f 0f                	jg     803fc3 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  803fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  803fb9:	85 d2                	test   %edx,%edx
  803fbb:	0f 84 99 00 00 00    	je     80405a <inet_aton+0x1e4>
  803fc1:	eb 6c                	jmp    80402f <inet_aton+0x1b9>
  803fc3:	83 fa 03             	cmp    $0x3,%edx
  803fc6:	74 23                	je     803feb <inet_aton+0x175>
  803fc8:	83 fa 04             	cmp    $0x4,%edx
  803fcb:	90                   	nop
  803fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803fd0:	75 5d                	jne    80402f <inet_aton+0x1b9>
  803fd2:	eb 36                	jmp    80400a <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  803fd4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  803fd9:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  803fdf:	77 79                	ja     80405a <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  803fe1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803fe4:	c1 e6 18             	shl    $0x18,%esi
  803fe7:	09 de                	or     %ebx,%esi
    break;
  803fe9:	eb 44                	jmp    80402f <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  803feb:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  803ff0:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  803ff6:	77 62                	ja     80405a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  803ff8:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803ffb:	c1 e6 10             	shl    $0x10,%esi
  803ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804001:	c1 e0 18             	shl    $0x18,%eax
  804004:	09 c6                	or     %eax,%esi
  804006:	09 de                	or     %ebx,%esi
    break;
  804008:	eb 25                	jmp    80402f <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  80400a:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80400f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  804015:	77 43                	ja     80405a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804017:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80401a:	c1 e6 10             	shl    $0x10,%esi
  80401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804020:	c1 e0 18             	shl    $0x18,%eax
  804023:	09 c6                	or     %eax,%esi
  804025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804028:	c1 e0 08             	shl    $0x8,%eax
  80402b:	09 c6                	or     %eax,%esi
  80402d:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  80402f:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804038:	74 20                	je     80405a <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  80403a:	89 34 24             	mov    %esi,(%esp)
  80403d:	e8 08 fe ff ff       	call   803e4a <htonl>
  804042:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  804045:	89 03                	mov    %eax,(%ebx)
  return (1);
  804047:	b8 01 00 00 00       	mov    $0x1,%eax
  80404c:	eb 0c                	jmp    80405a <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80404e:	b8 00 00 00 00       	mov    $0x0,%eax
  804053:	eb 05                	jmp    80405a <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  804055:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  80405a:	83 c4 28             	add    $0x28,%esp
  80405d:	5b                   	pop    %ebx
  80405e:	5e                   	pop    %esi
  80405f:	5f                   	pop    %edi
  804060:	5d                   	pop    %ebp
  804061:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804062:	89 d0                	mov    %edx,%eax
  804064:	89 f3                	mov    %esi,%ebx
  804066:	eb 04                	jmp    80406c <inet_aton+0x1f6>
  804068:	89 d0                	mov    %edx,%eax
  80406a:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  80406c:	83 f8 2e             	cmp    $0x2e,%eax
  80406f:	0f 84 c3 fe ff ff    	je     803f38 <inet_aton+0xc2>
  804075:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804077:	85 d2                	test   %edx,%edx
  804079:	0f 84 1d ff ff ff    	je     803f9c <inet_aton+0x126>
  80407f:	e9 e0 fe ff ff       	jmp    803f64 <inet_aton+0xee>

00804084 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804084:	55                   	push   %ebp
  804085:	89 e5                	mov    %esp,%ebp
  804087:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80408a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80408d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804091:	8b 45 08             	mov    0x8(%ebp),%eax
  804094:	89 04 24             	mov    %eax,(%esp)
  804097:	e8 da fd ff ff       	call   803e76 <inet_aton>
  80409c:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80409e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8040a3:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8040a7:	c9                   	leave  
  8040a8:	c3                   	ret    

008040a9 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8040a9:	55                   	push   %ebp
  8040aa:	89 e5                	mov    %esp,%ebp
  8040ac:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8040af:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b2:	89 04 24             	mov    %eax,(%esp)
  8040b5:	e8 90 fd ff ff       	call   803e4a <htonl>
}
  8040ba:	c9                   	leave  
  8040bb:	c3                   	ret    
  8040bc:	00 00                	add    %al,(%eax)
	...

008040c0 <__udivdi3>:
  8040c0:	55                   	push   %ebp
  8040c1:	89 e5                	mov    %esp,%ebp
  8040c3:	57                   	push   %edi
  8040c4:	56                   	push   %esi
  8040c5:	83 ec 20             	sub    $0x20,%esp
  8040c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8040cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8040ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8040d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8040d4:	85 c0                	test   %eax,%eax
  8040d6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8040d9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8040dc:	75 3a                	jne    804118 <__udivdi3+0x58>
  8040de:	39 f9                	cmp    %edi,%ecx
  8040e0:	77 66                	ja     804148 <__udivdi3+0x88>
  8040e2:	85 c9                	test   %ecx,%ecx
  8040e4:	75 0b                	jne    8040f1 <__udivdi3+0x31>
  8040e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040eb:	31 d2                	xor    %edx,%edx
  8040ed:	f7 f1                	div    %ecx
  8040ef:	89 c1                	mov    %eax,%ecx
  8040f1:	89 f8                	mov    %edi,%eax
  8040f3:	31 d2                	xor    %edx,%edx
  8040f5:	f7 f1                	div    %ecx
  8040f7:	89 c7                	mov    %eax,%edi
  8040f9:	89 f0                	mov    %esi,%eax
  8040fb:	f7 f1                	div    %ecx
  8040fd:	89 fa                	mov    %edi,%edx
  8040ff:	89 c6                	mov    %eax,%esi
  804101:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804104:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80410a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80410d:	83 c4 20             	add    $0x20,%esp
  804110:	5e                   	pop    %esi
  804111:	5f                   	pop    %edi
  804112:	5d                   	pop    %ebp
  804113:	c3                   	ret    
  804114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804118:	31 d2                	xor    %edx,%edx
  80411a:	31 f6                	xor    %esi,%esi
  80411c:	39 f8                	cmp    %edi,%eax
  80411e:	77 e1                	ja     804101 <__udivdi3+0x41>
  804120:	0f bd d0             	bsr    %eax,%edx
  804123:	83 f2 1f             	xor    $0x1f,%edx
  804126:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804129:	75 2d                	jne    804158 <__udivdi3+0x98>
  80412b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80412e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804131:	76 06                	jbe    804139 <__udivdi3+0x79>
  804133:	39 f8                	cmp    %edi,%eax
  804135:	89 f2                	mov    %esi,%edx
  804137:	73 c8                	jae    804101 <__udivdi3+0x41>
  804139:	31 d2                	xor    %edx,%edx
  80413b:	be 01 00 00 00       	mov    $0x1,%esi
  804140:	eb bf                	jmp    804101 <__udivdi3+0x41>
  804142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804148:	89 f0                	mov    %esi,%eax
  80414a:	89 fa                	mov    %edi,%edx
  80414c:	f7 f1                	div    %ecx
  80414e:	31 d2                	xor    %edx,%edx
  804150:	89 c6                	mov    %eax,%esi
  804152:	eb ad                	jmp    804101 <__udivdi3+0x41>
  804154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804158:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80415c:	89 c2                	mov    %eax,%edx
  80415e:	b8 20 00 00 00       	mov    $0x20,%eax
  804163:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804166:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804169:	d3 e2                	shl    %cl,%edx
  80416b:	89 c1                	mov    %eax,%ecx
  80416d:	d3 ee                	shr    %cl,%esi
  80416f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804173:	09 d6                	or     %edx,%esi
  804175:	89 fa                	mov    %edi,%edx
  804177:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80417a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80417d:	d3 e6                	shl    %cl,%esi
  80417f:	89 c1                	mov    %eax,%ecx
  804181:	d3 ea                	shr    %cl,%edx
  804183:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804187:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80418a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80418d:	d3 e7                	shl    %cl,%edi
  80418f:	89 c1                	mov    %eax,%ecx
  804191:	d3 ee                	shr    %cl,%esi
  804193:	09 fe                	or     %edi,%esi
  804195:	89 f0                	mov    %esi,%eax
  804197:	f7 75 e4             	divl   -0x1c(%ebp)
  80419a:	89 d7                	mov    %edx,%edi
  80419c:	89 c6                	mov    %eax,%esi
  80419e:	f7 65 f0             	mull   -0x10(%ebp)
  8041a1:	39 d7                	cmp    %edx,%edi
  8041a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8041a6:	72 12                	jb     8041ba <__udivdi3+0xfa>
  8041a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ab:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041af:	d3 e2                	shl    %cl,%edx
  8041b1:	39 c2                	cmp    %eax,%edx
  8041b3:	73 08                	jae    8041bd <__udivdi3+0xfd>
  8041b5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8041b8:	75 03                	jne    8041bd <__udivdi3+0xfd>
  8041ba:	83 ee 01             	sub    $0x1,%esi
  8041bd:	31 d2                	xor    %edx,%edx
  8041bf:	e9 3d ff ff ff       	jmp    804101 <__udivdi3+0x41>
	...

008041d0 <__umoddi3>:
  8041d0:	55                   	push   %ebp
  8041d1:	89 e5                	mov    %esp,%ebp
  8041d3:	57                   	push   %edi
  8041d4:	56                   	push   %esi
  8041d5:	83 ec 20             	sub    $0x20,%esp
  8041d8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8041db:	8b 45 08             	mov    0x8(%ebp),%eax
  8041de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8041e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8041e4:	85 ff                	test   %edi,%edi
  8041e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8041e9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8041ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041ef:	89 f2                	mov    %esi,%edx
  8041f1:	75 15                	jne    804208 <__umoddi3+0x38>
  8041f3:	39 f1                	cmp    %esi,%ecx
  8041f5:	76 41                	jbe    804238 <__umoddi3+0x68>
  8041f7:	f7 f1                	div    %ecx
  8041f9:	89 d0                	mov    %edx,%eax
  8041fb:	31 d2                	xor    %edx,%edx
  8041fd:	83 c4 20             	add    $0x20,%esp
  804200:	5e                   	pop    %esi
  804201:	5f                   	pop    %edi
  804202:	5d                   	pop    %ebp
  804203:	c3                   	ret    
  804204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804208:	39 f7                	cmp    %esi,%edi
  80420a:	77 4c                	ja     804258 <__umoddi3+0x88>
  80420c:	0f bd c7             	bsr    %edi,%eax
  80420f:	83 f0 1f             	xor    $0x1f,%eax
  804212:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804215:	75 51                	jne    804268 <__umoddi3+0x98>
  804217:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80421a:	0f 87 e8 00 00 00    	ja     804308 <__umoddi3+0x138>
  804220:	89 f2                	mov    %esi,%edx
  804222:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804225:	29 ce                	sub    %ecx,%esi
  804227:	19 fa                	sbb    %edi,%edx
  804229:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80422c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80422f:	83 c4 20             	add    $0x20,%esp
  804232:	5e                   	pop    %esi
  804233:	5f                   	pop    %edi
  804234:	5d                   	pop    %ebp
  804235:	c3                   	ret    
  804236:	66 90                	xchg   %ax,%ax
  804238:	85 c9                	test   %ecx,%ecx
  80423a:	75 0b                	jne    804247 <__umoddi3+0x77>
  80423c:	b8 01 00 00 00       	mov    $0x1,%eax
  804241:	31 d2                	xor    %edx,%edx
  804243:	f7 f1                	div    %ecx
  804245:	89 c1                	mov    %eax,%ecx
  804247:	89 f0                	mov    %esi,%eax
  804249:	31 d2                	xor    %edx,%edx
  80424b:	f7 f1                	div    %ecx
  80424d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804250:	eb a5                	jmp    8041f7 <__umoddi3+0x27>
  804252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804258:	89 f2                	mov    %esi,%edx
  80425a:	83 c4 20             	add    $0x20,%esp
  80425d:	5e                   	pop    %esi
  80425e:	5f                   	pop    %edi
  80425f:	5d                   	pop    %ebp
  804260:	c3                   	ret    
  804261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804268:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80426c:	89 f2                	mov    %esi,%edx
  80426e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804271:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804278:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80427b:	d3 e7                	shl    %cl,%edi
  80427d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804280:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804284:	d3 e8                	shr    %cl,%eax
  804286:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80428a:	09 f8                	or     %edi,%eax
  80428c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804292:	d3 e0                	shl    %cl,%eax
  804294:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804298:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80429b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80429e:	d3 ea                	shr    %cl,%edx
  8042a0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042a4:	d3 e6                	shl    %cl,%esi
  8042a6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042aa:	d3 e8                	shr    %cl,%eax
  8042ac:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042b0:	09 f0                	or     %esi,%eax
  8042b2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8042b5:	f7 75 e4             	divl   -0x1c(%ebp)
  8042b8:	d3 e6                	shl    %cl,%esi
  8042ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8042bd:	89 d6                	mov    %edx,%esi
  8042bf:	f7 65 f4             	mull   -0xc(%ebp)
  8042c2:	89 d7                	mov    %edx,%edi
  8042c4:	89 c2                	mov    %eax,%edx
  8042c6:	39 fe                	cmp    %edi,%esi
  8042c8:	89 f9                	mov    %edi,%ecx
  8042ca:	72 30                	jb     8042fc <__umoddi3+0x12c>
  8042cc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8042cf:	72 27                	jb     8042f8 <__umoddi3+0x128>
  8042d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d4:	29 d0                	sub    %edx,%eax
  8042d6:	19 ce                	sbb    %ecx,%esi
  8042d8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042dc:	89 f2                	mov    %esi,%edx
  8042de:	d3 e8                	shr    %cl,%eax
  8042e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042e4:	d3 e2                	shl    %cl,%edx
  8042e6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042ea:	09 d0                	or     %edx,%eax
  8042ec:	89 f2                	mov    %esi,%edx
  8042ee:	d3 ea                	shr    %cl,%edx
  8042f0:	83 c4 20             	add    $0x20,%esp
  8042f3:	5e                   	pop    %esi
  8042f4:	5f                   	pop    %edi
  8042f5:	5d                   	pop    %ebp
  8042f6:	c3                   	ret    
  8042f7:	90                   	nop
  8042f8:	39 fe                	cmp    %edi,%esi
  8042fa:	75 d5                	jne    8042d1 <__umoddi3+0x101>
  8042fc:	89 f9                	mov    %edi,%ecx
  8042fe:	89 c2                	mov    %eax,%edx
  804300:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804303:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804306:	eb c9                	jmp    8042d1 <__umoddi3+0x101>
  804308:	39 f7                	cmp    %esi,%edi
  80430a:	0f 82 10 ff ff ff    	jb     804220 <__umoddi3+0x50>
  804310:	e9 17 ff ff ff       	jmp    80422c <__umoddi3+0x5c>
