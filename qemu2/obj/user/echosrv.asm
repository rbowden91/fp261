
obj/user/echosrv:     file format elf32-i386


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
  80002c:	e8 db 01 00 00       	call   80020c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL3diePKc>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(const char *m)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  80003a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003e:	c7 04 24 90 43 80 00 	movl   $0x804390,(%esp)
  800045:	e8 f4 02 00 00       	call   80033e <_Z7cprintfPKcz>
	exit();
  80004a:	e8 25 02 00 00       	call   800274 <_Z4exitv>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <_Z13handle_clienti>:

void
handle_client(int sock)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 3c             	sub    $0x3c,%esp
  80005a:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800064:	00 
  800065:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	89 34 24             	mov    %esi,(%esp)
  80006f:	e8 3a 16 00 00       	call   8016ae <_Z4readiPvj>
  800074:	89 c3                	mov    %eax,%ebx
  800076:	85 c0                	test   %eax,%eax
  800078:	79 0a                	jns    800084 <_Z13handle_clienti+0x33>
		die("Failed to receive initial bytes from client");
  80007a:	b8 94 43 80 00       	mov    $0x804394,%eax
  80007f:	e8 b0 ff ff ff       	call   800034 <_ZL3diePKc>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800084:	85 db                	test   %ebx,%ebx
  800086:	7e 49                	jle    8000d1 <_Z13handle_clienti+0x80>
		// Send back received data
		if (write(sock, buffer, received) != received)
  800088:	8d 7d c8             	lea    -0x38(%ebp),%edi
  80008b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 fe 16 00 00       	call   801799 <_Z5writeiPKvj>
  80009b:	39 c3                	cmp    %eax,%ebx
  80009d:	74 0a                	je     8000a9 <_Z13handle_clienti+0x58>
			die("Failed to send bytes to client");
  80009f:	b8 c0 43 80 00       	mov    $0x8043c0,%eax
  8000a4:	e8 8b ff ff ff       	call   800034 <_ZL3diePKc>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000b0:	00 
  8000b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b5:	89 34 24             	mov    %esi,(%esp)
  8000b8:	e8 f1 15 00 00       	call   8016ae <_Z4readiPvj>
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	79 0a                	jns    8000cd <_Z13handle_clienti+0x7c>
			die("Failed to receive additional bytes from client");
  8000c3:	b8 e0 43 80 00       	mov    $0x8043e0,%eax
  8000c8:	e8 67 ff ff ff       	call   800034 <_ZL3diePKc>
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	85 db                	test   %ebx,%ebx
  8000cf:	7f ba                	jg     80008b <_Z13handle_clienti+0x3a>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d1:	89 34 24             	mov    %esi,(%esp)
  8000d4:	e8 2c 14 00 00       	call   801505 <_Z5closei>
}
  8000d9:	83 c4 3c             	add    $0x3c,%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5f                   	pop    %edi
  8000df:	5d                   	pop    %ebp
  8000e0:	c3                   	ret    

008000e1 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	57                   	push   %edi
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ea:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f1:	00 
  8000f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800101:	e8 6e 35 00 00       	call   803674 <_Z6socketiii>
  800106:	89 c6                	mov    %eax,%esi
  800108:	85 c0                	test   %eax,%eax
  80010a:	79 0a                	jns    800116 <_Z5umainiPPc+0x35>
		die("Failed to create socket");
  80010c:	b8 40 43 80 00       	mov    $0x804340,%eax
  800111:	e8 1e ff ff ff       	call   800034 <_ZL3diePKc>

	cprintf("opened socket\n");
  800116:	c7 04 24 58 43 80 00 	movl   $0x804358,(%esp)
  80011d:	e8 1c 02 00 00       	call   80033e <_Z7cprintfPKcz>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800122:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800129:	00 
  80012a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800131:	00 
  800132:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
  800135:	89 1c 24             	mov    %ebx,(%esp)
  800138:	e8 64 09 00 00       	call   800aa1 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013d:	c6 45 d5 02          	movb   $0x2,-0x2b(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800148:	e8 1d 3d 00 00       	call   803e6a <htonl>
  80014d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800150:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800157:	e8 ed 3c 00 00       	call   803e49 <htons>
  80015c:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)

	cprintf("trying to bind\n");
  800160:	c7 04 24 67 43 80 00 	movl   $0x804367,(%esp)
  800167:	e8 d2 01 00 00       	call   80033e <_Z7cprintfPKcz>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
		 sizeof(echoserver)) < 0) {
  80016c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800173:	00 
  800174:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800178:	89 34 24             	mov    %esi,(%esp)
  80017b:	e8 5a 34 00 00       	call   8035da <_Z4bindiP8sockaddrj>
	echoserver.sin_port = htons(PORT);		  // server port

	cprintf("trying to bind\n");

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800180:	85 c0                	test   %eax,%eax
  800182:	79 0a                	jns    80018e <_Z5umainiPPc+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800184:	b8 10 44 80 00       	mov    $0x804410,%eax
  800189:	e8 a6 fe ff ff       	call   800034 <_ZL3diePKc>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800195:	00 
  800196:	89 34 24             	mov    %esi,(%esp)
  800199:	e8 b3 34 00 00       	call   803651 <_Z6listenii>
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	79 0a                	jns    8001ac <_Z5umainiPPc+0xcb>
		die("Failed to listen on server socket");
  8001a2:	b8 34 44 80 00       	mov    $0x804434,%eax
  8001a7:	e8 88 fe ff ff       	call   800034 <_ZL3diePKc>

	cprintf("bound\n");
  8001ac:	c7 04 24 77 43 80 00 	movl   $0x804377,(%esp)
  8001b3:	e8 86 01 00 00       	call   80033e <_Z7cprintfPKcz>
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
  8001b8:	8d 7d e4             	lea    -0x1c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001bb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%ebp)
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
  8001c2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c6:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8001c9:	89 44 24 04          	mov    %eax,0x4(%esp)

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001cd:	89 34 24             	mov    %esi,(%esp)
  8001d0:	e8 d2 33 00 00       	call   8035a7 <_Z6acceptiP8sockaddrPj>
  8001d5:	89 c3                	mov    %eax,%ebx
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	79 0a                	jns    8001e5 <_Z5umainiPPc+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001db:	b8 58 44 80 00       	mov    $0x804458,%eax
  8001e0:	e8 4f fe ff ff       	call   800034 <_ZL3diePKc>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 b0 3b 00 00       	call   803da0 <inet_ntoa>
  8001f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f4:	c7 04 24 7e 43 80 00 	movl   $0x80437e,(%esp)
  8001fb:	e8 3e 01 00 00       	call   80033e <_Z7cprintfPKcz>
		handle_client(clientsock);
  800200:	89 1c 24             	mov    %ebx,(%esp)
  800203:	e8 49 fe ff ff       	call   800051 <_Z13handle_clienti>
		die("Failed to listen on server socket");

	cprintf("bound\n");

	// Run until canceled
	while (1) {
  800208:	eb b1                	jmp    8001bb <_Z5umainiPPc+0xda>
	...

0080020c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	8b 7d 08             	mov    0x8(%ebp),%edi
  800218:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80021b:	e8 b8 0b 00 00       	call   800dd8 <_Z12sys_getenvidv>
  800220:	25 ff 03 00 00       	and    $0x3ff,%eax
  800225:	6b c0 78             	imul   $0x78,%eax,%eax
  800228:	05 00 00 00 ef       	add    $0xef000000,%eax
  80022d:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800232:	85 ff                	test   %edi,%edi
  800234:	7e 07                	jle    80023d <libmain+0x31>
		binaryname = argv[0];
  800236:	8b 06                	mov    (%esi),%eax
  800238:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80023d:	b8 ad 4f 80 00       	mov    $0x804fad,%eax
  800242:	3d ad 4f 80 00       	cmp    $0x804fad,%eax
  800247:	76 0f                	jbe    800258 <libmain+0x4c>
  800249:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80024b:	83 eb 04             	sub    $0x4,%ebx
  80024e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800250:	81 fb ad 4f 80 00    	cmp    $0x804fad,%ebx
  800256:	77 f3                	ja     80024b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800258:	89 74 24 04          	mov    %esi,0x4(%esp)
  80025c:	89 3c 24             	mov    %edi,(%esp)
  80025f:	e8 7d fe ff ff       	call   8000e1 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800264:	e8 0b 00 00 00       	call   800274 <_Z4exitv>
}
  800269:	83 c4 1c             	add    $0x1c,%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    
  800271:	00 00                	add    %al,(%eax)
	...

00800274 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80027a:	e8 bf 12 00 00       	call   80153e <_Z9close_allv>
	sys_env_destroy(0);
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 f0 0a 00 00       	call   800d7b <_Z15sys_env_destroyi>
}
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    
  80028d:	00 00                	add    %al,(%eax)
	...

00800290 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
  800296:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800299:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80029c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80029f:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8002a1:	8b 03                	mov    (%ebx),%eax
  8002a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002aa:	83 c0 01             	add    $0x1,%eax
  8002ad:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b4:	75 19                	jne    8002cf <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8002b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002bd:	00 
  8002be:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c1:	89 04 24             	mov    %eax,(%esp)
  8002c4:	e8 4b 0a 00 00       	call   800d14 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8002c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002cf:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8002d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8002d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8002d9:	89 ec                	mov    %ebp,%esp
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	89 44 24 08          	mov    %eax,0x8(%esp)
  800308:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800312:	c7 04 24 90 02 80 00 	movl   $0x800290,(%esp)
  800319:	e8 a9 01 00 00       	call   8004c7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80031e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800324:	89 44 24 04          	mov    %eax,0x4(%esp)
  800328:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80032e:	89 04 24             	mov    %eax,(%esp)
  800331:	e8 de 09 00 00       	call   800d14 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800336:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800344:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	e8 87 ff ff ff       	call   8002dd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800356:	c9                   	leave  
  800357:	c3                   	ret    
	...

00800360 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 4c             	sub    $0x4c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d6                	mov    %edx,%esi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80037a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80037d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800380:	b8 00 00 00 00       	mov    $0x0,%eax
  800385:	39 d0                	cmp    %edx,%eax
  800387:	72 11                	jb     80039a <_ZL8printnumPFviPvES_yjii+0x3a>
  800389:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80038c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80038f:	76 09                	jbe    80039a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800391:	83 eb 01             	sub    $0x1,%ebx
  800394:	85 db                	test   %ebx,%ebx
  800396:	7f 5d                	jg     8003f5 <_ZL8printnumPFviPvES_yjii+0x95>
  800398:	eb 6c                	jmp    800406 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80039e:	83 eb 01             	sub    $0x1,%ebx
  8003a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003b0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8003ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003c1:	00 
  8003c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003c5:	89 14 24             	mov    %edx,(%esp)
  8003c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003cf:	e8 0c 3d 00 00       	call   8040e0 <__udivdi3>
  8003d4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003d7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003de:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003e2:	89 04 24             	mov    %eax,(%esp)
  8003e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e9:	89 f2                	mov    %esi,%edx
  8003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ee:	e8 6d ff ff ff       	call   800360 <_ZL8printnumPFviPvES_yjii>
  8003f3:	eb 11                	jmp    800406 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f9:	89 3c 24             	mov    %edi,(%esp)
  8003fc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ff:	83 eb 01             	sub    $0x1,%ebx
  800402:	85 db                	test   %ebx,%ebx
  800404:	7f ef                	jg     8003f5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80040e:	8b 45 10             	mov    0x10(%ebp),%eax
  800411:	89 44 24 08          	mov    %eax,0x8(%esp)
  800415:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041c:	00 
  80041d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800420:	89 14 24             	mov    %edx,(%esp)
  800423:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800426:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80042a:	e8 c1 3d 00 00       	call   8041f0 <__umoddi3>
  80042f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800433:	0f be 80 85 44 80 00 	movsbl 0x804485(%eax),%eax
  80043a:	89 04 24             	mov    %eax,(%esp)
  80043d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800440:	83 c4 4c             	add    $0x4c,%esp
  800443:	5b                   	pop    %ebx
  800444:	5e                   	pop    %esi
  800445:	5f                   	pop    %edi
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    

00800448 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044b:	83 fa 01             	cmp    $0x1,%edx
  80044e:	7e 0e                	jle    80045e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800450:	8b 10                	mov    (%eax),%edx
  800452:	8d 4a 08             	lea    0x8(%edx),%ecx
  800455:	89 08                	mov    %ecx,(%eax)
  800457:	8b 02                	mov    (%edx),%eax
  800459:	8b 52 04             	mov    0x4(%edx),%edx
  80045c:	eb 22                	jmp    800480 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80045e:	85 d2                	test   %edx,%edx
  800460:	74 10                	je     800472 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800462:	8b 10                	mov    (%eax),%edx
  800464:	8d 4a 04             	lea    0x4(%edx),%ecx
  800467:	89 08                	mov    %ecx,(%eax)
  800469:	8b 02                	mov    (%edx),%eax
  80046b:	ba 00 00 00 00       	mov    $0x0,%edx
  800470:	eb 0e                	jmp    800480 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800472:	8b 10                	mov    (%eax),%edx
  800474:	8d 4a 04             	lea    0x4(%edx),%ecx
  800477:	89 08                	mov    %ecx,(%eax)
  800479:	8b 02                	mov    (%edx),%eax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800488:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048c:	8b 10                	mov    (%eax),%edx
  80048e:	3b 50 04             	cmp    0x4(%eax),%edx
  800491:	73 0a                	jae    80049d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800493:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800496:	88 0a                	mov    %cl,(%edx)
  800498:	83 c2 01             	add    $0x1,%edx
  80049b:	89 10                	mov    %edx,(%eax)
}
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004a5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 02 00 00 00       	call   8004c7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 3c             	sub    $0x3c,%esp
  8004d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d3:	8b 55 10             	mov    0x10(%ebp),%edx
  8004d6:	0f b6 02             	movzbl (%edx),%eax
  8004d9:	89 d3                	mov    %edx,%ebx
  8004db:	83 c3 01             	add    $0x1,%ebx
  8004de:	83 f8 25             	cmp    $0x25,%eax
  8004e1:	74 2b                	je     80050e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8004e7:	e9 a5 03 00 00       	jmp    800891 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004ec:	85 c0                	test   %eax,%eax
  8004ee:	66 90                	xchg   %ax,%ax
  8004f0:	75 08                	jne    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8004f2:	e9 9a 03 00 00       	jmp    800891 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004f7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	89 04 24             	mov    %eax,(%esp)
  800501:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800503:	0f b6 03             	movzbl (%ebx),%eax
  800506:	83 c3 01             	add    $0x1,%ebx
  800509:	83 f8 25             	cmp    $0x25,%eax
  80050c:	75 de                	jne    8004ec <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80050e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800512:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800519:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80051e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800525:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80052d:	eb 2b                	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800532:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800536:	eb 22                	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800538:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80053f:	eb 19                	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800541:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800544:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80054b:	eb 0d                	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80054d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800550:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800553:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	0f b6 03             	movzbl (%ebx),%eax
  80055d:	0f b6 d0             	movzbl %al,%edx
  800560:	8d 73 01             	lea    0x1(%ebx),%esi
  800563:	89 75 10             	mov    %esi,0x10(%ebp)
  800566:	83 e8 23             	sub    $0x23,%eax
  800569:	3c 55                	cmp    $0x55,%al
  80056b:	0f 87 d8 02 00 00    	ja     800849 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800571:	0f b6 c0             	movzbl %al,%eax
  800574:	ff 24 85 20 46 80 00 	jmp    *0x804620(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80057b:	83 ea 30             	sub    $0x30,%edx
  80057e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800581:	8b 55 10             	mov    0x10(%ebp),%edx
  800584:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800587:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80058d:	83 fa 09             	cmp    $0x9,%edx
  800590:	77 4e                	ja     8005e0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800592:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800595:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800598:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80059b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80059f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8005a2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005a5:	83 fa 09             	cmp    $0x9,%edx
  8005a8:	76 eb                	jbe    800595 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8005aa:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005ad:	eb 31                	jmp    8005e0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c0:	eb 1e                	jmp    8005e0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8005c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c6:	0f 88 75 ff ff ff    	js     800541 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cf:	eb 89                	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005d4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005db:	e9 7a ff ff ff       	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8005e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e4:	0f 89 70 ff ff ff    	jns    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005ea:	e9 5e ff ff ff       	jmp    80054d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ef:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f5:	e9 60 ff ff ff       	jmp    80055a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 50 04             	lea    0x4(%eax),%edx
  800600:	89 55 14             	mov    %edx,0x14(%ebp)
  800603:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800607:	8b 00                	mov    (%eax),%eax
  800609:	89 04 24             	mov    %eax,(%esp)
  80060c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80060f:	e9 bf fe ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 50 04             	lea    0x4(%eax),%edx
  80061a:	89 55 14             	mov    %edx,0x14(%ebp)
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 c2                	mov    %eax,%edx
  800621:	c1 fa 1f             	sar    $0x1f,%edx
  800624:	31 d0                	xor    %edx,%eax
  800626:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800628:	83 f8 14             	cmp    $0x14,%eax
  80062b:	7f 0f                	jg     80063c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80062d:	8b 14 85 80 47 80 00 	mov    0x804780(,%eax,4),%edx
  800634:	85 d2                	test   %edx,%edx
  800636:	0f 85 35 02 00 00    	jne    800871 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80063c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800640:	c7 44 24 08 9d 44 80 	movl   $0x80449d,0x8(%esp)
  800647:	00 
  800648:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064c:	8b 75 08             	mov    0x8(%ebp),%esi
  80064f:	89 34 24             	mov    %esi,(%esp)
  800652:	e8 48 fe ff ff       	call   80049f <_Z8printfmtPFviPvES_PKcz>
  800657:	e9 77 fe ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80065c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800662:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 50 04             	lea    0x4(%eax),%edx
  80066b:	89 55 14             	mov    %edx,0x14(%ebp)
  80066e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800670:	85 db                	test   %ebx,%ebx
  800672:	ba 96 44 80 00       	mov    $0x804496,%edx
  800677:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80067a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80067e:	7e 72                	jle    8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800680:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800684:	74 6c                	je     8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800686:	89 74 24 04          	mov    %esi,0x4(%esp)
  80068a:	89 1c 24             	mov    %ebx,(%esp)
  80068d:	e8 a9 02 00 00       	call   80093b <_Z7strnlenPKcj>
  800692:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80069a:	85 d2                	test   %edx,%edx
  80069c:	7e 54                	jle    8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80069e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8006a2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006a5:	89 d3                	mov    %edx,%ebx
  8006a7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006aa:	89 c6                	mov    %eax,%esi
  8006ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b0:	89 34 24             	mov    %esi,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b6:	83 eb 01             	sub    $0x1,%ebx
  8006b9:	85 db                	test   %ebx,%ebx
  8006bb:	7f ef                	jg     8006ac <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8006bd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006ca:	eb 26                	jmp    8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006cc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006cf:	83 fa 5e             	cmp    $0x5e,%edx
  8006d2:	76 10                	jbe    8006e4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8006d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006df:	ff 55 08             	call   *0x8(%ebp)
  8006e2:	eb 0a                	jmp    8006ee <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8006e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e8:	89 04 24             	mov    %eax,(%esp)
  8006eb:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006f2:	0f be 03             	movsbl (%ebx),%eax
  8006f5:	83 c3 01             	add    $0x1,%ebx
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	74 11                	je     80070d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  8006fc:	85 f6                	test   %esi,%esi
  8006fe:	78 05                	js     800705 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800700:	83 ee 01             	sub    $0x1,%esi
  800703:	78 0d                	js     800712 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800705:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800709:	75 c1                	jne    8006cc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80070b:	eb d7                	jmp    8006e4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800710:	eb 03                	jmp    800715 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800715:	85 c0                	test   %eax,%eax
  800717:	0f 8e b6 fd ff ff    	jle    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80071d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800720:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800723:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800727:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80072e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800730:	83 eb 01             	sub    $0x1,%ebx
  800733:	85 db                	test   %ebx,%ebx
  800735:	7f ec                	jg     800723 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800737:	e9 97 fd ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80073c:	83 f9 01             	cmp    $0x1,%ecx
  80073f:	90                   	nop
  800740:	7e 10                	jle    800752 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8d 50 08             	lea    0x8(%eax),%edx
  800748:	89 55 14             	mov    %edx,0x14(%ebp)
  80074b:	8b 18                	mov    (%eax),%ebx
  80074d:	8b 70 04             	mov    0x4(%eax),%esi
  800750:	eb 26                	jmp    800778 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800752:	85 c9                	test   %ecx,%ecx
  800754:	74 12                	je     800768 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 50 04             	lea    0x4(%eax),%edx
  80075c:	89 55 14             	mov    %edx,0x14(%ebp)
  80075f:	8b 18                	mov    (%eax),%ebx
  800761:	89 de                	mov    %ebx,%esi
  800763:	c1 fe 1f             	sar    $0x1f,%esi
  800766:	eb 10                	jmp    800778 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8d 50 04             	lea    0x4(%eax),%edx
  80076e:	89 55 14             	mov    %edx,0x14(%ebp)
  800771:	8b 18                	mov    (%eax),%ebx
  800773:	89 de                	mov    %ebx,%esi
  800775:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800778:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80077d:	85 f6                	test   %esi,%esi
  80077f:	0f 89 8c 00 00 00    	jns    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800785:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800789:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800790:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800793:	f7 db                	neg    %ebx
  800795:	83 d6 00             	adc    $0x0,%esi
  800798:	f7 de                	neg    %esi
			}
			base = 10;
  80079a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079f:	eb 70                	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a1:	89 ca                	mov    %ecx,%edx
  8007a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a6:	e8 9d fc ff ff       	call   800448 <_ZL7getuintPPci>
  8007ab:	89 c3                	mov    %eax,%ebx
  8007ad:	89 d6                	mov    %edx,%esi
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007b4:	eb 5b                	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007b6:	89 ca                	mov    %ecx,%edx
  8007b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bb:	e8 88 fc ff ff       	call   800448 <_ZL7getuintPPci>
  8007c0:	89 c3                	mov    %eax,%ebx
  8007c2:	89 d6                	mov    %edx,%esi
			base = 8;
  8007c4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007c9:	eb 46                	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8007cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007d6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007dd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007e4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f0:	8b 18                	mov    (%eax),%ebx
  8007f2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  8007f7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007fc:	eb 13                	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007fe:	89 ca                	mov    %ecx,%edx
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
  800803:	e8 40 fc ff ff       	call   800448 <_ZL7getuintPPci>
  800808:	89 c3                	mov    %eax,%ebx
  80080a:	89 d6                	mov    %edx,%esi
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800811:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800815:	89 54 24 10          	mov    %edx,0x10(%esp)
  800819:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80081c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800820:	89 44 24 08          	mov    %eax,0x8(%esp)
  800824:	89 1c 24             	mov    %ebx,(%esp)
  800827:	89 74 24 04          	mov    %esi,0x4(%esp)
  80082b:	89 fa                	mov    %edi,%edx
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	e8 2b fb ff ff       	call   800360 <_ZL8printnumPFviPvES_yjii>
			break;
  800835:	e9 99 fc ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083e:	89 14 24             	mov    %edx,(%esp)
  800841:	ff 55 08             	call   *0x8(%ebp)
			break;
  800844:	e9 8a fc ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800849:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800854:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800857:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80085a:	89 d8                	mov    %ebx,%eax
  80085c:	eb 02                	jmp    800860 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80085e:	89 d0                	mov    %edx,%eax
  800860:	8d 50 ff             	lea    -0x1(%eax),%edx
  800863:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800867:	75 f5                	jne    80085e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800869:	89 45 10             	mov    %eax,0x10(%ebp)
  80086c:	e9 62 fc ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800871:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800875:	c7 44 24 08 1e 48 80 	movl   $0x80481e,0x8(%esp)
  80087c:	00 
  80087d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800881:	8b 75 08             	mov    0x8(%ebp),%esi
  800884:	89 34 24             	mov    %esi,(%esp)
  800887:	e8 13 fc ff ff       	call   80049f <_Z8printfmtPFviPvES_PKcz>
  80088c:	e9 42 fc ff ff       	jmp    8004d3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800891:	83 c4 3c             	add    $0x3c,%esp
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5f                   	pop    %edi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 28             	sub    $0x28,%esp
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8008ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008af:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	74 30                	je     8008ea <_Z9vsnprintfPciPKcS_+0x51>
  8008ba:	85 d2                	test   %edx,%edx
  8008bc:	7e 2c                	jle    8008ea <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d3:	c7 04 24 82 04 80 00 	movl   $0x800482,(%esp)
  8008da:	e8 e8 fb ff ff       	call   8004c7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8008df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e8:	eb 05                	jmp    8008ef <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800901:	89 44 24 08          	mov    %eax,0x8(%esp)
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
  800908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	89 04 24             	mov    %eax,(%esp)
  800912:	e8 82 ff ff ff       	call   800899 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800917:	c9                   	leave  
  800918:	c3                   	ret    
  800919:	00 00                	add    %al,(%eax)
  80091b:	00 00                	add    %al,(%eax)
  80091d:	00 00                	add    %al,(%eax)
	...

00800920 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	80 3a 00             	cmpb   $0x0,(%edx)
  80092e:	74 09                	je     800939 <_Z6strlenPKc+0x19>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	75 f7                	jne    800930 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	39 c2                	cmp    %eax,%edx
  80094b:	74 0b                	je     800958 <_Z7strnlenPKcj+0x1d>
  80094d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800951:	74 05                	je     800958 <_Z7strnlenPKcj+0x1d>
		n++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	eb f1                	jmp    800949 <_Z7strnlenPKcj+0xe>
	return n;
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800964:	ba 00 00 00 00       	mov    $0x0,%edx
  800969:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80096d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800970:	83 c2 01             	add    $0x1,%edx
  800973:	84 c9                	test   %cl,%cl
  800975:	75 f2                	jne    800969 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800988:	85 f6                	test   %esi,%esi
  80098a:	74 18                	je     8009a4 <_Z7strncpyPcPKcj+0x2a>
  80098c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800991:	0f b6 1a             	movzbl (%edx),%ebx
  800994:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800997:	80 3a 01             	cmpb   $0x1,(%edx)
  80099a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80099d:	83 c1 01             	add    $0x1,%ecx
  8009a0:	39 ce                	cmp    %ecx,%esi
  8009a2:	77 ed                	ja     800991 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8009b6:	89 f0                	mov    %esi,%eax
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	74 17                	je     8009d3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8009bc:	83 ea 01             	sub    $0x1,%edx
  8009bf:	74 18                	je     8009d9 <_Z7strlcpyPcPKcj+0x31>
  8009c1:	80 39 00             	cmpb   $0x0,(%ecx)
  8009c4:	74 17                	je     8009dd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8009c6:	0f b6 19             	movzbl (%ecx),%ebx
  8009c9:	88 18                	mov    %bl,(%eax)
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	83 c1 01             	add    $0x1,%ecx
  8009d1:	eb e9                	jmp    8009bc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8009d3:	29 f0                	sub    %esi,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d9:	89 c2                	mov    %eax,%edx
  8009db:	eb 02                	jmp    8009df <_Z7strlcpyPcPKcj+0x37>
  8009dd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009df:	c6 02 00             	movb   $0x0,(%edx)
  8009e2:	eb ef                	jmp    8009d3 <_Z7strlcpyPcPKcj+0x2b>

008009e4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ed:	0f b6 01             	movzbl (%ecx),%eax
  8009f0:	84 c0                	test   %al,%al
  8009f2:	74 0c                	je     800a00 <_Z6strcmpPKcS0_+0x1c>
  8009f4:	3a 02                	cmp    (%edx),%al
  8009f6:	75 08                	jne    800a00 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	eb ed                	jmp    8009ed <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	0f b6 12             	movzbl (%edx),%edx
  800a06:	29 d0                	sub    %edx,%eax
}
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	53                   	push   %ebx
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a14:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a17:	85 d2                	test   %edx,%edx
  800a19:	74 16                	je     800a31 <_Z7strncmpPKcS0_j+0x27>
  800a1b:	0f b6 01             	movzbl (%ecx),%eax
  800a1e:	84 c0                	test   %al,%al
  800a20:	74 17                	je     800a39 <_Z7strncmpPKcS0_j+0x2f>
  800a22:	3a 03                	cmp    (%ebx),%al
  800a24:	75 13                	jne    800a39 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800a26:	83 ea 01             	sub    $0x1,%edx
  800a29:	83 c1 01             	add    $0x1,%ecx
  800a2c:	83 c3 01             	add    $0x1,%ebx
  800a2f:	eb e6                	jmp    800a17 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800a39:	0f b6 01             	movzbl (%ecx),%eax
  800a3c:	0f b6 13             	movzbl (%ebx),%edx
  800a3f:	29 d0                	sub    %edx,%eax
  800a41:	eb f3                	jmp    800a36 <_Z7strncmpPKcS0_j+0x2c>

00800a43 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
  800a50:	84 d2                	test   %dl,%dl
  800a52:	74 1f                	je     800a73 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800a54:	38 ca                	cmp    %cl,%dl
  800a56:	75 0a                	jne    800a62 <_Z6strchrPKcc+0x1f>
  800a58:	eb 1e                	jmp    800a78 <_Z6strchrPKcc+0x35>
  800a5a:	38 ca                	cmp    %cl,%dl
  800a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a60:	74 16                	je     800a78 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a62:	83 c0 01             	add    $0x1,%eax
  800a65:	0f b6 10             	movzbl (%eax),%edx
  800a68:	84 d2                	test   %dl,%dl
  800a6a:	75 ee                	jne    800a5a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a71:	eb 05                	jmp    800a78 <_Z6strchrPKcc+0x35>
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a84:	0f b6 10             	movzbl (%eax),%edx
  800a87:	84 d2                	test   %dl,%dl
  800a89:	74 14                	je     800a9f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800a8b:	38 ca                	cmp    %cl,%dl
  800a8d:	75 06                	jne    800a95 <_Z7strfindPKcc+0x1b>
  800a8f:	eb 0e                	jmp    800a9f <_Z7strfindPKcc+0x25>
  800a91:	38 ca                	cmp    %cl,%dl
  800a93:	74 0a                	je     800a9f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a95:	83 c0 01             	add    $0x1,%eax
  800a98:	0f b6 10             	movzbl (%eax),%edx
  800a9b:	84 d2                	test   %dl,%dl
  800a9d:	75 f2                	jne    800a91 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 0c             	sub    $0xc,%esp
  800aa7:	89 1c 24             	mov    %ebx,(%esp)
  800aaa:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ab2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800abb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ac1:	75 25                	jne    800ae8 <memset+0x47>
  800ac3:	f6 c1 03             	test   $0x3,%cl
  800ac6:	75 20                	jne    800ae8 <memset+0x47>
		c &= 0xFF;
  800ac8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800acb:	89 d3                	mov    %edx,%ebx
  800acd:	c1 e3 08             	shl    $0x8,%ebx
  800ad0:	89 d6                	mov    %edx,%esi
  800ad2:	c1 e6 18             	shl    $0x18,%esi
  800ad5:	89 d0                	mov    %edx,%eax
  800ad7:	c1 e0 10             	shl    $0x10,%eax
  800ada:	09 f0                	or     %esi,%eax
  800adc:	09 d0                	or     %edx,%eax
  800ade:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800ae0:	c1 e9 02             	shr    $0x2,%ecx
  800ae3:	fc                   	cld    
  800ae4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae6:	eb 03                	jmp    800aeb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800ae8:	fc                   	cld    
  800ae9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800aeb:	89 f8                	mov    %edi,%eax
  800aed:	8b 1c 24             	mov    (%esp),%ebx
  800af0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800af4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800af8:	89 ec                	mov    %ebp,%esp
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	89 34 24             	mov    %esi,(%esp)
  800b05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800b12:	39 c6                	cmp    %eax,%esi
  800b14:	73 36                	jae    800b4c <memmove+0x50>
  800b16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b19:	39 d0                	cmp    %edx,%eax
  800b1b:	73 2f                	jae    800b4c <memmove+0x50>
		s += n;
		d += n;
  800b1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b20:	f6 c2 03             	test   $0x3,%dl
  800b23:	75 1b                	jne    800b40 <memmove+0x44>
  800b25:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b2b:	75 13                	jne    800b40 <memmove+0x44>
  800b2d:	f6 c1 03             	test   $0x3,%cl
  800b30:	75 0e                	jne    800b40 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b32:	83 ef 04             	sub    $0x4,%edi
  800b35:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b38:	c1 e9 02             	shr    $0x2,%ecx
  800b3b:	fd                   	std    
  800b3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3e:	eb 09                	jmp    800b49 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b40:	83 ef 01             	sub    $0x1,%edi
  800b43:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b46:	fd                   	std    
  800b47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b49:	fc                   	cld    
  800b4a:	eb 20                	jmp    800b6c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b52:	75 13                	jne    800b67 <memmove+0x6b>
  800b54:	a8 03                	test   $0x3,%al
  800b56:	75 0f                	jne    800b67 <memmove+0x6b>
  800b58:	f6 c1 03             	test   $0x3,%cl
  800b5b:	75 0a                	jne    800b67 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5d:	c1 e9 02             	shr    $0x2,%ecx
  800b60:	89 c7                	mov    %eax,%edi
  800b62:	fc                   	cld    
  800b63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b65:	eb 05                	jmp    800b6c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b67:	89 c7                	mov    %eax,%edi
  800b69:	fc                   	cld    
  800b6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b6c:	8b 34 24             	mov    (%esp),%esi
  800b6f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b73:	89 ec                	mov    %ebp,%esp
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	89 34 24             	mov    %esi,(%esp)
  800b80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b93:	75 13                	jne    800ba8 <memcpy+0x31>
  800b95:	a8 03                	test   $0x3,%al
  800b97:	75 0f                	jne    800ba8 <memcpy+0x31>
  800b99:	f6 c1 03             	test   $0x3,%cl
  800b9c:	75 0a                	jne    800ba8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9e:	c1 e9 02             	shr    $0x2,%ecx
  800ba1:	89 c7                	mov    %eax,%edi
  800ba3:	fc                   	cld    
  800ba4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba6:	eb 05                	jmp    800bad <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	fc                   	cld    
  800bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800bad:	8b 34 24             	mov    (%esp),%esi
  800bb0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bb4:	89 ec                	mov    %ebp,%esp
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bcc:	85 ff                	test   %edi,%edi
  800bce:	74 38                	je     800c08 <memcmp+0x50>
		if (*s1 != *s2)
  800bd0:	0f b6 03             	movzbl (%ebx),%eax
  800bd3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bd6:	83 ef 01             	sub    $0x1,%edi
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800bde:	38 c8                	cmp    %cl,%al
  800be0:	74 1d                	je     800bff <memcmp+0x47>
  800be2:	eb 11                	jmp    800bf5 <memcmp+0x3d>
  800be4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800be9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	38 c8                	cmp    %cl,%al
  800bf3:	74 0a                	je     800bff <memcmp+0x47>
			return *s1 - *s2;
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	0f b6 c9             	movzbl %cl,%ecx
  800bfb:	29 c8                	sub    %ecx,%eax
  800bfd:	eb 09                	jmp    800c08 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bff:	39 fa                	cmp    %edi,%edx
  800c01:	75 e1                	jne    800be4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	53                   	push   %ebx
  800c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800c14:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800c16:	89 da                	mov    %ebx,%edx
  800c18:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800c1b:	39 d3                	cmp    %edx,%ebx
  800c1d:	73 15                	jae    800c34 <memfind+0x27>
		if (*s == (unsigned char) c)
  800c1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c23:	38 0b                	cmp    %cl,(%ebx)
  800c25:	75 06                	jne    800c2d <memfind+0x20>
  800c27:	eb 0b                	jmp    800c34 <memfind+0x27>
  800c29:	38 08                	cmp    %cl,(%eax)
  800c2b:	74 07                	je     800c34 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800c2d:	83 c0 01             	add    $0x1,%eax
  800c30:	39 c2                	cmp    %eax,%edx
  800c32:	77 f5                	ja     800c29 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c34:	5b                   	pop    %ebx
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c43:	0f b6 02             	movzbl (%edx),%eax
  800c46:	3c 20                	cmp    $0x20,%al
  800c48:	74 04                	je     800c4e <_Z6strtolPKcPPci+0x17>
  800c4a:	3c 09                	cmp    $0x9,%al
  800c4c:	75 0e                	jne    800c5c <_Z6strtolPKcPPci+0x25>
		s++;
  800c4e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c51:	0f b6 02             	movzbl (%edx),%eax
  800c54:	3c 20                	cmp    $0x20,%al
  800c56:	74 f6                	je     800c4e <_Z6strtolPKcPPci+0x17>
  800c58:	3c 09                	cmp    $0x9,%al
  800c5a:	74 f2                	je     800c4e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c5c:	3c 2b                	cmp    $0x2b,%al
  800c5e:	75 0a                	jne    800c6a <_Z6strtolPKcPPci+0x33>
		s++;
  800c60:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c63:	bf 00 00 00 00       	mov    $0x0,%edi
  800c68:	eb 10                	jmp    800c7a <_Z6strtolPKcPPci+0x43>
  800c6a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c6f:	3c 2d                	cmp    $0x2d,%al
  800c71:	75 07                	jne    800c7a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7a:	85 db                	test   %ebx,%ebx
  800c7c:	0f 94 c0             	sete   %al
  800c7f:	74 05                	je     800c86 <_Z6strtolPKcPPci+0x4f>
  800c81:	83 fb 10             	cmp    $0x10,%ebx
  800c84:	75 15                	jne    800c9b <_Z6strtolPKcPPci+0x64>
  800c86:	80 3a 30             	cmpb   $0x30,(%edx)
  800c89:	75 10                	jne    800c9b <_Z6strtolPKcPPci+0x64>
  800c8b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c8f:	75 0a                	jne    800c9b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800c91:	83 c2 02             	add    $0x2,%edx
  800c94:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c99:	eb 13                	jmp    800cae <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800c9b:	84 c0                	test   %al,%al
  800c9d:	74 0f                	je     800cae <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c9f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ca4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ca7:	75 05                	jne    800cae <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800ca9:	83 c2 01             	add    $0x1,%edx
  800cac:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cb5:	0f b6 0a             	movzbl (%edx),%ecx
  800cb8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cbb:	80 fb 09             	cmp    $0x9,%bl
  800cbe:	77 08                	ja     800cc8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800cc0:	0f be c9             	movsbl %cl,%ecx
  800cc3:	83 e9 30             	sub    $0x30,%ecx
  800cc6:	eb 1e                	jmp    800ce6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800cc8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800ccb:	80 fb 19             	cmp    $0x19,%bl
  800cce:	77 08                	ja     800cd8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800cd0:	0f be c9             	movsbl %cl,%ecx
  800cd3:	83 e9 57             	sub    $0x57,%ecx
  800cd6:	eb 0e                	jmp    800ce6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800cd8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800cdb:	80 fb 19             	cmp    $0x19,%bl
  800cde:	77 15                	ja     800cf5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800ce0:	0f be c9             	movsbl %cl,%ecx
  800ce3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ce6:	39 f1                	cmp    %esi,%ecx
  800ce8:	7d 0f                	jge    800cf9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800cea:	83 c2 01             	add    $0x1,%edx
  800ced:	0f af c6             	imul   %esi,%eax
  800cf0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800cf3:	eb c0                	jmp    800cb5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800cf5:	89 c1                	mov    %eax,%ecx
  800cf7:	eb 02                	jmp    800cfb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cf9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cff:	74 05                	je     800d06 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800d01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d04:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d06:	89 ca                	mov    %ecx,%edx
  800d08:	f7 da                	neg    %edx
  800d0a:	85 ff                	test   %edi,%edi
  800d0c:	0f 45 c2             	cmovne %edx,%eax
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	89 1c 24             	mov    %ebx,(%esp)
  800d1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d21:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	89 c3                	mov    %eax,%ebx
  800d32:	89 c7                	mov    %eax,%edi
  800d34:	89 c6                	mov    %eax,%esi
  800d36:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d38:	8b 1c 24             	mov    (%esp),%ebx
  800d3b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d3f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d43:	89 ec                	mov    %ebp,%esp
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	89 1c 24             	mov    %ebx,(%esp)
  800d50:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d54:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d58:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d62:	89 d1                	mov    %edx,%ecx
  800d64:	89 d3                	mov    %edx,%ebx
  800d66:	89 d7                	mov    %edx,%edi
  800d68:	89 d6                	mov    %edx,%esi
  800d6a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d6c:	8b 1c 24             	mov    (%esp),%ebx
  800d6f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d73:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d77:	89 ec                	mov    %ebp,%esp
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 38             	sub    $0x38,%esp
  800d81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d87:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	89 cb                	mov    %ecx,%ebx
  800d99:	89 cf                	mov    %ecx,%edi
  800d9b:	89 ce                	mov    %ecx,%esi
  800d9d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7e 28                	jle    800dcb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800dae:	00 
  800daf:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  800dc6:	e8 11 2d 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd4:	89 ec                	mov    %ebp,%esp
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	89 1c 24             	mov    %ebx,(%esp)
  800de1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800de5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dee:	b8 02 00 00 00       	mov    $0x2,%eax
  800df3:	89 d1                	mov    %edx,%ecx
  800df5:	89 d3                	mov    %edx,%ebx
  800df7:	89 d7                	mov    %edx,%edi
  800df9:	89 d6                	mov    %edx,%esi
  800dfb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfd:	8b 1c 24             	mov    (%esp),%ebx
  800e00:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e08:	89 ec                	mov    %ebp,%esp
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	89 1c 24             	mov    %ebx,(%esp)
  800e15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e19:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e22:	b8 04 00 00 00       	mov    $0x4,%eax
  800e27:	89 d1                	mov    %edx,%ecx
  800e29:	89 d3                	mov    %edx,%ebx
  800e2b:	89 d7                	mov    %edx,%edi
  800e2d:	89 d6                	mov    %edx,%esi
  800e2f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e31:	8b 1c 24             	mov    (%esp),%ebx
  800e34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e3c:	89 ec                	mov    %ebp,%esp
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 38             	sub    $0x38,%esp
  800e46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e49:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e4f:	be 00 00 00 00       	mov    $0x0,%esi
  800e54:	b8 08 00 00 00       	mov    $0x8,%eax
  800e59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	89 f7                	mov    %esi,%edi
  800e64:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7e 28                	jle    800e92 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e75:	00 
  800e76:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800e7d:	00 
  800e7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e85:	00 
  800e86:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  800e8d:	e8 4a 2c 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e95:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e98:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9b:	89 ec                	mov    %ebp,%esp
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 38             	sub    $0x38,%esp
  800ea5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eab:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eae:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb3:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 28                	jle    800ef0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800edb:	00 
  800edc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee3:	00 
  800ee4:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  800eeb:	e8 ec 2b 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef9:	89 ec                	mov    %ebp,%esp
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 38             	sub    $0x38,%esp
  800f03:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f06:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f09:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7e 28                	jle    800f4e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f31:	00 
  800f32:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800f39:	00 
  800f3a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f41:	00 
  800f42:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  800f49:	e8 8e 2b 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f51:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f54:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f57:	89 ec                	mov    %ebp,%esp
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	83 ec 38             	sub    $0x38,%esp
  800f61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f67:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	89 df                	mov    %ebx,%edi
  800f7c:	89 de                	mov    %ebx,%esi
  800f7e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f80:	85 c0                	test   %eax,%eax
  800f82:	7e 28                	jle    800fac <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f84:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f88:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f8f:	00 
  800f90:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800f97:	00 
  800f98:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9f:	00 
  800fa0:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  800fa7:	e8 30 2b 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800faf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb5:	89 ec                	mov    %ebp,%esp
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 38             	sub    $0x38,%esp
  800fbf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcd:	b8 06 00 00 00       	mov    $0x6,%eax
  800fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	89 df                	mov    %ebx,%edi
  800fda:	89 de                	mov    %ebx,%esi
  800fdc:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	7e 28                	jle    80100a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fed:	00 
  800fee:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  800ff5:	00 
  800ff6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffd:	00 
  800ffe:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  801005:	e8 d2 2a 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80100a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801010:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801013:	89 ec                	mov    %ebp,%esp
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 38             	sub    $0x38,%esp
  80101d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801020:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801023:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7e 28                	jle    801068 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801040:	89 44 24 10          	mov    %eax,0x10(%esp)
  801044:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80104b:	00 
  80104c:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  801053:	00 
  801054:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105b:	00 
  80105c:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  801063:	e8 74 2a 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801068:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80106b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801071:	89 ec                	mov    %ebp,%esp
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 38             	sub    $0x38,%esp
  80107b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801081:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
  801089:	b8 0c 00 00 00       	mov    $0xc,%eax
  80108e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801091:	8b 55 08             	mov    0x8(%ebp),%edx
  801094:	89 df                	mov    %ebx,%edi
  801096:	89 de                	mov    %ebx,%esi
  801098:	cd 30                	int    $0x30

	if(check && ret > 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	7e 28                	jle    8010c6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8010a9:	00 
  8010aa:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b9:	00 
  8010ba:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  8010c1:	e8 16 2a 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010cf:	89 ec                	mov    %ebp,%esp
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 0c             	sub    $0xc,%esp
  8010d9:	89 1c 24             	mov    %ebx,(%esp)
  8010dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010e4:	be 00 00 00 00       	mov    $0x0,%esi
  8010e9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ee:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fa:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010fc:	8b 1c 24             	mov    (%esp),%ebx
  8010ff:	8b 74 24 04          	mov    0x4(%esp),%esi
  801103:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801107:	89 ec                	mov    %ebp,%esp
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 38             	sub    $0x38,%esp
  801111:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801114:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801117:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80111a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80111f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	89 cb                	mov    %ecx,%ebx
  801129:	89 cf                	mov    %ecx,%edi
  80112b:	89 ce                	mov    %ecx,%esi
  80112d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80112f:	85 c0                	test   %eax,%eax
  801131:	7e 28                	jle    80115b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801133:	89 44 24 10          	mov    %eax,0x10(%esp)
  801137:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80113e:	00 
  80113f:	c7 44 24 08 d4 47 80 	movl   $0x8047d4,0x8(%esp)
  801146:	00 
  801147:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114e:	00 
  80114f:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  801156:	e8 81 29 00 00       	call   803adc <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80115b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80115e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801161:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801164:	89 ec                	mov    %ebp,%esp
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	89 1c 24             	mov    %ebx,(%esp)
  801171:	89 74 24 04          	mov    %esi,0x4(%esp)
  801175:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801179:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801183:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801186:	8b 55 08             	mov    0x8(%ebp),%edx
  801189:	89 df                	mov    %ebx,%edi
  80118b:	89 de                	mov    %ebx,%esi
  80118d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80118f:	8b 1c 24             	mov    (%esp),%ebx
  801192:	8b 74 24 04          	mov    0x4(%esp),%esi
  801196:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80119a:	89 ec                	mov    %ebp,%esp
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	89 1c 24             	mov    %ebx,(%esp)
  8011a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ab:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011af:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b4:	b8 11 00 00 00       	mov    $0x11,%eax
  8011b9:	89 d1                	mov    %edx,%ecx
  8011bb:	89 d3                	mov    %edx,%ebx
  8011bd:	89 d7                	mov    %edx,%edi
  8011bf:	89 d6                	mov    %edx,%esi
  8011c1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011c3:	8b 1c 24             	mov    (%esp),%ebx
  8011c6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011ca:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ce:	89 ec                	mov    %ebp,%esp
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	89 1c 24             	mov    %ebx,(%esp)
  8011db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011df:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e8:	b8 12 00 00 00       	mov    $0x12,%eax
  8011ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f3:	89 df                	mov    %ebx,%edi
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8011f9:	8b 1c 24             	mov    (%esp),%ebx
  8011fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801200:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801204:	89 ec                	mov    %ebp,%esp
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	89 1c 24             	mov    %ebx,(%esp)
  801211:	89 74 24 04          	mov    %esi,0x4(%esp)
  801215:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80121e:	b8 13 00 00 00       	mov    $0x13,%eax
  801223:	8b 55 08             	mov    0x8(%ebp),%edx
  801226:	89 cb                	mov    %ecx,%ebx
  801228:	89 cf                	mov    %ecx,%edi
  80122a:	89 ce                	mov    %ecx,%esi
  80122c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80122e:	8b 1c 24             	mov    (%esp),%ebx
  801231:	8b 74 24 04          	mov    0x4(%esp),%esi
  801235:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801239:	89 ec                	mov    %ebp,%esp
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	89 1c 24             	mov    %ebx,(%esp)
  801246:	89 74 24 04          	mov    %esi,0x4(%esp)
  80124a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80124e:	b8 10 00 00 00       	mov    $0x10,%eax
  801253:	8b 75 18             	mov    0x18(%ebp),%esi
  801256:	8b 7d 14             	mov    0x14(%ebp),%edi
  801259:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80125c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125f:	8b 55 08             	mov    0x8(%ebp),%edx
  801262:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801264:	8b 1c 24             	mov    (%esp),%ebx
  801267:	8b 74 24 04          	mov    0x4(%esp),%esi
  80126b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80126f:	89 ec                	mov    %ebp,%esp
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    
	...

00801280 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801283:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801288:	75 11                	jne    80129b <_ZL8fd_validPK2Fd+0x1b>
  80128a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80128f:	76 0a                	jbe    80129b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801291:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801296:	0f 96 c0             	setbe  %al
  801299:	eb 05                	jmp    8012a0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    

008012a2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	53                   	push   %ebx
  8012a6:	83 ec 14             	sub    $0x14,%esp
  8012a9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8012ab:	e8 d0 ff ff ff       	call   801280 <_ZL8fd_validPK2Fd>
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 24                	jne    8012d8 <_ZL9fd_isopenPK2Fd+0x36>
  8012b4:	c7 44 24 0c ff 47 80 	movl   $0x8047ff,0xc(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 08 0c 48 80 	movl   $0x80480c,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 21 48 80 00 	movl   $0x804821,(%esp)
  8012d3:	e8 04 28 00 00       	call   803adc <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	c1 e8 16             	shr    $0x16,%eax
  8012dd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	f6 c2 01             	test   $0x1,%dl
  8012ec:	74 0d                	je     8012fb <_ZL9fd_isopenPK2Fd+0x59>
  8012ee:	c1 eb 0c             	shr    $0xc,%ebx
  8012f1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8012f8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8012fb:	83 c4 14             	add    $0x14,%esp
  8012fe:	5b                   	pop    %ebx
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 08             	sub    $0x8,%esp
  801307:	89 1c 24             	mov    %ebx,(%esp)
  80130a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80130e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801311:	8b 75 0c             	mov    0xc(%ebp),%esi
  801314:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801318:	83 fb 1f             	cmp    $0x1f,%ebx
  80131b:	77 18                	ja     801335 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80131d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801323:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801326:	84 c0                	test   %al,%al
  801328:	74 21                	je     80134b <_Z9fd_lookupiPP2Fdb+0x4a>
  80132a:	89 d8                	mov    %ebx,%eax
  80132c:	e8 71 ff ff ff       	call   8012a2 <_ZL9fd_isopenPK2Fd>
  801331:	84 c0                	test   %al,%al
  801333:	75 16                	jne    80134b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801335:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80133b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801340:	8b 1c 24             	mov    (%esp),%ebx
  801343:	8b 74 24 04          	mov    0x4(%esp),%esi
  801347:	89 ec                	mov    %ebp,%esp
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80134b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb ec                	jmp    801340 <_Z9fd_lookupiPP2Fdb+0x3f>

00801354 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	53                   	push   %ebx
  801358:	83 ec 14             	sub    $0x14,%esp
  80135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80135e:	89 d8                	mov    %ebx,%eax
  801360:	e8 1b ff ff ff       	call   801280 <_ZL8fd_validPK2Fd>
  801365:	84 c0                	test   %al,%al
  801367:	75 24                	jne    80138d <_Z6fd2numP2Fd+0x39>
  801369:	c7 44 24 0c ff 47 80 	movl   $0x8047ff,0xc(%esp)
  801370:	00 
  801371:	c7 44 24 08 0c 48 80 	movl   $0x80480c,0x8(%esp)
  801378:	00 
  801379:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801380:	00 
  801381:	c7 04 24 21 48 80 00 	movl   $0x804821,(%esp)
  801388:	e8 4f 27 00 00       	call   803adc <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80138d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801393:	c1 e8 0c             	shr    $0xc,%eax
}
  801396:	83 c4 14             	add    $0x14,%esp
  801399:	5b                   	pop    %ebx
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	e8 a7 ff ff ff       	call   801354 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8013ad:	05 20 00 0d 00       	add    $0xd0020,%eax
  8013b2:	c1 e0 0c             	shl    $0xc,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	57                   	push   %edi
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
  8013bd:	83 ec 2c             	sub    $0x2c,%esp
  8013c0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8013c8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8013cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d2:	00 
  8013d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d7:	89 1c 24             	mov    %ebx,(%esp)
  8013da:	e8 22 ff ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8013df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e2:	e8 bb fe ff ff       	call   8012a2 <_ZL9fd_isopenPK2Fd>
  8013e7:	84 c0                	test   %al,%al
  8013e9:	75 0c                	jne    8013f7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8013eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ee:	89 07                	mov    %eax,(%edi)
			return 0;
  8013f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f5:	eb 13                	jmp    80140a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013f7:	83 c3 01             	add    $0x1,%ebx
  8013fa:	83 fb 20             	cmp    $0x20,%ebx
  8013fd:	75 cc                	jne    8013cb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013ff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801405:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80140a:	83 c4 2c             	add    $0x2c,%esp
  80140d:	5b                   	pop    %ebx
  80140e:	5e                   	pop    %esi
  80140f:	5f                   	pop    %edi
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	53                   	push   %ebx
  801416:	83 ec 14             	sub    $0x14,%esp
  801419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801424:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  80142a:	75 16                	jne    801442 <_Z10dev_lookupiPP3Dev+0x30>
  80142c:	eb 06                	jmp    801434 <_Z10dev_lookupiPP3Dev+0x22>
  80142e:	39 0a                	cmp    %ecx,(%edx)
  801430:	75 10                	jne    801442 <_Z10dev_lookupiPP3Dev+0x30>
  801432:	eb 05                	jmp    801439 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801434:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801439:	89 13                	mov    %edx,(%ebx)
			return 0;
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
  801440:	eb 35                	jmp    801477 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801442:	83 c0 01             	add    $0x1,%eax
  801445:	8b 14 85 8c 48 80 00 	mov    0x80488c(,%eax,4),%edx
  80144c:	85 d2                	test   %edx,%edx
  80144e:	75 de                	jne    80142e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801450:	a1 00 60 80 00       	mov    0x806000,%eax
  801455:	8b 40 04             	mov    0x4(%eax),%eax
  801458:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80145c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801460:	c7 04 24 48 48 80 00 	movl   $0x804848,(%esp)
  801467:	e8 d2 ee ff ff       	call   80033e <_Z7cprintfPKcz>
	*dev = 0;
  80146c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801472:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801477:	83 c4 14             	add    $0x14,%esp
  80147a:	5b                   	pop    %ebx
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    

0080147d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 20             	sub    $0x20,%esp
  801485:	8b 75 08             	mov    0x8(%ebp),%esi
  801488:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80148c:	89 34 24             	mov    %esi,(%esp)
  80148f:	e8 c0 fe ff ff       	call   801354 <_Z6fd2numP2Fd>
  801494:	0f b6 d3             	movzbl %bl,%edx
  801497:	89 54 24 08          	mov    %edx,0x8(%esp)
  80149b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80149e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014a2:	89 04 24             	mov    %eax,(%esp)
  8014a5:	e8 57 fe ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 05                	js     8014b3 <_Z8fd_closeP2Fdb+0x36>
  8014ae:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014b1:	74 0c                	je     8014bf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8014b3:	80 fb 01             	cmp    $0x1,%bl
  8014b6:	19 db                	sbb    %ebx,%ebx
  8014b8:	f7 d3                	not    %ebx
  8014ba:	83 e3 fd             	and    $0xfffffffd,%ebx
  8014bd:	eb 3d                	jmp    8014fc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c6:	8b 06                	mov    (%esi),%eax
  8014c8:	89 04 24             	mov    %eax,(%esp)
  8014cb:	e8 42 ff ff ff       	call   801412 <_Z10dev_lookupiPP3Dev>
  8014d0:	89 c3                	mov    %eax,%ebx
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 16                	js     8014ec <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014dc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	74 07                	je     8014ec <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8014e5:	89 34 24             	mov    %esi,(%esp)
  8014e8:	ff d0                	call   *%eax
  8014ea:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f7:	e8 01 fa ff ff       	call   800efd <_Z14sys_page_unmapiPv>
	return r;
}
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	83 c4 20             	add    $0x20,%esp
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80150b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801512:	00 
  801513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	89 04 24             	mov    %eax,(%esp)
  801520:	e8 dc fd ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  801525:	85 c0                	test   %eax,%eax
  801527:	78 13                	js     80153c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801529:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801530:	00 
  801531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 41 ff ff ff       	call   80147d <_Z8fd_closeP2Fdb>
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <_Z9close_allv>:

void
close_all(void)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	53                   	push   %ebx
  801542:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801545:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80154a:	89 1c 24             	mov    %ebx,(%esp)
  80154d:	e8 b3 ff ff ff       	call   801505 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801552:	83 c3 01             	add    $0x1,%ebx
  801555:	83 fb 20             	cmp    $0x20,%ebx
  801558:	75 f0                	jne    80154a <_Z9close_allv+0xc>
		close(i);
}
  80155a:	83 c4 14             	add    $0x14,%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 48             	sub    $0x48,%esp
  801566:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801569:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80156c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80156f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801572:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801579:	00 
  80157a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80157d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 75 fd ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  80158c:	89 c3                	mov    %eax,%ebx
  80158e:	85 c0                	test   %eax,%eax
  801590:	0f 88 ce 00 00 00    	js     801664 <_Z3dupii+0x104>
  801596:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80159d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80159e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015a1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8015a5:	89 34 24             	mov    %esi,(%esp)
  8015a8:	e8 54 fd ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8015ad:	89 c3                	mov    %eax,%ebx
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	0f 89 bc 00 00 00    	jns    801673 <_Z3dupii+0x113>
  8015b7:	e9 a8 00 00 00       	jmp    801664 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	c1 e8 0c             	shr    $0xc,%eax
  8015c1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8015c8:	f6 c2 01             	test   $0x1,%dl
  8015cb:	74 32                	je     8015ff <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015cd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8015d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015e8:	00 
  8015e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f4:	e8 a6 f8 ff ff       	call   800e9f <_Z12sys_page_mapiPviS_i>
  8015f9:	89 c3                	mov    %eax,%ebx
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 3e                	js     80163d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801602:	89 c2                	mov    %eax,%edx
  801604:	c1 ea 0c             	shr    $0xc,%edx
  801607:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80160e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801614:	89 54 24 10          	mov    %edx,0x10(%esp)
  801618:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80161b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80161f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801626:	00 
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801632:	e8 68 f8 ff ff       	call   800e9f <_Z12sys_page_mapiPviS_i>
  801637:	89 c3                	mov    %eax,%ebx
  801639:	85 c0                	test   %eax,%eax
  80163b:	79 25                	jns    801662 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80163d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801640:	89 44 24 04          	mov    %eax,0x4(%esp)
  801644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164b:	e8 ad f8 ff ff       	call   800efd <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801650:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801654:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165b:	e8 9d f8 ff ff       	call   800efd <_Z14sys_page_unmapiPv>
	return r;
  801660:	eb 02                	jmp    801664 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801662:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801664:	89 d8                	mov    %ebx,%eax
  801666:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801669:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80166c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80166f:	89 ec                	mov    %ebp,%esp
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801673:	89 34 24             	mov    %esi,(%esp)
  801676:	e8 8a fe ff ff       	call   801505 <_Z5closei>

	ova = fd2data(oldfd);
  80167b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167e:	89 04 24             	mov    %eax,(%esp)
  801681:	e8 16 fd ff ff       	call   80139c <_Z7fd2dataP2Fd>
  801686:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168b:	89 04 24             	mov    %eax,(%esp)
  80168e:	e8 09 fd ff ff       	call   80139c <_Z7fd2dataP2Fd>
  801693:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801695:	89 d8                	mov    %ebx,%eax
  801697:	c1 e8 16             	shr    $0x16,%eax
  80169a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8016a1:	a8 01                	test   $0x1,%al
  8016a3:	0f 85 13 ff ff ff    	jne    8015bc <_Z3dupii+0x5c>
  8016a9:	e9 51 ff ff ff       	jmp    8015ff <_Z3dupii+0x9f>

008016ae <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 24             	sub    $0x24,%esp
  8016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016bf:	00 
  8016c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c7:	89 1c 24             	mov    %ebx,(%esp)
  8016ca:	e8 32 fc ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 5f                	js     801732 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016dd:	8b 00                	mov    (%eax),%eax
  8016df:	89 04 24             	mov    %eax,(%esp)
  8016e2:	e8 2b fd ff ff       	call   801412 <_Z10dev_lookupiPP3Dev>
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	79 4d                	jns    801738 <_Z4readiPvj+0x8a>
  8016eb:	eb 45                	jmp    801732 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ed:	a1 00 60 80 00       	mov    0x806000,%eax
  8016f2:	8b 40 04             	mov    0x4(%eax),%eax
  8016f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fd:	c7 04 24 2a 48 80 00 	movl   $0x80482a,(%esp)
  801704:	e8 35 ec ff ff       	call   80033e <_Z7cprintfPKcz>
		return -E_INVAL;
  801709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170e:	eb 22                	jmp    801732 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801713:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801716:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80171b:	85 d2                	test   %edx,%edx
  80171d:	74 13                	je     801732 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80171f:	8b 45 10             	mov    0x10(%ebp),%eax
  801722:	89 44 24 08          	mov    %eax,0x8(%esp)
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172d:	89 0c 24             	mov    %ecx,(%esp)
  801730:	ff d2                	call   *%edx
}
  801732:	83 c4 24             	add    $0x24,%esp
  801735:	5b                   	pop    %ebx
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801738:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80173b:	8b 41 08             	mov    0x8(%ecx),%eax
  80173e:	83 e0 03             	and    $0x3,%eax
  801741:	83 f8 01             	cmp    $0x1,%eax
  801744:	75 ca                	jne    801710 <_Z4readiPvj+0x62>
  801746:	eb a5                	jmp    8016ed <_Z4readiPvj+0x3f>

00801748 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	57                   	push   %edi
  80174c:	56                   	push   %esi
  80174d:	53                   	push   %ebx
  80174e:	83 ec 1c             	sub    $0x1c,%esp
  801751:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801754:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801757:	85 f6                	test   %esi,%esi
  801759:	74 2f                	je     80178a <_Z5readniPvj+0x42>
  80175b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801760:	89 f0                	mov    %esi,%eax
  801762:	29 d8                	sub    %ebx,%eax
  801764:	89 44 24 08          	mov    %eax,0x8(%esp)
  801768:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80176b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	89 04 24             	mov    %eax,(%esp)
  801775:	e8 34 ff ff ff       	call   8016ae <_Z4readiPvj>
		if (m < 0)
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 13                	js     801791 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80177e:	85 c0                	test   %eax,%eax
  801780:	74 0d                	je     80178f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801782:	01 c3                	add    %eax,%ebx
  801784:	39 de                	cmp    %ebx,%esi
  801786:	77 d8                	ja     801760 <_Z5readniPvj+0x18>
  801788:	eb 05                	jmp    80178f <_Z5readniPvj+0x47>
  80178a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80178f:	89 d8                	mov    %ebx,%eax
}
  801791:	83 c4 1c             	add    $0x1c,%esp
  801794:	5b                   	pop    %ebx
  801795:	5e                   	pop    %esi
  801796:	5f                   	pop    %edi
  801797:	5d                   	pop    %ebp
  801798:	c3                   	ret    

00801799 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80179f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017a6:	00 
  8017a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	89 04 24             	mov    %eax,(%esp)
  8017b4:	e8 48 fb ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 3c                	js     8017f9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017c7:	8b 00                	mov    (%eax),%eax
  8017c9:	89 04 24             	mov    %eax,(%esp)
  8017cc:	e8 41 fc ff ff       	call   801412 <_Z10dev_lookupiPP3Dev>
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	79 26                	jns    8017fb <_Z5writeiPKvj+0x62>
  8017d5:	eb 22                	jmp    8017f9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017da:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8017dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017e2:	85 c9                	test   %ecx,%ecx
  8017e4:	74 13                	je     8017f9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f4:	89 14 24             	mov    %edx,(%esp)
  8017f7:	ff d1                	call   *%ecx
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8017fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  8017fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801803:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801807:	74 f0                	je     8017f9 <_Z5writeiPKvj+0x60>
  801809:	eb cc                	jmp    8017d7 <_Z5writeiPKvj+0x3e>

0080180b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801811:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801818:	00 
  801819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	89 04 24             	mov    %eax,(%esp)
  801826:	e8 d6 fa ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 0e                	js     80183d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 24             	sub    $0x24,%esp
  801846:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801849:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801850:	00 
  801851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801854:	89 44 24 04          	mov    %eax,0x4(%esp)
  801858:	89 1c 24             	mov    %ebx,(%esp)
  80185b:	e8 a1 fa ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  801860:	85 c0                	test   %eax,%eax
  801862:	78 58                	js     8018bc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80186e:	8b 00                	mov    (%eax),%eax
  801870:	89 04 24             	mov    %eax,(%esp)
  801873:	e8 9a fb ff ff       	call   801412 <_Z10dev_lookupiPP3Dev>
  801878:	85 c0                	test   %eax,%eax
  80187a:	79 46                	jns    8018c2 <_Z9ftruncateii+0x83>
  80187c:	eb 3e                	jmp    8018bc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80187e:	a1 00 60 80 00       	mov    0x806000,%eax
  801883:	8b 40 04             	mov    0x4(%eax),%eax
  801886:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80188a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188e:	c7 04 24 68 48 80 00 	movl   $0x804868,(%esp)
  801895:	e8 a4 ea ff ff       	call   80033e <_Z7cprintfPKcz>
		return -E_INVAL;
  80189a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189f:	eb 1b                	jmp    8018bc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8018a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018ac:	85 d2                	test   %edx,%edx
  8018ae:	74 0c                	je     8018bc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b7:	89 0c 24             	mov    %ecx,(%esp)
  8018ba:	ff d2                	call   *%edx
}
  8018bc:	83 c4 24             	add    $0x24,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8018c9:	75 d6                	jne    8018a1 <_Z9ftruncateii+0x62>
  8018cb:	eb b1                	jmp    80187e <_Z9ftruncateii+0x3f>

008018cd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	53                   	push   %ebx
  8018d1:	83 ec 24             	sub    $0x24,%esp
  8018d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018de:	00 
  8018df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	89 04 24             	mov    %eax,(%esp)
  8018ec:	e8 10 fa ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 3e                	js     801933 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	89 04 24             	mov    %eax,(%esp)
  801904:	e8 09 fb ff ff       	call   801412 <_Z10dev_lookupiPP3Dev>
  801909:	85 c0                	test   %eax,%eax
  80190b:	79 2c                	jns    801939 <_Z5fstatiP4Stat+0x6c>
  80190d:	eb 24                	jmp    801933 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80190f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801912:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801919:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801920:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801926:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192d:	89 04 24             	mov    %eax,(%esp)
  801930:	ff 52 14             	call   *0x14(%edx)
}
  801933:	83 c4 24             	add    $0x24,%esp
  801936:	5b                   	pop    %ebx
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801939:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80193c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801941:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801945:	75 c8                	jne    80190f <_Z5fstatiP4Stat+0x42>
  801947:	eb ea                	jmp    801933 <_Z5fstatiP4Stat+0x66>

00801949 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 18             	sub    $0x18,%esp
  80194f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801952:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801955:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80195c:	00 
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 d6 09 00 00       	call   80233e <_Z4openPKci>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 1b                	js     801989 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	89 44 24 04          	mov    %eax,0x4(%esp)
  801975:	89 1c 24             	mov    %ebx,(%esp)
  801978:	e8 50 ff ff ff       	call   8018cd <_Z5fstatiP4Stat>
  80197d:	89 c6                	mov    %eax,%esi
	close(fd);
  80197f:	89 1c 24             	mov    %ebx,(%esp)
  801982:	e8 7e fb ff ff       	call   801505 <_Z5closei>
	return r;
  801987:	89 f3                	mov    %esi,%ebx
}
  801989:	89 d8                	mov    %ebx,%eax
  80198b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80198e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801991:	89 ec                	mov    %ebp,%esp
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    
	...

008019a0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8019a8:	85 d2                	test   %edx,%edx
  8019aa:	78 33                	js     8019df <_ZL10inode_dataP5Inodei+0x3f>
  8019ac:	3b 50 08             	cmp    0x8(%eax),%edx
  8019af:	7d 2e                	jge    8019df <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8019b1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8019b7:	85 d2                	test   %edx,%edx
  8019b9:	0f 49 ca             	cmovns %edx,%ecx
  8019bc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8019bf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8019c3:	c1 e1 0c             	shl    $0xc,%ecx
  8019c6:	89 d0                	mov    %edx,%eax
  8019c8:	c1 f8 1f             	sar    $0x1f,%eax
  8019cb:	c1 e8 14             	shr    $0x14,%eax
  8019ce:	01 c2                	add    %eax,%edx
  8019d0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8019d6:	29 c2                	sub    %eax,%edx
  8019d8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8019df:	89 c8                	mov    %ecx,%eax
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8019e6:	8b 48 08             	mov    0x8(%eax),%ecx
  8019e9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  8019f1:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  8019f8:	50 80 00 
}
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    

008019fd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a03:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	74 08                	je     801a15 <_ZL9get_inodei+0x18>
  801a0d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801a13:	7e 20                	jle    801a35 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801a15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a19:	c7 44 24 08 a0 48 80 	movl   $0x8048a0,0x8(%esp)
  801a20:	00 
  801a21:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801a28:	00 
  801a29:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  801a30:	e8 a7 20 00 00       	call   803adc <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a35:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801a3b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a41:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801a47:	85 d2                	test   %edx,%edx
  801a49:	0f 48 d1             	cmovs  %ecx,%edx
  801a4c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801a4f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801a56:	c1 e0 0c             	shl    $0xc,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801a63:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801a69:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801a6c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801a72:	76 20                	jbe    801a94 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801a74:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a78:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  801a7f:	00 
  801a80:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801a87:	00 
  801a88:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  801a8f:	e8 48 20 00 00       	call   803adc <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801a94:	83 fe 01             	cmp    $0x1,%esi
  801a97:	7e 08                	jle    801aa1 <_ZL10bcache_ipcPvi+0x46>
  801a99:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801a9f:	7d 12                	jge    801ab3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801aa1:	89 f3                	mov    %esi,%ebx
  801aa3:	c1 e3 04             	shl    $0x4,%ebx
  801aa6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801aa8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801aae:	c1 e6 0c             	shl    $0xc,%esi
  801ab1:	eb 20                	jmp    801ad3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801ab3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ab7:	c7 44 24 08 0c 49 80 	movl   $0x80490c,0x8(%esp)
  801abe:	00 
  801abf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801ac6:	00 
  801ac7:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  801ace:	e8 09 20 00 00       	call   803adc <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ad3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ada:	00 
  801adb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ae2:	00 
  801ae3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801aee:	e8 3c 22 00 00       	call   803d2f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801af3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801afa:	00 
  801afb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b06:	e8 95 21 00 00       	call   803ca0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801b0b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801b0e:	74 c3                	je     801ad3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5d                   	pop    %ebp
  801b16:	c3                   	ret    

00801b17 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 28             	sub    $0x28,%esp
  801b1d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b20:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b23:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b26:	89 c7                	mov    %eax,%edi
  801b28:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801b2a:	c7 04 24 bd 1d 80 00 	movl   $0x801dbd,(%esp)
  801b31:	e8 75 20 00 00       	call   803bab <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801b36:	89 f8                	mov    %edi,%eax
  801b38:	e8 c0 fe ff ff       	call   8019fd <_ZL9get_inodei>
  801b3d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801b3f:	ba 02 00 00 00       	mov    $0x2,%edx
  801b44:	e8 12 ff ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	79 08                	jns    801b55 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801b4d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801b53:	eb 2e                	jmp    801b83 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801b55:	85 c0                	test   %eax,%eax
  801b57:	75 1c                	jne    801b75 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801b59:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801b5f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801b66:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801b69:	ba 06 00 00 00       	mov    $0x6,%edx
  801b6e:	89 d8                	mov    %ebx,%eax
  801b70:	e8 e6 fe ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801b75:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801b7c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b83:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b86:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b89:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b8c:	89 ec                	mov    %ebp,%esp
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	57                   	push   %edi
  801b94:	56                   	push   %esi
  801b95:	53                   	push   %ebx
  801b96:	83 ec 2c             	sub    $0x2c,%esp
  801b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b9c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801b9f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801ba4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801baa:	0f 87 3d 01 00 00    	ja     801ced <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801bb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bb3:	8b 42 08             	mov    0x8(%edx),%eax
  801bb6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	0f 49 f0             	cmovns %eax,%esi
  801bc1:	c1 fe 0c             	sar    $0xc,%esi
  801bc4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801bc6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801bc9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801bcf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801bd2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801bd5:	0f 82 a6 00 00 00    	jb     801c81 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801bdb:	39 fe                	cmp    %edi,%esi
  801bdd:	0f 8d f2 00 00 00    	jge    801cd5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801be3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801be7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801bea:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801bed:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801bf0:	83 3e 00             	cmpl   $0x0,(%esi)
  801bf3:	75 77                	jne    801c6c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801bf5:	ba 02 00 00 00       	mov    $0x2,%edx
  801bfa:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801bff:	e8 57 fe ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c04:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801c0a:	83 f9 02             	cmp    $0x2,%ecx
  801c0d:	7e 43                	jle    801c52 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801c0f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c14:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801c19:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801c20:	74 29                	je     801c4b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801c22:	e9 ce 00 00 00       	jmp    801cf5 <_ZL14inode_set_sizeP5Inodej+0x165>
  801c27:	89 c7                	mov    %eax,%edi
  801c29:	0f b6 10             	movzbl (%eax),%edx
  801c2c:	83 c0 01             	add    $0x1,%eax
  801c2f:	84 d2                	test   %dl,%dl
  801c31:	74 18                	je     801c4b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801c33:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c36:	ba 05 00 00 00       	mov    $0x5,%edx
  801c3b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c40:	e8 16 fe ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801c45:	85 db                	test   %ebx,%ebx
  801c47:	79 1e                	jns    801c67 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801c49:	eb 07                	jmp    801c52 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c4b:	83 c3 01             	add    $0x1,%ebx
  801c4e:	39 d9                	cmp    %ebx,%ecx
  801c50:	7f d5                	jg     801c27 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c55:	8b 50 08             	mov    0x8(%eax),%edx
  801c58:	e8 33 ff ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801c5d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c62:	e9 86 00 00 00       	jmp    801ced <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801c67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801c6c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801c70:	83 c6 04             	add    $0x4,%esi
  801c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c76:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801c79:	0f 8f 6e ff ff ff    	jg     801bed <_ZL14inode_set_sizeP5Inodej+0x5d>
  801c7f:	eb 54                	jmp    801cd5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801c81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c84:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801c89:	83 f8 01             	cmp    $0x1,%eax
  801c8c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c8f:	ba 02 00 00 00       	mov    $0x2,%edx
  801c94:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c99:	e8 bd fd ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801c9e:	39 f7                	cmp    %esi,%edi
  801ca0:	7d 24                	jge    801cc6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801ca2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ca5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801ca9:	8b 10                	mov    (%eax),%edx
  801cab:	85 d2                	test   %edx,%edx
  801cad:	74 0d                	je     801cbc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801caf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801cbc:	83 eb 01             	sub    $0x1,%ebx
  801cbf:	83 e8 04             	sub    $0x4,%eax
  801cc2:	39 fb                	cmp    %edi,%ebx
  801cc4:	75 e3                	jne    801ca9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cc6:	ba 05 00 00 00       	mov    $0x5,%edx
  801ccb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801cd0:	e8 86 fd ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801cd5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cdb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801cde:	ba 04 00 00 00       	mov    $0x4,%edx
  801ce3:	e8 73 fd ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	return 0;
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ced:	83 c4 2c             	add    $0x2c,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801cf5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cfc:	ba 05 00 00 00       	mov    $0x5,%edx
  801d01:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d06:	e8 50 fd ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801d0b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801d10:	e9 52 ff ff ff       	jmp    801c67 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801d15 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	53                   	push   %ebx
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801d1e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801d24:	83 e8 01             	sub    $0x1,%eax
  801d27:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801d2d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801d31:	75 40                	jne    801d73 <_ZL11inode_closeP5Inode+0x5e>
  801d33:	85 c0                	test   %eax,%eax
  801d35:	75 3c                	jne    801d73 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d37:	ba 02 00 00 00       	mov    $0x2,%edx
  801d3c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d41:	e8 15 fd ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801d4b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801d4f:	85 d2                	test   %edx,%edx
  801d51:	74 07                	je     801d5a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801d53:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801d5a:	83 c0 01             	add    $0x1,%eax
  801d5d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801d62:	75 e7                	jne    801d4b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d64:	ba 05 00 00 00       	mov    $0x5,%edx
  801d69:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d6e:	e8 e8 fc ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801d73:	ba 03 00 00 00       	mov    $0x3,%edx
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	e8 dc fc ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
}
  801d7f:	83 c4 04             	add    $0x4,%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
  801d89:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d95:	e8 7d fd ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  801d9a:	89 c3                	mov    %eax,%ebx
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 15                	js     801db5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	e8 e5 fd ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
  801dab:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	e8 60 ff ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
	return r;
}
  801db5:	89 d8                	mov    %ebx,%eax
  801db7:	83 c4 14             	add    $0x14,%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	53                   	push   %ebx
  801dc1:	83 ec 14             	sub    $0x14,%esp
  801dc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801dc7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801dc9:	89 c2                	mov    %eax,%edx
  801dcb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801dd1:	78 32                	js     801e05 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	e8 7e fc ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	74 1c                	je     801dfd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801de1:	c7 44 24 08 c1 48 80 	movl   $0x8048c1,0x8(%esp)
  801de8:	00 
  801de9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801df0:	00 
  801df1:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  801df8:	e8 df 1c 00 00       	call   803adc <_Z6_panicPKciS0_z>
    resume(utf);
  801dfd:	89 1c 24             	mov    %ebx,(%esp)
  801e00:	e8 7b 1e 00 00       	call   803c80 <resume>
}
  801e05:	83 c4 14             	add    $0x14,%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    

00801e0b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 28             	sub    $0x28,%esp
  801e11:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e14:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e1a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e1d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e20:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e23:	e8 ef fc ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 26                	js     801e52 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801e2c:	83 c3 10             	add    $0x10,%ebx
  801e2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e33:	89 34 24             	mov    %esi,(%esp)
  801e36:	e8 1f eb ff ff       	call   80095a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801e3b:	89 f2                	mov    %esi,%edx
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	e8 9e fb ff ff       	call   8019e3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	e8 c8 fe ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
	return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e55:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e58:	89 ec                	mov    %ebp,%esp
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    

00801e5c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	53                   	push   %ebx
  801e60:	83 ec 24             	sub    $0x24,%esp
  801e63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e66:	89 1c 24             	mov    %ebx,(%esp)
  801e69:	e8 9e 15 00 00       	call   80340c <_Z7pagerefPv>
  801e6e:	89 c2                	mov    %eax,%edx
        return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e75:	83 fa 01             	cmp    $0x1,%edx
  801e78:	7f 1e                	jg     801e98 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e7a:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e7d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e80:	e8 92 fc ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 0f                	js     801e98 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801e93:	e8 7d fe ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
}
  801e98:	83 c4 24             	add    $0x24,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 3c             	sub    $0x3c,%esp
  801ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801eaa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801ead:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801eb3:	8b 43 0c             	mov    0xc(%ebx),%eax
  801eb6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801eb9:	e8 59 fc ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	0f 88 8c 00 00 00    	js     801f52 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801ec6:	8b 53 04             	mov    0x4(%ebx),%edx
  801ec9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801ecf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801ed5:	29 d7                	sub    %edx,%edi
  801ed7:	39 f7                	cmp    %esi,%edi
  801ed9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801edc:	85 ff                	test   %edi,%edi
  801ede:	74 16                	je     801ef6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801ee0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ee6:	3b 50 08             	cmp    0x8(%eax),%edx
  801ee9:	76 6f                	jbe    801f5a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801eeb:	e8 a0 fc ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	79 66                	jns    801f5a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801ef4:	eb 4e                	jmp    801f44 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801ef6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801efc:	76 24                	jbe    801f22 <_ZL13devfile_writeP2FdPKvj+0x84>
  801efe:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f00:	8b 53 04             	mov    0x4(%ebx),%edx
  801f03:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f0c:	3b 50 08             	cmp    0x8(%eax),%edx
  801f0f:	0f 86 83 00 00 00    	jbe    801f98 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801f15:	e8 76 fc ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	79 7a                	jns    801f98 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801f1e:	66 90                	xchg   %ax,%ax
  801f20:	eb 22                	jmp    801f44 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801f22:	85 f6                	test   %esi,%esi
  801f24:	74 1e                	je     801f44 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f26:	89 f2                	mov    %esi,%edx
  801f28:	03 53 04             	add    0x4(%ebx),%edx
  801f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2e:	3b 50 08             	cmp    0x8(%eax),%edx
  801f31:	0f 86 b8 00 00 00    	jbe    801fef <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801f37:	e8 54 fc ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	0f 89 ab 00 00 00    	jns    801fef <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f47:	e8 c9 fd ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801f4c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f4f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801f52:	83 c4 3c             	add    $0x3c,%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801f5a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f5c:	8b 53 04             	mov    0x4(%ebx),%edx
  801f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f62:	e8 39 fa ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  801f67:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801f6a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f75:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 f7 eb ff ff       	call   800b77 <memcpy>
        fd->fd_offset += n2;
  801f80:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801f83:	ba 04 00 00 00       	mov    $0x4,%edx
  801f88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f8b:	e8 cb fa ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801f90:	01 7d 0c             	add    %edi,0xc(%ebp)
  801f93:	e9 5e ff ff ff       	jmp    801ef6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f98:	8b 53 04             	mov    0x4(%ebx),%edx
  801f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9e:	e8 fd f9 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  801fa3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801fa5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fac:	00 
  801fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb4:	89 34 24             	mov    %esi,(%esp)
  801fb7:	e8 bb eb ff ff       	call   800b77 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801fbc:	ba 04 00 00 00       	mov    $0x4,%edx
  801fc1:	89 f0                	mov    %esi,%eax
  801fc3:	e8 93 fa ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801fc8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801fce:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801fd5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801fdc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801fe2:	0f 87 18 ff ff ff    	ja     801f00 <_ZL13devfile_writeP2FdPKvj+0x62>
  801fe8:	89 fe                	mov    %edi,%esi
  801fea:	e9 33 ff ff ff       	jmp    801f22 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801fef:	8b 53 04             	mov    0x4(%ebx),%edx
  801ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff5:	e8 a6 f9 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  801ffa:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  801ffc:	89 74 24 08          	mov    %esi,0x8(%esp)
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	89 3c 24             	mov    %edi,(%esp)
  80200a:	e8 68 eb ff ff       	call   800b77 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80200f:	ba 04 00 00 00       	mov    $0x4,%edx
  802014:	89 f8                	mov    %edi,%eax
  802016:	e8 40 fa ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80201b:	01 73 04             	add    %esi,0x4(%ebx)
  80201e:	e9 21 ff ff ff       	jmp    801f44 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802023 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	57                   	push   %edi
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	83 ec 3c             	sub    $0x3c,%esp
  80202c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80202f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802032:	8b 43 04             	mov    0x4(%ebx),%eax
  802035:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802038:	8b 43 0c             	mov    0xc(%ebx),%eax
  80203b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80203e:	e8 d4 fa ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  802043:	85 c0                	test   %eax,%eax
  802045:	0f 88 d3 00 00 00    	js     80211e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80204b:	8b 73 04             	mov    0x4(%ebx),%esi
  80204e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802051:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802054:	8b 50 08             	mov    0x8(%eax),%edx
  802057:	29 f2                	sub    %esi,%edx
  802059:	3b 48 08             	cmp    0x8(%eax),%ecx
  80205c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80205f:	89 f2                	mov    %esi,%edx
  802061:	e8 3a f9 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  802066:	85 c0                	test   %eax,%eax
  802068:	0f 84 a2 00 00 00    	je     802110 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80206e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802074:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80207a:	29 f2                	sub    %esi,%edx
  80207c:	39 d7                	cmp    %edx,%edi
  80207e:	0f 46 d7             	cmovbe %edi,%edx
  802081:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802084:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802086:	01 d6                	add    %edx,%esi
  802088:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80208b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80208f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802093:	8b 45 0c             	mov    0xc(%ebp),%eax
  802096:	89 04 24             	mov    %eax,(%esp)
  802099:	e8 d9 ea ff ff       	call   800b77 <memcpy>
    buf = (void *)((char *)buf + n2);
  80209e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8020a4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020aa:	76 3e                	jbe    8020ea <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020ac:	8b 53 04             	mov    0x4(%ebx),%edx
  8020af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b2:	e8 e9 f8 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	74 55                	je     802110 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8020bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020c2:	00 
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	89 34 24             	mov    %esi,(%esp)
  8020ca:	e8 a8 ea ff ff       	call   800b77 <memcpy>
        n -= PGSIZE;
  8020cf:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8020d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8020db:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8020e2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020e8:	77 c2                	ja     8020ac <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8020ea:	85 ff                	test   %edi,%edi
  8020ec:	74 22                	je     802110 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020ee:	8b 53 04             	mov    0x4(%ebx),%edx
  8020f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f4:	e8 a7 f8 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	74 13                	je     802110 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8020fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802101:	89 44 24 04          	mov    %eax,0x4(%esp)
  802105:	89 34 24             	mov    %esi,(%esp)
  802108:	e8 6a ea ff ff       	call   800b77 <memcpy>
        fd->fd_offset += n;
  80210d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802113:	e8 fd fb ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802118:	8b 43 04             	mov    0x4(%ebx),%eax
  80211b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80211e:	83 c4 3c             	add    $0x3c,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	57                   	push   %edi
  80212a:	56                   	push   %esi
  80212b:	53                   	push   %ebx
  80212c:	83 ec 4c             	sub    $0x4c,%esp
  80212f:	89 c6                	mov    %eax,%esi
  802131:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802134:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802137:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80213d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802146:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802149:	b8 01 00 00 00       	mov    $0x1,%eax
  80214e:	e8 c4 f9 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  802153:	89 c7                	mov    %eax,%edi
  802155:	85 c0                	test   %eax,%eax
  802157:	0f 88 cd 01 00 00    	js     80232a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80215d:	89 f3                	mov    %esi,%ebx
  80215f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802162:	75 08                	jne    80216c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802164:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802167:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80216a:	74 f8                	je     802164 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80216c:	0f b6 03             	movzbl (%ebx),%eax
  80216f:	3c 2f                	cmp    $0x2f,%al
  802171:	74 16                	je     802189 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802173:	84 c0                	test   %al,%al
  802175:	74 12                	je     802189 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802177:	89 da                	mov    %ebx,%edx
		++path;
  802179:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80217c:	0f b6 02             	movzbl (%edx),%eax
  80217f:	3c 2f                	cmp    $0x2f,%al
  802181:	74 08                	je     80218b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802183:	84 c0                	test   %al,%al
  802185:	75 f2                	jne    802179 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802187:	eb 02                	jmp    80218b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802189:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80218b:	89 d0                	mov    %edx,%eax
  80218d:	29 d8                	sub    %ebx,%eax
  80218f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802192:	0f b6 02             	movzbl (%edx),%eax
  802195:	89 d6                	mov    %edx,%esi
  802197:	3c 2f                	cmp    $0x2f,%al
  802199:	75 0a                	jne    8021a5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80219b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80219e:	0f b6 06             	movzbl (%esi),%eax
  8021a1:	3c 2f                	cmp    $0x2f,%al
  8021a3:	74 f6                	je     80219b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8021a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021a9:	75 1b                	jne    8021c6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8021ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021b1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8021b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021b6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8021bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c1:	e9 64 01 00 00       	jmp    80232a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021c6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8021ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ce:	74 06                	je     8021d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8021d0:	84 c0                	test   %al,%al
  8021d2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021d9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8021dc:	83 3a 02             	cmpl   $0x2,(%edx)
  8021df:	0f 85 f4 00 00 00    	jne    8022d9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8021e5:	89 d0                	mov    %edx,%eax
  8021e7:	8b 52 08             	mov    0x8(%edx),%edx
  8021ea:	85 d2                	test   %edx,%edx
  8021ec:	7e 78                	jle    802266 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8021ee:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8021f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fa:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8021fd:	89 fb                	mov    %edi,%ebx
  8021ff:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802202:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802204:	89 da                	mov    %ebx,%edx
  802206:	89 f0                	mov    %esi,%eax
  802208:	e8 93 f7 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  80220d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80220f:	83 38 00             	cmpl   $0x0,(%eax)
  802212:	74 26                	je     80223a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802214:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802217:	3b 50 04             	cmp    0x4(%eax),%edx
  80221a:	75 33                	jne    80224f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80221c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802220:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	8d 47 08             	lea    0x8(%edi),%eax
  80222a:	89 04 24             	mov    %eax,(%esp)
  80222d:	e8 86 e9 ff ff       	call   800bb8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802232:	85 c0                	test   %eax,%eax
  802234:	0f 84 fa 00 00 00    	je     802334 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80223a:	83 3f 00             	cmpl   $0x0,(%edi)
  80223d:	75 10                	jne    80224f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80223f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802243:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802246:	84 c0                	test   %al,%al
  802248:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80224c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80224f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802255:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802257:	8b 56 08             	mov    0x8(%esi),%edx
  80225a:	39 d0                	cmp    %edx,%eax
  80225c:	7c a6                	jl     802204 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80225e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802261:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802264:	eb 07                	jmp    80226d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802266:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80226d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802271:	74 6d                	je     8022e0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802273:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802277:	75 24                	jne    80229d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802279:	83 ea 80             	sub    $0xffffff80,%edx
  80227c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80227f:	e8 0c f9 ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802284:	85 c0                	test   %eax,%eax
  802286:	0f 88 90 00 00 00    	js     80231c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80228c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228f:	8b 50 08             	mov    0x8(%eax),%edx
  802292:	83 c2 80             	add    $0xffffff80,%edx
  802295:	e8 06 f7 ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  80229a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80229d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8022a4:	00 
  8022a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022ac:	00 
  8022ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8022b0:	89 14 24             	mov    %edx,(%esp)
  8022b3:	e8 e9 e7 ff ff       	call   800aa1 <memset>
	empty->de_namelen = namelen;
  8022b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8022c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c9:	83 c0 08             	add    $0x8,%eax
  8022cc:	89 04 24             	mov    %eax,(%esp)
  8022cf:	e8 a3 e8 ff ff       	call   800b77 <memcpy>
	*de_store = empty;
  8022d4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8022d7:	eb 5e                	jmp    802337 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8022d9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8022de:	eb 42                	jmp    802322 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8022e0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8022e5:	eb 3b                	jmp    802322 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8022e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ea:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8022ed:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8022ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022f2:	89 38                	mov    %edi,(%eax)
			return 0;
  8022f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f9:	eb 2f                	jmp    80232a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8022fb:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8022fe:	8b 07                	mov    (%edi),%eax
  802300:	e8 12 f8 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  802305:	85 c0                	test   %eax,%eax
  802307:	78 17                	js     802320 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230c:	e8 04 fa ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802314:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802317:	e9 41 fe ff ff       	jmp    80215d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80231c:	89 c7                	mov    %eax,%edi
  80231e:	eb 02                	jmp    802322 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802320:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802325:	e8 eb f9 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
	return r;
}
  80232a:	89 f8                	mov    %edi,%eax
  80232c:	83 c4 4c             	add    $0x4c,%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5f                   	pop    %edi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    
  802334:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802337:	80 3e 00             	cmpb   $0x0,(%esi)
  80233a:	75 bf                	jne    8022fb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80233c:	eb a9                	jmp    8022e7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080233e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 3c             	sub    $0x3c,%esp
  802347:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80234a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80234d:	89 04 24             	mov    %eax,(%esp)
  802350:	e8 62 f0 ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  802355:	89 c3                	mov    %eax,%ebx
  802357:	85 c0                	test   %eax,%eax
  802359:	0f 88 16 02 00 00    	js     802575 <_Z4openPKci+0x237>
  80235f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802366:	00 
  802367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802375:	e8 c6 ea ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  80237a:	89 c3                	mov    %eax,%ebx
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
  802381:	85 db                	test   %ebx,%ebx
  802383:	0f 88 ec 01 00 00    	js     802575 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802389:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80238d:	0f 84 ec 01 00 00    	je     80257f <_Z4openPKci+0x241>
  802393:	83 c0 01             	add    $0x1,%eax
  802396:	83 f8 78             	cmp    $0x78,%eax
  802399:	75 ee                	jne    802389 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80239b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8023a0:	e9 b9 01 00 00       	jmp    80255e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8023a5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023a8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8023ae:	89 3c 24             	mov    %edi,(%esp)
  8023b1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8023b4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	e8 68 fd ff ff       	call   802126 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8023be:	89 c3                	mov    %eax,%ebx
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	0f 85 96 01 00 00    	jne    80255e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8023c8:	85 ff                	test   %edi,%edi
  8023ca:	75 41                	jne    80240d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8023cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023cf:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8023d4:	75 08                	jne    8023de <_Z4openPKci+0xa0>
            fileino = dirino;
  8023d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023dc:	eb 14                	jmp    8023f2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8023de:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	e8 2f f7 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  8023e8:	89 c3                	mov    %eax,%ebx
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	0f 88 5d 01 00 00    	js     80254f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8023f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f5:	83 38 02             	cmpl   $0x2,(%eax)
  8023f8:	0f 85 d2 00 00 00    	jne    8024d0 <_Z4openPKci+0x192>
  8023fe:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802402:	0f 84 c8 00 00 00    	je     8024d0 <_Z4openPKci+0x192>
  802408:	e9 38 01 00 00       	jmp    802545 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80240d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802414:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80241b:	0f 8e a8 00 00 00    	jle    8024c9 <_Z4openPKci+0x18b>
  802421:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802426:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	e8 e7 f6 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  802430:	89 c3                	mov    %eax,%ebx
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 88 15 01 00 00    	js     80254f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80243a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80243d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802441:	75 68                	jne    8024ab <_Z4openPKci+0x16d>
  802443:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80244a:	75 5f                	jne    8024ab <_Z4openPKci+0x16d>
			*ino_store = ino;
  80244c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80244f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802455:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802458:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80245f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802466:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80246d:	00 
  80246e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802475:	00 
  802476:	83 c0 0c             	add    $0xc,%eax
  802479:	89 04 24             	mov    %eax,(%esp)
  80247c:	e8 20 e6 ff ff       	call   800aa1 <memset>
        de->de_inum = fileino->i_inum;
  802481:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802484:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80248a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80248d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80248f:	ba 04 00 00 00       	mov    $0x4,%edx
  802494:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802497:	e8 bf f5 ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80249c:	ba 04 00 00 00       	mov    $0x4,%edx
  8024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a4:	e8 b2 f5 ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
  8024a9:	eb 25                	jmp    8024d0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8024ab:	e8 65 f8 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8024b0:	83 c7 01             	add    $0x1,%edi
  8024b3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8024b9:	0f 8c 67 ff ff ff    	jl     802426 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8024bf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024c4:	e9 86 00 00 00       	jmp    80254f <_Z4openPKci+0x211>
  8024c9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024ce:	eb 7f                	jmp    80254f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8024d0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8024d7:	74 0d                	je     8024e6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8024d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e1:	e8 aa f6 ff ff       	call   801b90 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8024e6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8024f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8024fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fe:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802501:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802504:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80250a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80250d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802511:	83 c0 10             	add    $0x10,%eax
  802514:	89 04 24             	mov    %eax,(%esp)
  802517:	e8 3e e4 ff ff       	call   80095a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80251c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802529:	e8 e7 f7 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80252e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802531:	e8 df f7 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 13 ee ff ff       	call   801354 <_Z6fd2numP2Fd>
  802541:	89 c3                	mov    %eax,%ebx
  802543:	eb 30                	jmp    802575 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802545:	e8 cb f7 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80254a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80254f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802552:	e8 be f7 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
  802557:	eb 05                	jmp    80255e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802559:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80255e:	a1 00 60 80 00       	mov    0x806000,%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802569:	89 54 24 04          	mov    %edx,0x4(%esp)
  80256d:	89 04 24             	mov    %eax,(%esp)
  802570:	e8 88 e9 ff ff       	call   800efd <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802575:	89 d8                	mov    %ebx,%eax
  802577:	83 c4 3c             	add    $0x3c,%esp
  80257a:	5b                   	pop    %ebx
  80257b:	5e                   	pop    %esi
  80257c:	5f                   	pop    %edi
  80257d:	5d                   	pop    %ebp
  80257e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80257f:	83 f8 78             	cmp    $0x78,%eax
  802582:	0f 85 1d fe ff ff    	jne    8023a5 <_Z4openPKci+0x67>
  802588:	eb cf                	jmp    802559 <_Z4openPKci+0x21b>

0080258a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	53                   	push   %ebx
  80258e:	83 ec 24             	sub    $0x24,%esp
  802591:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802594:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	e8 78 f5 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	78 27                	js     8025ca <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8025a3:	c7 44 24 04 d4 48 80 	movl   $0x8048d4,0x4(%esp)
  8025aa:	00 
  8025ab:	89 1c 24             	mov    %ebx,(%esp)
  8025ae:	e8 a7 e3 ff ff       	call   80095a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8025b3:	89 da                	mov    %ebx,%edx
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	e8 26 f4 ff ff       	call   8019e3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	e8 50 f7 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
	return 0;
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ca:	83 c4 24             	add    $0x24,%esp
  8025cd:	5b                   	pop    %ebx
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    

008025d0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8025d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025de:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8025e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	e8 3a fb ff ff       	call   802126 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8025ec:	89 c3                	mov    %eax,%ebx
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	78 5f                	js     802651 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  8025f2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	e8 18 f5 ff ff       	call   801b17 <_ZL10inode_openiPP5Inode>
  8025ff:	89 c3                	mov    %eax,%ebx
  802601:	85 c0                	test   %eax,%eax
  802603:	78 44                	js     802649 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802605:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	83 38 02             	cmpl   $0x2,(%eax)
  802610:	74 2f                	je     802641 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802622:	ba 04 00 00 00       	mov    $0x4,%edx
  802627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262a:	e8 2c f4 ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80262f:	ba 04 00 00 00       	mov    $0x4,%edx
  802634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802637:	e8 1f f4 ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
	r = 0;
  80263c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	e8 cc f6 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	e8 c4 f6 ff ff       	call   801d15 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802651:	89 d8                	mov    %ebx,%eax
  802653:	83 c4 24             	add    $0x24,%esp
  802656:	5b                   	pop    %ebx
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    

00802659 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    

00802663 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	57                   	push   %edi
  802667:	56                   	push   %esi
  802668:	53                   	push   %ebx
  802669:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80266f:	c7 04 24 bd 1d 80 00 	movl   $0x801dbd,(%esp)
  802676:	e8 30 15 00 00       	call   803bab <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80267b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802680:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802685:	74 28                	je     8026af <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802687:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80268e:	4a 
  80268f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802693:	c7 44 24 08 3c 49 80 	movl   $0x80493c,0x8(%esp)
  80269a:	00 
  80269b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8026a2:	00 
  8026a3:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  8026aa:	e8 2d 14 00 00       	call   803adc <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8026af:	a1 04 10 00 50       	mov    0x50001004,%eax
  8026b4:	83 f8 03             	cmp    $0x3,%eax
  8026b7:	7f 1c                	jg     8026d5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8026b9:	c7 44 24 08 70 49 80 	movl   $0x804970,0x8(%esp)
  8026c0:	00 
  8026c1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8026c8:	00 
  8026c9:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  8026d0:	e8 07 14 00 00       	call   803adc <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8026d5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8026db:	85 d2                	test   %edx,%edx
  8026dd:	7f 1c                	jg     8026fb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8026df:	c7 44 24 08 a0 49 80 	movl   $0x8049a0,0x8(%esp)
  8026e6:	00 
  8026e7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  8026ee:	00 
  8026ef:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  8026f6:	e8 e1 13 00 00       	call   803adc <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  8026fb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802701:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802707:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80270d:	85 c9                	test   %ecx,%ecx
  80270f:	0f 48 cb             	cmovs  %ebx,%ecx
  802712:	c1 f9 0c             	sar    $0xc,%ecx
  802715:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802719:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80271f:	39 c8                	cmp    %ecx,%eax
  802721:	7c 13                	jl     802736 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802723:	85 c0                	test   %eax,%eax
  802725:	7f 3d                	jg     802764 <_Z4fsckv+0x101>
  802727:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80272e:	00 00 00 
  802731:	e9 ac 00 00 00       	jmp    8027e2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802736:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80273c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802740:	89 44 24 10          	mov    %eax,0x10(%esp)
  802744:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802748:	c7 44 24 08 d0 49 80 	movl   $0x8049d0,0x8(%esp)
  80274f:	00 
  802750:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802757:	00 
  802758:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  80275f:	e8 78 13 00 00       	call   803adc <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802764:	be 00 20 00 50       	mov    $0x50002000,%esi
  802769:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802770:	00 00 00 
  802773:	bb 00 00 00 00       	mov    $0x0,%ebx
  802778:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80277e:	39 df                	cmp    %ebx,%edi
  802780:	7e 27                	jle    8027a9 <_Z4fsckv+0x146>
  802782:	0f b6 06             	movzbl (%esi),%eax
  802785:	84 c0                	test   %al,%al
  802787:	74 4b                	je     8027d4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802789:	0f be c0             	movsbl %al,%eax
  80278c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802790:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802794:	c7 04 24 14 4a 80 00 	movl   $0x804a14,(%esp)
  80279b:	e8 9e db ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  8027a0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8027a7:	eb 2b                	jmp    8027d4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8027a9:	0f b6 06             	movzbl (%esi),%eax
  8027ac:	3c 01                	cmp    $0x1,%al
  8027ae:	76 24                	jbe    8027d4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8027b0:	0f be c0             	movsbl %al,%eax
  8027b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027bb:	c7 04 24 48 4a 80 00 	movl   $0x804a48,(%esp)
  8027c2:	e8 77 db ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  8027c7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8027ce:	80 3e 00             	cmpb   $0x0,(%esi)
  8027d1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8027d4:	83 c3 01             	add    $0x1,%ebx
  8027d7:	83 c6 01             	add    $0x1,%esi
  8027da:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8027e0:	7f 9c                	jg     80277e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8027e2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8027e9:	0f 8e e1 02 00 00    	jle    802ad0 <_Z4fsckv+0x46d>
  8027ef:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  8027f6:	00 00 00 
		struct Inode *ino = get_inode(i);
  8027f9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8027ff:	e8 f9 f1 ff ff       	call   8019fd <_ZL9get_inodei>
  802804:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80280a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80280e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802815:	75 22                	jne    802839 <_Z4fsckv+0x1d6>
  802817:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80281e:	0f 84 a9 06 00 00    	je     802ecd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802824:	ba 00 00 00 00       	mov    $0x0,%edx
  802829:	e8 2d f2 ff ff       	call   801a5b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80282e:	85 c0                	test   %eax,%eax
  802830:	74 3a                	je     80286c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802832:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802839:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80283f:	8b 02                	mov    (%edx),%eax
  802841:	83 f8 01             	cmp    $0x1,%eax
  802844:	74 26                	je     80286c <_Z4fsckv+0x209>
  802846:	83 f8 02             	cmp    $0x2,%eax
  802849:	74 21                	je     80286c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80284b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80284f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802855:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802859:	c7 04 24 74 4a 80 00 	movl   $0x804a74,(%esp)
  802860:	e8 d9 da ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  802865:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80286c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802873:	75 3f                	jne    8028b4 <_Z4fsckv+0x251>
  802875:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80287b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80287f:	75 15                	jne    802896 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802881:	c7 04 24 98 4a 80 00 	movl   $0x804a98,(%esp)
  802888:	e8 b1 da ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  80288d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802894:	eb 1e                	jmp    8028b4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802896:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80289c:	83 3a 02             	cmpl   $0x2,(%edx)
  80289f:	74 13                	je     8028b4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8028a1:	c7 04 24 cc 4a 80 00 	movl   $0x804acc,(%esp)
  8028a8:	e8 91 da ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  8028ad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8028b4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8028b9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028c0:	0f 84 93 00 00 00    	je     802959 <_Z4fsckv+0x2f6>
  8028c6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8028cc:	8b 41 08             	mov    0x8(%ecx),%eax
  8028cf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8028d4:	7e 23                	jle    8028f9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8028d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028da:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8028e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e4:	c7 04 24 fc 4a 80 00 	movl   $0x804afc,(%esp)
  8028eb:	e8 4e da ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  8028f0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028f7:	eb 09                	jmp    802902 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  8028f9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802900:	74 4b                	je     80294d <_Z4fsckv+0x2ea>
  802902:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802908:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80290e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802914:	74 23                	je     802939 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80291a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802920:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802924:	c7 04 24 20 4b 80 00 	movl   $0x804b20,(%esp)
  80292b:	e8 0e da ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  802930:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802937:	eb 09                	jmp    802942 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802939:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802940:	74 12                	je     802954 <_Z4fsckv+0x2f1>
  802942:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802948:	8b 78 08             	mov    0x8(%eax),%edi
  80294b:	eb 0c                	jmp    802959 <_Z4fsckv+0x2f6>
  80294d:	bf 00 00 00 00       	mov    $0x0,%edi
  802952:	eb 05                	jmp    802959 <_Z4fsckv+0x2f6>
  802954:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802959:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80295e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802964:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802968:	89 d8                	mov    %ebx,%eax
  80296a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80296d:	39 c7                	cmp    %eax,%edi
  80296f:	7e 2b                	jle    80299c <_Z4fsckv+0x339>
  802971:	85 f6                	test   %esi,%esi
  802973:	75 27                	jne    80299c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802975:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802979:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80297d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802983:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802987:	c7 04 24 44 4b 80 00 	movl   $0x804b44,(%esp)
  80298e:	e8 ab d9 ff ff       	call   80033e <_Z7cprintfPKcz>
				++errors;
  802993:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80299a:	eb 36                	jmp    8029d2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80299c:	39 f8                	cmp    %edi,%eax
  80299e:	7c 32                	jl     8029d2 <_Z4fsckv+0x36f>
  8029a0:	85 f6                	test   %esi,%esi
  8029a2:	74 2e                	je     8029d2 <_Z4fsckv+0x36f>
  8029a4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029ab:	74 25                	je     8029d2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8029ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bf:	c7 04 24 88 4b 80 00 	movl   $0x804b88,(%esp)
  8029c6:	e8 73 d9 ff ff       	call   80033e <_Z7cprintfPKcz>
				++errors;
  8029cb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8029d2:	85 f6                	test   %esi,%esi
  8029d4:	0f 84 a0 00 00 00    	je     802a7a <_Z4fsckv+0x417>
  8029da:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029e1:	0f 84 93 00 00 00    	je     802a7a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8029e7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8029ed:	7e 27                	jle    802a16 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8029ef:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8029f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029f7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8029fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a01:	c7 04 24 cc 4b 80 00 	movl   $0x804bcc,(%esp)
  802a08:	e8 31 d9 ff ff       	call   80033e <_Z7cprintfPKcz>
					++errors;
  802a0d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a14:	eb 64                	jmp    802a7a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802a16:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802a1d:	3c 01                	cmp    $0x1,%al
  802a1f:	75 27                	jne    802a48 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802a21:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a29:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a33:	c7 04 24 10 4c 80 00 	movl   $0x804c10,(%esp)
  802a3a:	e8 ff d8 ff ff       	call   80033e <_Z7cprintfPKcz>
					++errors;
  802a3f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a46:	eb 32                	jmp    802a7a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802a48:	3c ff                	cmp    $0xff,%al
  802a4a:	75 27                	jne    802a73 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802a4c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a50:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a54:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5e:	c7 04 24 4c 4c 80 00 	movl   $0x804c4c,(%esp)
  802a65:	e8 d4 d8 ff ff       	call   80033e <_Z7cprintfPKcz>
					++errors;
  802a6a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a71:	eb 07                	jmp    802a7a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802a73:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802a7a:	83 c3 01             	add    $0x1,%ebx
  802a7d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802a83:	0f 85 d5 fe ff ff    	jne    80295e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802a89:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802a90:	0f 94 c0             	sete   %al
  802a93:	0f b6 c0             	movzbl %al,%eax
  802a96:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a9c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802aa2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802aa9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802ab0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802ab7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802abe:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ac4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802aca:	0f 8f 29 fd ff ff    	jg     8027f9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ad0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802ad7:	0f 8e 7f 03 00 00    	jle    802e5c <_Z4fsckv+0x7f9>
  802add:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802ae2:	89 f0                	mov    %esi,%eax
  802ae4:	e8 14 ef ff ff       	call   8019fd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802ae9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802af0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802af7:	c1 e2 08             	shl    $0x8,%edx
  802afa:	09 ca                	or     %ecx,%edx
  802afc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802b03:	c1 e1 10             	shl    $0x10,%ecx
  802b06:	09 ca                	or     %ecx,%edx
  802b08:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802b0f:	83 e1 7f             	and    $0x7f,%ecx
  802b12:	c1 e1 18             	shl    $0x18,%ecx
  802b15:	09 d1                	or     %edx,%ecx
  802b17:	74 0e                	je     802b27 <_Z4fsckv+0x4c4>
  802b19:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802b20:	78 05                	js     802b27 <_Z4fsckv+0x4c4>
  802b22:	83 38 02             	cmpl   $0x2,(%eax)
  802b25:	74 1f                	je     802b46 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b27:	83 c6 01             	add    $0x1,%esi
  802b2a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802b2f:	39 f0                	cmp    %esi,%eax
  802b31:	7f af                	jg     802ae2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802b33:	bb 01 00 00 00       	mov    $0x1,%ebx
  802b38:	83 f8 01             	cmp    $0x1,%eax
  802b3b:	0f 8f ad 02 00 00    	jg     802dee <_Z4fsckv+0x78b>
  802b41:	e9 16 03 00 00       	jmp    802e5c <_Z4fsckv+0x7f9>
  802b46:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802b48:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802b4f:	8b 40 08             	mov    0x8(%eax),%eax
  802b52:	a8 7f                	test   $0x7f,%al
  802b54:	74 23                	je     802b79 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802b56:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802b5d:	00 
  802b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b62:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b66:	c7 04 24 88 4c 80 00 	movl   $0x804c88,(%esp)
  802b6d:	e8 cc d7 ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  802b72:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b79:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802b80:	00 00 00 
  802b83:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802b89:	e9 3d 02 00 00       	jmp    802dcb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802b8e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b94:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802b9a:	e8 01 ee ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
  802b9f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802ba1:	83 38 00             	cmpl   $0x0,(%eax)
  802ba4:	0f 84 15 02 00 00    	je     802dbf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bb0:	83 fa 76             	cmp    $0x76,%edx
  802bb3:	76 27                	jbe    802bdc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802bb5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bb9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802bbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bc7:	c7 04 24 bc 4c 80 00 	movl   $0x804cbc,(%esp)
  802bce:	e8 6b d7 ff ff       	call   80033e <_Z7cprintfPKcz>
				++errors;
  802bd3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802bda:	eb 28                	jmp    802c04 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802bdc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802be1:	74 21                	je     802c04 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802be3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802be9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bed:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bf1:	c7 04 24 e8 4c 80 00 	movl   $0x804ce8,(%esp)
  802bf8:	e8 41 d7 ff ff       	call   80033e <_Z7cprintfPKcz>
				++errors;
  802bfd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802c04:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802c0b:	00 
  802c0c:	8d 43 08             	lea    0x8(%ebx),%eax
  802c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c13:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c19:	89 0c 24             	mov    %ecx,(%esp)
  802c1c:	e8 56 df ff ff       	call   800b77 <memcpy>
  802c21:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802c25:	bf 77 00 00 00       	mov    $0x77,%edi
  802c2a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802c2e:	85 ff                	test   %edi,%edi
  802c30:	b8 00 00 00 00       	mov    $0x0,%eax
  802c35:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802c38:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802c3f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802c40:	8b 03                	mov    (%ebx),%eax
  802c42:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802c48:	7c 3e                	jl     802c88 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802c4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c4e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c58:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c62:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c66:	c7 04 24 1c 4d 80 00 	movl   $0x804d1c,(%esp)
  802c6d:	e8 cc d6 ff ff       	call   80033e <_Z7cprintfPKcz>
				++errors;
  802c72:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802c79:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802c80:	00 00 00 
  802c83:	e9 0b 01 00 00       	jmp    802d93 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802c88:	e8 70 ed ff ff       	call   8019fd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802c8d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802c94:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802c9b:	c1 e2 08             	shl    $0x8,%edx
  802c9e:	09 d1                	or     %edx,%ecx
  802ca0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802ca7:	c1 e2 10             	shl    $0x10,%edx
  802caa:	09 d1                	or     %edx,%ecx
  802cac:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802cb3:	83 e2 7f             	and    $0x7f,%edx
  802cb6:	c1 e2 18             	shl    $0x18,%edx
  802cb9:	09 ca                	or     %ecx,%edx
  802cbb:	83 c2 01             	add    $0x1,%edx
  802cbe:	89 d1                	mov    %edx,%ecx
  802cc0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802cc6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802ccc:	0f b6 d5             	movzbl %ch,%edx
  802ccf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802cd5:	89 ca                	mov    %ecx,%edx
  802cd7:	c1 ea 10             	shr    $0x10,%edx
  802cda:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802ce0:	c1 e9 18             	shr    $0x18,%ecx
  802ce3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802cea:	83 e2 80             	and    $0xffffff80,%edx
  802ced:	09 ca                	or     %ecx,%edx
  802cef:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802cf5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802cf9:	0f 85 7a ff ff ff    	jne    802c79 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802cff:	8b 03                	mov    (%ebx),%eax
  802d01:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d05:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802d0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d0f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d15:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d19:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d1d:	c7 04 24 4c 4d 80 00 	movl   $0x804d4c,(%esp)
  802d24:	e8 15 d6 ff ff       	call   80033e <_Z7cprintfPKcz>
					++errors;
  802d29:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d30:	e9 44 ff ff ff       	jmp    802c79 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d35:	3b 78 04             	cmp    0x4(%eax),%edi
  802d38:	75 52                	jne    802d8c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802d3a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d3e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802d44:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d48:	83 c0 08             	add    $0x8,%eax
  802d4b:	89 04 24             	mov    %eax,(%esp)
  802d4e:	e8 65 de ff ff       	call   800bb8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d53:	85 c0                	test   %eax,%eax
  802d55:	75 35                	jne    802d8c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802d57:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d61:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d6b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d71:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d75:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d79:	c7 04 24 7c 4d 80 00 	movl   $0x804d7c,(%esp)
  802d80:	e8 b9 d5 ff ff       	call   80033e <_Z7cprintfPKcz>
					++errors;
  802d85:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d8c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802d93:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d99:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802d9f:	7e 1e                	jle    802dbf <_Z4fsckv+0x75c>
  802da1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802da5:	7f 18                	jg     802dbf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802da7:	89 ca                	mov    %ecx,%edx
  802da9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802daf:	e8 ec eb ff ff       	call   8019a0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802db4:	83 38 00             	cmpl   $0x0,(%eax)
  802db7:	0f 85 78 ff ff ff    	jne    802d35 <_Z4fsckv+0x6d2>
  802dbd:	eb cd                	jmp    802d8c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802dbf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802dc5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802dcb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802dd1:	83 ea 80             	sub    $0xffffff80,%edx
  802dd4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802dda:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802de0:	3b 51 08             	cmp    0x8(%ecx),%edx
  802de3:	0f 8f e7 fc ff ff    	jg     802ad0 <_Z4fsckv+0x46d>
  802de9:	e9 a0 fd ff ff       	jmp    802b8e <_Z4fsckv+0x52b>
  802dee:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802df4:	89 d8                	mov    %ebx,%eax
  802df6:	e8 02 ec ff ff       	call   8019fd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802dfb:	8b 50 04             	mov    0x4(%eax),%edx
  802dfe:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e05:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802e0c:	c1 e7 08             	shl    $0x8,%edi
  802e0f:	09 f9                	or     %edi,%ecx
  802e11:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802e18:	c1 e7 10             	shl    $0x10,%edi
  802e1b:	09 f9                	or     %edi,%ecx
  802e1d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802e24:	83 e7 7f             	and    $0x7f,%edi
  802e27:	c1 e7 18             	shl    $0x18,%edi
  802e2a:	09 f9                	or     %edi,%ecx
  802e2c:	39 ca                	cmp    %ecx,%edx
  802e2e:	74 1b                	je     802e4b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802e30:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e34:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e38:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e3c:	c7 04 24 ac 4d 80 00 	movl   $0x804dac,(%esp)
  802e43:	e8 f6 d4 ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  802e48:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802e4b:	83 c3 01             	add    $0x1,%ebx
  802e4e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802e54:	7f 9e                	jg     802df4 <_Z4fsckv+0x791>
  802e56:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e5c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802e63:	7e 4f                	jle    802eb4 <_Z4fsckv+0x851>
  802e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e6a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802e70:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802e77:	3c ff                	cmp    $0xff,%al
  802e79:	75 09                	jne    802e84 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802e7b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802e82:	eb 1f                	jmp    802ea3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802e84:	84 c0                	test   %al,%al
  802e86:	75 1b                	jne    802ea3 <_Z4fsckv+0x840>
  802e88:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802e8e:	7c 13                	jl     802ea3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802e90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e94:	c7 04 24 d8 4d 80 00 	movl   $0x804dd8,(%esp)
  802e9b:	e8 9e d4 ff ff       	call   80033e <_Z7cprintfPKcz>
			++errors;
  802ea0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802ea3:	83 c3 01             	add    $0x1,%ebx
  802ea6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802eac:	7f c2                	jg     802e70 <_Z4fsckv+0x80d>
  802eae:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802eb4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802ebb:	19 c0                	sbb    %eax,%eax
  802ebd:	f7 d0                	not    %eax
  802ebf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802ec2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802ec8:	5b                   	pop    %ebx
  802ec9:	5e                   	pop    %esi
  802eca:	5f                   	pop    %edi
  802ecb:	5d                   	pop    %ebp
  802ecc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802ecd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ed4:	0f 84 92 f9 ff ff    	je     80286c <_Z4fsckv+0x209>
  802eda:	e9 5a f9 ff ff       	jmp    802839 <_Z4fsckv+0x1d6>
	...

00802ee0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
  802ee3:	83 ec 18             	sub    $0x18,%esp
  802ee6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802ee9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802eec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	89 04 24             	mov    %eax,(%esp)
  802ef5:	e8 a2 e4 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  802efa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802efc:	c7 44 24 04 0b 4e 80 	movl   $0x804e0b,0x4(%esp)
  802f03:	00 
  802f04:	89 34 24             	mov    %esi,(%esp)
  802f07:	e8 4e da ff ff       	call   80095a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802f0c:	8b 43 04             	mov    0x4(%ebx),%eax
  802f0f:	2b 03                	sub    (%ebx),%eax
  802f11:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802f14:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802f1b:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  802f22:	50 80 00 
	return 0;
}
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f2d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f30:	89 ec                	mov    %ebp,%esp
  802f32:	5d                   	pop    %ebp
  802f33:	c3                   	ret    

00802f34 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
  802f37:	53                   	push   %ebx
  802f38:	83 ec 14             	sub    $0x14,%esp
  802f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f49:	e8 af df ff ff       	call   800efd <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802f4e:	89 1c 24             	mov    %ebx,(%esp)
  802f51:	e8 46 e4 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  802f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f61:	e8 97 df ff ff       	call   800efd <_Z14sys_page_unmapiPv>
}
  802f66:	83 c4 14             	add    $0x14,%esp
  802f69:	5b                   	pop    %ebx
  802f6a:	5d                   	pop    %ebp
  802f6b:	c3                   	ret    

00802f6c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f6c:	55                   	push   %ebp
  802f6d:	89 e5                	mov    %esp,%ebp
  802f6f:	57                   	push   %edi
  802f70:	56                   	push   %esi
  802f71:	53                   	push   %ebx
  802f72:	83 ec 2c             	sub    $0x2c,%esp
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802f7a:	a1 00 60 80 00       	mov    0x806000,%eax
  802f7f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802f82:	89 3c 24             	mov    %edi,(%esp)
  802f85:	e8 82 04 00 00       	call   80340c <_Z7pagerefPv>
  802f8a:	89 c3                	mov    %eax,%ebx
  802f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8f:	89 04 24             	mov    %eax,(%esp)
  802f92:	e8 75 04 00 00       	call   80340c <_Z7pagerefPv>
  802f97:	39 c3                	cmp    %eax,%ebx
  802f99:	0f 94 c0             	sete   %al
  802f9c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802f9f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802fa5:	8b 52 58             	mov    0x58(%edx),%edx
  802fa8:	39 d6                	cmp    %edx,%esi
  802faa:	75 08                	jne    802fb4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802fac:	83 c4 2c             	add    $0x2c,%esp
  802faf:	5b                   	pop    %ebx
  802fb0:	5e                   	pop    %esi
  802fb1:	5f                   	pop    %edi
  802fb2:	5d                   	pop    %ebp
  802fb3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 c2                	je     802f7a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802fb8:	c7 04 24 12 4e 80 00 	movl   $0x804e12,(%esp)
  802fbf:	e8 7a d3 ff ff       	call   80033e <_Z7cprintfPKcz>
  802fc4:	eb b4                	jmp    802f7a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802fc6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fc6:	55                   	push   %ebp
  802fc7:	89 e5                	mov    %esp,%ebp
  802fc9:	57                   	push   %edi
  802fca:	56                   	push   %esi
  802fcb:	53                   	push   %ebx
  802fcc:	83 ec 1c             	sub    $0x1c,%esp
  802fcf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802fd2:	89 34 24             	mov    %esi,(%esp)
  802fd5:	e8 c2 e3 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  802fda:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fdc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fe5:	75 46                	jne    80302d <_ZL13devpipe_writeP2FdPKvj+0x67>
  802fe7:	eb 52                	jmp    80303b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802fe9:	89 da                	mov    %ebx,%edx
  802feb:	89 f0                	mov    %esi,%eax
  802fed:	e8 7a ff ff ff       	call   802f6c <_ZL13_pipeisclosedP2FdP4Pipe>
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	75 49                	jne    80303f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  802ff6:	e8 11 de ff ff       	call   800e0c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802ffb:	8b 43 04             	mov    0x4(%ebx),%eax
  802ffe:	89 c2                	mov    %eax,%edx
  803000:	2b 13                	sub    (%ebx),%edx
  803002:	83 fa 20             	cmp    $0x20,%edx
  803005:	74 e2                	je     802fe9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803007:	89 c2                	mov    %eax,%edx
  803009:	c1 fa 1f             	sar    $0x1f,%edx
  80300c:	c1 ea 1b             	shr    $0x1b,%edx
  80300f:	01 d0                	add    %edx,%eax
  803011:	83 e0 1f             	and    $0x1f,%eax
  803014:	29 d0                	sub    %edx,%eax
  803016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803019:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80301d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803021:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803025:	83 c7 01             	add    $0x1,%edi
  803028:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80302b:	76 0e                	jbe    80303b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80302d:	8b 43 04             	mov    0x4(%ebx),%eax
  803030:	89 c2                	mov    %eax,%edx
  803032:	2b 13                	sub    (%ebx),%edx
  803034:	83 fa 20             	cmp    $0x20,%edx
  803037:	74 b0                	je     802fe9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803039:	eb cc                	jmp    803007 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80303b:	89 f8                	mov    %edi,%eax
  80303d:	eb 05                	jmp    803044 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80303f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803044:	83 c4 1c             	add    $0x1c,%esp
  803047:	5b                   	pop    %ebx
  803048:	5e                   	pop    %esi
  803049:	5f                   	pop    %edi
  80304a:	5d                   	pop    %ebp
  80304b:	c3                   	ret    

0080304c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80304c:	55                   	push   %ebp
  80304d:	89 e5                	mov    %esp,%ebp
  80304f:	83 ec 28             	sub    $0x28,%esp
  803052:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803055:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803058:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80305b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80305e:	89 3c 24             	mov    %edi,(%esp)
  803061:	e8 36 e3 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  803066:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803068:	be 00 00 00 00       	mov    $0x0,%esi
  80306d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803071:	75 47                	jne    8030ba <_ZL12devpipe_readP2FdPvj+0x6e>
  803073:	eb 52                	jmp    8030c7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803075:	89 f0                	mov    %esi,%eax
  803077:	eb 5e                	jmp    8030d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803079:	89 da                	mov    %ebx,%edx
  80307b:	89 f8                	mov    %edi,%eax
  80307d:	8d 76 00             	lea    0x0(%esi),%esi
  803080:	e8 e7 fe ff ff       	call   802f6c <_ZL13_pipeisclosedP2FdP4Pipe>
  803085:	85 c0                	test   %eax,%eax
  803087:	75 49                	jne    8030d2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803089:	e8 7e dd ff ff       	call   800e0c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80308e:	8b 03                	mov    (%ebx),%eax
  803090:	3b 43 04             	cmp    0x4(%ebx),%eax
  803093:	74 e4                	je     803079 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803095:	89 c2                	mov    %eax,%edx
  803097:	c1 fa 1f             	sar    $0x1f,%edx
  80309a:	c1 ea 1b             	shr    $0x1b,%edx
  80309d:	01 d0                	add    %edx,%eax
  80309f:	83 e0 1f             	and    $0x1f,%eax
  8030a2:	29 d0                	sub    %edx,%eax
  8030a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8030a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ac:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8030af:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8030b2:	83 c6 01             	add    $0x1,%esi
  8030b5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8030b8:	76 0d                	jbe    8030c7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8030ba:	8b 03                	mov    (%ebx),%eax
  8030bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030bf:	75 d4                	jne    803095 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8030c1:	85 f6                	test   %esi,%esi
  8030c3:	75 b0                	jne    803075 <_ZL12devpipe_readP2FdPvj+0x29>
  8030c5:	eb b2                	jmp    803079 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8030c7:	89 f0                	mov    %esi,%eax
  8030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030d0:	eb 05                	jmp    8030d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8030d2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8030d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8030da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8030dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8030e0:	89 ec                	mov    %ebp,%esp
  8030e2:	5d                   	pop    %ebp
  8030e3:	c3                   	ret    

008030e4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030e4:	55                   	push   %ebp
  8030e5:	89 e5                	mov    %esp,%ebp
  8030e7:	83 ec 48             	sub    $0x48,%esp
  8030ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8030ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8030f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8030f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8030f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8030f9:	89 04 24             	mov    %eax,(%esp)
  8030fc:	e8 b6 e2 ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  803101:	89 c3                	mov    %eax,%ebx
  803103:	85 c0                	test   %eax,%eax
  803105:	0f 88 0b 01 00 00    	js     803216 <_Z4pipePi+0x132>
  80310b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803112:	00 
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	89 44 24 04          	mov    %eax,0x4(%esp)
  80311a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803121:	e8 1a dd ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803126:	89 c3                	mov    %eax,%ebx
  803128:	85 c0                	test   %eax,%eax
  80312a:	0f 89 f5 00 00 00    	jns    803225 <_Z4pipePi+0x141>
  803130:	e9 e1 00 00 00       	jmp    803216 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803135:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80313c:	00 
  80313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803140:	89 44 24 04          	mov    %eax,0x4(%esp)
  803144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80314b:	e8 f0 dc ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803150:	89 c3                	mov    %eax,%ebx
  803152:	85 c0                	test   %eax,%eax
  803154:	0f 89 e2 00 00 00    	jns    80323c <_Z4pipePi+0x158>
  80315a:	e9 a4 00 00 00       	jmp    803203 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80315f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803162:	89 04 24             	mov    %eax,(%esp)
  803165:	e8 32 e2 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  80316a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803171:	00 
  803172:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803176:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80317d:	00 
  80317e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803182:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803189:	e8 11 dd ff ff       	call   800e9f <_Z12sys_page_mapiPviS_i>
  80318e:	89 c3                	mov    %eax,%ebx
  803190:	85 c0                	test   %eax,%eax
  803192:	78 4c                	js     8031e0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803194:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80319a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031a9:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8031af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8031b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c1:	89 04 24             	mov    %eax,(%esp)
  8031c4:	e8 8b e1 ff ff       	call   801354 <_Z6fd2numP2Fd>
  8031c9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8031cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ce:	89 04 24             	mov    %eax,(%esp)
  8031d1:	e8 7e e1 ff ff       	call   801354 <_Z6fd2numP2Fd>
  8031d6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8031d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031de:	eb 36                	jmp    803216 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8031e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031eb:	e8 0d dd ff ff       	call   800efd <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031fe:	e8 fa dc ff ff       	call   800efd <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80320a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803211:	e8 e7 dc ff ff       	call   800efd <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803216:	89 d8                	mov    %ebx,%eax
  803218:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80321b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80321e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803221:	89 ec                	mov    %ebp,%esp
  803223:	5d                   	pop    %ebp
  803224:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803225:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803228:	89 04 24             	mov    %eax,(%esp)
  80322b:	e8 87 e1 ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  803230:	89 c3                	mov    %eax,%ebx
  803232:	85 c0                	test   %eax,%eax
  803234:	0f 89 fb fe ff ff    	jns    803135 <_Z4pipePi+0x51>
  80323a:	eb c7                	jmp    803203 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80323c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323f:	89 04 24             	mov    %eax,(%esp)
  803242:	e8 55 e1 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  803247:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803249:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803250:	00 
  803251:	89 44 24 04          	mov    %eax,0x4(%esp)
  803255:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80325c:	e8 df db ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803261:	89 c3                	mov    %eax,%ebx
  803263:	85 c0                	test   %eax,%eax
  803265:	0f 89 f4 fe ff ff    	jns    80315f <_Z4pipePi+0x7b>
  80326b:	eb 83                	jmp    8031f0 <_Z4pipePi+0x10c>

0080326d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80326d:	55                   	push   %ebp
  80326e:	89 e5                	mov    %esp,%ebp
  803270:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803273:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80327a:	00 
  80327b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80327e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	89 04 24             	mov    %eax,(%esp)
  803288:	e8 74 e0 ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  80328d:	85 c0                	test   %eax,%eax
  80328f:	78 15                	js     8032a6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	89 04 24             	mov    %eax,(%esp)
  803297:	e8 00 e1 ff ff       	call   80139c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80329c:	89 c2                	mov    %eax,%edx
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	e8 c6 fc ff ff       	call   802f6c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
  8032ab:	53                   	push   %ebx
  8032ac:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8032af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032b2:	89 04 24             	mov    %eax,(%esp)
  8032b5:	e8 fd e0 ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  8032ba:	89 c3                	mov    %eax,%ebx
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	0f 88 be 00 00 00    	js     803382 <_Z18pipe_ipc_recv_readv+0xda>
  8032c4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032cb:	00 
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032da:	e8 61 db ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  8032df:	89 c3                	mov    %eax,%ebx
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	0f 89 a1 00 00 00    	jns    80338a <_Z18pipe_ipc_recv_readv+0xe2>
  8032e9:	e9 94 00 00 00       	jmp    803382 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8032ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	75 0e                	jne    803303 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8032f5:	c7 04 24 70 4e 80 00 	movl   $0x804e70,(%esp)
  8032fc:	e8 3d d0 ff ff       	call   80033e <_Z7cprintfPKcz>
  803301:	eb 10                	jmp    803313 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803303:	89 44 24 04          	mov    %eax,0x4(%esp)
  803307:	c7 04 24 25 4e 80 00 	movl   $0x804e25,(%esp)
  80330e:	e8 2b d0 ff ff       	call   80033e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803313:	c7 04 24 2f 4e 80 00 	movl   $0x804e2f,(%esp)
  80331a:	e8 1f d0 ff ff       	call   80033e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80331f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803322:	a8 04                	test   $0x4,%al
  803324:	74 04                	je     80332a <_Z18pipe_ipc_recv_readv+0x82>
  803326:	a8 01                	test   $0x1,%al
  803328:	75 24                	jne    80334e <_Z18pipe_ipc_recv_readv+0xa6>
  80332a:	c7 44 24 0c 42 4e 80 	movl   $0x804e42,0xc(%esp)
  803331:	00 
  803332:	c7 44 24 08 0c 48 80 	movl   $0x80480c,0x8(%esp)
  803339:	00 
  80333a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803341:	00 
  803342:	c7 04 24 5f 4e 80 00 	movl   $0x804e5f,(%esp)
  803349:	e8 8e 07 00 00       	call   803adc <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80334e:	8b 15 20 50 80 00    	mov    0x805020,%edx
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803363:	89 04 24             	mov    %eax,(%esp)
  803366:	e8 e9 df ff ff       	call   801354 <_Z6fd2numP2Fd>
  80336b:	89 c3                	mov    %eax,%ebx
  80336d:	eb 13                	jmp    803382 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	89 44 24 04          	mov    %eax,0x4(%esp)
  803376:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80337d:	e8 7b db ff ff       	call   800efd <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803382:	89 d8                	mov    %ebx,%eax
  803384:	83 c4 24             	add    $0x24,%esp
  803387:	5b                   	pop    %ebx
  803388:	5d                   	pop    %ebp
  803389:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	89 04 24             	mov    %eax,(%esp)
  803390:	e8 07 e0 ff ff       	call   80139c <_Z7fd2dataP2Fd>
  803395:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803398:	89 54 24 08          	mov    %edx,0x8(%esp)
  80339c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033a3:	89 04 24             	mov    %eax,(%esp)
  8033a6:	e8 f5 08 00 00       	call   803ca0 <_Z8ipc_recvPiPvS_>
  8033ab:	89 c3                	mov    %eax,%ebx
  8033ad:	85 c0                	test   %eax,%eax
  8033af:	0f 89 39 ff ff ff    	jns    8032ee <_Z18pipe_ipc_recv_readv+0x46>
  8033b5:	eb b8                	jmp    80336f <_Z18pipe_ipc_recv_readv+0xc7>

008033b7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8033bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8033c4:	00 
  8033c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cf:	89 04 24             	mov    %eax,(%esp)
  8033d2:	e8 2a df ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	78 2f                	js     80340a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	89 04 24             	mov    %eax,(%esp)
  8033e1:	e8 b6 df ff ff       	call   80139c <_Z7fd2dataP2Fd>
  8033e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8033ed:	00 
  8033ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033f9:	00 
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	89 04 24             	mov    %eax,(%esp)
  803400:	e8 2a 09 00 00       	call   803d2f <_Z8ipc_sendijPvi>
    return 0;
  803405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340a:	c9                   	leave  
  80340b:	c3                   	ret    

0080340c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80340c:	55                   	push   %ebp
  80340d:	89 e5                	mov    %esp,%ebp
  80340f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803412:	89 d0                	mov    %edx,%eax
  803414:	c1 e8 16             	shr    $0x16,%eax
  803417:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80341e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803423:	f6 c1 01             	test   $0x1,%cl
  803426:	74 1d                	je     803445 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803428:	c1 ea 0c             	shr    $0xc,%edx
  80342b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803432:	f6 c2 01             	test   $0x1,%dl
  803435:	74 0e                	je     803445 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803437:	c1 ea 0c             	shr    $0xc,%edx
  80343a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803441:	ef 
  803442:	0f b7 c0             	movzwl %ax,%eax
}
  803445:	5d                   	pop    %ebp
  803446:	c3                   	ret    
	...

00803450 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
  803453:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803456:	c7 44 24 04 93 4e 80 	movl   $0x804e93,0x4(%esp)
  80345d:	00 
  80345e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803461:	89 04 24             	mov    %eax,(%esp)
  803464:	e8 f1 d4 ff ff       	call   80095a <_Z6strcpyPcPKc>
	return 0;
}
  803469:	b8 00 00 00 00       	mov    $0x0,%eax
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
  803473:	53                   	push   %ebx
  803474:	83 ec 14             	sub    $0x14,%esp
  803477:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80347a:	89 1c 24             	mov    %ebx,(%esp)
  80347d:	e8 8a ff ff ff       	call   80340c <_Z7pagerefPv>
  803482:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803484:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803489:	83 fa 01             	cmp    $0x1,%edx
  80348c:	75 0b                	jne    803499 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80348e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803491:	89 04 24             	mov    %eax,(%esp)
  803494:	e8 fe 02 00 00       	call   803797 <_Z11nsipc_closei>
	else
		return 0;
}
  803499:	83 c4 14             	add    $0x14,%esp
  80349c:	5b                   	pop    %ebx
  80349d:	5d                   	pop    %ebp
  80349e:	c3                   	ret    

0080349f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80349f:	55                   	push   %ebp
  8034a0:	89 e5                	mov    %esp,%ebp
  8034a2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8034ac:	00 
  8034ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8034b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c1:	89 04 24             	mov    %eax,(%esp)
  8034c4:	e8 c9 03 00 00       	call   803892 <_Z10nsipc_sendiPKvij>
}
  8034c9:	c9                   	leave  
  8034ca:	c3                   	ret    

008034cb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034cb:	55                   	push   %ebp
  8034cc:	89 e5                	mov    %esp,%ebp
  8034ce:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8034d8:	00 
  8034d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ed:	89 04 24             	mov    %eax,(%esp)
  8034f0:	e8 1d 03 00 00       	call   803812 <_Z10nsipc_recviPvij>
}
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 28             	sub    $0x28,%esp
  8034fd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803500:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803503:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803505:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803508:	89 04 24             	mov    %eax,(%esp)
  80350b:	e8 a7 de ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  803510:	89 c3                	mov    %eax,%ebx
  803512:	85 c0                	test   %eax,%eax
  803514:	78 21                	js     803537 <_ZL12alloc_sockfdi+0x40>
  803516:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80351d:	00 
  80351e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803521:	89 44 24 04          	mov    %eax,0x4(%esp)
  803525:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80352c:	e8 0f d9 ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803531:	89 c3                	mov    %eax,%ebx
  803533:	85 c0                	test   %eax,%eax
  803535:	79 14                	jns    80354b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803537:	89 34 24             	mov    %esi,(%esp)
  80353a:	e8 58 02 00 00       	call   803797 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80353f:	89 d8                	mov    %ebx,%eax
  803541:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803544:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803547:	89 ec                	mov    %ebp,%esp
  803549:	5d                   	pop    %ebp
  80354a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80354b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803560:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803563:	89 04 24             	mov    %eax,(%esp)
  803566:	e8 e9 dd ff ff       	call   801354 <_Z6fd2numP2Fd>
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	eb d0                	jmp    80353f <_ZL12alloc_sockfdi+0x48>

0080356f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80356f:	55                   	push   %ebp
  803570:	89 e5                	mov    %esp,%ebp
  803572:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803575:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80357c:	00 
  80357d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803580:	89 54 24 04          	mov    %edx,0x4(%esp)
  803584:	89 04 24             	mov    %eax,(%esp)
  803587:	e8 75 dd ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  80358c:	85 c0                	test   %eax,%eax
  80358e:	78 15                	js     8035a5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803590:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803593:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803598:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80359e:	39 0a                	cmp    %ecx,(%edx)
  8035a0:	75 03                	jne    8035a5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8035a2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8035a5:	c9                   	leave  
  8035a6:	c3                   	ret    

008035a7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035a7:	55                   	push   %ebp
  8035a8:	89 e5                	mov    %esp,%ebp
  8035aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	e8 ba ff ff ff       	call   80356f <_ZL9fd2sockidi>
  8035b5:	85 c0                	test   %eax,%eax
  8035b7:	78 1f                	js     8035d8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035b9:	8b 55 10             	mov    0x10(%ebp),%edx
  8035bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035c7:	89 04 24             	mov    %eax,(%esp)
  8035ca:	e8 19 01 00 00       	call   8036e8 <_Z12nsipc_acceptiP8sockaddrPj>
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	78 05                	js     8035d8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8035d3:	e8 1f ff ff ff       	call   8034f7 <_ZL12alloc_sockfdi>
}
  8035d8:	c9                   	leave  
  8035d9:	c3                   	ret    

008035da <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035da:	55                   	push   %ebp
  8035db:	89 e5                	mov    %esp,%ebp
  8035dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	e8 87 ff ff ff       	call   80356f <_ZL9fd2sockidi>
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	78 16                	js     803602 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8035ec:	8b 55 10             	mov    0x10(%ebp),%edx
  8035ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035fa:	89 04 24             	mov    %eax,(%esp)
  8035fd:	e8 34 01 00 00       	call   803736 <_Z10nsipc_bindiP8sockaddrj>
}
  803602:	c9                   	leave  
  803603:	c3                   	ret    

00803604 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803604:	55                   	push   %ebp
  803605:	89 e5                	mov    %esp,%ebp
  803607:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	e8 5d ff ff ff       	call   80356f <_ZL9fd2sockidi>
  803612:	85 c0                	test   %eax,%eax
  803614:	78 0f                	js     803625 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803616:	8b 55 0c             	mov    0xc(%ebp),%edx
  803619:	89 54 24 04          	mov    %edx,0x4(%esp)
  80361d:	89 04 24             	mov    %eax,(%esp)
  803620:	e8 50 01 00 00       	call   803775 <_Z14nsipc_shutdownii>
}
  803625:	c9                   	leave  
  803626:	c3                   	ret    

00803627 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803627:	55                   	push   %ebp
  803628:	89 e5                	mov    %esp,%ebp
  80362a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	e8 3a ff ff ff       	call   80356f <_ZL9fd2sockidi>
  803635:	85 c0                	test   %eax,%eax
  803637:	78 16                	js     80364f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803639:	8b 55 10             	mov    0x10(%ebp),%edx
  80363c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803640:	8b 55 0c             	mov    0xc(%ebp),%edx
  803643:	89 54 24 04          	mov    %edx,0x4(%esp)
  803647:	89 04 24             	mov    %eax,(%esp)
  80364a:	e8 62 01 00 00       	call   8037b1 <_Z13nsipc_connectiPK8sockaddrj>
}
  80364f:	c9                   	leave  
  803650:	c3                   	ret    

00803651 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803651:	55                   	push   %ebp
  803652:	89 e5                	mov    %esp,%ebp
  803654:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	e8 10 ff ff ff       	call   80356f <_ZL9fd2sockidi>
  80365f:	85 c0                	test   %eax,%eax
  803661:	78 0f                	js     803672 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803663:	8b 55 0c             	mov    0xc(%ebp),%edx
  803666:	89 54 24 04          	mov    %edx,0x4(%esp)
  80366a:	89 04 24             	mov    %eax,(%esp)
  80366d:	e8 7e 01 00 00       	call   8037f0 <_Z12nsipc_listenii>
}
  803672:	c9                   	leave  
  803673:	c3                   	ret    

00803674 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803674:	55                   	push   %ebp
  803675:	89 e5                	mov    %esp,%ebp
  803677:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80367a:	8b 45 10             	mov    0x10(%ebp),%eax
  80367d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803681:	8b 45 0c             	mov    0xc(%ebp),%eax
  803684:	89 44 24 04          	mov    %eax,0x4(%esp)
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	89 04 24             	mov    %eax,(%esp)
  80368e:	e8 72 02 00 00       	call   803905 <_Z12nsipc_socketiii>
  803693:	85 c0                	test   %eax,%eax
  803695:	78 05                	js     80369c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803697:	e8 5b fe ff ff       	call   8034f7 <_ZL12alloc_sockfdi>
}
  80369c:	c9                   	leave  
  80369d:	8d 76 00             	lea    0x0(%esi),%esi
  8036a0:	c3                   	ret    
  8036a1:	00 00                	add    %al,(%eax)
	...

008036a4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036a4:	55                   	push   %ebp
  8036a5:	89 e5                	mov    %esp,%ebp
  8036a7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8036aa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8036b1:	00 
  8036b2:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8036b9:	00 
  8036ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036be:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8036c5:	e8 65 06 00 00       	call   803d2f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8036ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036d1:	00 
  8036d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036d9:	00 
  8036da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036e1:	e8 ba 05 00 00       	call   803ca0 <_Z8ipc_recvPiPvS_>
}
  8036e6:	c9                   	leave  
  8036e7:	c3                   	ret    

008036e8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036e8:	55                   	push   %ebp
  8036e9:	89 e5                	mov    %esp,%ebp
  8036eb:	53                   	push   %ebx
  8036ec:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fc:	e8 a3 ff ff ff       	call   8036a4 <_ZL5nsipcj>
  803701:	89 c3                	mov    %eax,%ebx
  803703:	85 c0                	test   %eax,%eax
  803705:	78 27                	js     80372e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803707:	a1 10 70 80 00       	mov    0x807010,%eax
  80370c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803710:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803717:	00 
  803718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371b:	89 04 24             	mov    %eax,(%esp)
  80371e:	e8 d9 d3 ff ff       	call   800afc <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803723:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803729:	8b 45 10             	mov    0x10(%ebp),%eax
  80372c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80372e:	89 d8                	mov    %ebx,%eax
  803730:	83 c4 14             	add    $0x14,%esp
  803733:	5b                   	pop    %ebx
  803734:	5d                   	pop    %ebp
  803735:	c3                   	ret    

00803736 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
  803739:	53                   	push   %ebx
  80373a:	83 ec 14             	sub    $0x14,%esp
  80373d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803748:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80374c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803753:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80375a:	e8 9d d3 ff ff       	call   800afc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80375f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803765:	b8 02 00 00 00       	mov    $0x2,%eax
  80376a:	e8 35 ff ff ff       	call   8036a4 <_ZL5nsipcj>
}
  80376f:	83 c4 14             	add    $0x14,%esp
  803772:	5b                   	pop    %ebx
  803773:	5d                   	pop    %ebp
  803774:	c3                   	ret    

00803775 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803783:	8b 45 0c             	mov    0xc(%ebp),%eax
  803786:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80378b:	b8 03 00 00 00       	mov    $0x3,%eax
  803790:	e8 0f ff ff ff       	call   8036a4 <_ZL5nsipcj>
}
  803795:	c9                   	leave  
  803796:	c3                   	ret    

00803797 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803797:	55                   	push   %ebp
  803798:	89 e5                	mov    %esp,%ebp
  80379a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8037a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8037aa:	e8 f5 fe ff ff       	call   8036a4 <_ZL5nsipcj>
}
  8037af:	c9                   	leave  
  8037b0:	c3                   	ret    

008037b1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037b1:	55                   	push   %ebp
  8037b2:	89 e5                	mov    %esp,%ebp
  8037b4:	53                   	push   %ebx
  8037b5:	83 ec 14             	sub    $0x14,%esp
  8037b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ce:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8037d5:	e8 22 d3 ff ff       	call   800afc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8037da:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8037e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8037e5:	e8 ba fe ff ff       	call   8036a4 <_ZL5nsipcj>
}
  8037ea:	83 c4 14             	add    $0x14,%esp
  8037ed:	5b                   	pop    %ebx
  8037ee:	5d                   	pop    %ebp
  8037ef:	c3                   	ret    

008037f0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8037fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803801:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803806:	b8 06 00 00 00       	mov    $0x6,%eax
  80380b:	e8 94 fe ff ff       	call   8036a4 <_ZL5nsipcj>
}
  803810:	c9                   	leave  
  803811:	c3                   	ret    

00803812 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803812:	55                   	push   %ebp
  803813:	89 e5                	mov    %esp,%ebp
  803815:	56                   	push   %esi
  803816:	53                   	push   %ebx
  803817:	83 ec 10             	sub    $0x10,%esp
  80381a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803825:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80382b:	8b 45 14             	mov    0x14(%ebp),%eax
  80382e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803833:	b8 07 00 00 00       	mov    $0x7,%eax
  803838:	e8 67 fe ff ff       	call   8036a4 <_ZL5nsipcj>
  80383d:	89 c3                	mov    %eax,%ebx
  80383f:	85 c0                	test   %eax,%eax
  803841:	78 46                	js     803889 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803843:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803848:	7f 04                	jg     80384e <_Z10nsipc_recviPvij+0x3c>
  80384a:	39 f0                	cmp    %esi,%eax
  80384c:	7e 24                	jle    803872 <_Z10nsipc_recviPvij+0x60>
  80384e:	c7 44 24 0c 9f 4e 80 	movl   $0x804e9f,0xc(%esp)
  803855:	00 
  803856:	c7 44 24 08 0c 48 80 	movl   $0x80480c,0x8(%esp)
  80385d:	00 
  80385e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803865:	00 
  803866:	c7 04 24 b4 4e 80 00 	movl   $0x804eb4,(%esp)
  80386d:	e8 6a 02 00 00       	call   803adc <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803872:	89 44 24 08          	mov    %eax,0x8(%esp)
  803876:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80387d:	00 
  80387e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803881:	89 04 24             	mov    %eax,(%esp)
  803884:	e8 73 d2 ff ff       	call   800afc <memmove>
	}

	return r;
}
  803889:	89 d8                	mov    %ebx,%eax
  80388b:	83 c4 10             	add    $0x10,%esp
  80388e:	5b                   	pop    %ebx
  80388f:	5e                   	pop    %esi
  803890:	5d                   	pop    %ebp
  803891:	c3                   	ret    

00803892 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803892:	55                   	push   %ebp
  803893:	89 e5                	mov    %esp,%ebp
  803895:	53                   	push   %ebx
  803896:	83 ec 14             	sub    $0x14,%esp
  803899:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8038a4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8038aa:	7e 24                	jle    8038d0 <_Z10nsipc_sendiPKvij+0x3e>
  8038ac:	c7 44 24 0c c0 4e 80 	movl   $0x804ec0,0xc(%esp)
  8038b3:	00 
  8038b4:	c7 44 24 08 0c 48 80 	movl   $0x80480c,0x8(%esp)
  8038bb:	00 
  8038bc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8038c3:	00 
  8038c4:	c7 04 24 b4 4e 80 00 	movl   $0x804eb4,(%esp)
  8038cb:	e8 0c 02 00 00       	call   803adc <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038db:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8038e2:	e8 15 d2 ff ff       	call   800afc <memmove>
	nsipcbuf.send.req_size = size;
  8038e7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8038ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8038f0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8038f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8038fa:	e8 a5 fd ff ff       	call   8036a4 <_ZL5nsipcj>
}
  8038ff:	83 c4 14             	add    $0x14,%esp
  803902:	5b                   	pop    %ebx
  803903:	5d                   	pop    %ebp
  803904:	c3                   	ret    

00803905 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803905:	55                   	push   %ebp
  803906:	89 e5                	mov    %esp,%ebp
  803908:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803913:	8b 45 0c             	mov    0xc(%ebp),%eax
  803916:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80391b:	8b 45 10             	mov    0x10(%ebp),%eax
  80391e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803923:	b8 09 00 00 00       	mov    $0x9,%eax
  803928:	e8 77 fd ff ff       	call   8036a4 <_ZL5nsipcj>
}
  80392d:	c9                   	leave  
  80392e:	c3                   	ret    
	...

00803930 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803930:	55                   	push   %ebp
  803931:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803933:	b8 00 00 00 00       	mov    $0x0,%eax
  803938:	5d                   	pop    %ebp
  803939:	c3                   	ret    

0080393a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80393a:	55                   	push   %ebp
  80393b:	89 e5                	mov    %esp,%ebp
  80393d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803940:	c7 44 24 04 cc 4e 80 	movl   $0x804ecc,0x4(%esp)
  803947:	00 
  803948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80394b:	89 04 24             	mov    %eax,(%esp)
  80394e:	e8 07 d0 ff ff       	call   80095a <_Z6strcpyPcPKc>
	return 0;
}
  803953:	b8 00 00 00 00       	mov    $0x0,%eax
  803958:	c9                   	leave  
  803959:	c3                   	ret    

0080395a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80395a:	55                   	push   %ebp
  80395b:	89 e5                	mov    %esp,%ebp
  80395d:	57                   	push   %edi
  80395e:	56                   	push   %esi
  80395f:	53                   	push   %ebx
  803960:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803966:	bb 00 00 00 00       	mov    $0x0,%ebx
  80396b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80396f:	74 3e                	je     8039af <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803971:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803977:	8b 75 10             	mov    0x10(%ebp),%esi
  80397a:	29 de                	sub    %ebx,%esi
  80397c:	83 fe 7f             	cmp    $0x7f,%esi
  80397f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803984:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803987:	89 74 24 08          	mov    %esi,0x8(%esp)
  80398b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398e:	01 d8                	add    %ebx,%eax
  803990:	89 44 24 04          	mov    %eax,0x4(%esp)
  803994:	89 3c 24             	mov    %edi,(%esp)
  803997:	e8 60 d1 ff ff       	call   800afc <memmove>
		sys_cputs(buf, m);
  80399c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039a0:	89 3c 24             	mov    %edi,(%esp)
  8039a3:	e8 6c d3 ff ff       	call   800d14 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039a8:	01 f3                	add    %esi,%ebx
  8039aa:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8039ad:	77 c8                	ja     803977 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8039af:	89 d8                	mov    %ebx,%eax
  8039b1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8039b7:	5b                   	pop    %ebx
  8039b8:	5e                   	pop    %esi
  8039b9:	5f                   	pop    %edi
  8039ba:	5d                   	pop    %ebp
  8039bb:	c3                   	ret    

008039bc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
  8039bf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8039c2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8039c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8039cb:	75 07                	jne    8039d4 <_ZL12devcons_readP2FdPvj+0x18>
  8039cd:	eb 2a                	jmp    8039f9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8039cf:	e8 38 d4 ff ff       	call   800e0c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039d4:	e8 6e d3 ff ff       	call   800d47 <_Z9sys_cgetcv>
  8039d9:	85 c0                	test   %eax,%eax
  8039db:	74 f2                	je     8039cf <_ZL12devcons_readP2FdPvj+0x13>
  8039dd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8039df:	85 c0                	test   %eax,%eax
  8039e1:	78 16                	js     8039f9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8039e3:	83 f8 04             	cmp    $0x4,%eax
  8039e6:	74 0c                	je     8039f4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8039e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039eb:	88 10                	mov    %dl,(%eax)
	return 1;
  8039ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f2:	eb 05                	jmp    8039f9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8039f4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8039f9:	c9                   	leave  
  8039fa:	c3                   	ret    

008039fb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8039fb:	55                   	push   %ebp
  8039fc:	89 e5                	mov    %esp,%ebp
  8039fe:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803a01:	8b 45 08             	mov    0x8(%ebp),%eax
  803a04:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803a0e:	00 
  803a0f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a12:	89 04 24             	mov    %eax,(%esp)
  803a15:	e8 fa d2 ff ff       	call   800d14 <_Z9sys_cputsPKcj>
}
  803a1a:	c9                   	leave  
  803a1b:	c3                   	ret    

00803a1c <_Z7getcharv>:

int
getchar(void)
{
  803a1c:	55                   	push   %ebp
  803a1d:	89 e5                	mov    %esp,%ebp
  803a1f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a22:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a29:	00 
  803a2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a38:	e8 71 dc ff ff       	call   8016ae <_Z4readiPvj>
	if (r < 0)
  803a3d:	85 c0                	test   %eax,%eax
  803a3f:	78 0f                	js     803a50 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803a41:	85 c0                	test   %eax,%eax
  803a43:	7e 06                	jle    803a4b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803a45:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803a49:	eb 05                	jmp    803a50 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803a4b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803a50:	c9                   	leave  
  803a51:	c3                   	ret    

00803a52 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
  803a55:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803a58:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a5f:	00 
  803a60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a67:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6a:	89 04 24             	mov    %eax,(%esp)
  803a6d:	e8 8f d8 ff ff       	call   801301 <_Z9fd_lookupiPP2Fdb>
  803a72:	85 c0                	test   %eax,%eax
  803a74:	78 11                	js     803a87 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a79:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803a7f:	39 10                	cmp    %edx,(%eax)
  803a81:	0f 94 c0             	sete   %al
  803a84:	0f b6 c0             	movzbl %al,%eax
}
  803a87:	c9                   	leave  
  803a88:	c3                   	ret    

00803a89 <_Z8openconsv>:

int
opencons(void)
{
  803a89:	55                   	push   %ebp
  803a8a:	89 e5                	mov    %esp,%ebp
  803a8c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803a8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a92:	89 04 24             	mov    %eax,(%esp)
  803a95:	e8 1d d9 ff ff       	call   8013b7 <_Z14fd_find_unusedPP2Fd>
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	78 3c                	js     803ada <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a9e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803aa5:	00 
  803aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ab4:	e8 87 d3 ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	78 1d                	js     803ada <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803abd:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803ad2:	89 04 24             	mov    %eax,(%esp)
  803ad5:	e8 7a d8 ff ff       	call   801354 <_Z6fd2numP2Fd>
}
  803ada:	c9                   	leave  
  803adb:	c3                   	ret    

00803adc <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803adc:	55                   	push   %ebp
  803add:	89 e5                	mov    %esp,%ebp
  803adf:	56                   	push   %esi
  803ae0:	53                   	push   %ebx
  803ae1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  803ae4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  803ae7:	a1 00 80 80 00       	mov    0x808000,%eax
  803aec:	85 c0                	test   %eax,%eax
  803aee:	74 10                	je     803b00 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af4:	c7 04 24 d8 4e 80 00 	movl   $0x804ed8,(%esp)
  803afb:	e8 3e c8 ff ff       	call   80033e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803b00:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  803b06:	e8 cd d2 ff ff       	call   800dd8 <_Z12sys_getenvidv>
  803b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b0e:	89 54 24 10          	mov    %edx,0x10(%esp)
  803b12:	8b 55 08             	mov    0x8(%ebp),%edx
  803b15:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803b19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b21:	c7 04 24 e0 4e 80 00 	movl   $0x804ee0,(%esp)
  803b28:	e8 11 c8 ff ff       	call   80033e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  803b2d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b31:	8b 45 10             	mov    0x10(%ebp),%eax
  803b34:	89 04 24             	mov    %eax,(%esp)
  803b37:	e8 a1 c7 ff ff       	call   8002dd <_Z8vcprintfPKcPc>
	cprintf("\n");
  803b3c:	c7 04 24 23 4e 80 00 	movl   $0x804e23,(%esp)
  803b43:	e8 f6 c7 ff ff       	call   80033e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b48:	cc                   	int3   
  803b49:	eb fd                	jmp    803b48 <_Z6_panicPKciS0_z+0x6c>
  803b4b:	00 00                	add    %al,(%eax)
  803b4d:	00 00                	add    %al,(%eax)
	...

00803b50 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803b50:	55                   	push   %ebp
  803b51:	89 e5                	mov    %esp,%ebp
  803b53:	56                   	push   %esi
  803b54:	53                   	push   %ebx
  803b55:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803b58:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803b5d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  803b64:	85 c0                	test   %eax,%eax
  803b66:	74 08                	je     803b70 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803b68:	8d 55 08             	lea    0x8(%ebp),%edx
  803b6b:	89 14 24             	mov    %edx,(%esp)
  803b6e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803b70:	83 eb 01             	sub    $0x1,%ebx
  803b73:	83 fb ff             	cmp    $0xffffffff,%ebx
  803b76:	75 e5                	jne    803b5d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803b78:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803b7b:	8b 75 08             	mov    0x8(%ebp),%esi
  803b7e:	e8 55 d2 ff ff       	call   800dd8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803b83:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803b87:	89 74 24 10          	mov    %esi,0x10(%esp)
  803b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b8f:	c7 44 24 08 04 4f 80 	movl   $0x804f04,0x8(%esp)
  803b96:	00 
  803b97:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803b9e:	00 
  803b9f:	c7 04 24 88 4f 80 00 	movl   $0x804f88,(%esp)
  803ba6:	e8 31 ff ff ff       	call   803adc <_Z6_panicPKciS0_z>

00803bab <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803bab:	55                   	push   %ebp
  803bac:	89 e5                	mov    %esp,%ebp
  803bae:	56                   	push   %esi
  803baf:	53                   	push   %ebx
  803bb0:	83 ec 10             	sub    $0x10,%esp
  803bb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803bb6:	e8 1d d2 ff ff       	call   800dd8 <_Z12sys_getenvidv>
  803bbb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803bbd:	a1 00 60 80 00       	mov    0x806000,%eax
  803bc2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803bc5:	85 c0                	test   %eax,%eax
  803bc7:	75 4c                	jne    803c15 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803bc9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803bd0:	00 
  803bd1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803bd8:	ee 
  803bd9:	89 34 24             	mov    %esi,(%esp)
  803bdc:	e8 5f d2 ff ff       	call   800e40 <_Z14sys_page_allociPvi>
  803be1:	85 c0                	test   %eax,%eax
  803be3:	74 20                	je     803c05 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803be5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803be9:	c7 44 24 08 3c 4f 80 	movl   $0x804f3c,0x8(%esp)
  803bf0:	00 
  803bf1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803bf8:	00 
  803bf9:	c7 04 24 88 4f 80 00 	movl   $0x804f88,(%esp)
  803c00:	e8 d7 fe ff ff       	call   803adc <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803c05:	c7 44 24 04 50 3b 80 	movl   $0x803b50,0x4(%esp)
  803c0c:	00 
  803c0d:	89 34 24             	mov    %esi,(%esp)
  803c10:	e8 60 d4 ff ff       	call   801075 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803c15:	a1 20 80 80 00       	mov    0x808020,%eax
  803c1a:	39 d8                	cmp    %ebx,%eax
  803c1c:	74 1a                	je     803c38 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803c1e:	85 c0                	test   %eax,%eax
  803c20:	74 20                	je     803c42 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c22:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803c27:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  803c2e:	39 da                	cmp    %ebx,%edx
  803c30:	74 15                	je     803c47 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c32:	85 d2                	test   %edx,%edx
  803c34:	75 1f                	jne    803c55 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803c36:	eb 0f                	jmp    803c47 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c38:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3d:	8d 76 00             	lea    0x0(%esi),%esi
  803c40:	eb 05                	jmp    803c47 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c42:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803c47:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803c4e:	83 c4 10             	add    $0x10,%esp
  803c51:	5b                   	pop    %ebx
  803c52:	5e                   	pop    %esi
  803c53:	5d                   	pop    %ebp
  803c54:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c55:	83 c0 01             	add    $0x1,%eax
  803c58:	83 f8 08             	cmp    $0x8,%eax
  803c5b:	75 ca                	jne    803c27 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803c5d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803c61:	c7 44 24 08 60 4f 80 	movl   $0x804f60,0x8(%esp)
  803c68:	00 
  803c69:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803c70:	00 
  803c71:	c7 04 24 88 4f 80 00 	movl   $0x804f88,(%esp)
  803c78:	e8 5f fe ff ff       	call   803adc <_Z6_panicPKciS0_z>
  803c7d:	00 00                	add    %al,(%eax)
	...

00803c80 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803c80:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803c83:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803c84:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803c87:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803c8b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803c8f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803c92:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803c94:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803c98:	61                   	popa   
    popf
  803c99:	9d                   	popf   
    popl %esp
  803c9a:	5c                   	pop    %esp
    ret
  803c9b:	c3                   	ret    

00803c9c <spin>:

spin:	jmp spin
  803c9c:	eb fe                	jmp    803c9c <spin>
	...

00803ca0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ca0:	55                   	push   %ebp
  803ca1:	89 e5                	mov    %esp,%ebp
  803ca3:	56                   	push   %esi
  803ca4:	53                   	push   %ebx
  803ca5:	83 ec 10             	sub    $0x10,%esp
  803ca8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cae:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803cb1:	85 c0                	test   %eax,%eax
  803cb3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803cb8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803cbb:	89 04 24             	mov    %eax,(%esp)
  803cbe:	e8 48 d4 ff ff       	call   80110b <_Z12sys_ipc_recvPv>
  803cc3:	85 c0                	test   %eax,%eax
  803cc5:	79 16                	jns    803cdd <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803cc7:	85 db                	test   %ebx,%ebx
  803cc9:	74 06                	je     803cd1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803ccb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803cd1:	85 f6                	test   %esi,%esi
  803cd3:	74 53                	je     803d28 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803cd5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803cdb:	eb 4b                	jmp    803d28 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803cdd:	85 db                	test   %ebx,%ebx
  803cdf:	74 17                	je     803cf8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803ce1:	e8 f2 d0 ff ff       	call   800dd8 <_Z12sys_getenvidv>
  803ce6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ceb:	6b c0 78             	imul   $0x78,%eax,%eax
  803cee:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803cf3:	8b 40 60             	mov    0x60(%eax),%eax
  803cf6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803cf8:	85 f6                	test   %esi,%esi
  803cfa:	74 17                	je     803d13 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803cfc:	e8 d7 d0 ff ff       	call   800dd8 <_Z12sys_getenvidv>
  803d01:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d06:	6b c0 78             	imul   $0x78,%eax,%eax
  803d09:	05 00 00 00 ef       	add    $0xef000000,%eax
  803d0e:	8b 40 70             	mov    0x70(%eax),%eax
  803d11:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803d13:	e8 c0 d0 ff ff       	call   800dd8 <_Z12sys_getenvidv>
  803d18:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d1d:	6b c0 78             	imul   $0x78,%eax,%eax
  803d20:	05 08 00 00 ef       	add    $0xef000008,%eax
  803d25:	8b 40 60             	mov    0x60(%eax),%eax

}
  803d28:	83 c4 10             	add    $0x10,%esp
  803d2b:	5b                   	pop    %ebx
  803d2c:	5e                   	pop    %esi
  803d2d:	5d                   	pop    %ebp
  803d2e:	c3                   	ret    

00803d2f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d2f:	55                   	push   %ebp
  803d30:	89 e5                	mov    %esp,%ebp
  803d32:	57                   	push   %edi
  803d33:	56                   	push   %esi
  803d34:	53                   	push   %ebx
  803d35:	83 ec 1c             	sub    $0x1c,%esp
  803d38:	8b 75 08             	mov    0x8(%ebp),%esi
  803d3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803d3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803d41:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803d43:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803d48:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  803d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d52:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d56:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803d5a:	89 34 24             	mov    %esi,(%esp)
  803d5d:	e8 71 d3 ff ff       	call   8010d3 <_Z16sys_ipc_try_sendijPvi>
  803d62:	85 c0                	test   %eax,%eax
  803d64:	79 31                	jns    803d97 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803d66:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803d69:	75 0c                	jne    803d77 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803d6b:	90                   	nop
  803d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d70:	e8 97 d0 ff ff       	call   800e0c <_Z9sys_yieldv>
  803d75:	eb d4                	jmp    803d4b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d7b:	c7 44 24 08 96 4f 80 	movl   $0x804f96,0x8(%esp)
  803d82:	00 
  803d83:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803d8a:	00 
  803d8b:	c7 04 24 a3 4f 80 00 	movl   $0x804fa3,(%esp)
  803d92:	e8 45 fd ff ff       	call   803adc <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803d97:	83 c4 1c             	add    $0x1c,%esp
  803d9a:	5b                   	pop    %ebx
  803d9b:	5e                   	pop    %esi
  803d9c:	5f                   	pop    %edi
  803d9d:	5d                   	pop    %ebp
  803d9e:	c3                   	ret    
	...

00803da0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  803da0:	55                   	push   %ebp
  803da1:	89 e5                	mov    %esp,%ebp
  803da3:	57                   	push   %edi
  803da4:	56                   	push   %esi
  803da5:	53                   	push   %ebx
  803da6:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  803da9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  803daf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  803db2:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803db5:	8d 45 ef             	lea    -0x11(%ebp),%eax
  803db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  803dbb:	bb 40 80 80 00       	mov    $0x808040,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803dc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc3:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  803dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  803dcb:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  803dd0:	f6 e1                	mul    %cl
  803dd2:	66 c1 e8 08          	shr    $0x8,%ax
  803dd6:	c0 e8 03             	shr    $0x3,%al
  803dd9:	89 c6                	mov    %eax,%esi
  803ddb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  803dde:	01 c0                	add    %eax,%eax
  803de0:	28 c1                	sub    %al,%cl
  803de2:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  803de4:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  803de6:	0f b6 fa             	movzbl %dl,%edi
  803de9:	83 c0 30             	add    $0x30,%eax
  803dec:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  803df0:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  803df3:	84 c9                	test   %cl,%cl
  803df5:	75 d4                	jne    803dcb <inet_ntoa+0x2b>
  803df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dfa:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  803dfc:	84 d2                	test   %dl,%dl
  803dfe:	74 24                	je     803e24 <inet_ntoa+0x84>
  803e00:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803e03:	0f b6 fa             	movzbl %dl,%edi
  803e06:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  803e0a:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  803e0c:	0f b6 ca             	movzbl %dl,%ecx
  803e0f:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  803e14:	88 08                	mov    %cl,(%eax)
  803e16:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  803e19:	83 ea 01             	sub    $0x1,%edx
  803e1c:	39 f0                	cmp    %esi,%eax
  803e1e:	75 ec                	jne    803e0c <inet_ntoa+0x6c>
  803e20:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  803e24:	c6 03 2e             	movb   $0x2e,(%ebx)
  803e27:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  803e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e2d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  803e30:	74 06                	je     803e38 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  803e32:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  803e36:	eb 88                	jmp    803dc0 <inet_ntoa+0x20>
  }
  *--rp = 0;
  803e38:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  803e3c:	b8 40 80 80 00       	mov    $0x808040,%eax
  803e41:	83 c4 18             	add    $0x18,%esp
  803e44:	5b                   	pop    %ebx
  803e45:	5e                   	pop    %esi
  803e46:	5f                   	pop    %edi
  803e47:	5d                   	pop    %ebp
  803e48:	c3                   	ret    

00803e49 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  803e49:	55                   	push   %ebp
  803e4a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  803e4c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  803e50:	66 c1 c0 08          	rol    $0x8,%ax
}
  803e54:	5d                   	pop    %ebp
  803e55:	c3                   	ret    

00803e56 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  803e56:	55                   	push   %ebp
  803e57:	89 e5                	mov    %esp,%ebp
  803e59:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  803e5c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  803e60:	89 04 24             	mov    %eax,(%esp)
  803e63:	e8 e1 ff ff ff       	call   803e49 <htons>
}
  803e68:	c9                   	leave  
  803e69:	c3                   	ret    

00803e6a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  803e6a:	55                   	push   %ebp
  803e6b:	89 e5                	mov    %esp,%ebp
  803e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  803e70:	89 d1                	mov    %edx,%ecx
  803e72:	c1 e9 18             	shr    $0x18,%ecx
  803e75:	89 d0                	mov    %edx,%eax
  803e77:	c1 e0 18             	shl    $0x18,%eax
  803e7a:	09 c8                	or     %ecx,%eax
  803e7c:	89 d1                	mov    %edx,%ecx
  803e7e:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  803e84:	c1 e1 08             	shl    $0x8,%ecx
  803e87:	09 c8                	or     %ecx,%eax
  803e89:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  803e8f:	c1 ea 08             	shr    $0x8,%edx
  803e92:	09 d0                	or     %edx,%eax
}
  803e94:	5d                   	pop    %ebp
  803e95:	c3                   	ret    

00803e96 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803e96:	55                   	push   %ebp
  803e97:	89 e5                	mov    %esp,%ebp
  803e99:	57                   	push   %edi
  803e9a:	56                   	push   %esi
  803e9b:	53                   	push   %ebx
  803e9c:	83 ec 28             	sub    $0x28,%esp
  803e9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  803ea2:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803ea5:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  803ea8:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803ead:	80 fb 09             	cmp    $0x9,%bl
  803eb0:	0f 87 c4 01 00 00    	ja     80407a <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803eb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803eb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803ebc:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  803ebf:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  803ec2:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  803ec9:	83 fa 30             	cmp    $0x30,%edx
  803ecc:	75 25                	jne    803ef3 <inet_aton+0x5d>
      c = *++cp;
  803ece:	83 c1 01             	add    $0x1,%ecx
  803ed1:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  803ed4:	83 fa 78             	cmp    $0x78,%edx
  803ed7:	74 0c                	je     803ee5 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  803ed9:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  803ee0:	83 fa 58             	cmp    $0x58,%edx
  803ee3:	75 0e                	jne    803ef3 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  803ee5:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  803ee9:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  803eec:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  803ef3:	8d 41 01             	lea    0x1(%ecx),%eax
  803ef6:	be 00 00 00 00       	mov    $0x0,%esi
  803efb:	eb 03                	jmp    803f00 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  803efd:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  803f00:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  803f03:	89 d1                	mov    %edx,%ecx
  803f05:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  803f08:	80 fb 09             	cmp    $0x9,%bl
  803f0b:	77 0d                	ja     803f1a <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  803f0d:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  803f11:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  803f15:	0f be 10             	movsbl (%eax),%edx
  803f18:	eb e3                	jmp    803efd <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  803f1a:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  803f1e:	0f 85 5e 01 00 00    	jne    804082 <inet_aton+0x1ec>
  803f24:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  803f27:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  803f2a:	80 fb 05             	cmp    $0x5,%bl
  803f2d:	76 0c                	jbe    803f3b <inet_aton+0xa5>
  803f2f:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  803f32:	80 fb 05             	cmp    $0x5,%bl
  803f35:	0f 87 4d 01 00 00    	ja     804088 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803f3b:	89 f1                	mov    %esi,%ecx
  803f3d:	c1 e1 04             	shl    $0x4,%ecx
  803f40:	8d 72 0a             	lea    0xa(%edx),%esi
  803f43:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  803f47:	19 d2                	sbb    %edx,%edx
  803f49:	83 e2 20             	and    $0x20,%edx
  803f4c:	83 c2 41             	add    $0x41,%edx
  803f4f:	29 d6                	sub    %edx,%esi
  803f51:	09 ce                	or     %ecx,%esi
        c = *++cp;
  803f53:	0f be 10             	movsbl (%eax),%edx
  803f56:	eb a5                	jmp    803efd <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f5b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  803f5e:	0f 83 0a 01 00 00    	jae    80406e <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  803f64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f67:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  803f69:	8d 4f 01             	lea    0x1(%edi),%ecx
  803f6c:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803f70:	8d 42 d0             	lea    -0x30(%edx),%eax
  803f73:	3c 09                	cmp    $0x9,%al
  803f75:	0f 87 fa 00 00 00    	ja     804075 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  803f7b:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  803f7f:	e9 3e ff ff ff       	jmp    803ec2 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  803f84:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  803f89:	80 f9 1f             	cmp    $0x1f,%cl
  803f8c:	0f 86 e8 00 00 00    	jbe    80407a <inet_aton+0x1e4>
  803f92:	84 d2                	test   %dl,%dl
  803f94:	0f 88 e0 00 00 00    	js     80407a <inet_aton+0x1e4>
  803f9a:	83 fa 20             	cmp    $0x20,%edx
  803f9d:	74 1d                	je     803fbc <inet_aton+0x126>
  803f9f:	83 fa 0c             	cmp    $0xc,%edx
  803fa2:	74 18                	je     803fbc <inet_aton+0x126>
  803fa4:	83 fa 0a             	cmp    $0xa,%edx
  803fa7:	74 13                	je     803fbc <inet_aton+0x126>
  803fa9:	83 fa 0d             	cmp    $0xd,%edx
  803fac:	74 0e                	je     803fbc <inet_aton+0x126>
  803fae:	83 fa 09             	cmp    $0x9,%edx
  803fb1:	74 09                	je     803fbc <inet_aton+0x126>
  803fb3:	83 fa 0b             	cmp    $0xb,%edx
  803fb6:	0f 85 be 00 00 00    	jne    80407a <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  803fbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803fbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803fc2:	29 c2                	sub    %eax,%edx
  803fc4:	c1 fa 02             	sar    $0x2,%edx
  803fc7:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  803fca:	83 fa 02             	cmp    $0x2,%edx
  803fcd:	74 25                	je     803ff4 <inet_aton+0x15e>
  803fcf:	83 fa 02             	cmp    $0x2,%edx
  803fd2:	7f 0f                	jg     803fe3 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  803fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  803fd9:	85 d2                	test   %edx,%edx
  803fdb:	0f 84 99 00 00 00    	je     80407a <inet_aton+0x1e4>
  803fe1:	eb 6c                	jmp    80404f <inet_aton+0x1b9>
  803fe3:	83 fa 03             	cmp    $0x3,%edx
  803fe6:	74 23                	je     80400b <inet_aton+0x175>
  803fe8:	83 fa 04             	cmp    $0x4,%edx
  803feb:	90                   	nop
  803fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ff0:	75 5d                	jne    80404f <inet_aton+0x1b9>
  803ff2:	eb 36                	jmp    80402a <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  803ff4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  803ff9:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  803fff:	77 79                	ja     80407a <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  804001:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804004:	c1 e6 18             	shl    $0x18,%esi
  804007:	09 de                	or     %ebx,%esi
    break;
  804009:	eb 44                	jmp    80404f <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  80400b:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804010:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  804016:	77 62                	ja     80407a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  804018:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80401b:	c1 e6 10             	shl    $0x10,%esi
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	c1 e0 18             	shl    $0x18,%eax
  804024:	09 c6                	or     %eax,%esi
  804026:	09 de                	or     %ebx,%esi
    break;
  804028:	eb 25                	jmp    80404f <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  80402a:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80402f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  804035:	77 43                	ja     80407a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804037:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80403a:	c1 e6 10             	shl    $0x10,%esi
  80403d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804040:	c1 e0 18             	shl    $0x18,%eax
  804043:	09 c6                	or     %eax,%esi
  804045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804048:	c1 e0 08             	shl    $0x8,%eax
  80404b:	09 c6                	or     %eax,%esi
  80404d:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  80404f:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804054:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804058:	74 20                	je     80407a <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  80405a:	89 34 24             	mov    %esi,(%esp)
  80405d:	e8 08 fe ff ff       	call   803e6a <htonl>
  804062:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  804065:	89 03                	mov    %eax,(%ebx)
  return (1);
  804067:	b8 01 00 00 00       	mov    $0x1,%eax
  80406c:	eb 0c                	jmp    80407a <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80406e:	b8 00 00 00 00       	mov    $0x0,%eax
  804073:	eb 05                	jmp    80407a <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  804075:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  80407a:	83 c4 28             	add    $0x28,%esp
  80407d:	5b                   	pop    %ebx
  80407e:	5e                   	pop    %esi
  80407f:	5f                   	pop    %edi
  804080:	5d                   	pop    %ebp
  804081:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804082:	89 d0                	mov    %edx,%eax
  804084:	89 f3                	mov    %esi,%ebx
  804086:	eb 04                	jmp    80408c <inet_aton+0x1f6>
  804088:	89 d0                	mov    %edx,%eax
  80408a:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  80408c:	83 f8 2e             	cmp    $0x2e,%eax
  80408f:	0f 84 c3 fe ff ff    	je     803f58 <inet_aton+0xc2>
  804095:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804097:	85 d2                	test   %edx,%edx
  804099:	0f 84 1d ff ff ff    	je     803fbc <inet_aton+0x126>
  80409f:	e9 e0 fe ff ff       	jmp    803f84 <inet_aton+0xee>

008040a4 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8040a4:	55                   	push   %ebp
  8040a5:	89 e5                	mov    %esp,%ebp
  8040a7:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8040aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8040ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b4:	89 04 24             	mov    %eax,(%esp)
  8040b7:	e8 da fd ff ff       	call   803e96 <inet_aton>
  8040bc:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  8040be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8040c3:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8040c7:	c9                   	leave  
  8040c8:	c3                   	ret    

008040c9 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8040c9:	55                   	push   %ebp
  8040ca:	89 e5                	mov    %esp,%ebp
  8040cc:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8040cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d2:	89 04 24             	mov    %eax,(%esp)
  8040d5:	e8 90 fd ff ff       	call   803e6a <htonl>
}
  8040da:	c9                   	leave  
  8040db:	c3                   	ret    
  8040dc:	00 00                	add    %al,(%eax)
	...

008040e0 <__udivdi3>:
  8040e0:	55                   	push   %ebp
  8040e1:	89 e5                	mov    %esp,%ebp
  8040e3:	57                   	push   %edi
  8040e4:	56                   	push   %esi
  8040e5:	83 ec 20             	sub    $0x20,%esp
  8040e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8040eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8040ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8040f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8040f4:	85 c0                	test   %eax,%eax
  8040f6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8040f9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8040fc:	75 3a                	jne    804138 <__udivdi3+0x58>
  8040fe:	39 f9                	cmp    %edi,%ecx
  804100:	77 66                	ja     804168 <__udivdi3+0x88>
  804102:	85 c9                	test   %ecx,%ecx
  804104:	75 0b                	jne    804111 <__udivdi3+0x31>
  804106:	b8 01 00 00 00       	mov    $0x1,%eax
  80410b:	31 d2                	xor    %edx,%edx
  80410d:	f7 f1                	div    %ecx
  80410f:	89 c1                	mov    %eax,%ecx
  804111:	89 f8                	mov    %edi,%eax
  804113:	31 d2                	xor    %edx,%edx
  804115:	f7 f1                	div    %ecx
  804117:	89 c7                	mov    %eax,%edi
  804119:	89 f0                	mov    %esi,%eax
  80411b:	f7 f1                	div    %ecx
  80411d:	89 fa                	mov    %edi,%edx
  80411f:	89 c6                	mov    %eax,%esi
  804121:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804124:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80412a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80412d:	83 c4 20             	add    $0x20,%esp
  804130:	5e                   	pop    %esi
  804131:	5f                   	pop    %edi
  804132:	5d                   	pop    %ebp
  804133:	c3                   	ret    
  804134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804138:	31 d2                	xor    %edx,%edx
  80413a:	31 f6                	xor    %esi,%esi
  80413c:	39 f8                	cmp    %edi,%eax
  80413e:	77 e1                	ja     804121 <__udivdi3+0x41>
  804140:	0f bd d0             	bsr    %eax,%edx
  804143:	83 f2 1f             	xor    $0x1f,%edx
  804146:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804149:	75 2d                	jne    804178 <__udivdi3+0x98>
  80414b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80414e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804151:	76 06                	jbe    804159 <__udivdi3+0x79>
  804153:	39 f8                	cmp    %edi,%eax
  804155:	89 f2                	mov    %esi,%edx
  804157:	73 c8                	jae    804121 <__udivdi3+0x41>
  804159:	31 d2                	xor    %edx,%edx
  80415b:	be 01 00 00 00       	mov    $0x1,%esi
  804160:	eb bf                	jmp    804121 <__udivdi3+0x41>
  804162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804168:	89 f0                	mov    %esi,%eax
  80416a:	89 fa                	mov    %edi,%edx
  80416c:	f7 f1                	div    %ecx
  80416e:	31 d2                	xor    %edx,%edx
  804170:	89 c6                	mov    %eax,%esi
  804172:	eb ad                	jmp    804121 <__udivdi3+0x41>
  804174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804178:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80417c:	89 c2                	mov    %eax,%edx
  80417e:	b8 20 00 00 00       	mov    $0x20,%eax
  804183:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804186:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804189:	d3 e2                	shl    %cl,%edx
  80418b:	89 c1                	mov    %eax,%ecx
  80418d:	d3 ee                	shr    %cl,%esi
  80418f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804193:	09 d6                	or     %edx,%esi
  804195:	89 fa                	mov    %edi,%edx
  804197:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80419a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80419d:	d3 e6                	shl    %cl,%esi
  80419f:	89 c1                	mov    %eax,%ecx
  8041a1:	d3 ea                	shr    %cl,%edx
  8041a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041a7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8041aa:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8041ad:	d3 e7                	shl    %cl,%edi
  8041af:	89 c1                	mov    %eax,%ecx
  8041b1:	d3 ee                	shr    %cl,%esi
  8041b3:	09 fe                	or     %edi,%esi
  8041b5:	89 f0                	mov    %esi,%eax
  8041b7:	f7 75 e4             	divl   -0x1c(%ebp)
  8041ba:	89 d7                	mov    %edx,%edi
  8041bc:	89 c6                	mov    %eax,%esi
  8041be:	f7 65 f0             	mull   -0x10(%ebp)
  8041c1:	39 d7                	cmp    %edx,%edi
  8041c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8041c6:	72 12                	jb     8041da <__udivdi3+0xfa>
  8041c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041cb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041cf:	d3 e2                	shl    %cl,%edx
  8041d1:	39 c2                	cmp    %eax,%edx
  8041d3:	73 08                	jae    8041dd <__udivdi3+0xfd>
  8041d5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8041d8:	75 03                	jne    8041dd <__udivdi3+0xfd>
  8041da:	83 ee 01             	sub    $0x1,%esi
  8041dd:	31 d2                	xor    %edx,%edx
  8041df:	e9 3d ff ff ff       	jmp    804121 <__udivdi3+0x41>
	...

008041f0 <__umoddi3>:
  8041f0:	55                   	push   %ebp
  8041f1:	89 e5                	mov    %esp,%ebp
  8041f3:	57                   	push   %edi
  8041f4:	56                   	push   %esi
  8041f5:	83 ec 20             	sub    $0x20,%esp
  8041f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8041fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8041fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804201:	8b 75 0c             	mov    0xc(%ebp),%esi
  804204:	85 ff                	test   %edi,%edi
  804206:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804209:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80420c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80420f:	89 f2                	mov    %esi,%edx
  804211:	75 15                	jne    804228 <__umoddi3+0x38>
  804213:	39 f1                	cmp    %esi,%ecx
  804215:	76 41                	jbe    804258 <__umoddi3+0x68>
  804217:	f7 f1                	div    %ecx
  804219:	89 d0                	mov    %edx,%eax
  80421b:	31 d2                	xor    %edx,%edx
  80421d:	83 c4 20             	add    $0x20,%esp
  804220:	5e                   	pop    %esi
  804221:	5f                   	pop    %edi
  804222:	5d                   	pop    %ebp
  804223:	c3                   	ret    
  804224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804228:	39 f7                	cmp    %esi,%edi
  80422a:	77 4c                	ja     804278 <__umoddi3+0x88>
  80422c:	0f bd c7             	bsr    %edi,%eax
  80422f:	83 f0 1f             	xor    $0x1f,%eax
  804232:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804235:	75 51                	jne    804288 <__umoddi3+0x98>
  804237:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80423a:	0f 87 e8 00 00 00    	ja     804328 <__umoddi3+0x138>
  804240:	89 f2                	mov    %esi,%edx
  804242:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804245:	29 ce                	sub    %ecx,%esi
  804247:	19 fa                	sbb    %edi,%edx
  804249:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80424c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80424f:	83 c4 20             	add    $0x20,%esp
  804252:	5e                   	pop    %esi
  804253:	5f                   	pop    %edi
  804254:	5d                   	pop    %ebp
  804255:	c3                   	ret    
  804256:	66 90                	xchg   %ax,%ax
  804258:	85 c9                	test   %ecx,%ecx
  80425a:	75 0b                	jne    804267 <__umoddi3+0x77>
  80425c:	b8 01 00 00 00       	mov    $0x1,%eax
  804261:	31 d2                	xor    %edx,%edx
  804263:	f7 f1                	div    %ecx
  804265:	89 c1                	mov    %eax,%ecx
  804267:	89 f0                	mov    %esi,%eax
  804269:	31 d2                	xor    %edx,%edx
  80426b:	f7 f1                	div    %ecx
  80426d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804270:	eb a5                	jmp    804217 <__umoddi3+0x27>
  804272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804278:	89 f2                	mov    %esi,%edx
  80427a:	83 c4 20             	add    $0x20,%esp
  80427d:	5e                   	pop    %esi
  80427e:	5f                   	pop    %edi
  80427f:	5d                   	pop    %ebp
  804280:	c3                   	ret    
  804281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804288:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80428c:	89 f2                	mov    %esi,%edx
  80428e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804291:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804298:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80429b:	d3 e7                	shl    %cl,%edi
  80429d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042a4:	d3 e8                	shr    %cl,%eax
  8042a6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042aa:	09 f8                	or     %edi,%eax
  8042ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8042af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b2:	d3 e0                	shl    %cl,%eax
  8042b4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042be:	d3 ea                	shr    %cl,%edx
  8042c0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042c4:	d3 e6                	shl    %cl,%esi
  8042c6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042ca:	d3 e8                	shr    %cl,%eax
  8042cc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042d0:	09 f0                	or     %esi,%eax
  8042d2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8042d5:	f7 75 e4             	divl   -0x1c(%ebp)
  8042d8:	d3 e6                	shl    %cl,%esi
  8042da:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8042dd:	89 d6                	mov    %edx,%esi
  8042df:	f7 65 f4             	mull   -0xc(%ebp)
  8042e2:	89 d7                	mov    %edx,%edi
  8042e4:	89 c2                	mov    %eax,%edx
  8042e6:	39 fe                	cmp    %edi,%esi
  8042e8:	89 f9                	mov    %edi,%ecx
  8042ea:	72 30                	jb     80431c <__umoddi3+0x12c>
  8042ec:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8042ef:	72 27                	jb     804318 <__umoddi3+0x128>
  8042f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042f4:	29 d0                	sub    %edx,%eax
  8042f6:	19 ce                	sbb    %ecx,%esi
  8042f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042fc:	89 f2                	mov    %esi,%edx
  8042fe:	d3 e8                	shr    %cl,%eax
  804300:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804304:	d3 e2                	shl    %cl,%edx
  804306:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80430a:	09 d0                	or     %edx,%eax
  80430c:	89 f2                	mov    %esi,%edx
  80430e:	d3 ea                	shr    %cl,%edx
  804310:	83 c4 20             	add    $0x20,%esp
  804313:	5e                   	pop    %esi
  804314:	5f                   	pop    %edi
  804315:	5d                   	pop    %ebp
  804316:	c3                   	ret    
  804317:	90                   	nop
  804318:	39 fe                	cmp    %edi,%esi
  80431a:	75 d5                	jne    8042f1 <__umoddi3+0x101>
  80431c:	89 f9                	mov    %edi,%ecx
  80431e:	89 c2                	mov    %eax,%edx
  804320:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804323:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804326:	eb c9                	jmp    8042f1 <__umoddi3+0x101>
  804328:	39 f7                	cmp    %esi,%edi
  80432a:	0f 82 10 ff ff ff    	jb     804240 <__umoddi3+0x50>
  804330:	e9 17 ff ff ff       	jmp    80424c <__umoddi3+0x5c>
