
obj/user/httpd:     file format elf32-i386


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
  80002c:	e8 f7 02 00 00       	call   800328 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL3diePKc>:
	{404, "Not Found"},
};

static void
die(const char *m)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  80003a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003e:	c7 04 24 00 47 80 00 	movl   $0x804700,(%esp)
  800045:	e8 80 04 00 00       	call   8004ca <_Z7cprintfPKcz>
	exit();
  80004a:	e8 41 03 00 00       	call   800390 <_Z4exitv>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <_ZL13handle_clienti>:
	return r;
}

static void
handle_client(int sock)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	81 ec 3c 04 00 00    	sub    $0x43c,%esp
  80005d:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800066:	00 
  800067:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800071:	89 1c 24             	mov    %ebx,(%esp)
  800074:	e8 c5 17 00 00       	call   80183e <_Z4readiPvj>
  800079:	85 c0                	test   %eax,%eax
  80007b:	79 1c                	jns    800099 <_ZL13handle_clienti+0x48>
			panic("failed to read");
  80007d:	c7 44 24 08 04 47 80 	movl   $0x804704,0x8(%esp)
  800084:	00 
  800085:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  80008c:	00 
  80008d:	c7 04 24 13 47 80 00 	movl   $0x804713,(%esp)
  800094:	e8 13 03 00 00       	call   8003ac <_Z6_panicPKciS0_z>

		memset(req, 0, sizeof(req));
  800099:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  8000a0:	00 
  8000a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000a8:	00 
  8000a9:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000ac:	89 04 24             	mov    %eax,(%esp)
  8000af:	e8 7d 0b 00 00       	call   800c31 <memset>

		req->sock = sock;
  8000b4:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  8000b7:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 20 47 80 	movl   $0x804720,0x4(%esp)
  8000c6:	00 

		memset(req, 0, sizeof(req));

		req->sock = sock;

		r = http_request_parse(req, buffer);
  8000c7:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  8000cd:	89 04 24             	mov    %eax,(%esp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  8000d0:	e8 c5 0a 00 00       	call   800b9a <_Z7strncmpPKcS0_j>
  8000d5:	85 c0                	test   %eax,%eax
  8000d7:	0f 85 c5 00 00 00    	jne    8001a2 <_ZL13handle_clienti+0x151>
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  8000dd:	0f b6 85 e0 fd ff ff 	movzbl -0x220(%ebp),%eax
  8000e4:	84 c0                	test   %al,%al
  8000e6:	74 1a                	je     800102 <_ZL13handle_clienti+0xb1>
  8000e8:	3c 20                	cmp    $0x20,%al
  8000ea:	74 16                	je     800102 <_ZL13handle_clienti+0xb1>

	if (strncmp(request, "GET ", 4) != 0)
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  8000ec:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  8000f2:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  8000f5:	0f b6 03             	movzbl (%ebx),%eax
  8000f8:	84 c0                	test   %al,%al
  8000fa:	74 0c                	je     800108 <_ZL13handle_clienti+0xb7>
  8000fc:	3c 20                	cmp    $0x20,%al
  8000fe:	75 f2                	jne    8000f2 <_ZL13handle_clienti+0xa1>
  800100:	eb 06                	jmp    800108 <_ZL13handle_clienti+0xb7>

	if (strncmp(request, "GET ", 4) != 0)
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  800102:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800108:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
	url_len = request - url;
  80010e:	89 de                	mov    %ebx,%esi
  800110:	29 fe                	sub    %edi,%esi

	req->url = (char *)malloc(url_len + 1);
  800112:	8d 46 01             	lea    0x1(%esi),%eax
  800115:	89 04 24             	mov    %eax,(%esp)
  800118:	e8 75 3a 00 00       	call   803b92 <_Z6mallocj>
  80011d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  800120:	89 74 24 08          	mov    %esi,0x8(%esp)

	if (strncmp(request, "GET ", 4) != 0)
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  800124:	89 7c 24 04          	mov    %edi,0x4(%esp)
	while (*request && *request != ' ')
		request++;
	url_len = request - url;

	req->url = (char *)malloc(url_len + 1);
	memmove(req->url, url, url_len);
  800128:	89 04 24             	mov    %eax,(%esp)
  80012b:	e8 5c 0b 00 00       	call   800c8c <memmove>
	req->url[url_len] = '\0';
  800130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800133:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)

	// skip space
	request++;
  800137:	8d 73 01             	lea    0x1(%ebx),%esi

	version = request;
	while (*request && *request != '\n')
  80013a:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  80013e:	84 c0                	test   %al,%al
  800140:	74 16                	je     800158 <_ZL13handle_clienti+0x107>
  800142:	3c 0a                	cmp    $0xa,%al
  800144:	74 12                	je     800158 <_ZL13handle_clienti+0x107>
	req->url = (char *)malloc(url_len + 1);
	memmove(req->url, url, url_len);
	req->url[url_len] = '\0';

	// skip space
	request++;
  800146:	89 f3                	mov    %esi,%ebx

	version = request;
	while (*request && *request != '\n')
		request++;
  800148:	83 c3 01             	add    $0x1,%ebx

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  80014b:	0f b6 03             	movzbl (%ebx),%eax
  80014e:	84 c0                	test   %al,%al
  800150:	74 08                	je     80015a <_ZL13handle_clienti+0x109>
  800152:	3c 0a                	cmp    $0xa,%al
  800154:	75 f2                	jne    800148 <_ZL13handle_clienti+0xf7>
  800156:	eb 02                	jmp    80015a <_ZL13handle_clienti+0x109>
	req->url = (char *)malloc(url_len + 1);
	memmove(req->url, url, url_len);
	req->url[url_len] = '\0';

	// skip space
	request++;
  800158:	89 f3                	mov    %esi,%ebx

	version = request;
	while (*request && *request != '\n')
		request++;
	version_len = request - version;
  80015a:	29 f3                	sub    %esi,%ebx

	req->version = (char *)malloc(version_len + 1);
  80015c:	8d 43 01             	lea    0x1(%ebx),%eax
  80015f:	89 04 24             	mov    %eax,(%esp)
  800162:	e8 2b 3a 00 00       	call   803b92 <_Z6mallocj>
  800167:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80016a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80016e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800172:	89 04 24             	mov    %eax,(%esp)
  800175:	e8 12 0b 00 00       	call   800c8c <memmove>
	req->version[version_len] = '\0';
  80017a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017d:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	panic("send_file not implemented");
  800181:	c7 44 24 08 25 47 80 	movl   $0x804725,0x8(%esp)
  800188:	00 
  800189:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  800190:	00 
  800191:	c7 04 24 13 47 80 00 	movl   $0x804713,(%esp)
  800198:	e8 0f 02 00 00       	call   8003ac <_Z6_panicPKciS0_z>

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
		if (e->code == code)
			break;
		e++;
  80019d:	83 c0 08             	add    $0x8,%eax
  8001a0:	eb 05                	jmp    8001a7 <_ZL13handle_clienti+0x156>
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  8001a2:	b8 10 60 80 00       	mov    $0x806010,%eax
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  8001a7:	8b 10                	mov    (%eax),%edx
  8001a9:	85 d2                	test   %edx,%edx
  8001ab:	74 52                	je     8001ff <_ZL13handle_clienti+0x1ae>
  8001ad:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8001b1:	74 08                	je     8001bb <_ZL13handle_clienti+0x16a>
		if (e->code == code)
  8001b3:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  8001b9:	75 e2                	jne    80019d <_ZL13handle_clienti+0x14c>
			       "Server: jhttpd/" VERSION "\r\n"
			       "Connection: close"
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);
  8001bb:	8b 40 04             	mov    0x4(%eax),%eax
  8001be:	89 44 24 18          	mov    %eax,0x18(%esp)
  8001c2:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ce:	c7 44 24 08 74 47 80 	movl   $0x804774,0x8(%esp)
  8001d5:	00 
  8001d6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8001dd:	00 
  8001de:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  8001e4:	89 34 24             	mov    %esi,(%esp)
  8001e7:	e8 95 08 00 00       	call   800a81 <_Z8snprintfPciPKcz>

	if (write(req->sock, buf, r) != r)
  8001ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f7:	89 04 24             	mov    %eax,(%esp)
  8001fa:	e8 2a 17 00 00       	call   801929 <_Z5writeiPKvj>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  8001ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800202:	89 04 24             	mov    %eax,(%esp)
  800205:	e8 b6 38 00 00       	call   803ac0 <_Z4freePv>
	free(req->version);
  80020a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020d:	89 04 24             	mov    %eax,(%esp)
  800210:	e8 ab 38 00 00       	call   803ac0 <_Z4freePv>

		// no keep alive
		break;
	}

	close(sock);
  800215:	89 1c 24             	mov    %ebx,(%esp)
  800218:	e8 78 14 00 00       	call   801695 <_Z5closei>
}
  80021d:	81 c4 3c 04 00 00    	add    $0x43c,%esp
  800223:	5b                   	pop    %ebx
  800224:	5e                   	pop    %esi
  800225:	5f                   	pop    %edi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  800231:	c7 05 20 60 80 00 3f 	movl   $0x80473f,0x806020
  800238:	47 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  80023b:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800242:	00 
  800243:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80024a:	00 
  80024b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800252:	e8 ad 35 00 00       	call   803804 <_Z6socketiii>
  800257:	89 c6                	mov    %eax,%esi
  800259:	85 c0                	test   %eax,%eax
  80025b:	79 0a                	jns    800267 <_Z5umainiPPc+0x3f>
		die("Failed to create socket");
  80025d:	b8 46 47 80 00       	mov    $0x804746,%eax
  800262:	e8 cd fd ff ff       	call   800034 <_ZL3diePKc>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800267:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  80026e:	00 
  80026f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800276:	00 
  800277:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
  80027a:	89 1c 24             	mov    %ebx,(%esp)
  80027d:	e8 af 09 00 00       	call   800c31 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  800282:	c6 45 d5 02          	movb   $0x2,-0x2b(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80028d:	e8 88 3f 00 00       	call   80421a <htonl>
  800292:	89 45 d8             	mov    %eax,-0x28(%ebp)
	server.sin_port = htons(PORT);			// server port
  800295:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  80029c:	e8 58 3f 00 00       	call   8041f9 <htons>
  8002a1:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
		 sizeof(server)) < 0)
  8002a5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8002ac:	00 
  8002ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b1:	89 34 24             	mov    %esi,(%esp)
  8002b4:	e8 b1 34 00 00       	call   80376a <_Z4bindiP8sockaddrj>
	server.sin_family = AF_INET;			// Internet/IP
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
	server.sin_port = htons(PORT);			// server port

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	79 0a                	jns    8002c7 <_Z5umainiPPc+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  8002bd:	b8 f0 47 80 00       	mov    $0x8047f0,%eax
  8002c2:	e8 6d fd ff ff       	call   800034 <_ZL3diePKc>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  8002c7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  8002ce:	00 
  8002cf:	89 34 24             	mov    %esi,(%esp)
  8002d2:	e8 0a 35 00 00       	call   8037e1 <_Z6listenii>
  8002d7:	85 c0                	test   %eax,%eax
  8002d9:	79 0a                	jns    8002e5 <_Z5umainiPPc+0xbd>
		die("Failed to listen on server socket");
  8002db:	b8 14 48 80 00       	mov    $0x804814,%eax
  8002e0:	e8 4f fd ff ff       	call   800034 <_ZL3diePKc>

	cprintf("Waiting for http connections...\n");
  8002e5:	c7 04 24 38 48 80 00 	movl   $0x804838,(%esp)
  8002ec:	e8 d9 01 00 00       	call   8004ca <_Z7cprintfPKcz>
	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
  8002f1:	8d 7d e4             	lea    -0x1c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  8002f4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
  8002fb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8002ff:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800302:	89 44 24 04          	mov    %eax,0x4(%esp)
	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800306:	89 34 24             	mov    %esi,(%esp)
  800309:	e8 29 34 00 00       	call   803737 <_Z6acceptiP8sockaddrPj>
  80030e:	89 c3                	mov    %eax,%ebx
  800310:	85 c0                	test   %eax,%eax
  800312:	79 0a                	jns    80031e <_Z5umainiPPc+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800314:	b8 5c 48 80 00       	mov    $0x80485c,%eax
  800319:	e8 16 fd ff ff       	call   800034 <_ZL3diePKc>
		}
		handle_client(clientsock);
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	e8 2c fd ff ff       	call   800051 <_ZL13handle_clienti>
	if (listen(serversock, MAXPENDING) < 0)
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
  800325:	eb cd                	jmp    8002f4 <_Z5umainiPPc+0xcc>
	...

00800328 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 1c             	sub    $0x1c,%esp
  800331:	8b 7d 08             	mov    0x8(%ebp),%edi
  800334:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800337:	e8 2c 0c 00 00       	call   800f68 <_Z12sys_getenvidv>
  80033c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800341:	6b c0 78             	imul   $0x78,%eax,%eax
  800344:	05 00 00 00 ef       	add    $0xef000000,%eax
  800349:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80034e:	85 ff                	test   %edi,%edi
  800350:	7e 07                	jle    800359 <libmain+0x31>
		binaryname = argv[0];
  800352:	8b 06                	mov    (%esi),%eax
  800354:	a3 20 60 80 00       	mov    %eax,0x806020

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800359:	b8 35 54 80 00       	mov    $0x805435,%eax
  80035e:	3d 35 54 80 00       	cmp    $0x805435,%eax
  800363:	76 0f                	jbe    800374 <libmain+0x4c>
  800365:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800367:	83 eb 04             	sub    $0x4,%ebx
  80036a:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80036c:	81 fb 35 54 80 00    	cmp    $0x805435,%ebx
  800372:	77 f3                	ja     800367 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800374:	89 74 24 04          	mov    %esi,0x4(%esp)
  800378:	89 3c 24             	mov    %edi,(%esp)
  80037b:	e8 a8 fe ff ff       	call   800228 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800380:	e8 0b 00 00 00       	call   800390 <_Z4exitv>
}
  800385:	83 c4 1c             	add    $0x1c,%esp
  800388:	5b                   	pop    %ebx
  800389:	5e                   	pop    %esi
  80038a:	5f                   	pop    %edi
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    
  80038d:	00 00                	add    %al,(%eax)
	...

00800390 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800396:	e8 33 13 00 00       	call   8016ce <_Z9close_allv>
	sys_env_destroy(0);
  80039b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003a2:	e8 64 0b 00 00       	call   800f0b <_Z15sys_env_destroyi>
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    
  8003a9:	00 00                	add    %al,(%eax)
	...

008003ac <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8003b7:	a1 04 70 80 00       	mov    0x807004,%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	74 10                	je     8003d0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8003c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c4:	c7 04 24 b0 48 80 00 	movl   $0x8048b0,(%esp)
  8003cb:	e8 fa 00 00 00       	call   8004ca <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8003d0:	8b 1d 20 60 80 00    	mov    0x806020,%ebx
  8003d6:	e8 8d 0b 00 00       	call   800f68 <_Z12sys_getenvidv>
  8003db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003de:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	c7 04 24 b8 48 80 00 	movl   $0x8048b8,(%esp)
  8003f8:	e8 cd 00 00 00       	call   8004ca <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8003fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800401:	8b 45 10             	mov    0x10(%ebp),%eax
  800404:	89 04 24             	mov    %eax,(%esp)
  800407:	e8 5d 00 00 00       	call   800469 <_Z8vcprintfPKcPc>
	cprintf("\n");
  80040c:	c7 04 24 83 52 80 00 	movl   $0x805283,(%esp)
  800413:	e8 b2 00 00 00       	call   8004ca <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800418:	cc                   	int3   
  800419:	eb fd                	jmp    800418 <_Z6_panicPKciS0_z+0x6c>
	...

0080041c <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 18             	sub    $0x18,%esp
  800422:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800425:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80042b:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  80042d:	8b 03                	mov    (%ebx),%eax
  80042f:	8b 55 08             	mov    0x8(%ebp),%edx
  800432:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800436:	83 c0 01             	add    $0x1,%eax
  800439:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80043b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800440:	75 19                	jne    80045b <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800442:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800449:	00 
  80044a:	8d 43 08             	lea    0x8(%ebx),%eax
  80044d:	89 04 24             	mov    %eax,(%esp)
  800450:	e8 4f 0a 00 00       	call   800ea4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80045b:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80045f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800462:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800465:	89 ec                	mov    %ebp,%esp
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800472:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800479:	00 00 00 
	b.cnt = 0;
  80047c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800483:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	89 44 24 08          	mov    %eax,0x8(%esp)
  800494:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049e:	c7 04 24 1c 04 80 00 	movl   $0x80041c,(%esp)
  8004a5:	e8 ad 01 00 00       	call   800657 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8004aa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004ba:	89 04 24             	mov    %eax,(%esp)
  8004bd:	e8 e2 09 00 00       	call   800ea4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8004c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 04 24             	mov    %eax,(%esp)
  8004dd:	e8 87 ff ff ff       	call   800469 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    
	...

008004f0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 4c             	sub    $0x4c,%esp
  8004f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fc:	89 d6                	mov    %edx,%esi
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800504:	8b 55 0c             	mov    0xc(%ebp),%edx
  800507:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80050d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	39 d0                	cmp    %edx,%eax
  800517:	72 11                	jb     80052a <_ZL8printnumPFviPvES_yjii+0x3a>
  800519:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80051c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80051f:	76 09                	jbe    80052a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800521:	83 eb 01             	sub    $0x1,%ebx
  800524:	85 db                	test   %ebx,%ebx
  800526:	7f 5d                	jg     800585 <_ZL8printnumPFviPvES_yjii+0x95>
  800528:	eb 6c                	jmp    800596 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80052a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80052e:	83 eb 01             	sub    $0x1,%ebx
  800531:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800535:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800538:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80053c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800540:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800544:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800547:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80054a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800551:	00 
  800552:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800555:	89 14 24             	mov    %edx,(%esp)
  800558:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80055f:	e8 2c 3f 00 00       	call   804490 <__udivdi3>
  800564:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800567:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80056a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80056e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800572:	89 04 24             	mov    %eax,(%esp)
  800575:	89 54 24 04          	mov    %edx,0x4(%esp)
  800579:	89 f2                	mov    %esi,%edx
  80057b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80057e:	e8 6d ff ff ff       	call   8004f0 <_ZL8printnumPFviPvES_yjii>
  800583:	eb 11                	jmp    800596 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800585:	89 74 24 04          	mov    %esi,0x4(%esp)
  800589:	89 3c 24             	mov    %edi,(%esp)
  80058c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058f:	83 eb 01             	sub    $0x1,%ebx
  800592:	85 db                	test   %ebx,%ebx
  800594:	7f ef                	jg     800585 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800596:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005ac:	00 
  8005ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005b0:	89 14 24             	mov    %edx,(%esp)
  8005b3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005ba:	e8 e1 3f 00 00       	call   8045a0 <__umoddi3>
  8005bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c3:	0f be 80 db 48 80 00 	movsbl 0x8048db(%eax),%eax
  8005ca:	89 04 24             	mov    %eax,(%esp)
  8005cd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8005d0:	83 c4 4c             	add    $0x4c,%esp
  8005d3:	5b                   	pop    %ebx
  8005d4:	5e                   	pop    %esi
  8005d5:	5f                   	pop    %edi
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    

008005d8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005db:	83 fa 01             	cmp    $0x1,%edx
  8005de:	7e 0e                	jle    8005ee <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005e5:	89 08                	mov    %ecx,(%eax)
  8005e7:	8b 02                	mov    (%edx),%eax
  8005e9:	8b 52 04             	mov    0x4(%edx),%edx
  8005ec:	eb 22                	jmp    800610 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8005ee:	85 d2                	test   %edx,%edx
  8005f0:	74 10                	je     800602 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005f7:	89 08                	mov    %ecx,(%eax)
  8005f9:	8b 02                	mov    (%edx),%eax
  8005fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800600:	eb 0e                	jmp    800610 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800602:	8b 10                	mov    (%eax),%edx
  800604:	8d 4a 04             	lea    0x4(%edx),%ecx
  800607:	89 08                	mov    %ecx,(%eax)
  800609:	8b 02                	mov    (%edx),%eax
  80060b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800610:	5d                   	pop    %ebp
  800611:	c3                   	ret    

00800612 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800612:	55                   	push   %ebp
  800613:	89 e5                	mov    %esp,%ebp
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800618:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	3b 50 04             	cmp    0x4(%eax),%edx
  800621:	73 0a                	jae    80062d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800623:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800626:	88 0a                	mov    %cl,(%edx)
  800628:	83 c2 01             	add    $0x1,%edx
  80062b:	89 10                	mov    %edx,(%eax)
}
  80062d:	5d                   	pop    %ebp
  80062e:	c3                   	ret    

0080062f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80062f:	55                   	push   %ebp
  800630:	89 e5                	mov    %esp,%ebp
  800632:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800635:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800638:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80063c:	8b 45 10             	mov    0x10(%ebp),%eax
  80063f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800643:	8b 45 0c             	mov    0xc(%ebp),%eax
  800646:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 04 24             	mov    %eax,(%esp)
  800650:	e8 02 00 00 00       	call   800657 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	57                   	push   %edi
  80065b:	56                   	push   %esi
  80065c:	53                   	push   %ebx
  80065d:	83 ec 3c             	sub    $0x3c,%esp
  800660:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800663:	8b 55 10             	mov    0x10(%ebp),%edx
  800666:	0f b6 02             	movzbl (%edx),%eax
  800669:	89 d3                	mov    %edx,%ebx
  80066b:	83 c3 01             	add    $0x1,%ebx
  80066e:	83 f8 25             	cmp    $0x25,%eax
  800671:	74 2b                	je     80069e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800673:	85 c0                	test   %eax,%eax
  800675:	75 10                	jne    800687 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800677:	e9 a5 03 00 00       	jmp    800a21 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80067c:	85 c0                	test   %eax,%eax
  80067e:	66 90                	xchg   %ax,%ax
  800680:	75 08                	jne    80068a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800682:	e9 9a 03 00 00       	jmp    800a21 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800687:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80068a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068e:	89 04 24             	mov    %eax,(%esp)
  800691:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800693:	0f b6 03             	movzbl (%ebx),%eax
  800696:	83 c3 01             	add    $0x1,%ebx
  800699:	83 f8 25             	cmp    $0x25,%eax
  80069c:	75 de                	jne    80067c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80069e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8006a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8006a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8006ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8006b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ba:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006bd:	eb 2b                	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bf:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8006c6:	eb 22                	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006cb:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8006cf:	eb 19                	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8006d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006db:	eb 0d                	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8006dd:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006e0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006e3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	0f b6 03             	movzbl (%ebx),%eax
  8006ed:	0f b6 d0             	movzbl %al,%edx
  8006f0:	8d 73 01             	lea    0x1(%ebx),%esi
  8006f3:	89 75 10             	mov    %esi,0x10(%ebp)
  8006f6:	83 e8 23             	sub    $0x23,%eax
  8006f9:	3c 55                	cmp    $0x55,%al
  8006fb:	0f 87 d8 02 00 00    	ja     8009d9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800701:	0f b6 c0             	movzbl %al,%eax
  800704:	ff 24 85 80 4a 80 00 	jmp    *0x804a80(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80070b:	83 ea 30             	sub    $0x30,%edx
  80070e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800711:	8b 55 10             	mov    0x10(%ebp),%edx
  800714:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800717:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80071d:	83 fa 09             	cmp    $0x9,%edx
  800720:	77 4e                	ja     800770 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800722:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800725:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800728:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80072b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80072f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800732:	8d 50 d0             	lea    -0x30(%eax),%edx
  800735:	83 fa 09             	cmp    $0x9,%edx
  800738:	76 eb                	jbe    800725 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80073a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80073d:	eb 31                	jmp    800770 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 50 04             	lea    0x4(%eax),%edx
  800745:	89 55 14             	mov    %edx,0x14(%ebp)
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800750:	eb 1e                	jmp    800770 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800752:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800756:	0f 88 75 ff ff ff    	js     8006d1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80075f:	eb 89                	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800761:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800764:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80076b:	e9 7a ff ff ff       	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800774:	0f 89 70 ff ff ff    	jns    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80077a:	e9 5e ff ff ff       	jmp    8006dd <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800782:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800785:	e9 60 ff ff ff       	jmp    8006ea <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 50 04             	lea    0x4(%eax),%edx
  800790:	89 55 14             	mov    %edx,0x14(%ebp)
  800793:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800797:	8b 00                	mov    (%eax),%eax
  800799:	89 04 24             	mov    %eax,(%esp)
  80079c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80079f:	e9 bf fe ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 50 04             	lea    0x4(%eax),%edx
  8007aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 c2                	mov    %eax,%edx
  8007b1:	c1 fa 1f             	sar    $0x1f,%edx
  8007b4:	31 d0                	xor    %edx,%eax
  8007b6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007b8:	83 f8 14             	cmp    $0x14,%eax
  8007bb:	7f 0f                	jg     8007cc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8007bd:	8b 14 85 e0 4b 80 00 	mov    0x804be0(,%eax,4),%edx
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	0f 85 35 02 00 00    	jne    800a01 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8007cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d0:	c7 44 24 08 f3 48 80 	movl   $0x8048f3,0x8(%esp)
  8007d7:	00 
  8007d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007df:	89 34 24             	mov    %esi,(%esp)
  8007e2:	e8 48 fe ff ff       	call   80062f <_Z8printfmtPFviPvES_PKcz>
  8007e7:	e9 77 fe ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8007ec:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007fe:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800800:	85 db                	test   %ebx,%ebx
  800802:	ba ec 48 80 00       	mov    $0x8048ec,%edx
  800807:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80080a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80080e:	7e 72                	jle    800882 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800810:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800814:	74 6c                	je     800882 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081a:	89 1c 24             	mov    %ebx,(%esp)
  80081d:	e8 a9 02 00 00       	call   800acb <_Z7strnlenPKcj>
  800822:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800825:	29 c2                	sub    %eax,%edx
  800827:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80082a:	85 d2                	test   %edx,%edx
  80082c:	7e 54                	jle    800882 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80082e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800832:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800835:	89 d3                	mov    %edx,%ebx
  800837:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80083a:	89 c6                	mov    %eax,%esi
  80083c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800840:	89 34 24             	mov    %esi,(%esp)
  800843:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800846:	83 eb 01             	sub    $0x1,%ebx
  800849:	85 db                	test   %ebx,%ebx
  80084b:	7f ef                	jg     80083c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80084d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800850:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800853:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80085a:	eb 26                	jmp    800882 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80085c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80085f:	83 fa 5e             	cmp    $0x5e,%edx
  800862:	76 10                	jbe    800874 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800864:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800868:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80086f:	ff 55 08             	call   *0x8(%ebp)
  800872:	eb 0a                	jmp    80087e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800874:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800882:	0f be 03             	movsbl (%ebx),%eax
  800885:	83 c3 01             	add    $0x1,%ebx
  800888:	85 c0                	test   %eax,%eax
  80088a:	74 11                	je     80089d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80088c:	85 f6                	test   %esi,%esi
  80088e:	78 05                	js     800895 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800890:	83 ee 01             	sub    $0x1,%esi
  800893:	78 0d                	js     8008a2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800895:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800899:	75 c1                	jne    80085c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80089b:	eb d7                	jmp    800874 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80089d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a0:	eb 03                	jmp    8008a5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8008a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	0f 8e b6 fd ff ff    	jle    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8008ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8008b0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8008b3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008be:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008c0:	83 eb 01             	sub    $0x1,%ebx
  8008c3:	85 db                	test   %ebx,%ebx
  8008c5:	7f ec                	jg     8008b3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8008c7:	e9 97 fd ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008cc:	83 f9 01             	cmp    $0x1,%ecx
  8008cf:	90                   	nop
  8008d0:	7e 10                	jle    8008e2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 50 08             	lea    0x8(%eax),%edx
  8008d8:	89 55 14             	mov    %edx,0x14(%ebp)
  8008db:	8b 18                	mov    (%eax),%ebx
  8008dd:	8b 70 04             	mov    0x4(%eax),%esi
  8008e0:	eb 26                	jmp    800908 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8008e2:	85 c9                	test   %ecx,%ecx
  8008e4:	74 12                	je     8008f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ec:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ef:	8b 18                	mov    (%eax),%ebx
  8008f1:	89 de                	mov    %ebx,%esi
  8008f3:	c1 fe 1f             	sar    $0x1f,%esi
  8008f6:	eb 10                	jmp    800908 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	8d 50 04             	lea    0x4(%eax),%edx
  8008fe:	89 55 14             	mov    %edx,0x14(%ebp)
  800901:	8b 18                	mov    (%eax),%ebx
  800903:	89 de                	mov    %ebx,%esi
  800905:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800908:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80090d:	85 f6                	test   %esi,%esi
  80090f:	0f 89 8c 00 00 00    	jns    8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800915:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800919:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800920:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800923:	f7 db                	neg    %ebx
  800925:	83 d6 00             	adc    $0x0,%esi
  800928:	f7 de                	neg    %esi
			}
			base = 10;
  80092a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092f:	eb 70                	jmp    8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800931:	89 ca                	mov    %ecx,%edx
  800933:	8d 45 14             	lea    0x14(%ebp),%eax
  800936:	e8 9d fc ff ff       	call   8005d8 <_ZL7getuintPPci>
  80093b:	89 c3                	mov    %eax,%ebx
  80093d:	89 d6                	mov    %edx,%esi
			base = 10;
  80093f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800944:	eb 5b                	jmp    8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800946:	89 ca                	mov    %ecx,%edx
  800948:	8d 45 14             	lea    0x14(%ebp),%eax
  80094b:	e8 88 fc ff ff       	call   8005d8 <_ZL7getuintPPci>
  800950:	89 c3                	mov    %eax,%ebx
  800952:	89 d6                	mov    %edx,%esi
			base = 8;
  800954:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800959:	eb 46                	jmp    8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80095b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800966:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800969:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800974:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8d 50 04             	lea    0x4(%eax),%edx
  80097d:	89 55 14             	mov    %edx,0x14(%ebp)
  800980:	8b 18                	mov    (%eax),%ebx
  800982:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800987:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80098c:	eb 13                	jmp    8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80098e:	89 ca                	mov    %ecx,%edx
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
  800993:	e8 40 fc ff ff       	call   8005d8 <_ZL7getuintPPci>
  800998:	89 c3                	mov    %eax,%ebx
  80099a:	89 d6                	mov    %edx,%esi
			base = 16;
  80099c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8009a5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b4:	89 1c 24             	mov    %ebx,(%esp)
  8009b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bb:	89 fa                	mov    %edi,%edx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	e8 2b fb ff ff       	call   8004f0 <_ZL8printnumPFviPvES_yjii>
			break;
  8009c5:	e9 99 fc ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ce:	89 14 24             	mov    %edx,(%esp)
  8009d1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009d4:	e9 8a fc ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009dd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009e4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	eb 02                	jmp    8009f0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8009ee:	89 d0                	mov    %edx,%eax
  8009f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009f3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f7:	75 f5                	jne    8009ee <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8009f9:	89 45 10             	mov    %eax,0x10(%ebp)
  8009fc:	e9 62 fc ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a05:	c7 44 24 08 7e 4c 80 	movl   $0x804c7e,0x8(%esp)
  800a0c:	00 
  800a0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a11:	8b 75 08             	mov    0x8(%ebp),%esi
  800a14:	89 34 24             	mov    %esi,(%esp)
  800a17:	e8 13 fc ff ff       	call   80062f <_Z8printfmtPFviPvES_PKcz>
  800a1c:	e9 42 fc ff ff       	jmp    800663 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a21:	83 c4 3c             	add    $0x3c,%esp
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5f                   	pop    %edi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 28             	sub    $0x28,%esp
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a3f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a43:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800a46:	85 c0                	test   %eax,%eax
  800a48:	74 30                	je     800a7a <_Z9vsnprintfPciPKcS_+0x51>
  800a4a:	85 d2                	test   %edx,%edx
  800a4c:	7e 2c                	jle    800a7a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a55:	8b 45 10             	mov    0x10(%ebp),%eax
  800a58:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a63:	c7 04 24 12 06 80 00 	movl   $0x800612,(%esp)
  800a6a:	e8 e8 fb ff ff       	call   800657 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a78:	eb 05                	jmp    800a7f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a91:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	e8 82 ff ff ff       	call   800a29 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    
  800aa9:	00 00                	add    %al,(%eax)
  800aab:	00 00                	add    %al,(%eax)
  800aad:	00 00                	add    %al,(%eax)
	...

00800ab0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	80 3a 00             	cmpb   $0x0,(%edx)
  800abe:	74 09                	je     800ac9 <_Z6strlenPKc+0x19>
		n++;
  800ac0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ac7:	75 f7                	jne    800ac0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad9:	39 c2                	cmp    %eax,%edx
  800adb:	74 0b                	je     800ae8 <_Z7strnlenPKcj+0x1d>
  800add:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ae1:	74 05                	je     800ae8 <_Z7strnlenPKcj+0x1d>
		n++;
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	eb f1                	jmp    800ad9 <_Z7strnlenPKcj+0xe>
	return n;
}
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800af4:	ba 00 00 00 00       	mov    $0x0,%edx
  800af9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800afd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	84 c9                	test   %cl,%cl
  800b05:	75 f2                	jne    800af9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800b07:	5b                   	pop    %ebx
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b18:	85 f6                	test   %esi,%esi
  800b1a:	74 18                	je     800b34 <_Z7strncpyPcPKcj+0x2a>
  800b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b21:	0f b6 1a             	movzbl (%edx),%ebx
  800b24:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b27:	80 3a 01             	cmpb   $0x1,(%edx)
  800b2a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b2d:	83 c1 01             	add    $0x1,%ecx
  800b30:	39 ce                	cmp    %ecx,%esi
  800b32:	77 ed                	ja     800b21 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b43:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800b46:	89 f0                	mov    %esi,%eax
  800b48:	85 d2                	test   %edx,%edx
  800b4a:	74 17                	je     800b63 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800b4c:	83 ea 01             	sub    $0x1,%edx
  800b4f:	74 18                	je     800b69 <_Z7strlcpyPcPKcj+0x31>
  800b51:	80 39 00             	cmpb   $0x0,(%ecx)
  800b54:	74 17                	je     800b6d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800b56:	0f b6 19             	movzbl (%ecx),%ebx
  800b59:	88 18                	mov    %bl,(%eax)
  800b5b:	83 c0 01             	add    $0x1,%eax
  800b5e:	83 c1 01             	add    $0x1,%ecx
  800b61:	eb e9                	jmp    800b4c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800b63:	29 f0                	sub    %esi,%eax
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	eb 02                	jmp    800b6f <_Z7strlcpyPcPKcj+0x37>
  800b6d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b6f:	c6 02 00             	movb   $0x0,(%edx)
  800b72:	eb ef                	jmp    800b63 <_Z7strlcpyPcPKcj+0x2b>

00800b74 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b7d:	0f b6 01             	movzbl (%ecx),%eax
  800b80:	84 c0                	test   %al,%al
  800b82:	74 0c                	je     800b90 <_Z6strcmpPKcS0_+0x1c>
  800b84:	3a 02                	cmp    (%edx),%al
  800b86:	75 08                	jne    800b90 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800b88:	83 c1 01             	add    $0x1,%ecx
  800b8b:	83 c2 01             	add    $0x1,%edx
  800b8e:	eb ed                	jmp    800b7d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800b90:	0f b6 c0             	movzbl %al,%eax
  800b93:	0f b6 12             	movzbl (%edx),%edx
  800b96:	29 d0                	sub    %edx,%eax
}
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	53                   	push   %ebx
  800b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ba4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800ba7:	85 d2                	test   %edx,%edx
  800ba9:	74 16                	je     800bc1 <_Z7strncmpPKcS0_j+0x27>
  800bab:	0f b6 01             	movzbl (%ecx),%eax
  800bae:	84 c0                	test   %al,%al
  800bb0:	74 17                	je     800bc9 <_Z7strncmpPKcS0_j+0x2f>
  800bb2:	3a 03                	cmp    (%ebx),%al
  800bb4:	75 13                	jne    800bc9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800bb6:	83 ea 01             	sub    $0x1,%edx
  800bb9:	83 c1 01             	add    $0x1,%ecx
  800bbc:	83 c3 01             	add    $0x1,%ebx
  800bbf:	eb e6                	jmp    800ba7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800bc9:	0f b6 01             	movzbl (%ecx),%eax
  800bcc:	0f b6 13             	movzbl (%ebx),%edx
  800bcf:	29 d0                	sub    %edx,%eax
  800bd1:	eb f3                	jmp    800bc6 <_Z7strncmpPKcS0_j+0x2c>

00800bd3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdd:	0f b6 10             	movzbl (%eax),%edx
  800be0:	84 d2                	test   %dl,%dl
  800be2:	74 1f                	je     800c03 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800be4:	38 ca                	cmp    %cl,%dl
  800be6:	75 0a                	jne    800bf2 <_Z6strchrPKcc+0x1f>
  800be8:	eb 1e                	jmp    800c08 <_Z6strchrPKcc+0x35>
  800bea:	38 ca                	cmp    %cl,%dl
  800bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bf0:	74 16                	je     800c08 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bf2:	83 c0 01             	add    $0x1,%eax
  800bf5:	0f b6 10             	movzbl (%eax),%edx
  800bf8:	84 d2                	test   %dl,%dl
  800bfa:	75 ee                	jne    800bea <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	eb 05                	jmp    800c08 <_Z6strchrPKcc+0x35>
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c14:	0f b6 10             	movzbl (%eax),%edx
  800c17:	84 d2                	test   %dl,%dl
  800c19:	74 14                	je     800c2f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800c1b:	38 ca                	cmp    %cl,%dl
  800c1d:	75 06                	jne    800c25 <_Z7strfindPKcc+0x1b>
  800c1f:	eb 0e                	jmp    800c2f <_Z7strfindPKcc+0x25>
  800c21:	38 ca                	cmp    %cl,%dl
  800c23:	74 0a                	je     800c2f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c25:	83 c0 01             	add    $0x1,%eax
  800c28:	0f b6 10             	movzbl (%eax),%edx
  800c2b:	84 d2                	test   %dl,%dl
  800c2d:	75 f2                	jne    800c21 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	89 1c 24             	mov    %ebx,(%esp)
  800c3a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800c4b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c51:	75 25                	jne    800c78 <memset+0x47>
  800c53:	f6 c1 03             	test   $0x3,%cl
  800c56:	75 20                	jne    800c78 <memset+0x47>
		c &= 0xFF;
  800c58:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c5b:	89 d3                	mov    %edx,%ebx
  800c5d:	c1 e3 08             	shl    $0x8,%ebx
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	c1 e6 18             	shl    $0x18,%esi
  800c65:	89 d0                	mov    %edx,%eax
  800c67:	c1 e0 10             	shl    $0x10,%eax
  800c6a:	09 f0                	or     %esi,%eax
  800c6c:	09 d0                	or     %edx,%eax
  800c6e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800c70:	c1 e9 02             	shr    $0x2,%ecx
  800c73:	fc                   	cld    
  800c74:	f3 ab                	rep stos %eax,%es:(%edi)
  800c76:	eb 03                	jmp    800c7b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800c78:	fc                   	cld    
  800c79:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800c7b:	89 f8                	mov    %edi,%eax
  800c7d:	8b 1c 24             	mov    (%esp),%ebx
  800c80:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c88:	89 ec                	mov    %ebp,%esp
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	89 34 24             	mov    %esi,(%esp)
  800c95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800ca2:	39 c6                	cmp    %eax,%esi
  800ca4:	73 36                	jae    800cdc <memmove+0x50>
  800ca6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	73 2f                	jae    800cdc <memmove+0x50>
		s += n;
		d += n;
  800cad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800cb0:	f6 c2 03             	test   $0x3,%dl
  800cb3:	75 1b                	jne    800cd0 <memmove+0x44>
  800cb5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cbb:	75 13                	jne    800cd0 <memmove+0x44>
  800cbd:	f6 c1 03             	test   $0x3,%cl
  800cc0:	75 0e                	jne    800cd0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc2:	83 ef 04             	sub    $0x4,%edi
  800cc5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc8:	c1 e9 02             	shr    $0x2,%ecx
  800ccb:	fd                   	std    
  800ccc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cce:	eb 09                	jmp    800cd9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cd0:	83 ef 01             	sub    $0x1,%edi
  800cd3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800cd6:	fd                   	std    
  800cd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd9:	fc                   	cld    
  800cda:	eb 20                	jmp    800cfc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800cdc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce2:	75 13                	jne    800cf7 <memmove+0x6b>
  800ce4:	a8 03                	test   $0x3,%al
  800ce6:	75 0f                	jne    800cf7 <memmove+0x6b>
  800ce8:	f6 c1 03             	test   $0x3,%cl
  800ceb:	75 0a                	jne    800cf7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ced:	c1 e9 02             	shr    $0x2,%ecx
  800cf0:	89 c7                	mov    %eax,%edi
  800cf2:	fc                   	cld    
  800cf3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf5:	eb 05                	jmp    800cfc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800cf7:	89 c7                	mov    %eax,%edi
  800cf9:	fc                   	cld    
  800cfa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800cfc:	8b 34 24             	mov    (%esp),%esi
  800cff:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d03:	89 ec                	mov    %ebp,%esp
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	89 34 24             	mov    %esi,(%esp)
  800d10:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d1d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d23:	75 13                	jne    800d38 <memcpy+0x31>
  800d25:	a8 03                	test   $0x3,%al
  800d27:	75 0f                	jne    800d38 <memcpy+0x31>
  800d29:	f6 c1 03             	test   $0x3,%cl
  800d2c:	75 0a                	jne    800d38 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d2e:	c1 e9 02             	shr    $0x2,%ecx
  800d31:	89 c7                	mov    %eax,%edi
  800d33:	fc                   	cld    
  800d34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d36:	eb 05                	jmp    800d3d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800d38:	89 c7                	mov    %eax,%edi
  800d3a:	fc                   	cld    
  800d3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800d3d:	8b 34 24             	mov    (%esp),%esi
  800d40:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d44:	89 ec                	mov    %ebp,%esp
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d54:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d5c:	85 ff                	test   %edi,%edi
  800d5e:	74 38                	je     800d98 <memcmp+0x50>
		if (*s1 != *s2)
  800d60:	0f b6 03             	movzbl (%ebx),%eax
  800d63:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d66:	83 ef 01             	sub    $0x1,%edi
  800d69:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800d6e:	38 c8                	cmp    %cl,%al
  800d70:	74 1d                	je     800d8f <memcmp+0x47>
  800d72:	eb 11                	jmp    800d85 <memcmp+0x3d>
  800d74:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d79:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800d7e:	83 c2 01             	add    $0x1,%edx
  800d81:	38 c8                	cmp    %cl,%al
  800d83:	74 0a                	je     800d8f <memcmp+0x47>
			return *s1 - *s2;
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	0f b6 c9             	movzbl %cl,%ecx
  800d8b:	29 c8                	sub    %ecx,%eax
  800d8d:	eb 09                	jmp    800d98 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d8f:	39 fa                	cmp    %edi,%edx
  800d91:	75 e1                	jne    800d74 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	53                   	push   %ebx
  800da1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800da4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800da6:	89 da                	mov    %ebx,%edx
  800da8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800dab:	39 d3                	cmp    %edx,%ebx
  800dad:	73 15                	jae    800dc4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800daf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800db3:	38 0b                	cmp    %cl,(%ebx)
  800db5:	75 06                	jne    800dbd <memfind+0x20>
  800db7:	eb 0b                	jmp    800dc4 <memfind+0x27>
  800db9:	38 08                	cmp    %cl,(%eax)
  800dbb:	74 07                	je     800dc4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800dbd:	83 c0 01             	add    $0x1,%eax
  800dc0:	39 c2                	cmp    %eax,%edx
  800dc2:	77 f5                	ja     800db9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dd3:	0f b6 02             	movzbl (%edx),%eax
  800dd6:	3c 20                	cmp    $0x20,%al
  800dd8:	74 04                	je     800dde <_Z6strtolPKcPPci+0x17>
  800dda:	3c 09                	cmp    $0x9,%al
  800ddc:	75 0e                	jne    800dec <_Z6strtolPKcPPci+0x25>
		s++;
  800dde:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de1:	0f b6 02             	movzbl (%edx),%eax
  800de4:	3c 20                	cmp    $0x20,%al
  800de6:	74 f6                	je     800dde <_Z6strtolPKcPPci+0x17>
  800de8:	3c 09                	cmp    $0x9,%al
  800dea:	74 f2                	je     800dde <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dec:	3c 2b                	cmp    $0x2b,%al
  800dee:	75 0a                	jne    800dfa <_Z6strtolPKcPPci+0x33>
		s++;
  800df0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800df3:	bf 00 00 00 00       	mov    $0x0,%edi
  800df8:	eb 10                	jmp    800e0a <_Z6strtolPKcPPci+0x43>
  800dfa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800dff:	3c 2d                	cmp    $0x2d,%al
  800e01:	75 07                	jne    800e0a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800e03:	83 c2 01             	add    $0x1,%edx
  800e06:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	0f 94 c0             	sete   %al
  800e0f:	74 05                	je     800e16 <_Z6strtolPKcPPci+0x4f>
  800e11:	83 fb 10             	cmp    $0x10,%ebx
  800e14:	75 15                	jne    800e2b <_Z6strtolPKcPPci+0x64>
  800e16:	80 3a 30             	cmpb   $0x30,(%edx)
  800e19:	75 10                	jne    800e2b <_Z6strtolPKcPPci+0x64>
  800e1b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e1f:	75 0a                	jne    800e2b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800e21:	83 c2 02             	add    $0x2,%edx
  800e24:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e29:	eb 13                	jmp    800e3e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800e2b:	84 c0                	test   %al,%al
  800e2d:	74 0f                	je     800e3e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e2f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e34:	80 3a 30             	cmpb   $0x30,(%edx)
  800e37:	75 05                	jne    800e3e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800e39:	83 c2 01             	add    $0x1,%edx
  800e3c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e43:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e45:	0f b6 0a             	movzbl (%edx),%ecx
  800e48:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e4b:	80 fb 09             	cmp    $0x9,%bl
  800e4e:	77 08                	ja     800e58 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800e50:	0f be c9             	movsbl %cl,%ecx
  800e53:	83 e9 30             	sub    $0x30,%ecx
  800e56:	eb 1e                	jmp    800e76 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800e58:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800e5b:	80 fb 19             	cmp    $0x19,%bl
  800e5e:	77 08                	ja     800e68 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800e60:	0f be c9             	movsbl %cl,%ecx
  800e63:	83 e9 57             	sub    $0x57,%ecx
  800e66:	eb 0e                	jmp    800e76 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800e68:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800e6b:	80 fb 19             	cmp    $0x19,%bl
  800e6e:	77 15                	ja     800e85 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800e70:	0f be c9             	movsbl %cl,%ecx
  800e73:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e76:	39 f1                	cmp    %esi,%ecx
  800e78:	7d 0f                	jge    800e89 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800e7a:	83 c2 01             	add    $0x1,%edx
  800e7d:	0f af c6             	imul   %esi,%eax
  800e80:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800e83:	eb c0                	jmp    800e45 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e85:	89 c1                	mov    %eax,%ecx
  800e87:	eb 02                	jmp    800e8b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e89:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8f:	74 05                	je     800e96 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800e91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e94:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e96:	89 ca                	mov    %ecx,%edx
  800e98:	f7 da                	neg    %edx
  800e9a:	85 ff                	test   %edi,%edi
  800e9c:	0f 45 c2             	cmovne %edx,%eax
}
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	89 1c 24             	mov    %ebx,(%esp)
  800ead:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eb1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	89 c3                	mov    %eax,%ebx
  800ec2:	89 c7                	mov    %eax,%edi
  800ec4:	89 c6                	mov    %eax,%esi
  800ec6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ec8:	8b 1c 24             	mov    (%esp),%ebx
  800ecb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ecf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ed3:	89 ec                	mov    %ebp,%esp
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	89 1c 24             	mov    %ebx,(%esp)
  800ee0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ee4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  800eed:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef2:	89 d1                	mov    %edx,%ecx
  800ef4:	89 d3                	mov    %edx,%ebx
  800ef6:	89 d7                	mov    %edx,%edi
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800efc:	8b 1c 24             	mov    (%esp),%ebx
  800eff:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f03:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f07:	89 ec                	mov    %ebp,%esp
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 38             	sub    $0x38,%esp
  800f11:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f14:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f17:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	89 cb                	mov    %ecx,%ebx
  800f29:	89 cf                	mov    %ecx,%edi
  800f2b:	89 ce                	mov    %ecx,%esi
  800f2d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7e 28                	jle    800f5b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  800f56:	e8 51 f4 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f64:	89 ec                	mov    %ebp,%esp
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	89 1c 24             	mov    %ebx,(%esp)
  800f71:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f75:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f79:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800f83:	89 d1                	mov    %edx,%ecx
  800f85:	89 d3                	mov    %edx,%ebx
  800f87:	89 d7                	mov    %edx,%edi
  800f89:	89 d6                	mov    %edx,%esi
  800f8b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f8d:	8b 1c 24             	mov    (%esp),%ebx
  800f90:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f98:	89 ec                	mov    %ebp,%esp
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	89 1c 24             	mov    %ebx,(%esp)
  800fa5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fa9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fad:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb7:	89 d1                	mov    %edx,%ecx
  800fb9:	89 d3                	mov    %edx,%ebx
  800fbb:	89 d7                	mov    %edx,%edi
  800fbd:	89 d6                	mov    %edx,%esi
  800fbf:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fc1:	8b 1c 24             	mov    (%esp),%ebx
  800fc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fcc:	89 ec                	mov    %ebp,%esp
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 38             	sub    $0x38,%esp
  800fd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fdf:	be 00 00 00 00       	mov    $0x0,%esi
  800fe4:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	89 f7                	mov    %esi,%edi
  800ff4:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	7e 28                	jle    801022 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ffe:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801005:	00 
  801006:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  80100d:	00 
  80100e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801015:	00 
  801016:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  80101d:	e8 8a f3 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801022:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801025:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801028:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102b:	89 ec                	mov    %ebp,%esp
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 38             	sub    $0x38,%esp
  801035:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801038:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80103b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80103e:	b8 09 00 00 00       	mov    $0x9,%eax
  801043:	8b 75 18             	mov    0x18(%ebp),%esi
  801046:	8b 7d 14             	mov    0x14(%ebp),%edi
  801049:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	cd 30                	int    $0x30

	if(check && ret > 0)
  801054:	85 c0                	test   %eax,%eax
  801056:	7e 28                	jle    801080 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801058:	89 44 24 10          	mov    %eax,0x10(%esp)
  80105c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801063:	00 
  801064:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  80106b:	00 
  80106c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801073:	00 
  801074:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  80107b:	e8 2c f3 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801080:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801083:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801086:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801089:	89 ec                	mov    %ebp,%esp
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 38             	sub    $0x38,%esp
  801093:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801096:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801099:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ac:	89 df                	mov    %ebx,%edi
  8010ae:	89 de                	mov    %ebx,%esi
  8010b0:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	7e 28                	jle    8010de <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010c1:	00 
  8010c2:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  8010c9:	00 
  8010ca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d1:	00 
  8010d2:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  8010d9:	e8 ce f2 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e7:	89 ec                	mov    %ebp,%esp
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
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
  8010fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	89 df                	mov    %ebx,%edi
  80110c:	89 de                	mov    %ebx,%esi
  80110e:	cd 30                	int    $0x30

	if(check && ret > 0)
  801110:	85 c0                	test   %eax,%eax
  801112:	7e 28                	jle    80113c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801114:	89 44 24 10          	mov    %eax,0x10(%esp)
  801118:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80111f:	00 
  801120:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  801127:	00 
  801128:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112f:	00 
  801130:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  801137:	e8 70 f2 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80113c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80113f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801142:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801145:	89 ec                	mov    %ebp,%esp
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 38             	sub    $0x38,%esp
  80114f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801152:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801155:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801158:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115d:	b8 06 00 00 00       	mov    $0x6,%eax
  801162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801165:	8b 55 08             	mov    0x8(%ebp),%edx
  801168:	89 df                	mov    %ebx,%edi
  80116a:	89 de                	mov    %ebx,%esi
  80116c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80116e:	85 c0                	test   %eax,%eax
  801170:	7e 28                	jle    80119a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801172:	89 44 24 10          	mov    %eax,0x10(%esp)
  801176:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80117d:	00 
  80117e:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  801185:	00 
  801186:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80118d:	00 
  80118e:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  801195:	e8 12 f2 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80119a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80119d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011a3:	89 ec                	mov    %ebp,%esp
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 38             	sub    $0x38,%esp
  8011ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 df                	mov    %ebx,%edi
  8011c8:	89 de                	mov    %ebx,%esi
  8011ca:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	7e 28                	jle    8011f8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8011db:	00 
  8011dc:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  8011f3:	e8 b4 f1 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801201:	89 ec                	mov    %ebp,%esp
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 38             	sub    $0x38,%esp
  80120b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801211:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801214:	bb 00 00 00 00       	mov    $0x0,%ebx
  801219:	b8 0c 00 00 00       	mov    $0xc,%eax
  80121e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	89 df                	mov    %ebx,%edi
  801226:	89 de                	mov    %ebx,%esi
  801228:	cd 30                	int    $0x30

	if(check && ret > 0)
  80122a:	85 c0                	test   %eax,%eax
  80122c:	7e 28                	jle    801256 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801232:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801239:	00 
  80123a:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  801241:	00 
  801242:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801249:	00 
  80124a:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  801251:	e8 56 f1 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801256:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801259:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80125f:	89 ec                	mov    %ebp,%esp
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	89 1c 24             	mov    %ebx,(%esp)
  80126c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801270:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801274:	be 00 00 00 00       	mov    $0x0,%esi
  801279:	b8 0d 00 00 00       	mov    $0xd,%eax
  80127e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801281:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801287:	8b 55 08             	mov    0x8(%ebp),%edx
  80128a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80128c:	8b 1c 24             	mov    (%esp),%ebx
  80128f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801293:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801297:	89 ec                	mov    %ebp,%esp
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	83 ec 38             	sub    $0x38,%esp
  8012a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012af:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	89 cb                	mov    %ecx,%ebx
  8012b9:	89 cf                	mov    %ecx,%edi
  8012bb:	89 ce                	mov    %ecx,%esi
  8012bd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	7e 28                	jle    8012eb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8012ce:	00 
  8012cf:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  8012d6:	00 
  8012d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012de:	00 
  8012df:	c7 04 24 51 4c 80 00 	movl   $0x804c51,(%esp)
  8012e6:	e8 c1 f0 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012f4:	89 ec                	mov    %ebp,%esp
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	89 1c 24             	mov    %ebx,(%esp)
  801301:	89 74 24 04          	mov    %esi,0x4(%esp)
  801305:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801309:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801316:	8b 55 08             	mov    0x8(%ebp),%edx
  801319:	89 df                	mov    %ebx,%edi
  80131b:	89 de                	mov    %ebx,%esi
  80131d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80131f:	8b 1c 24             	mov    (%esp),%ebx
  801322:	8b 74 24 04          	mov    0x4(%esp),%esi
  801326:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80132a:	89 ec                	mov    %ebp,%esp
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	89 1c 24             	mov    %ebx,(%esp)
  801337:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80133f:	ba 00 00 00 00       	mov    $0x0,%edx
  801344:	b8 11 00 00 00       	mov    $0x11,%eax
  801349:	89 d1                	mov    %edx,%ecx
  80134b:	89 d3                	mov    %edx,%ebx
  80134d:	89 d7                	mov    %edx,%edi
  80134f:	89 d6                	mov    %edx,%esi
  801351:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801353:	8b 1c 24             	mov    (%esp),%ebx
  801356:	8b 74 24 04          	mov    0x4(%esp),%esi
  80135a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80135e:	89 ec                	mov    %ebp,%esp
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 0c             	sub    $0xc,%esp
  801368:	89 1c 24             	mov    %ebx,(%esp)
  80136b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801373:	bb 00 00 00 00       	mov    $0x0,%ebx
  801378:	b8 12 00 00 00       	mov    $0x12,%eax
  80137d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801380:	8b 55 08             	mov    0x8(%ebp),%edx
  801383:	89 df                	mov    %ebx,%edi
  801385:	89 de                	mov    %ebx,%esi
  801387:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801389:	8b 1c 24             	mov    (%esp),%ebx
  80138c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801390:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801394:	89 ec                	mov    %ebp,%esp
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 0c             	sub    $0xc,%esp
  80139e:	89 1c 24             	mov    %ebx,(%esp)
  8013a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013ae:	b8 13 00 00 00       	mov    $0x13,%eax
  8013b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b6:	89 cb                	mov    %ecx,%ebx
  8013b8:	89 cf                	mov    %ecx,%edi
  8013ba:	89 ce                	mov    %ecx,%esi
  8013bc:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8013be:	8b 1c 24             	mov    (%esp),%ebx
  8013c1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013c9:	89 ec                	mov    %ebp,%esp
  8013cb:	5d                   	pop    %ebp
  8013cc:	c3                   	ret    

008013cd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	89 1c 24             	mov    %ebx,(%esp)
  8013d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013da:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013de:	b8 10 00 00 00       	mov    $0x10,%eax
  8013e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8013f4:	8b 1c 24             	mov    (%esp),%ebx
  8013f7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013fb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ff:	89 ec                	mov    %ebp,%esp
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    
	...

00801410 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801413:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801418:	75 11                	jne    80142b <_ZL8fd_validPK2Fd+0x1b>
  80141a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80141f:	76 0a                	jbe    80142b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801421:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801426:	0f 96 c0             	setbe  %al
  801429:	eb 05                	jmp    801430 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	53                   	push   %ebx
  801436:	83 ec 14             	sub    $0x14,%esp
  801439:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80143b:	e8 d0 ff ff ff       	call   801410 <_ZL8fd_validPK2Fd>
  801440:	84 c0                	test   %al,%al
  801442:	75 24                	jne    801468 <_ZL9fd_isopenPK2Fd+0x36>
  801444:	c7 44 24 0c 5f 4c 80 	movl   $0x804c5f,0xc(%esp)
  80144b:	00 
  80144c:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  801453:	00 
  801454:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80145b:	00 
  80145c:	c7 04 24 81 4c 80 00 	movl   $0x804c81,(%esp)
  801463:	e8 44 ef ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	c1 e8 16             	shr    $0x16,%eax
  80146d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
  801479:	f6 c2 01             	test   $0x1,%dl
  80147c:	74 0d                	je     80148b <_ZL9fd_isopenPK2Fd+0x59>
  80147e:	c1 eb 0c             	shr    $0xc,%ebx
  801481:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801488:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80148b:	83 c4 14             	add    $0x14,%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    

00801491 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	89 1c 24             	mov    %ebx,(%esp)
  80149a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80149e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014a4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8014a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8014ab:	77 18                	ja     8014c5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8014ad:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8014b3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8014b6:	84 c0                	test   %al,%al
  8014b8:	74 21                	je     8014db <_Z9fd_lookupiPP2Fdb+0x4a>
  8014ba:	89 d8                	mov    %ebx,%eax
  8014bc:	e8 71 ff ff ff       	call   801432 <_ZL9fd_isopenPK2Fd>
  8014c1:	84 c0                	test   %al,%al
  8014c3:	75 16                	jne    8014db <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8014c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8014cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8014d0:	8b 1c 24             	mov    (%esp),%ebx
  8014d3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014d7:	89 ec                	mov    %ebp,%esp
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8014db:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb ec                	jmp    8014d0 <_Z9fd_lookupiPP2Fdb+0x3f>

008014e4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 14             	sub    $0x14,%esp
  8014eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8014ee:	89 d8                	mov    %ebx,%eax
  8014f0:	e8 1b ff ff ff       	call   801410 <_ZL8fd_validPK2Fd>
  8014f5:	84 c0                	test   %al,%al
  8014f7:	75 24                	jne    80151d <_Z6fd2numP2Fd+0x39>
  8014f9:	c7 44 24 0c 5f 4c 80 	movl   $0x804c5f,0xc(%esp)
  801500:	00 
  801501:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  801508:	00 
  801509:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801510:	00 
  801511:	c7 04 24 81 4c 80 00 	movl   $0x804c81,(%esp)
  801518:	e8 8f ee ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80151d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801523:	c1 e8 0c             	shr    $0xc,%eax
}
  801526:	83 c4 14             	add    $0x14,%esp
  801529:	5b                   	pop    %ebx
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    

0080152c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	89 04 24             	mov    %eax,(%esp)
  801538:	e8 a7 ff ff ff       	call   8014e4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80153d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801542:	c1 e0 0c             	shl    $0xc,%eax
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	57                   	push   %edi
  80154b:	56                   	push   %esi
  80154c:	53                   	push   %ebx
  80154d:	83 ec 2c             	sub    $0x2c,%esp
  801550:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801553:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801558:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80155b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801562:	00 
  801563:	89 74 24 04          	mov    %esi,0x4(%esp)
  801567:	89 1c 24             	mov    %ebx,(%esp)
  80156a:	e8 22 ff ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80156f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801572:	e8 bb fe ff ff       	call   801432 <_ZL9fd_isopenPK2Fd>
  801577:	84 c0                	test   %al,%al
  801579:	75 0c                	jne    801587 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80157b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157e:	89 07                	mov    %eax,(%edi)
			return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
  801585:	eb 13                	jmp    80159a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801587:	83 c3 01             	add    $0x1,%ebx
  80158a:	83 fb 20             	cmp    $0x20,%ebx
  80158d:	75 cc                	jne    80155b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80158f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801595:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80159a:	83 c4 2c             	add    $0x2c,%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 14             	sub    $0x14,%esp
  8015a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015b4:	39 0d 24 60 80 00    	cmp    %ecx,0x806024
  8015ba:	75 16                	jne    8015d2 <_Z10dev_lookupiPP3Dev+0x30>
  8015bc:	eb 06                	jmp    8015c4 <_Z10dev_lookupiPP3Dev+0x22>
  8015be:	39 0a                	cmp    %ecx,(%edx)
  8015c0:	75 10                	jne    8015d2 <_Z10dev_lookupiPP3Dev+0x30>
  8015c2:	eb 05                	jmp    8015c9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015c4:	ba 24 60 80 00       	mov    $0x806024,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8015c9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 35                	jmp    801607 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015d2:	83 c0 01             	add    $0x1,%eax
  8015d5:	8b 14 85 ec 4c 80 00 	mov    0x804cec(,%eax,4),%edx
  8015dc:	85 d2                	test   %edx,%edx
  8015de:	75 de                	jne    8015be <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015e0:	a1 00 70 80 00       	mov    0x807000,%eax
  8015e5:	8b 40 04             	mov    0x4(%eax),%eax
  8015e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f0:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  8015f7:	e8 ce ee ff ff       	call   8004ca <_Z7cprintfPKcz>
	*dev = 0;
  8015fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801602:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801607:	83 c4 14             	add    $0x14,%esp
  80160a:	5b                   	pop    %ebx
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	83 ec 20             	sub    $0x20,%esp
  801615:	8b 75 08             	mov    0x8(%ebp),%esi
  801618:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80161c:	89 34 24             	mov    %esi,(%esp)
  80161f:	e8 c0 fe ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  801624:	0f b6 d3             	movzbl %bl,%edx
  801627:	89 54 24 08          	mov    %edx,0x8(%esp)
  80162b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80162e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801632:	89 04 24             	mov    %eax,(%esp)
  801635:	e8 57 fe ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 05                	js     801643 <_Z8fd_closeP2Fdb+0x36>
  80163e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801641:	74 0c                	je     80164f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801643:	80 fb 01             	cmp    $0x1,%bl
  801646:	19 db                	sbb    %ebx,%ebx
  801648:	f7 d3                	not    %ebx
  80164a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80164d:	eb 3d                	jmp    80168c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80164f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801652:	89 44 24 04          	mov    %eax,0x4(%esp)
  801656:	8b 06                	mov    (%esi),%eax
  801658:	89 04 24             	mov    %eax,(%esp)
  80165b:	e8 42 ff ff ff       	call   8015a2 <_Z10dev_lookupiPP3Dev>
  801660:	89 c3                	mov    %eax,%ebx
  801662:	85 c0                	test   %eax,%eax
  801664:	78 16                	js     80167c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80166c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801671:	85 c0                	test   %eax,%eax
  801673:	74 07                	je     80167c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801675:	89 34 24             	mov    %esi,(%esp)
  801678:	ff d0                	call   *%eax
  80167a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80167c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801687:	e8 01 fa ff ff       	call   80108d <_Z14sys_page_unmapiPv>
	return r;
}
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	83 c4 20             	add    $0x20,%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80169b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016a2:	00 
  8016a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 04 24             	mov    %eax,(%esp)
  8016b0:	e8 dc fd ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 13                	js     8016cc <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  8016b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016c0:	00 
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 41 ff ff ff       	call   80160d <_Z8fd_closeP2Fdb>
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <_Z9close_allv>:

void
close_all(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  8016d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016da:	89 1c 24             	mov    %ebx,(%esp)
  8016dd:	e8 b3 ff ff ff       	call   801695 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  8016e2:	83 c3 01             	add    $0x1,%ebx
  8016e5:	83 fb 20             	cmp    $0x20,%ebx
  8016e8:	75 f0                	jne    8016da <_Z9close_allv+0xc>
		close(i);
}
  8016ea:	83 c4 14             	add    $0x14,%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 48             	sub    $0x48,%esp
  8016f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801702:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801709:	00 
  80170a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80170d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	89 04 24             	mov    %eax,(%esp)
  801717:	e8 75 fd ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	85 c0                	test   %eax,%eax
  801720:	0f 88 ce 00 00 00    	js     8017f4 <_Z3dupii+0x104>
  801726:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80172e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801731:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801735:	89 34 24             	mov    %esi,(%esp)
  801738:	e8 54 fd ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80173d:	89 c3                	mov    %eax,%ebx
  80173f:	85 c0                	test   %eax,%eax
  801741:	0f 89 bc 00 00 00    	jns    801803 <_Z3dupii+0x113>
  801747:	e9 a8 00 00 00       	jmp    8017f4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80174c:	89 d8                	mov    %ebx,%eax
  80174e:	c1 e8 0c             	shr    $0xc,%eax
  801751:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801758:	f6 c2 01             	test   $0x1,%dl
  80175b:	74 32                	je     80178f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80175d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801764:	25 07 0e 00 00       	and    $0xe07,%eax
  801769:	89 44 24 10          	mov    %eax,0x10(%esp)
  80176d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801771:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801778:	00 
  801779:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80177d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801784:	e8 a6 f8 ff ff       	call   80102f <_Z12sys_page_mapiPviS_i>
  801789:	89 c3                	mov    %eax,%ebx
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 3e                	js     8017cd <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80178f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801792:	89 c2                	mov    %eax,%edx
  801794:	c1 ea 0c             	shr    $0xc,%edx
  801797:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80179e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017a4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b6:	00 
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 68 f8 ff ff       	call   80102f <_Z12sys_page_mapiPviS_i>
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	79 25                	jns    8017f2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017db:	e8 ad f8 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8017e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017eb:	e8 9d f8 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
	return r;
  8017f0:	eb 02                	jmp    8017f4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8017f2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017f4:	89 d8                	mov    %ebx,%eax
  8017f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017ff:	89 ec                	mov    %ebp,%esp
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801803:	89 34 24             	mov    %esi,(%esp)
  801806:	e8 8a fe ff ff       	call   801695 <_Z5closei>

	ova = fd2data(oldfd);
  80180b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180e:	89 04 24             	mov    %eax,(%esp)
  801811:	e8 16 fd ff ff       	call   80152c <_Z7fd2dataP2Fd>
  801816:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80181b:	89 04 24             	mov    %eax,(%esp)
  80181e:	e8 09 fd ff ff       	call   80152c <_Z7fd2dataP2Fd>
  801823:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801825:	89 d8                	mov    %ebx,%eax
  801827:	c1 e8 16             	shr    $0x16,%eax
  80182a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801831:	a8 01                	test   $0x1,%al
  801833:	0f 85 13 ff ff ff    	jne    80174c <_Z3dupii+0x5c>
  801839:	e9 51 ff ff ff       	jmp    80178f <_Z3dupii+0x9f>

0080183e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	53                   	push   %ebx
  801842:	83 ec 24             	sub    $0x24,%esp
  801845:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801848:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80184f:	00 
  801850:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801853:	89 44 24 04          	mov    %eax,0x4(%esp)
  801857:	89 1c 24             	mov    %ebx,(%esp)
  80185a:	e8 32 fc ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 5f                	js     8018c2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801863:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801866:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80186d:	8b 00                	mov    (%eax),%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 2b fd ff ff       	call   8015a2 <_Z10dev_lookupiPP3Dev>
  801877:	85 c0                	test   %eax,%eax
  801879:	79 4d                	jns    8018c8 <_Z4readiPvj+0x8a>
  80187b:	eb 45                	jmp    8018c2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80187d:	a1 00 70 80 00       	mov    0x807000,%eax
  801882:	8b 40 04             	mov    0x4(%eax),%eax
  801885:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801889:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188d:	c7 04 24 8a 4c 80 00 	movl   $0x804c8a,(%esp)
  801894:	e8 31 ec ff ff       	call   8004ca <_Z7cprintfPKcz>
		return -E_INVAL;
  801899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189e:	eb 22                	jmp    8018c2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  8018a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018ab:	85 d2                	test   %edx,%edx
  8018ad:	74 13                	je     8018c2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bd:	89 0c 24             	mov    %ecx,(%esp)
  8018c0:	ff d2                	call   *%edx
}
  8018c2:	83 c4 24             	add    $0x24,%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018cb:	8b 41 08             	mov    0x8(%ecx),%eax
  8018ce:	83 e0 03             	and    $0x3,%eax
  8018d1:	83 f8 01             	cmp    $0x1,%eax
  8018d4:	75 ca                	jne    8018a0 <_Z4readiPvj+0x62>
  8018d6:	eb a5                	jmp    80187d <_Z4readiPvj+0x3f>

008018d8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	57                   	push   %edi
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 1c             	sub    $0x1c,%esp
  8018e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8018e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8018e7:	85 f6                	test   %esi,%esi
  8018e9:	74 2f                	je     80191a <_Z5readniPvj+0x42>
  8018eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018f0:	89 f0                	mov    %esi,%eax
  8018f2:	29 d8                	sub    %ebx,%eax
  8018f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 34 ff ff ff       	call   80183e <_Z4readiPvj>
		if (m < 0)
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 13                	js     801921 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80190e:	85 c0                	test   %eax,%eax
  801910:	74 0d                	je     80191f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801912:	01 c3                	add    %eax,%ebx
  801914:	39 de                	cmp    %ebx,%esi
  801916:	77 d8                	ja     8018f0 <_Z5readniPvj+0x18>
  801918:	eb 05                	jmp    80191f <_Z5readniPvj+0x47>
  80191a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80191f:	89 d8                	mov    %ebx,%eax
}
  801921:	83 c4 1c             	add    $0x1c,%esp
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5f                   	pop    %edi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    

00801929 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80192f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801936:	00 
  801937:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80193a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	89 04 24             	mov    %eax,(%esp)
  801944:	e8 48 fb ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 3c                	js     801989 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801950:	89 44 24 04          	mov    %eax,0x4(%esp)
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801957:	8b 00                	mov    (%eax),%eax
  801959:	89 04 24             	mov    %eax,(%esp)
  80195c:	e8 41 fc ff ff       	call   8015a2 <_Z10dev_lookupiPP3Dev>
  801961:	85 c0                	test   %eax,%eax
  801963:	79 26                	jns    80198b <_Z5writeiPKvj+0x62>
  801965:	eb 22                	jmp    801989 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80196d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801972:	85 c9                	test   %ecx,%ecx
  801974:	74 13                	je     801989 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801976:	8b 45 10             	mov    0x10(%ebp),%eax
  801979:	89 44 24 08          	mov    %eax,0x8(%esp)
  80197d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801980:	89 44 24 04          	mov    %eax,0x4(%esp)
  801984:	89 14 24             	mov    %edx,(%esp)
  801987:	ff d1                	call   *%ecx
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80198b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80198e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801993:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801997:	74 f0                	je     801989 <_Z5writeiPKvj+0x60>
  801999:	eb cc                	jmp    801967 <_Z5writeiPKvj+0x3e>

0080199b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8019a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8019a8:	00 
  8019a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 d6 fa ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 0e                	js     8019cd <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	53                   	push   %ebx
  8019d3:	83 ec 24             	sub    $0x24,%esp
  8019d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8019d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8019e0:	00 
  8019e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	89 1c 24             	mov    %ebx,(%esp)
  8019eb:	e8 a1 fa ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 58                	js     801a4c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 9a fb ff ff       	call   8015a2 <_Z10dev_lookupiPP3Dev>
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	79 46                	jns    801a52 <_Z9ftruncateii+0x83>
  801a0c:	eb 3e                	jmp    801a4c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801a0e:	a1 00 70 80 00       	mov    0x807000,%eax
  801a13:	8b 40 04             	mov    0x4(%eax),%eax
  801a16:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1e:	c7 04 24 c8 4c 80 00 	movl   $0x804cc8,(%esp)
  801a25:	e8 a0 ea ff ff       	call   8004ca <_Z7cprintfPKcz>
		return -E_INVAL;
  801a2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a2f:	eb 1b                	jmp    801a4c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a34:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801a37:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a3c:	85 d2                	test   %edx,%edx
  801a3e:	74 0c                	je     801a4c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	89 0c 24             	mov    %ecx,(%esp)
  801a4a:	ff d2                	call   *%edx
}
  801a4c:	83 c4 24             	add    $0x24,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a52:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a55:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801a59:	75 d6                	jne    801a31 <_Z9ftruncateii+0x62>
  801a5b:	eb b1                	jmp    801a0e <_Z9ftruncateii+0x3f>

00801a5d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	53                   	push   %ebx
  801a61:	83 ec 24             	sub    $0x24,%esp
  801a64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a67:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a6e:	00 
  801a6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	89 04 24             	mov    %eax,(%esp)
  801a7c:	e8 10 fa ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 3e                	js     801ac3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	e8 09 fb ff ff       	call   8015a2 <_Z10dev_lookupiPP3Dev>
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	79 2c                	jns    801ac9 <_Z5fstatiP4Stat+0x6c>
  801a9d:	eb 24                	jmp    801ac3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a9f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aa2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801aa9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801ab0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ab6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abd:	89 04 24             	mov    %eax,(%esp)
  801ac0:	ff 52 14             	call   *0x14(%edx)
}
  801ac3:	83 c4 24             	add    $0x24,%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801acc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801ad1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801ad5:	75 c8                	jne    801a9f <_Z5fstatiP4Stat+0x42>
  801ad7:	eb ea                	jmp    801ac3 <_Z5fstatiP4Stat+0x66>

00801ad9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 18             	sub    $0x18,%esp
  801adf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ae2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aec:	00 
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	89 04 24             	mov    %eax,(%esp)
  801af3:	e8 d6 09 00 00       	call   8024ce <_Z4openPKci>
  801af8:	89 c3                	mov    %eax,%ebx
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 1b                	js     801b19 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b05:	89 1c 24             	mov    %ebx,(%esp)
  801b08:	e8 50 ff ff ff       	call   801a5d <_Z5fstatiP4Stat>
  801b0d:	89 c6                	mov    %eax,%esi
	close(fd);
  801b0f:	89 1c 24             	mov    %ebx,(%esp)
  801b12:	e8 7e fb ff ff       	call   801695 <_Z5closei>
	return r;
  801b17:	89 f3                	mov    %esi,%ebx
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b1e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b21:	89 ec                	mov    %ebp,%esp
  801b23:	5d                   	pop    %ebp
  801b24:	c3                   	ret    
	...

00801b30 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801b33:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801b38:	85 d2                	test   %edx,%edx
  801b3a:	78 33                	js     801b6f <_ZL10inode_dataP5Inodei+0x3f>
  801b3c:	3b 50 08             	cmp    0x8(%eax),%edx
  801b3f:	7d 2e                	jge    801b6f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801b41:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801b47:	85 d2                	test   %edx,%edx
  801b49:	0f 49 ca             	cmovns %edx,%ecx
  801b4c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801b4f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801b53:	c1 e1 0c             	shl    $0xc,%ecx
  801b56:	89 d0                	mov    %edx,%eax
  801b58:	c1 f8 1f             	sar    $0x1f,%eax
  801b5b:	c1 e8 14             	shr    $0x14,%eax
  801b5e:	01 c2                	add    %eax,%edx
  801b60:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801b66:	29 c2                	sub    %eax,%edx
  801b68:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801b6f:	89 c8                	mov    %ecx,%eax
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    

00801b73 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801b76:	8b 48 08             	mov    0x8(%eax),%ecx
  801b79:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801b7c:	8b 00                	mov    (%eax),%eax
  801b7e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801b81:	c7 82 80 00 00 00 24 	movl   $0x806024,0x80(%edx)
  801b88:	60 80 00 
}
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    

00801b8d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801b93:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	74 08                	je     801ba5 <_ZL9get_inodei+0x18>
  801b9d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801ba3:	7e 20                	jle    801bc5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801ba5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba9:	c7 44 24 08 00 4d 80 	movl   $0x804d00,0x8(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801bb8:	00 
  801bb9:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  801bc0:	e8 e7 e7 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801bc5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801bcb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801bd1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801bd7:	85 d2                	test   %edx,%edx
  801bd9:	0f 48 d1             	cmovs  %ecx,%edx
  801bdc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801bdf:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801be6:	c1 e0 0c             	shl    $0xc,%eax
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801bf3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801bf9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801bfc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801c02:	76 20                	jbe    801c24 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801c04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c08:	c7 44 24 08 3c 4d 80 	movl   $0x804d3c,0x8(%esp)
  801c0f:	00 
  801c10:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801c17:	00 
  801c18:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  801c1f:	e8 88 e7 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801c24:	83 fe 01             	cmp    $0x1,%esi
  801c27:	7e 08                	jle    801c31 <_ZL10bcache_ipcPvi+0x46>
  801c29:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801c2f:	7d 12                	jge    801c43 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801c31:	89 f3                	mov    %esi,%ebx
  801c33:	c1 e3 04             	shl    $0x4,%ebx
  801c36:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801c38:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801c3e:	c1 e6 0c             	shl    $0xc,%esi
  801c41:	eb 20                	jmp    801c63 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801c43:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c47:	c7 44 24 08 6c 4d 80 	movl   $0x804d6c,0x8(%esp)
  801c4e:	00 
  801c4f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801c56:	00 
  801c57:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  801c5e:	e8 49 e7 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801c63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c6a:	00 
  801c6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c72:	00 
  801c73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c77:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801c7e:	e8 5c 24 00 00       	call   8040df <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801c83:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c8a:	00 
  801c8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c96:	e8 b5 23 00 00       	call   804050 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801c9b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801c9e:	74 c3                	je     801c63 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    

00801ca7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 28             	sub    $0x28,%esp
  801cad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cb0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cb3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cb6:	89 c7                	mov    %eax,%edi
  801cb8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801cba:	c7 04 24 4d 1f 80 00 	movl   $0x801f4d,(%esp)
  801cc1:	e8 95 22 00 00       	call   803f5b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801cc6:	89 f8                	mov    %edi,%eax
  801cc8:	e8 c0 fe ff ff       	call   801b8d <_ZL9get_inodei>
  801ccd:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801ccf:	ba 02 00 00 00       	mov    $0x2,%edx
  801cd4:	e8 12 ff ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	79 08                	jns    801ce5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801cdd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801ce3:	eb 2e                	jmp    801d13 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	75 1c                	jne    801d05 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801ce9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801cef:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801cf6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801cf9:	ba 06 00 00 00       	mov    $0x6,%edx
  801cfe:	89 d8                	mov    %ebx,%eax
  801d00:	e8 e6 fe ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801d05:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801d0c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d13:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d16:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d19:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d1c:	89 ec                	mov    %ebp,%esp
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	57                   	push   %edi
  801d24:	56                   	push   %esi
  801d25:	53                   	push   %ebx
  801d26:	83 ec 2c             	sub    $0x2c,%esp
  801d29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d2c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801d2f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801d34:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801d3a:	0f 87 3d 01 00 00    	ja     801e7d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801d40:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d43:	8b 42 08             	mov    0x8(%edx),%eax
  801d46:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	0f 49 f0             	cmovns %eax,%esi
  801d51:	c1 fe 0c             	sar    $0xc,%esi
  801d54:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801d56:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801d59:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801d5f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801d62:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801d65:	0f 82 a6 00 00 00    	jb     801e11 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801d6b:	39 fe                	cmp    %edi,%esi
  801d6d:	0f 8d f2 00 00 00    	jge    801e65 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801d73:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801d77:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801d7a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801d7d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801d80:	83 3e 00             	cmpl   $0x0,(%esi)
  801d83:	75 77                	jne    801dfc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d85:	ba 02 00 00 00       	mov    $0x2,%edx
  801d8a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d8f:	e8 57 fe ff ff       	call   801beb <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801d94:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801d9a:	83 f9 02             	cmp    $0x2,%ecx
  801d9d:	7e 43                	jle    801de2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801d9f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801da4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801da9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801db0:	74 29                	je     801ddb <_ZL14inode_set_sizeP5Inodej+0xbb>
  801db2:	e9 ce 00 00 00       	jmp    801e85 <_ZL14inode_set_sizeP5Inodej+0x165>
  801db7:	89 c7                	mov    %eax,%edi
  801db9:	0f b6 10             	movzbl (%eax),%edx
  801dbc:	83 c0 01             	add    $0x1,%eax
  801dbf:	84 d2                	test   %dl,%dl
  801dc1:	74 18                	je     801ddb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801dc3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801dc6:	ba 05 00 00 00       	mov    $0x5,%edx
  801dcb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801dd0:	e8 16 fe ff ff       	call   801beb <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801dd5:	85 db                	test   %ebx,%ebx
  801dd7:	79 1e                	jns    801df7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801dd9:	eb 07                	jmp    801de2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801ddb:	83 c3 01             	add    $0x1,%ebx
  801dde:	39 d9                	cmp    %ebx,%ecx
  801de0:	7f d5                	jg     801db7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801de5:	8b 50 08             	mov    0x8(%eax),%edx
  801de8:	e8 33 ff ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801ded:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801df2:	e9 86 00 00 00       	jmp    801e7d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801df7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dfa:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801dfc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801e00:	83 c6 04             	add    $0x4,%esi
  801e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e06:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801e09:	0f 8f 6e ff ff ff    	jg     801d7d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801e0f:	eb 54                	jmp    801e65 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801e11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e14:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801e19:	83 f8 01             	cmp    $0x1,%eax
  801e1c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801e1f:	ba 02 00 00 00       	mov    $0x2,%edx
  801e24:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e29:	e8 bd fd ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801e2e:	39 f7                	cmp    %esi,%edi
  801e30:	7d 24                	jge    801e56 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801e32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e35:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801e39:	8b 10                	mov    (%eax),%edx
  801e3b:	85 d2                	test   %edx,%edx
  801e3d:	74 0d                	je     801e4c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801e3f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801e46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801e4c:	83 eb 01             	sub    $0x1,%ebx
  801e4f:	83 e8 04             	sub    $0x4,%eax
  801e52:	39 fb                	cmp    %edi,%ebx
  801e54:	75 e3                	jne    801e39 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801e56:	ba 05 00 00 00       	mov    $0x5,%edx
  801e5b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e60:	e8 86 fd ff ff       	call   801beb <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801e65:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e6b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801e6e:	ba 04 00 00 00       	mov    $0x4,%edx
  801e73:	e8 73 fd ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7d:	83 c4 2c             	add    $0x2c,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801e85:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801e8c:	ba 05 00 00 00       	mov    $0x5,%edx
  801e91:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e96:	e8 50 fd ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801e9b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801ea0:	e9 52 ff ff ff       	jmp    801df7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801ea5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	53                   	push   %ebx
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801eae:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801eb4:	83 e8 01             	sub    $0x1,%eax
  801eb7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801ebd:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801ec1:	75 40                	jne    801f03 <_ZL11inode_closeP5Inode+0x5e>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	75 3c                	jne    801f03 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801ec7:	ba 02 00 00 00       	mov    $0x2,%edx
  801ecc:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ed1:	e8 15 fd ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801edb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801edf:	85 d2                	test   %edx,%edx
  801ee1:	74 07                	je     801eea <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801ee3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801eea:	83 c0 01             	add    $0x1,%eax
  801eed:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801ef2:	75 e7                	jne    801edb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801ef4:	ba 05 00 00 00       	mov    $0x5,%edx
  801ef9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801efe:	e8 e8 fc ff ff       	call   801beb <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801f03:	ba 03 00 00 00       	mov    $0x3,%edx
  801f08:	89 d8                	mov    %ebx,%eax
  801f0a:	e8 dc fc ff ff       	call   801beb <_ZL10bcache_ipcPvi>
}
  801f0f:	83 c4 04             	add    $0x4,%esp
  801f12:	5b                   	pop    %ebx
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    

00801f15 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	53                   	push   %ebx
  801f19:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f22:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f25:	e8 7d fd ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 15                	js     801f45 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	e8 e5 fd ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
  801f3b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	e8 60 ff ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
	return r;
}
  801f45:	89 d8                	mov    %ebx,%eax
  801f47:	83 c4 14             	add    $0x14,%esp
  801f4a:	5b                   	pop    %ebx
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	53                   	push   %ebx
  801f51:	83 ec 14             	sub    $0x14,%esp
  801f54:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801f57:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801f59:	89 c2                	mov    %eax,%edx
  801f5b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801f61:	78 32                	js     801f95 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801f63:	ba 00 00 00 00       	mov    $0x0,%edx
  801f68:	e8 7e fc ff ff       	call   801beb <_ZL10bcache_ipcPvi>
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	74 1c                	je     801f8d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801f71:	c7 44 24 08 21 4d 80 	movl   $0x804d21,0x8(%esp)
  801f78:	00 
  801f79:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801f80:	00 
  801f81:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  801f88:	e8 1f e4 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
    resume(utf);
  801f8d:	89 1c 24             	mov    %ebx,(%esp)
  801f90:	e8 9b 20 00 00       	call   804030 <resume>
}
  801f95:	83 c4 14             	add    $0x14,%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5d                   	pop    %ebp
  801f9a:	c3                   	ret    

00801f9b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 28             	sub    $0x28,%esp
  801fa1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fa4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801faa:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801fad:	8b 43 0c             	mov    0xc(%ebx),%eax
  801fb0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fb3:	e8 ef fc ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 26                	js     801fe2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801fbc:	83 c3 10             	add    $0x10,%ebx
  801fbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc3:	89 34 24             	mov    %esi,(%esp)
  801fc6:	e8 1f eb ff ff       	call   800aea <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801fcb:	89 f2                	mov    %esi,%edx
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	e8 9e fb ff ff       	call   801b73 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	e8 c8 fe ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
	return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801fe5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801fe8:	89 ec                	mov    %ebp,%esp
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    

00801fec <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 24             	sub    $0x24,%esp
  801ff3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801ff6:	89 1c 24             	mov    %ebx,(%esp)
  801ff9:	e8 9e 15 00 00       	call   80359c <_Z7pagerefPv>
  801ffe:	89 c2                	mov    %eax,%edx
        return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802005:	83 fa 01             	cmp    $0x1,%edx
  802008:	7f 1e                	jg     802028 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80200a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80200d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802010:	e8 92 fc ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  802015:	85 c0                	test   %eax,%eax
  802017:	78 0f                	js     802028 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802023:	e8 7d fe ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
}
  802028:	83 c4 24             	add    $0x24,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 3c             	sub    $0x3c,%esp
  802037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80203a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80203d:	8b 43 04             	mov    0x4(%ebx),%eax
  802040:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802043:	8b 43 0c             	mov    0xc(%ebx),%eax
  802046:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802049:	e8 59 fc ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  80204e:	85 c0                	test   %eax,%eax
  802050:	0f 88 8c 00 00 00    	js     8020e2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802056:	8b 53 04             	mov    0x4(%ebx),%edx
  802059:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80205f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802065:	29 d7                	sub    %edx,%edi
  802067:	39 f7                	cmp    %esi,%edi
  802069:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80206c:	85 ff                	test   %edi,%edi
  80206e:	74 16                	je     802086 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802070:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802076:	3b 50 08             	cmp    0x8(%eax),%edx
  802079:	76 6f                	jbe    8020ea <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80207b:	e8 a0 fc ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802080:	85 c0                	test   %eax,%eax
  802082:	79 66                	jns    8020ea <_ZL13devfile_writeP2FdPKvj+0xbc>
  802084:	eb 4e                	jmp    8020d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802086:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80208c:	76 24                	jbe    8020b2 <_ZL13devfile_writeP2FdPKvj+0x84>
  80208e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802090:	8b 53 04             	mov    0x4(%ebx),%edx
  802093:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80209c:	3b 50 08             	cmp    0x8(%eax),%edx
  80209f:	0f 86 83 00 00 00    	jbe    802128 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8020a5:	e8 76 fc ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	79 7a                	jns    802128 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8020ae:	66 90                	xchg   %ax,%ax
  8020b0:	eb 22                	jmp    8020d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8020b2:	85 f6                	test   %esi,%esi
  8020b4:	74 1e                	je     8020d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8020b6:	89 f2                	mov    %esi,%edx
  8020b8:	03 53 04             	add    0x4(%ebx),%edx
  8020bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020be:	3b 50 08             	cmp    0x8(%eax),%edx
  8020c1:	0f 86 b8 00 00 00    	jbe    80217f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  8020c7:	e8 54 fc ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	0f 89 ab 00 00 00    	jns    80217f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  8020d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d7:	e8 c9 fd ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8020dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8020df:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8020e2:	83 c4 3c             	add    $0x3c,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5f                   	pop    %edi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8020ea:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8020ec:	8b 53 04             	mov    0x4(%ebx),%edx
  8020ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f2:	e8 39 fa ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  8020f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8020fa:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802101:	89 44 24 04          	mov    %eax,0x4(%esp)
  802105:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 f7 eb ff ff       	call   800d07 <memcpy>
        fd->fd_offset += n2;
  802110:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802113:	ba 04 00 00 00       	mov    $0x4,%edx
  802118:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80211b:	e8 cb fa ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802120:	01 7d 0c             	add    %edi,0xc(%ebp)
  802123:	e9 5e ff ff ff       	jmp    802086 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802128:	8b 53 04             	mov    0x4(%ebx),%edx
  80212b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212e:	e8 fd f9 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  802133:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802135:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80213c:	00 
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	89 44 24 04          	mov    %eax,0x4(%esp)
  802144:	89 34 24             	mov    %esi,(%esp)
  802147:	e8 bb eb ff ff       	call   800d07 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80214c:	ba 04 00 00 00       	mov    $0x4,%edx
  802151:	89 f0                	mov    %esi,%eax
  802153:	e8 93 fa ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802158:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80215e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802165:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80216c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802172:	0f 87 18 ff ff ff    	ja     802090 <_ZL13devfile_writeP2FdPKvj+0x62>
  802178:	89 fe                	mov    %edi,%esi
  80217a:	e9 33 ff ff ff       	jmp    8020b2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80217f:	8b 53 04             	mov    0x4(%ebx),%edx
  802182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802185:	e8 a6 f9 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  80218a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80218c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	89 44 24 04          	mov    %eax,0x4(%esp)
  802197:	89 3c 24             	mov    %edi,(%esp)
  80219a:	e8 68 eb ff ff       	call   800d07 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80219f:	ba 04 00 00 00       	mov    $0x4,%edx
  8021a4:	89 f8                	mov    %edi,%eax
  8021a6:	e8 40 fa ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8021ab:	01 73 04             	add    %esi,0x4(%ebx)
  8021ae:	e9 21 ff ff ff       	jmp    8020d4 <_ZL13devfile_writeP2FdPKvj+0xa6>

008021b3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	57                   	push   %edi
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	83 ec 3c             	sub    $0x3c,%esp
  8021bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021bf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8021c2:	8b 43 04             	mov    0x4(%ebx),%eax
  8021c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8021c8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021cb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8021ce:	e8 d4 fa ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	0f 88 d3 00 00 00    	js     8022ae <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8021db:	8b 73 04             	mov    0x4(%ebx),%esi
  8021de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8021e4:	8b 50 08             	mov    0x8(%eax),%edx
  8021e7:	29 f2                	sub    %esi,%edx
  8021e9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8021ec:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8021ef:	89 f2                	mov    %esi,%edx
  8021f1:	e8 3a f9 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	0f 84 a2 00 00 00    	je     8022a0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8021fe:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802204:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80220a:	29 f2                	sub    %esi,%edx
  80220c:	39 d7                	cmp    %edx,%edi
  80220e:	0f 46 d7             	cmovbe %edi,%edx
  802211:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802214:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802216:	01 d6                	add    %edx,%esi
  802218:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80221b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802223:	8b 45 0c             	mov    0xc(%ebp),%eax
  802226:	89 04 24             	mov    %eax,(%esp)
  802229:	e8 d9 ea ff ff       	call   800d07 <memcpy>
    buf = (void *)((char *)buf + n2);
  80222e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802231:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802234:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80223a:	76 3e                	jbe    80227a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80223c:	8b 53 04             	mov    0x4(%ebx),%edx
  80223f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802242:	e8 e9 f8 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  802247:	85 c0                	test   %eax,%eax
  802249:	74 55                	je     8022a0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80224b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802252:	00 
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	89 34 24             	mov    %esi,(%esp)
  80225a:	e8 a8 ea ff ff       	call   800d07 <memcpy>
        n -= PGSIZE;
  80225f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802265:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80226b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802272:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802278:	77 c2                	ja     80223c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80227a:	85 ff                	test   %edi,%edi
  80227c:	74 22                	je     8022a0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80227e:	8b 53 04             	mov    0x4(%ebx),%edx
  802281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802284:	e8 a7 f8 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 13                	je     8022a0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80228d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802291:	89 44 24 04          	mov    %eax,0x4(%esp)
  802295:	89 34 24             	mov    %esi,(%esp)
  802298:	e8 6a ea ff ff       	call   800d07 <memcpy>
        fd->fd_offset += n;
  80229d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8022a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a3:	e8 fd fb ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8022a8:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ab:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8022ae:	83 c4 3c             	add    $0x3c,%esp
  8022b1:	5b                   	pop    %ebx
  8022b2:	5e                   	pop    %esi
  8022b3:	5f                   	pop    %edi
  8022b4:	5d                   	pop    %ebp
  8022b5:	c3                   	ret    

008022b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	57                   	push   %edi
  8022ba:	56                   	push   %esi
  8022bb:	53                   	push   %ebx
  8022bc:	83 ec 4c             	sub    $0x4c,%esp
  8022bf:	89 c6                	mov    %eax,%esi
  8022c1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8022c4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8022c7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8022cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8022d6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8022d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022de:	e8 c4 f9 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  8022e3:	89 c7                	mov    %eax,%edi
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	0f 88 cd 01 00 00    	js     8024ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8022ed:	89 f3                	mov    %esi,%ebx
  8022ef:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8022f2:	75 08                	jne    8022fc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8022f4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8022f7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8022fa:	74 f8                	je     8022f4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8022fc:	0f b6 03             	movzbl (%ebx),%eax
  8022ff:	3c 2f                	cmp    $0x2f,%al
  802301:	74 16                	je     802319 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802303:	84 c0                	test   %al,%al
  802305:	74 12                	je     802319 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802307:	89 da                	mov    %ebx,%edx
		++path;
  802309:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80230c:	0f b6 02             	movzbl (%edx),%eax
  80230f:	3c 2f                	cmp    $0x2f,%al
  802311:	74 08                	je     80231b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802313:	84 c0                	test   %al,%al
  802315:	75 f2                	jne    802309 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802317:	eb 02                	jmp    80231b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802319:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	29 d8                	sub    %ebx,%eax
  80231f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802322:	0f b6 02             	movzbl (%edx),%eax
  802325:	89 d6                	mov    %edx,%esi
  802327:	3c 2f                	cmp    $0x2f,%al
  802329:	75 0a                	jne    802335 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80232b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80232e:	0f b6 06             	movzbl (%esi),%eax
  802331:	3c 2f                	cmp    $0x2f,%al
  802333:	74 f6                	je     80232b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802335:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802339:	75 1b                	jne    802356 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80233b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802341:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802343:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802346:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80234c:	bf 00 00 00 00       	mov    $0x0,%edi
  802351:	e9 64 01 00 00       	jmp    8024ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802356:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80235a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235e:	74 06                	je     802366 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802360:	84 c0                	test   %al,%al
  802362:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802369:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80236c:	83 3a 02             	cmpl   $0x2,(%edx)
  80236f:	0f 85 f4 00 00 00    	jne    802469 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802375:	89 d0                	mov    %edx,%eax
  802377:	8b 52 08             	mov    0x8(%edx),%edx
  80237a:	85 d2                	test   %edx,%edx
  80237c:	7e 78                	jle    8023f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80237e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802385:	bf 00 00 00 00       	mov    $0x0,%edi
  80238a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80238d:	89 fb                	mov    %edi,%ebx
  80238f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802392:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802394:	89 da                	mov    %ebx,%edx
  802396:	89 f0                	mov    %esi,%eax
  802398:	e8 93 f7 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  80239d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80239f:	83 38 00             	cmpl   $0x0,(%eax)
  8023a2:	74 26                	je     8023ca <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8023a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8023aa:	75 33                	jne    8023df <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8023ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b7:	8d 47 08             	lea    0x8(%edi),%eax
  8023ba:	89 04 24             	mov    %eax,(%esp)
  8023bd:	e8 86 e9 ff ff       	call   800d48 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	0f 84 fa 00 00 00    	je     8024c4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8023ca:	83 3f 00             	cmpl   $0x0,(%edi)
  8023cd:	75 10                	jne    8023df <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8023cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8023d3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8023d6:	84 c0                	test   %al,%al
  8023d8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8023dc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8023df:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8023e5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8023e7:	8b 56 08             	mov    0x8(%esi),%edx
  8023ea:	39 d0                	cmp    %edx,%eax
  8023ec:	7c a6                	jl     802394 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8023ee:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8023f1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8023f4:	eb 07                	jmp    8023fd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8023f6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8023fd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802401:	74 6d                	je     802470 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802403:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802407:	75 24                	jne    80242d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802409:	83 ea 80             	sub    $0xffffff80,%edx
  80240c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80240f:	e8 0c f9 ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802414:	85 c0                	test   %eax,%eax
  802416:	0f 88 90 00 00 00    	js     8024ac <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80241c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80241f:	8b 50 08             	mov    0x8(%eax),%edx
  802422:	83 c2 80             	add    $0xffffff80,%edx
  802425:	e8 06 f7 ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  80242a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80242d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802434:	00 
  802435:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80243c:	00 
  80243d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802440:	89 14 24             	mov    %edx,(%esp)
  802443:	e8 e9 e7 ff ff       	call   800c31 <memset>
	empty->de_namelen = namelen;
  802448:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80244b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80244e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802451:	89 54 24 08          	mov    %edx,0x8(%esp)
  802455:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802459:	83 c0 08             	add    $0x8,%eax
  80245c:	89 04 24             	mov    %eax,(%esp)
  80245f:	e8 a3 e8 ff ff       	call   800d07 <memcpy>
	*de_store = empty;
  802464:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802467:	eb 5e                	jmp    8024c7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802469:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80246e:	eb 42                	jmp    8024b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802470:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802475:	eb 3b                	jmp    8024b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80247d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80247f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802482:	89 38                	mov    %edi,(%eax)
			return 0;
  802484:	bf 00 00 00 00       	mov    $0x0,%edi
  802489:	eb 2f                	jmp    8024ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80248b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80248e:	8b 07                	mov    (%edi),%eax
  802490:	e8 12 f8 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  802495:	85 c0                	test   %eax,%eax
  802497:	78 17                	js     8024b0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249c:	e8 04 fa ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8024a7:	e9 41 fe ff ff       	jmp    8022ed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	eb 02                	jmp    8024b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8024b0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8024b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b5:	e8 eb f9 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
	return r;
}
  8024ba:	89 f8                	mov    %edi,%eax
  8024bc:	83 c4 4c             	add    $0x4c,%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5f                   	pop    %edi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    
  8024c4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8024c7:	80 3e 00             	cmpb   $0x0,(%esi)
  8024ca:	75 bf                	jne    80248b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8024cc:	eb a9                	jmp    802477 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008024ce <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 3c             	sub    $0x3c,%esp
  8024d7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8024da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8024dd:	89 04 24             	mov    %eax,(%esp)
  8024e0:	e8 62 f0 ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  8024e5:	89 c3                	mov    %eax,%ebx
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	0f 88 16 02 00 00    	js     802705 <_Z4openPKci+0x237>
  8024ef:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f6:	00 
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802505:	e8 c6 ea ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  80250a:	89 c3                	mov    %eax,%ebx
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
  802511:	85 db                	test   %ebx,%ebx
  802513:	0f 88 ec 01 00 00    	js     802705 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802519:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80251d:	0f 84 ec 01 00 00    	je     80270f <_Z4openPKci+0x241>
  802523:	83 c0 01             	add    $0x1,%eax
  802526:	83 f8 78             	cmp    $0x78,%eax
  802529:	75 ee                	jne    802519 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80252b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802530:	e9 b9 01 00 00       	jmp    8026ee <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802535:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802538:	81 e7 00 01 00 00    	and    $0x100,%edi
  80253e:	89 3c 24             	mov    %edi,(%esp)
  802541:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802544:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802547:	89 f0                	mov    %esi,%eax
  802549:	e8 68 fd ff ff       	call   8022b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80254e:	89 c3                	mov    %eax,%ebx
  802550:	85 c0                	test   %eax,%eax
  802552:	0f 85 96 01 00 00    	jne    8026ee <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802558:	85 ff                	test   %edi,%edi
  80255a:	75 41                	jne    80259d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80255c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80255f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802564:	75 08                	jne    80256e <_Z4openPKci+0xa0>
            fileino = dirino;
  802566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80256c:	eb 14                	jmp    802582 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80256e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802571:	8b 00                	mov    (%eax),%eax
  802573:	e8 2f f7 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  802578:	89 c3                	mov    %eax,%ebx
  80257a:	85 c0                	test   %eax,%eax
  80257c:	0f 88 5d 01 00 00    	js     8026df <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802582:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802585:	83 38 02             	cmpl   $0x2,(%eax)
  802588:	0f 85 d2 00 00 00    	jne    802660 <_Z4openPKci+0x192>
  80258e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802592:	0f 84 c8 00 00 00    	je     802660 <_Z4openPKci+0x192>
  802598:	e9 38 01 00 00       	jmp    8026d5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80259d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8025a4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8025ab:	0f 8e a8 00 00 00    	jle    802659 <_Z4openPKci+0x18b>
  8025b1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8025b6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	e8 e7 f6 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  8025c0:	89 c3                	mov    %eax,%ebx
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	0f 88 15 01 00 00    	js     8026df <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8025ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025cd:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8025d1:	75 68                	jne    80263b <_Z4openPKci+0x16d>
  8025d3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8025da:	75 5f                	jne    80263b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8025dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8025df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8025e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025e8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8025ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8025f6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8025fd:	00 
  8025fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802605:	00 
  802606:	83 c0 0c             	add    $0xc,%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 20 e6 ff ff       	call   800c31 <memset>
        de->de_inum = fileino->i_inum;
  802611:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802614:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80261a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80261d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80261f:	ba 04 00 00 00       	mov    $0x4,%edx
  802624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802627:	e8 bf f5 ff ff       	call   801beb <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80262c:	ba 04 00 00 00       	mov    $0x4,%edx
  802631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802634:	e8 b2 f5 ff ff       	call   801beb <_ZL10bcache_ipcPvi>
  802639:	eb 25                	jmp    802660 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80263b:	e8 65 f8 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802640:	83 c7 01             	add    $0x1,%edi
  802643:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802649:	0f 8c 67 ff ff ff    	jl     8025b6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80264f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802654:	e9 86 00 00 00       	jmp    8026df <_Z4openPKci+0x211>
  802659:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80265e:	eb 7f                	jmp    8026df <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802660:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802667:	74 0d                	je     802676 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802669:	ba 00 00 00 00       	mov    $0x0,%edx
  80266e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802671:	e8 aa f6 ff ff       	call   801d20 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802676:	8b 15 24 60 80 00    	mov    0x806024,%edx
  80267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80268b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802691:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802694:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80269a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80269d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026a1:	83 c0 10             	add    $0x10,%eax
  8026a4:	89 04 24             	mov    %eax,(%esp)
  8026a7:	e8 3e e4 ff ff       	call   800aea <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8026ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026af:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  8026b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b9:	e8 e7 f7 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  8026be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c1:	e8 df f7 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  8026c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c9:	89 04 24             	mov    %eax,(%esp)
  8026cc:	e8 13 ee ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	eb 30                	jmp    802705 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  8026d5:	e8 cb f7 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  8026da:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	e8 be f7 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
  8026e7:	eb 05                	jmp    8026ee <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8026e9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  8026ee:	a1 00 70 80 00       	mov    0x807000,%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026fd:	89 04 24             	mov    %eax,(%esp)
  802700:	e8 88 e9 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802705:	89 d8                	mov    %ebx,%eax
  802707:	83 c4 3c             	add    $0x3c,%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80270f:	83 f8 78             	cmp    $0x78,%eax
  802712:	0f 85 1d fe ff ff    	jne    802535 <_Z4openPKci+0x67>
  802718:	eb cf                	jmp    8026e9 <_Z4openPKci+0x21b>

0080271a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	53                   	push   %ebx
  80271e:	83 ec 24             	sub    $0x24,%esp
  802721:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802724:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	e8 78 f5 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 27                	js     80275a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802733:	c7 44 24 04 34 4d 80 	movl   $0x804d34,0x4(%esp)
  80273a:	00 
  80273b:	89 1c 24             	mov    %ebx,(%esp)
  80273e:	e8 a7 e3 ff ff       	call   800aea <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802743:	89 da                	mov    %ebx,%edx
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	e8 26 f4 ff ff       	call   801b73 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	e8 50 f7 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
	return 0;
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275a:	83 c4 24             	add    $0x24,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    

00802760 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	53                   	push   %ebx
  802764:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802767:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802771:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	e8 3a fb ff ff       	call   8022b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80277c:	89 c3                	mov    %eax,%ebx
  80277e:	85 c0                	test   %eax,%eax
  802780:	78 5f                	js     8027e1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802782:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	e8 18 f5 ff ff       	call   801ca7 <_ZL10inode_openiPP5Inode>
  80278f:	89 c3                	mov    %eax,%ebx
  802791:	85 c0                	test   %eax,%eax
  802793:	78 44                	js     8027d9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802795:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	83 38 02             	cmpl   $0x2,(%eax)
  8027a0:	74 2f                	je     8027d1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  8027a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  8027b2:	ba 04 00 00 00       	mov    $0x4,%edx
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	e8 2c f4 ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  8027bf:	ba 04 00 00 00       	mov    $0x4,%edx
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	e8 1f f4 ff ff       	call   801beb <_ZL10bcache_ipcPvi>
	r = 0;
  8027cc:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  8027d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d4:	e8 cc f6 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	e8 c4 f6 ff ff       	call   801ea5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8027e1:	89 d8                	mov    %ebx,%eax
  8027e3:	83 c4 24             	add    $0x24,%esp
  8027e6:	5b                   	pop    %ebx
  8027e7:	5d                   	pop    %ebp
  8027e8:	c3                   	ret    

008027e9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    

008027f3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	57                   	push   %edi
  8027f7:	56                   	push   %esi
  8027f8:	53                   	push   %ebx
  8027f9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  8027ff:	c7 04 24 4d 1f 80 00 	movl   $0x801f4d,(%esp)
  802806:	e8 50 17 00 00       	call   803f5b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80280b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802810:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802815:	74 28                	je     80283f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802817:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80281e:	4a 
  80281f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802823:	c7 44 24 08 9c 4d 80 	movl   $0x804d9c,0x8(%esp)
  80282a:	00 
  80282b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802832:	00 
  802833:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  80283a:	e8 6d db ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  80283f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802844:	83 f8 03             	cmp    $0x3,%eax
  802847:	7f 1c                	jg     802865 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802849:	c7 44 24 08 d0 4d 80 	movl   $0x804dd0,0x8(%esp)
  802850:	00 
  802851:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802858:	00 
  802859:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  802860:	e8 47 db ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802865:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80286b:	85 d2                	test   %edx,%edx
  80286d:	7f 1c                	jg     80288b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80286f:	c7 44 24 08 00 4e 80 	movl   $0x804e00,0x8(%esp)
  802876:	00 
  802877:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80287e:	00 
  80287f:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  802886:	e8 21 db ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80288b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802891:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802897:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80289d:	85 c9                	test   %ecx,%ecx
  80289f:	0f 48 cb             	cmovs  %ebx,%ecx
  8028a2:	c1 f9 0c             	sar    $0xc,%ecx
  8028a5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  8028a9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  8028af:	39 c8                	cmp    %ecx,%eax
  8028b1:	7c 13                	jl     8028c6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	7f 3d                	jg     8028f4 <_Z4fsckv+0x101>
  8028b7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8028be:	00 00 00 
  8028c1:	e9 ac 00 00 00       	jmp    802972 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  8028c6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  8028cc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8028d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028d8:	c7 44 24 08 30 4e 80 	movl   $0x804e30,0x8(%esp)
  8028df:	00 
  8028e0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8028e7:	00 
  8028e8:	c7 04 24 16 4d 80 00 	movl   $0x804d16,(%esp)
  8028ef:	e8 b8 da ff ff       	call   8003ac <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8028f4:	be 00 20 00 50       	mov    $0x50002000,%esi
  8028f9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802900:	00 00 00 
  802903:	bb 00 00 00 00       	mov    $0x0,%ebx
  802908:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80290e:	39 df                	cmp    %ebx,%edi
  802910:	7e 27                	jle    802939 <_Z4fsckv+0x146>
  802912:	0f b6 06             	movzbl (%esi),%eax
  802915:	84 c0                	test   %al,%al
  802917:	74 4b                	je     802964 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802919:	0f be c0             	movsbl %al,%eax
  80291c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802924:	c7 04 24 74 4e 80 00 	movl   $0x804e74,(%esp)
  80292b:	e8 9a db ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802930:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802937:	eb 2b                	jmp    802964 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802939:	0f b6 06             	movzbl (%esi),%eax
  80293c:	3c 01                	cmp    $0x1,%al
  80293e:	76 24                	jbe    802964 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802940:	0f be c0             	movsbl %al,%eax
  802943:	89 44 24 08          	mov    %eax,0x8(%esp)
  802947:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80294b:	c7 04 24 a8 4e 80 00 	movl   $0x804ea8,(%esp)
  802952:	e8 73 db ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802957:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80295e:	80 3e 00             	cmpb   $0x0,(%esi)
  802961:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802964:	83 c3 01             	add    $0x1,%ebx
  802967:	83 c6 01             	add    $0x1,%esi
  80296a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802970:	7f 9c                	jg     80290e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802972:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802979:	0f 8e e1 02 00 00    	jle    802c60 <_Z4fsckv+0x46d>
  80297f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802986:	00 00 00 
		struct Inode *ino = get_inode(i);
  802989:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80298f:	e8 f9 f1 ff ff       	call   801b8d <_ZL9get_inodei>
  802994:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80299a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80299e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  8029a5:	75 22                	jne    8029c9 <_Z4fsckv+0x1d6>
  8029a7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  8029ae:	0f 84 a9 06 00 00    	je     80305d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  8029b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b9:	e8 2d f2 ff ff       	call   801beb <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 3a                	je     8029fc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  8029c2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8029c9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8029cf:	8b 02                	mov    (%edx),%eax
  8029d1:	83 f8 01             	cmp    $0x1,%eax
  8029d4:	74 26                	je     8029fc <_Z4fsckv+0x209>
  8029d6:	83 f8 02             	cmp    $0x2,%eax
  8029d9:	74 21                	je     8029fc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  8029db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029df:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029e9:	c7 04 24 d4 4e 80 00 	movl   $0x804ed4,(%esp)
  8029f0:	e8 d5 da ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  8029f5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  8029fc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802a03:	75 3f                	jne    802a44 <_Z4fsckv+0x251>
  802a05:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802a0b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802a0f:	75 15                	jne    802a26 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802a11:	c7 04 24 f8 4e 80 00 	movl   $0x804ef8,(%esp)
  802a18:	e8 ad da ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802a1d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a24:	eb 1e                	jmp    802a44 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802a26:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a2c:	83 3a 02             	cmpl   $0x2,(%edx)
  802a2f:	74 13                	je     802a44 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802a31:	c7 04 24 2c 4f 80 00 	movl   $0x804f2c,(%esp)
  802a38:	e8 8d da ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802a3d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802a44:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802a49:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802a50:	0f 84 93 00 00 00    	je     802ae9 <_Z4fsckv+0x2f6>
  802a56:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802a5c:	8b 41 08             	mov    0x8(%ecx),%eax
  802a5f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802a64:	7e 23                	jle    802a89 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802a66:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a6a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a74:	c7 04 24 5c 4f 80 00 	movl   $0x804f5c,(%esp)
  802a7b:	e8 4a da ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802a80:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a87:	eb 09                	jmp    802a92 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802a89:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802a90:	74 4b                	je     802add <_Z4fsckv+0x2ea>
  802a92:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a98:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802a9e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802aa4:	74 23                	je     802ac9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802aa6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aaa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ab0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ab4:	c7 04 24 80 4f 80 00 	movl   $0x804f80,(%esp)
  802abb:	e8 0a da ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802ac0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ac7:	eb 09                	jmp    802ad2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802ac9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ad0:	74 12                	je     802ae4 <_Z4fsckv+0x2f1>
  802ad2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802ad8:	8b 78 08             	mov    0x8(%eax),%edi
  802adb:	eb 0c                	jmp    802ae9 <_Z4fsckv+0x2f6>
  802add:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae2:	eb 05                	jmp    802ae9 <_Z4fsckv+0x2f6>
  802ae4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802ae9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802aee:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802af4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802af8:	89 d8                	mov    %ebx,%eax
  802afa:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802afd:	39 c7                	cmp    %eax,%edi
  802aff:	7e 2b                	jle    802b2c <_Z4fsckv+0x339>
  802b01:	85 f6                	test   %esi,%esi
  802b03:	75 27                	jne    802b2c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802b05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b0d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b17:	c7 04 24 a4 4f 80 00 	movl   $0x804fa4,(%esp)
  802b1e:	e8 a7 d9 ff ff       	call   8004ca <_Z7cprintfPKcz>
				++errors;
  802b23:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b2a:	eb 36                	jmp    802b62 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802b2c:	39 f8                	cmp    %edi,%eax
  802b2e:	7c 32                	jl     802b62 <_Z4fsckv+0x36f>
  802b30:	85 f6                	test   %esi,%esi
  802b32:	74 2e                	je     802b62 <_Z4fsckv+0x36f>
  802b34:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802b3b:	74 25                	je     802b62 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802b3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b45:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b4f:	c7 04 24 e8 4f 80 00 	movl   $0x804fe8,(%esp)
  802b56:	e8 6f d9 ff ff       	call   8004ca <_Z7cprintfPKcz>
				++errors;
  802b5b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802b62:	85 f6                	test   %esi,%esi
  802b64:	0f 84 a0 00 00 00    	je     802c0a <_Z4fsckv+0x417>
  802b6a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802b71:	0f 84 93 00 00 00    	je     802c0a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802b77:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802b7d:	7e 27                	jle    802ba6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802b7f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b87:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802b8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b91:	c7 04 24 2c 50 80 00 	movl   $0x80502c,(%esp)
  802b98:	e8 2d d9 ff ff       	call   8004ca <_Z7cprintfPKcz>
					++errors;
  802b9d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ba4:	eb 64                	jmp    802c0a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802ba6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802bad:	3c 01                	cmp    $0x1,%al
  802baf:	75 27                	jne    802bd8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802bb1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802bb5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bb9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802bbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bc3:	c7 04 24 70 50 80 00 	movl   $0x805070,(%esp)
  802bca:	e8 fb d8 ff ff       	call   8004ca <_Z7cprintfPKcz>
					++errors;
  802bcf:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802bd6:	eb 32                	jmp    802c0a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802bd8:	3c ff                	cmp    $0xff,%al
  802bda:	75 27                	jne    802c03 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802bdc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802be0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802be4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bee:	c7 04 24 ac 50 80 00 	movl   $0x8050ac,(%esp)
  802bf5:	e8 d0 d8 ff ff       	call   8004ca <_Z7cprintfPKcz>
					++errors;
  802bfa:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c01:	eb 07                	jmp    802c0a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802c03:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802c0a:	83 c3 01             	add    $0x1,%ebx
  802c0d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802c13:	0f 85 d5 fe ff ff    	jne    802aee <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802c19:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802c20:	0f 94 c0             	sete   %al
  802c23:	0f b6 c0             	movzbl %al,%eax
  802c26:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c2c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802c32:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802c39:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802c40:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802c47:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802c4e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802c54:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802c5a:	0f 8f 29 fd ff ff    	jg     802989 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802c60:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802c67:	0f 8e 7f 03 00 00    	jle    802fec <_Z4fsckv+0x7f9>
  802c6d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802c72:	89 f0                	mov    %esi,%eax
  802c74:	e8 14 ef ff ff       	call   801b8d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802c79:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802c80:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802c87:	c1 e2 08             	shl    $0x8,%edx
  802c8a:	09 ca                	or     %ecx,%edx
  802c8c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802c93:	c1 e1 10             	shl    $0x10,%ecx
  802c96:	09 ca                	or     %ecx,%edx
  802c98:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802c9f:	83 e1 7f             	and    $0x7f,%ecx
  802ca2:	c1 e1 18             	shl    $0x18,%ecx
  802ca5:	09 d1                	or     %edx,%ecx
  802ca7:	74 0e                	je     802cb7 <_Z4fsckv+0x4c4>
  802ca9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802cb0:	78 05                	js     802cb7 <_Z4fsckv+0x4c4>
  802cb2:	83 38 02             	cmpl   $0x2,(%eax)
  802cb5:	74 1f                	je     802cd6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802cb7:	83 c6 01             	add    $0x1,%esi
  802cba:	a1 08 10 00 50       	mov    0x50001008,%eax
  802cbf:	39 f0                	cmp    %esi,%eax
  802cc1:	7f af                	jg     802c72 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802cc3:	bb 01 00 00 00       	mov    $0x1,%ebx
  802cc8:	83 f8 01             	cmp    $0x1,%eax
  802ccb:	0f 8f ad 02 00 00    	jg     802f7e <_Z4fsckv+0x78b>
  802cd1:	e9 16 03 00 00       	jmp    802fec <_Z4fsckv+0x7f9>
  802cd6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802cd8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802cdf:	8b 40 08             	mov    0x8(%eax),%eax
  802ce2:	a8 7f                	test   $0x7f,%al
  802ce4:	74 23                	je     802d09 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802ce6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802ced:	00 
  802cee:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cf2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cf6:	c7 04 24 e8 50 80 00 	movl   $0x8050e8,(%esp)
  802cfd:	e8 c8 d7 ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802d02:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802d09:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802d10:	00 00 00 
  802d13:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802d19:	e9 3d 02 00 00       	jmp    802f5b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802d1e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d24:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d2a:	e8 01 ee ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
  802d2f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802d31:	83 38 00             	cmpl   $0x0,(%eax)
  802d34:	0f 84 15 02 00 00    	je     802f4f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d40:	83 fa 76             	cmp    $0x76,%edx
  802d43:	76 27                	jbe    802d6c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802d45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d49:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d53:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d57:	c7 04 24 1c 51 80 00 	movl   $0x80511c,(%esp)
  802d5e:	e8 67 d7 ff ff       	call   8004ca <_Z7cprintfPKcz>
				++errors;
  802d63:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d6a:	eb 28                	jmp    802d94 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802d6c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802d71:	74 21                	je     802d94 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802d73:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d79:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d81:	c7 04 24 48 51 80 00 	movl   $0x805148,(%esp)
  802d88:	e8 3d d7 ff ff       	call   8004ca <_Z7cprintfPKcz>
				++errors;
  802d8d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802d94:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802d9b:	00 
  802d9c:	8d 43 08             	lea    0x8(%ebx),%eax
  802d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802da9:	89 0c 24             	mov    %ecx,(%esp)
  802dac:	e8 56 df ff ff       	call   800d07 <memcpy>
  802db1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802db5:	bf 77 00 00 00       	mov    $0x77,%edi
  802dba:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802dbe:	85 ff                	test   %edi,%edi
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802dc8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802dcf:	00 

			if (de->de_inum >= super->s_ninodes) {
  802dd0:	8b 03                	mov    (%ebx),%eax
  802dd2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802dd8:	7c 3e                	jl     802e18 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802dda:	89 44 24 10          	mov    %eax,0x10(%esp)
  802dde:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802de4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802de8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802dee:	89 54 24 08          	mov    %edx,0x8(%esp)
  802df2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802df6:	c7 04 24 7c 51 80 00 	movl   $0x80517c,(%esp)
  802dfd:	e8 c8 d6 ff ff       	call   8004ca <_Z7cprintfPKcz>
				++errors;
  802e02:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802e09:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802e10:	00 00 00 
  802e13:	e9 0b 01 00 00       	jmp    802f23 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802e18:	e8 70 ed ff ff       	call   801b8d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802e1d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e24:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802e2b:	c1 e2 08             	shl    $0x8,%edx
  802e2e:	09 d1                	or     %edx,%ecx
  802e30:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802e37:	c1 e2 10             	shl    $0x10,%edx
  802e3a:	09 d1                	or     %edx,%ecx
  802e3c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802e43:	83 e2 7f             	and    $0x7f,%edx
  802e46:	c1 e2 18             	shl    $0x18,%edx
  802e49:	09 ca                	or     %ecx,%edx
  802e4b:	83 c2 01             	add    $0x1,%edx
  802e4e:	89 d1                	mov    %edx,%ecx
  802e50:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802e56:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802e5c:	0f b6 d5             	movzbl %ch,%edx
  802e5f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802e65:	89 ca                	mov    %ecx,%edx
  802e67:	c1 ea 10             	shr    $0x10,%edx
  802e6a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802e70:	c1 e9 18             	shr    $0x18,%ecx
  802e73:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802e7a:	83 e2 80             	and    $0xffffff80,%edx
  802e7d:	09 ca                	or     %ecx,%edx
  802e7f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802e85:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802e89:	0f 85 7a ff ff ff    	jne    802e09 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802e8f:	8b 03                	mov    (%ebx),%eax
  802e91:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e95:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802e9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e9f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802ea5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ea9:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ead:	c7 04 24 ac 51 80 00 	movl   $0x8051ac,(%esp)
  802eb4:	e8 11 d6 ff ff       	call   8004ca <_Z7cprintfPKcz>
					++errors;
  802eb9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ec0:	e9 44 ff ff ff       	jmp    802e09 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802ec5:	3b 78 04             	cmp    0x4(%eax),%edi
  802ec8:	75 52                	jne    802f1c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802eca:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ece:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802ed4:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ed8:	83 c0 08             	add    $0x8,%eax
  802edb:	89 04 24             	mov    %eax,(%esp)
  802ede:	e8 65 de ff ff       	call   800d48 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	75 35                	jne    802f1c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802ee7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802eed:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ef1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802ef7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802efb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f01:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f05:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f09:	c7 04 24 dc 51 80 00 	movl   $0x8051dc,(%esp)
  802f10:	e8 b5 d5 ff ff       	call   8004ca <_Z7cprintfPKcz>
					++errors;
  802f15:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802f1c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802f23:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802f29:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802f2f:	7e 1e                	jle    802f4f <_Z4fsckv+0x75c>
  802f31:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802f35:	7f 18                	jg     802f4f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802f37:	89 ca                	mov    %ecx,%edx
  802f39:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f3f:	e8 ec eb ff ff       	call   801b30 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802f44:	83 38 00             	cmpl   $0x0,(%eax)
  802f47:	0f 85 78 ff ff ff    	jne    802ec5 <_Z4fsckv+0x6d2>
  802f4d:	eb cd                	jmp    802f1c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802f4f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802f55:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802f5b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f61:	83 ea 80             	sub    $0xffffff80,%edx
  802f64:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802f6a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f70:	3b 51 08             	cmp    0x8(%ecx),%edx
  802f73:	0f 8f e7 fc ff ff    	jg     802c60 <_Z4fsckv+0x46d>
  802f79:	e9 a0 fd ff ff       	jmp    802d1e <_Z4fsckv+0x52b>
  802f7e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802f84:	89 d8                	mov    %ebx,%eax
  802f86:	e8 02 ec ff ff       	call   801b8d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802f8b:	8b 50 04             	mov    0x4(%eax),%edx
  802f8e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802f95:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802f9c:	c1 e7 08             	shl    $0x8,%edi
  802f9f:	09 f9                	or     %edi,%ecx
  802fa1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802fa8:	c1 e7 10             	shl    $0x10,%edi
  802fab:	09 f9                	or     %edi,%ecx
  802fad:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802fb4:	83 e7 7f             	and    $0x7f,%edi
  802fb7:	c1 e7 18             	shl    $0x18,%edi
  802fba:	09 f9                	or     %edi,%ecx
  802fbc:	39 ca                	cmp    %ecx,%edx
  802fbe:	74 1b                	je     802fdb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802fc0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fc4:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fc8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fcc:	c7 04 24 0c 52 80 00 	movl   $0x80520c,(%esp)
  802fd3:	e8 f2 d4 ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  802fd8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802fdb:	83 c3 01             	add    $0x1,%ebx
  802fde:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802fe4:	7f 9e                	jg     802f84 <_Z4fsckv+0x791>
  802fe6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802fec:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802ff3:	7e 4f                	jle    803044 <_Z4fsckv+0x851>
  802ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ffa:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803000:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803007:	3c ff                	cmp    $0xff,%al
  803009:	75 09                	jne    803014 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80300b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803012:	eb 1f                	jmp    803033 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803014:	84 c0                	test   %al,%al
  803016:	75 1b                	jne    803033 <_Z4fsckv+0x840>
  803018:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80301e:	7c 13                	jl     803033 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803020:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803024:	c7 04 24 38 52 80 00 	movl   $0x805238,(%esp)
  80302b:	e8 9a d4 ff ff       	call   8004ca <_Z7cprintfPKcz>
			++errors;
  803030:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803033:	83 c3 01             	add    $0x1,%ebx
  803036:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80303c:	7f c2                	jg     803000 <_Z4fsckv+0x80d>
  80303e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803044:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80304b:	19 c0                	sbb    %eax,%eax
  80304d:	f7 d0                	not    %eax
  80304f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803052:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803058:	5b                   	pop    %ebx
  803059:	5e                   	pop    %esi
  80305a:	5f                   	pop    %edi
  80305b:	5d                   	pop    %ebp
  80305c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80305d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803064:	0f 84 92 f9 ff ff    	je     8029fc <_Z4fsckv+0x209>
  80306a:	e9 5a f9 ff ff       	jmp    8029c9 <_Z4fsckv+0x1d6>
	...

00803070 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803070:	55                   	push   %ebp
  803071:	89 e5                	mov    %esp,%ebp
  803073:	83 ec 18             	sub    $0x18,%esp
  803076:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803079:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80307c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	89 04 24             	mov    %eax,(%esp)
  803085:	e8 a2 e4 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  80308a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80308c:	c7 44 24 04 6b 52 80 	movl   $0x80526b,0x4(%esp)
  803093:	00 
  803094:	89 34 24             	mov    %esi,(%esp)
  803097:	e8 4e da ff ff       	call   800aea <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80309c:	8b 43 04             	mov    0x4(%ebx),%eax
  80309f:	2b 03                	sub    (%ebx),%eax
  8030a1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8030a4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8030ab:	c7 86 80 00 00 00 40 	movl   $0x806040,0x80(%esi)
  8030b2:	60 80 00 
	return 0;
}
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ba:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8030bd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8030c0:	89 ec                	mov    %ebp,%esp
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    

008030c4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	53                   	push   %ebx
  8030c8:	83 ec 14             	sub    $0x14,%esp
  8030cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8030ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8030d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030d9:	e8 af df ff ff       	call   80108d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  8030de:	89 1c 24             	mov    %ebx,(%esp)
  8030e1:	e8 46 e4 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  8030e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030f1:	e8 97 df ff ff       	call   80108d <_Z14sys_page_unmapiPv>
}
  8030f6:	83 c4 14             	add    $0x14,%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5d                   	pop    %ebp
  8030fb:	c3                   	ret    

008030fc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030fc:	55                   	push   %ebp
  8030fd:	89 e5                	mov    %esp,%ebp
  8030ff:	57                   	push   %edi
  803100:	56                   	push   %esi
  803101:	53                   	push   %ebx
  803102:	83 ec 2c             	sub    $0x2c,%esp
  803105:	89 c7                	mov    %eax,%edi
  803107:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80310a:	a1 00 70 80 00       	mov    0x807000,%eax
  80310f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803112:	89 3c 24             	mov    %edi,(%esp)
  803115:	e8 82 04 00 00       	call   80359c <_Z7pagerefPv>
  80311a:	89 c3                	mov    %eax,%ebx
  80311c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311f:	89 04 24             	mov    %eax,(%esp)
  803122:	e8 75 04 00 00       	call   80359c <_Z7pagerefPv>
  803127:	39 c3                	cmp    %eax,%ebx
  803129:	0f 94 c0             	sete   %al
  80312c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80312f:	8b 15 00 70 80 00    	mov    0x807000,%edx
  803135:	8b 52 58             	mov    0x58(%edx),%edx
  803138:	39 d6                	cmp    %edx,%esi
  80313a:	75 08                	jne    803144 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80313c:	83 c4 2c             	add    $0x2c,%esp
  80313f:	5b                   	pop    %ebx
  803140:	5e                   	pop    %esi
  803141:	5f                   	pop    %edi
  803142:	5d                   	pop    %ebp
  803143:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803144:	85 c0                	test   %eax,%eax
  803146:	74 c2                	je     80310a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803148:	c7 04 24 72 52 80 00 	movl   $0x805272,(%esp)
  80314f:	e8 76 d3 ff ff       	call   8004ca <_Z7cprintfPKcz>
  803154:	eb b4                	jmp    80310a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803156 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	57                   	push   %edi
  80315a:	56                   	push   %esi
  80315b:	53                   	push   %ebx
  80315c:	83 ec 1c             	sub    $0x1c,%esp
  80315f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803162:	89 34 24             	mov    %esi,(%esp)
  803165:	e8 c2 e3 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  80316a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80316c:	bf 00 00 00 00       	mov    $0x0,%edi
  803171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803175:	75 46                	jne    8031bd <_ZL13devpipe_writeP2FdPKvj+0x67>
  803177:	eb 52                	jmp    8031cb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803179:	89 da                	mov    %ebx,%edx
  80317b:	89 f0                	mov    %esi,%eax
  80317d:	e8 7a ff ff ff       	call   8030fc <_ZL13_pipeisclosedP2FdP4Pipe>
  803182:	85 c0                	test   %eax,%eax
  803184:	75 49                	jne    8031cf <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803186:	e8 11 de ff ff       	call   800f9c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80318b:	8b 43 04             	mov    0x4(%ebx),%eax
  80318e:	89 c2                	mov    %eax,%edx
  803190:	2b 13                	sub    (%ebx),%edx
  803192:	83 fa 20             	cmp    $0x20,%edx
  803195:	74 e2                	je     803179 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803197:	89 c2                	mov    %eax,%edx
  803199:	c1 fa 1f             	sar    $0x1f,%edx
  80319c:	c1 ea 1b             	shr    $0x1b,%edx
  80319f:	01 d0                	add    %edx,%eax
  8031a1:	83 e0 1f             	and    $0x1f,%eax
  8031a4:	29 d0                	sub    %edx,%eax
  8031a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8031a9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8031ad:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8031b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8031b5:	83 c7 01             	add    $0x1,%edi
  8031b8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8031bb:	76 0e                	jbe    8031cb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8031bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8031c0:	89 c2                	mov    %eax,%edx
  8031c2:	2b 13                	sub    (%ebx),%edx
  8031c4:	83 fa 20             	cmp    $0x20,%edx
  8031c7:	74 b0                	je     803179 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8031c9:	eb cc                	jmp    803197 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8031cb:	89 f8                	mov    %edi,%eax
  8031cd:	eb 05                	jmp    8031d4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    

008031dc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8031dc:	55                   	push   %ebp
  8031dd:	89 e5                	mov    %esp,%ebp
  8031df:	83 ec 28             	sub    $0x28,%esp
  8031e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8031e5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8031e8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8031eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8031ee:	89 3c 24             	mov    %edi,(%esp)
  8031f1:	e8 36 e3 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  8031f6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8031f8:	be 00 00 00 00       	mov    $0x0,%esi
  8031fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803201:	75 47                	jne    80324a <_ZL12devpipe_readP2FdPvj+0x6e>
  803203:	eb 52                	jmp    803257 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803205:	89 f0                	mov    %esi,%eax
  803207:	eb 5e                	jmp    803267 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803209:	89 da                	mov    %ebx,%edx
  80320b:	89 f8                	mov    %edi,%eax
  80320d:	8d 76 00             	lea    0x0(%esi),%esi
  803210:	e8 e7 fe ff ff       	call   8030fc <_ZL13_pipeisclosedP2FdP4Pipe>
  803215:	85 c0                	test   %eax,%eax
  803217:	75 49                	jne    803262 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803219:	e8 7e dd ff ff       	call   800f9c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80321e:	8b 03                	mov    (%ebx),%eax
  803220:	3b 43 04             	cmp    0x4(%ebx),%eax
  803223:	74 e4                	je     803209 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803225:	89 c2                	mov    %eax,%edx
  803227:	c1 fa 1f             	sar    $0x1f,%edx
  80322a:	c1 ea 1b             	shr    $0x1b,%edx
  80322d:	01 d0                	add    %edx,%eax
  80322f:	83 e0 1f             	and    $0x1f,%eax
  803232:	29 d0                	sub    %edx,%eax
  803234:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80323f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803242:	83 c6 01             	add    $0x1,%esi
  803245:	39 75 10             	cmp    %esi,0x10(%ebp)
  803248:	76 0d                	jbe    803257 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80324a:	8b 03                	mov    (%ebx),%eax
  80324c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80324f:	75 d4                	jne    803225 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803251:	85 f6                	test   %esi,%esi
  803253:	75 b0                	jne    803205 <_ZL12devpipe_readP2FdPvj+0x29>
  803255:	eb b2                	jmp    803209 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803257:	89 f0                	mov    %esi,%eax
  803259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803260:	eb 05                	jmp    803267 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803267:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80326a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80326d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803270:	89 ec                	mov    %ebp,%esp
  803272:	5d                   	pop    %ebp
  803273:	c3                   	ret    

00803274 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803274:	55                   	push   %ebp
  803275:	89 e5                	mov    %esp,%ebp
  803277:	83 ec 48             	sub    $0x48,%esp
  80327a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80327d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803280:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803283:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803286:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803289:	89 04 24             	mov    %eax,(%esp)
  80328c:	e8 b6 e2 ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  803291:	89 c3                	mov    %eax,%ebx
  803293:	85 c0                	test   %eax,%eax
  803295:	0f 88 0b 01 00 00    	js     8033a6 <_Z4pipePi+0x132>
  80329b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032a2:	00 
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032b1:	e8 1a dd ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  8032b6:	89 c3                	mov    %eax,%ebx
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	0f 89 f5 00 00 00    	jns    8033b5 <_Z4pipePi+0x141>
  8032c0:	e9 e1 00 00 00       	jmp    8033a6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8032c5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032cc:	00 
  8032cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032db:	e8 f0 dc ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  8032e0:	89 c3                	mov    %eax,%ebx
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	0f 89 e2 00 00 00    	jns    8033cc <_Z4pipePi+0x158>
  8032ea:	e9 a4 00 00 00       	jmp    803393 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f2:	89 04 24             	mov    %eax,(%esp)
  8032f5:	e8 32 e2 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  8032fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803301:	00 
  803302:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803306:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80330d:	00 
  80330e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803319:	e8 11 dd ff ff       	call   80102f <_Z12sys_page_mapiPviS_i>
  80331e:	89 c3                	mov    %eax,%ebx
  803320:	85 c0                	test   %eax,%eax
  803322:	78 4c                	js     803370 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803324:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80332a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803332:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803339:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80333f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803342:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803344:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803347:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80334e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803351:	89 04 24             	mov    %eax,(%esp)
  803354:	e8 8b e1 ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  803359:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80335b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335e:	89 04 24             	mov    %eax,(%esp)
  803361:	e8 7e e1 ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  803366:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803369:	bb 00 00 00 00       	mov    $0x0,%ebx
  80336e:	eb 36                	jmp    8033a6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803370:	89 74 24 04          	mov    %esi,0x4(%esp)
  803374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80337b:	e8 0d dd ff ff       	call   80108d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803380:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803383:	89 44 24 04          	mov    %eax,0x4(%esp)
  803387:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80338e:	e8 fa dc ff ff       	call   80108d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803396:	89 44 24 04          	mov    %eax,0x4(%esp)
  80339a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033a1:	e8 e7 dc ff ff       	call   80108d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8033a6:	89 d8                	mov    %ebx,%eax
  8033a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8033ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8033ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8033b1:	89 ec                	mov    %ebp,%esp
  8033b3:	5d                   	pop    %ebp
  8033b4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8033b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033b8:	89 04 24             	mov    %eax,(%esp)
  8033bb:	e8 87 e1 ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  8033c0:	89 c3                	mov    %eax,%ebx
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	0f 89 fb fe ff ff    	jns    8032c5 <_Z4pipePi+0x51>
  8033ca:	eb c7                	jmp    803393 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	89 04 24             	mov    %eax,(%esp)
  8033d2:	e8 55 e1 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  8033d7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8033e0:	00 
  8033e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033ec:	e8 df db ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  8033f1:	89 c3                	mov    %eax,%ebx
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	0f 89 f4 fe ff ff    	jns    8032ef <_Z4pipePi+0x7b>
  8033fb:	eb 83                	jmp    803380 <_Z4pipePi+0x10c>

008033fd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8033fd:	55                   	push   %ebp
  8033fe:	89 e5                	mov    %esp,%ebp
  803400:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803403:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80340a:	00 
  80340b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80340e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	89 04 24             	mov    %eax,(%esp)
  803418:	e8 74 e0 ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80341d:	85 c0                	test   %eax,%eax
  80341f:	78 15                	js     803436 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	89 04 24             	mov    %eax,(%esp)
  803427:	e8 00 e1 ff ff       	call   80152c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80342c:	89 c2                	mov    %eax,%edx
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	e8 c6 fc ff ff       	call   8030fc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803436:	c9                   	leave  
  803437:	c3                   	ret    

00803438 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803438:	55                   	push   %ebp
  803439:	89 e5                	mov    %esp,%ebp
  80343b:	53                   	push   %ebx
  80343c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80343f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803442:	89 04 24             	mov    %eax,(%esp)
  803445:	e8 fd e0 ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  80344a:	89 c3                	mov    %eax,%ebx
  80344c:	85 c0                	test   %eax,%eax
  80344e:	0f 88 be 00 00 00    	js     803512 <_Z18pipe_ipc_recv_readv+0xda>
  803454:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80345b:	00 
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80346a:	e8 61 db ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  80346f:	89 c3                	mov    %eax,%ebx
  803471:	85 c0                	test   %eax,%eax
  803473:	0f 89 a1 00 00 00    	jns    80351a <_Z18pipe_ipc_recv_readv+0xe2>
  803479:	e9 94 00 00 00       	jmp    803512 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80347e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	75 0e                	jne    803493 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803485:	c7 04 24 d0 52 80 00 	movl   $0x8052d0,(%esp)
  80348c:	e8 39 d0 ff ff       	call   8004ca <_Z7cprintfPKcz>
  803491:	eb 10                	jmp    8034a3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803493:	89 44 24 04          	mov    %eax,0x4(%esp)
  803497:	c7 04 24 85 52 80 00 	movl   $0x805285,(%esp)
  80349e:	e8 27 d0 ff ff       	call   8004ca <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8034a3:	c7 04 24 8f 52 80 00 	movl   $0x80528f,(%esp)
  8034aa:	e8 1b d0 ff ff       	call   8004ca <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8034af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b2:	a8 04                	test   $0x4,%al
  8034b4:	74 04                	je     8034ba <_Z18pipe_ipc_recv_readv+0x82>
  8034b6:	a8 01                	test   $0x1,%al
  8034b8:	75 24                	jne    8034de <_Z18pipe_ipc_recv_readv+0xa6>
  8034ba:	c7 44 24 0c a2 52 80 	movl   $0x8052a2,0xc(%esp)
  8034c1:	00 
  8034c2:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  8034c9:	00 
  8034ca:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8034d1:	00 
  8034d2:	c7 04 24 bf 52 80 00 	movl   $0x8052bf,(%esp)
  8034d9:	e8 ce ce ff ff       	call   8003ac <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8034de:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8034f3:	89 04 24             	mov    %eax,(%esp)
  8034f6:	e8 e9 df ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  8034fb:	89 c3                	mov    %eax,%ebx
  8034fd:	eb 13                	jmp    803512 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8034ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803502:	89 44 24 04          	mov    %eax,0x4(%esp)
  803506:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80350d:	e8 7b db ff ff       	call   80108d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803512:	89 d8                	mov    %ebx,%eax
  803514:	83 c4 24             	add    $0x24,%esp
  803517:	5b                   	pop    %ebx
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	89 04 24             	mov    %eax,(%esp)
  803520:	e8 07 e0 ff ff       	call   80152c <_Z7fd2dataP2Fd>
  803525:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803528:	89 54 24 08          	mov    %edx,0x8(%esp)
  80352c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803530:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803533:	89 04 24             	mov    %eax,(%esp)
  803536:	e8 15 0b 00 00       	call   804050 <_Z8ipc_recvPiPvS_>
  80353b:	89 c3                	mov    %eax,%ebx
  80353d:	85 c0                	test   %eax,%eax
  80353f:	0f 89 39 ff ff ff    	jns    80347e <_Z18pipe_ipc_recv_readv+0x46>
  803545:	eb b8                	jmp    8034ff <_Z18pipe_ipc_recv_readv+0xc7>

00803547 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803547:	55                   	push   %ebp
  803548:	89 e5                	mov    %esp,%ebp
  80354a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80354d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803554:	00 
  803555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	89 04 24             	mov    %eax,(%esp)
  803562:	e8 2a df ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  803567:	85 c0                	test   %eax,%eax
  803569:	78 2f                	js     80359a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	89 04 24             	mov    %eax,(%esp)
  803571:	e8 b6 df ff ff       	call   80152c <_Z7fd2dataP2Fd>
  803576:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80357d:	00 
  80357e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803582:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803589:	00 
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	89 04 24             	mov    %eax,(%esp)
  803590:	e8 4a 0b 00 00       	call   8040df <_Z8ipc_sendijPvi>
    return 0;
  803595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80359a:	c9                   	leave  
  80359b:	c3                   	ret    

0080359c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80359c:	55                   	push   %ebp
  80359d:	89 e5                	mov    %esp,%ebp
  80359f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8035a2:	89 d0                	mov    %edx,%eax
  8035a4:	c1 e8 16             	shr    $0x16,%eax
  8035a7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8035b3:	f6 c1 01             	test   $0x1,%cl
  8035b6:	74 1d                	je     8035d5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8035b8:	c1 ea 0c             	shr    $0xc,%edx
  8035bb:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8035c2:	f6 c2 01             	test   $0x1,%dl
  8035c5:	74 0e                	je     8035d5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8035c7:	c1 ea 0c             	shr    $0xc,%edx
  8035ca:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8035d1:	ef 
  8035d2:	0f b7 c0             	movzwl %ax,%eax
}
  8035d5:	5d                   	pop    %ebp
  8035d6:	c3                   	ret    
	...

008035e0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035e0:	55                   	push   %ebp
  8035e1:	89 e5                	mov    %esp,%ebp
  8035e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8035e6:	c7 44 24 04 f3 52 80 	movl   $0x8052f3,0x4(%esp)
  8035ed:	00 
  8035ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f1:	89 04 24             	mov    %eax,(%esp)
  8035f4:	e8 f1 d4 ff ff       	call   800aea <_Z6strcpyPcPKc>
	return 0;
}
  8035f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fe:	c9                   	leave  
  8035ff:	c3                   	ret    

00803600 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803600:	55                   	push   %ebp
  803601:	89 e5                	mov    %esp,%ebp
  803603:	53                   	push   %ebx
  803604:	83 ec 14             	sub    $0x14,%esp
  803607:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80360a:	89 1c 24             	mov    %ebx,(%esp)
  80360d:	e8 8a ff ff ff       	call   80359c <_Z7pagerefPv>
  803612:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803614:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803619:	83 fa 01             	cmp    $0x1,%edx
  80361c:	75 0b                	jne    803629 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80361e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803621:	89 04 24             	mov    %eax,(%esp)
  803624:	e8 fe 02 00 00       	call   803927 <_Z11nsipc_closei>
	else
		return 0;
}
  803629:	83 c4 14             	add    $0x14,%esp
  80362c:	5b                   	pop    %ebx
  80362d:	5d                   	pop    %ebp
  80362e:	c3                   	ret    

0080362f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80362f:	55                   	push   %ebp
  803630:	89 e5                	mov    %esp,%ebp
  803632:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803635:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80363c:	00 
  80363d:	8b 45 10             	mov    0x10(%ebp),%eax
  803640:	89 44 24 08          	mov    %eax,0x8(%esp)
  803644:	8b 45 0c             	mov    0xc(%ebp),%eax
  803647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	89 04 24             	mov    %eax,(%esp)
  803654:	e8 c9 03 00 00       	call   803a22 <_Z10nsipc_sendiPKvij>
}
  803659:	c9                   	leave  
  80365a:	c3                   	ret    

0080365b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80365b:	55                   	push   %ebp
  80365c:	89 e5                	mov    %esp,%ebp
  80365e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803661:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803668:	00 
  803669:	8b 45 10             	mov    0x10(%ebp),%eax
  80366c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803670:	8b 45 0c             	mov    0xc(%ebp),%eax
  803673:	89 44 24 04          	mov    %eax,0x4(%esp)
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	8b 40 0c             	mov    0xc(%eax),%eax
  80367d:	89 04 24             	mov    %eax,(%esp)
  803680:	e8 1d 03 00 00       	call   8039a2 <_Z10nsipc_recviPvij>
}
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 28             	sub    $0x28,%esp
  80368d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803690:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803693:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803695:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803698:	89 04 24             	mov    %eax,(%esp)
  80369b:	e8 a7 de ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  8036a0:	89 c3                	mov    %eax,%ebx
  8036a2:	85 c0                	test   %eax,%eax
  8036a4:	78 21                	js     8036c7 <_ZL12alloc_sockfdi+0x40>
  8036a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8036ad:	00 
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036bc:	e8 0f d9 ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  8036c1:	89 c3                	mov    %eax,%ebx
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	79 14                	jns    8036db <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8036c7:	89 34 24             	mov    %esi,(%esp)
  8036ca:	e8 58 02 00 00       	call   803927 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8036cf:	89 d8                	mov    %ebx,%eax
  8036d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8036d4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8036d7:	89 ec                	mov    %ebp,%esp
  8036d9:	5d                   	pop    %ebp
  8036da:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036db:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8036f0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8036f3:	89 04 24             	mov    %eax,(%esp)
  8036f6:	e8 e9 dd ff ff       	call   8014e4 <_Z6fd2numP2Fd>
  8036fb:	89 c3                	mov    %eax,%ebx
  8036fd:	eb d0                	jmp    8036cf <_ZL12alloc_sockfdi+0x48>

008036ff <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036ff:	55                   	push   %ebp
  803700:	89 e5                	mov    %esp,%ebp
  803702:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803705:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80370c:	00 
  80370d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803710:	89 54 24 04          	mov    %edx,0x4(%esp)
  803714:	89 04 24             	mov    %eax,(%esp)
  803717:	e8 75 dd ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  80371c:	85 c0                	test   %eax,%eax
  80371e:	78 15                	js     803735 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803720:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803723:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803728:	8b 0d 5c 60 80 00    	mov    0x80605c,%ecx
  80372e:	39 0a                	cmp    %ecx,(%edx)
  803730:	75 03                	jne    803735 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803732:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803735:	c9                   	leave  
  803736:	c3                   	ret    

00803737 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
  80373a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	e8 ba ff ff ff       	call   8036ff <_ZL9fd2sockidi>
  803745:	85 c0                	test   %eax,%eax
  803747:	78 1f                	js     803768 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803749:	8b 55 10             	mov    0x10(%ebp),%edx
  80374c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803750:	8b 55 0c             	mov    0xc(%ebp),%edx
  803753:	89 54 24 04          	mov    %edx,0x4(%esp)
  803757:	89 04 24             	mov    %eax,(%esp)
  80375a:	e8 19 01 00 00       	call   803878 <_Z12nsipc_acceptiP8sockaddrPj>
  80375f:	85 c0                	test   %eax,%eax
  803761:	78 05                	js     803768 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803763:	e8 1f ff ff ff       	call   803687 <_ZL12alloc_sockfdi>
}
  803768:	c9                   	leave  
  803769:	c3                   	ret    

0080376a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80376a:	55                   	push   %ebp
  80376b:	89 e5                	mov    %esp,%ebp
  80376d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	e8 87 ff ff ff       	call   8036ff <_ZL9fd2sockidi>
  803778:	85 c0                	test   %eax,%eax
  80377a:	78 16                	js     803792 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80377c:	8b 55 10             	mov    0x10(%ebp),%edx
  80377f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803783:	8b 55 0c             	mov    0xc(%ebp),%edx
  803786:	89 54 24 04          	mov    %edx,0x4(%esp)
  80378a:	89 04 24             	mov    %eax,(%esp)
  80378d:	e8 34 01 00 00       	call   8038c6 <_Z10nsipc_bindiP8sockaddrj>
}
  803792:	c9                   	leave  
  803793:	c3                   	ret    

00803794 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803794:	55                   	push   %ebp
  803795:	89 e5                	mov    %esp,%ebp
  803797:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	e8 5d ff ff ff       	call   8036ff <_ZL9fd2sockidi>
  8037a2:	85 c0                	test   %eax,%eax
  8037a4:	78 0f                	js     8037b5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8037a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037ad:	89 04 24             	mov    %eax,(%esp)
  8037b0:	e8 50 01 00 00       	call   803905 <_Z14nsipc_shutdownii>
}
  8037b5:	c9                   	leave  
  8037b6:	c3                   	ret    

008037b7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037b7:	55                   	push   %ebp
  8037b8:	89 e5                	mov    %esp,%ebp
  8037ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	e8 3a ff ff ff       	call   8036ff <_ZL9fd2sockidi>
  8037c5:	85 c0                	test   %eax,%eax
  8037c7:	78 16                	js     8037df <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8037c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8037cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8037d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037d7:	89 04 24             	mov    %eax,(%esp)
  8037da:	e8 62 01 00 00       	call   803941 <_Z13nsipc_connectiPK8sockaddrj>
}
  8037df:	c9                   	leave  
  8037e0:	c3                   	ret    

008037e1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8037e1:	55                   	push   %ebp
  8037e2:	89 e5                	mov    %esp,%ebp
  8037e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	e8 10 ff ff ff       	call   8036ff <_ZL9fd2sockidi>
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	78 0f                	js     803802 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8037f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037fa:	89 04 24             	mov    %eax,(%esp)
  8037fd:	e8 7e 01 00 00       	call   803980 <_Z12nsipc_listenii>
}
  803802:	c9                   	leave  
  803803:	c3                   	ret    

00803804 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
  803807:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80380a:	8b 45 10             	mov    0x10(%ebp),%eax
  80380d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803811:	8b 45 0c             	mov    0xc(%ebp),%eax
  803814:	89 44 24 04          	mov    %eax,0x4(%esp)
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	89 04 24             	mov    %eax,(%esp)
  80381e:	e8 72 02 00 00       	call   803a95 <_Z12nsipc_socketiii>
  803823:	85 c0                	test   %eax,%eax
  803825:	78 05                	js     80382c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803827:	e8 5b fe ff ff       	call   803687 <_ZL12alloc_sockfdi>
}
  80382c:	c9                   	leave  
  80382d:	8d 76 00             	lea    0x0(%esi),%esi
  803830:	c3                   	ret    
  803831:	00 00                	add    %al,(%eax)
	...

00803834 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803834:	55                   	push   %ebp
  803835:	89 e5                	mov    %esp,%ebp
  803837:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80383a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803841:	00 
  803842:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803849:	00 
  80384a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80384e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803855:	e8 85 08 00 00       	call   8040df <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80385a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803861:	00 
  803862:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803869:	00 
  80386a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803871:	e8 da 07 00 00       	call   804050 <_Z8ipc_recvPiPvS_>
}
  803876:	c9                   	leave  
  803877:	c3                   	ret    

00803878 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803878:	55                   	push   %ebp
  803879:	89 e5                	mov    %esp,%ebp
  80387b:	53                   	push   %ebx
  80387c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803887:	b8 01 00 00 00       	mov    $0x1,%eax
  80388c:	e8 a3 ff ff ff       	call   803834 <_ZL5nsipcj>
  803891:	89 c3                	mov    %eax,%ebx
  803893:	85 c0                	test   %eax,%eax
  803895:	78 27                	js     8038be <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803897:	a1 10 80 80 00       	mov    0x808010,%eax
  80389c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038a0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8038a7:	00 
  8038a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ab:	89 04 24             	mov    %eax,(%esp)
  8038ae:	e8 d9 d3 ff ff       	call   800c8c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8038b3:	8b 15 10 80 80 00    	mov    0x808010,%edx
  8038b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8038bc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8038be:	89 d8                	mov    %ebx,%eax
  8038c0:	83 c4 14             	add    $0x14,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5d                   	pop    %ebp
  8038c5:	c3                   	ret    

008038c6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038c6:	55                   	push   %ebp
  8038c7:	89 e5                	mov    %esp,%ebp
  8038c9:	53                   	push   %ebx
  8038ca:	83 ec 14             	sub    $0x14,%esp
  8038cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e3:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8038ea:	e8 9d d3 ff ff       	call   800c8c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8038ef:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8038f5:	b8 02 00 00 00       	mov    $0x2,%eax
  8038fa:	e8 35 ff ff ff       	call   803834 <_ZL5nsipcj>
}
  8038ff:	83 c4 14             	add    $0x14,%esp
  803902:	5b                   	pop    %ebx
  803903:	5d                   	pop    %ebp
  803904:	c3                   	ret    

00803905 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803905:	55                   	push   %ebp
  803906:	89 e5                	mov    %esp,%ebp
  803908:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803913:	8b 45 0c             	mov    0xc(%ebp),%eax
  803916:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80391b:	b8 03 00 00 00       	mov    $0x3,%eax
  803920:	e8 0f ff ff ff       	call   803834 <_ZL5nsipcj>
}
  803925:	c9                   	leave  
  803926:	c3                   	ret    

00803927 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803927:	55                   	push   %ebp
  803928:	89 e5                	mov    %esp,%ebp
  80392a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803935:	b8 04 00 00 00       	mov    $0x4,%eax
  80393a:	e8 f5 fe ff ff       	call   803834 <_ZL5nsipcj>
}
  80393f:	c9                   	leave  
  803940:	c3                   	ret    

00803941 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803941:	55                   	push   %ebp
  803942:	89 e5                	mov    %esp,%ebp
  803944:	53                   	push   %ebx
  803945:	83 ec 14             	sub    $0x14,%esp
  803948:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803953:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803965:	e8 22 d3 ff ff       	call   800c8c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80396a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803970:	b8 05 00 00 00       	mov    $0x5,%eax
  803975:	e8 ba fe ff ff       	call   803834 <_ZL5nsipcj>
}
  80397a:	83 c4 14             	add    $0x14,%esp
  80397d:	5b                   	pop    %ebx
  80397e:	5d                   	pop    %ebp
  80397f:	c3                   	ret    

00803980 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803980:	55                   	push   %ebp
  803981:	89 e5                	mov    %esp,%ebp
  803983:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80398e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803991:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803996:	b8 06 00 00 00       	mov    $0x6,%eax
  80399b:	e8 94 fe ff ff       	call   803834 <_ZL5nsipcj>
}
  8039a0:	c9                   	leave  
  8039a1:	c3                   	ret    

008039a2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8039a2:	55                   	push   %ebp
  8039a3:	89 e5                	mov    %esp,%ebp
  8039a5:	56                   	push   %esi
  8039a6:	53                   	push   %ebx
  8039a7:	83 ec 10             	sub    $0x10,%esp
  8039aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8039b5:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8039bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8039be:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8039c8:	e8 67 fe ff ff       	call   803834 <_ZL5nsipcj>
  8039cd:	89 c3                	mov    %eax,%ebx
  8039cf:	85 c0                	test   %eax,%eax
  8039d1:	78 46                	js     803a19 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8039d3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8039d8:	7f 04                	jg     8039de <_Z10nsipc_recviPvij+0x3c>
  8039da:	39 f0                	cmp    %esi,%eax
  8039dc:	7e 24                	jle    803a02 <_Z10nsipc_recviPvij+0x60>
  8039de:	c7 44 24 0c ff 52 80 	movl   $0x8052ff,0xc(%esp)
  8039e5:	00 
  8039e6:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  8039ed:	00 
  8039ee:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8039f5:	00 
  8039f6:	c7 04 24 14 53 80 00 	movl   $0x805314,(%esp)
  8039fd:	e8 aa c9 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a06:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803a0d:	00 
  803a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a11:	89 04 24             	mov    %eax,(%esp)
  803a14:	e8 73 d2 ff ff       	call   800c8c <memmove>
	}

	return r;
}
  803a19:	89 d8                	mov    %ebx,%eax
  803a1b:	83 c4 10             	add    $0x10,%esp
  803a1e:	5b                   	pop    %ebx
  803a1f:	5e                   	pop    %esi
  803a20:	5d                   	pop    %ebp
  803a21:	c3                   	ret    

00803a22 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a22:	55                   	push   %ebp
  803a23:	89 e5                	mov    %esp,%ebp
  803a25:	53                   	push   %ebx
  803a26:	83 ec 14             	sub    $0x14,%esp
  803a29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803a34:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803a3a:	7e 24                	jle    803a60 <_Z10nsipc_sendiPKvij+0x3e>
  803a3c:	c7 44 24 0c 20 53 80 	movl   $0x805320,0xc(%esp)
  803a43:	00 
  803a44:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  803a4b:	00 
  803a4c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803a53:	00 
  803a54:	c7 04 24 14 53 80 00 	movl   $0x805314,(%esp)
  803a5b:	e8 4c c9 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a6b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803a72:	e8 15 d2 ff ff       	call   800c8c <memmove>
	nsipcbuf.send.req_size = size;
  803a77:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  803a80:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803a85:	b8 08 00 00 00       	mov    $0x8,%eax
  803a8a:	e8 a5 fd ff ff       	call   803834 <_ZL5nsipcj>
}
  803a8f:	83 c4 14             	add    $0x14,%esp
  803a92:	5b                   	pop    %ebx
  803a93:	5d                   	pop    %ebp
  803a94:	c3                   	ret    

00803a95 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a95:	55                   	push   %ebp
  803a96:	89 e5                	mov    %esp,%ebp
  803a98:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803aab:	8b 45 10             	mov    0x10(%ebp),%eax
  803aae:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803ab3:	b8 09 00 00 00       	mov    $0x9,%eax
  803ab8:	e8 77 fd ff ff       	call   803834 <_ZL5nsipcj>
}
  803abd:	c9                   	leave  
  803abe:	c3                   	ret    
	...

00803ac0 <_Z4freePv>:
	return v;
}

void
free(void *v)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	53                   	push   %ebx
  803ac4:	83 ec 14             	sub    $0x14,%esp
  803ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  803aca:	85 db                	test   %ebx,%ebx
  803acc:	0f 84 ba 00 00 00    	je     803b8c <_Z4freePv+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  803ad2:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  803ad8:	76 08                	jbe    803ae2 <_Z4freePv+0x22>
  803ada:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  803ae0:	76 24                	jbe    803b06 <_Z4freePv+0x46>
  803ae2:	c7 44 24 0c 2c 53 80 	movl   $0x80532c,0xc(%esp)
  803ae9:	00 
  803aea:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  803af1:	00 
  803af2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  803af9:	00 
  803afa:	c7 04 24 5a 53 80 00 	movl   $0x80535a,(%esp)
  803b01:	e8 a6 c8 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

	c = (uint8_t *)ROUNDDOWN(v, PGSIZE);
  803b06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (vpt[PGNUM(c)] & PTE_CONTINUED) {
  803b0c:	eb 4a                	jmp    803b58 <_Z4freePv+0x98>
		sys_page_unmap(0, c);
  803b0e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803b12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b19:	e8 6f d5 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
		c += PGSIZE;
  803b1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  803b24:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  803b2a:	76 08                	jbe    803b34 <_Z4freePv+0x74>
  803b2c:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  803b32:	76 24                	jbe    803b58 <_Z4freePv+0x98>
  803b34:	c7 44 24 0c 67 53 80 	movl   $0x805367,0xc(%esp)
  803b3b:	00 
  803b3c:	c7 44 24 08 6c 4c 80 	movl   $0x804c6c,0x8(%esp)
  803b43:	00 
  803b44:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  803b4b:	00 
  803b4c:	c7 04 24 5a 53 80 00 	movl   $0x80535a,(%esp)
  803b53:	e8 54 c8 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = (uint8_t *)ROUNDDOWN(v, PGSIZE);

	while (vpt[PGNUM(c)] & PTE_CONTINUED) {
  803b58:	89 d8                	mov    %ebx,%eax
  803b5a:	c1 e8 0c             	shr    $0xc,%eax
  803b5d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  803b64:	f6 c4 04             	test   $0x4,%ah
  803b67:	75 a5                	jne    803b0e <_Z4freePv+0x4e>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  803b69:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  803b6f:	83 e8 01             	sub    $0x1,%eax
  803b72:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  803b78:	85 c0                	test   %eax,%eax
  803b7a:	75 10                	jne    803b8c <_Z4freePv+0xcc>
		sys_page_unmap(0, c);
  803b7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803b80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b87:	e8 01 d5 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
}
  803b8c:	83 c4 14             	add    $0x14,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5d                   	pop    %ebp
  803b91:	c3                   	ret    

00803b92 <_Z6mallocj>:
	return 1;
}

void*
malloc(size_t n)
{
  803b92:	55                   	push   %ebp
  803b93:	89 e5                	mov    %esp,%ebp
  803b95:	57                   	push   %edi
  803b96:	56                   	push   %esi
  803b97:	53                   	push   %ebx
  803b98:	83 ec 2c             	sub    $0x2c,%esp
	int cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803b9b:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803ba2:	75 0a                	jne    803bae <_Z6mallocj+0x1c>
		mptr = mbegin;
  803ba4:	c7 05 00 90 80 00 00 	movl   $0x8000000,0x809000
  803bab:	00 00 08 

	n = ROUNDUP(n, 4);
  803bae:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb1:	83 c0 03             	add    $0x3,%eax
  803bb4:	83 e0 fc             	and    $0xfffffffc,%eax
  803bb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (n >= MAXMALLOC)
  803bba:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  803bbf:	0f 87 65 01 00 00    	ja     803d2a <_Z6mallocj+0x198>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  803bc5:	a1 00 90 80 00       	mov    0x809000,%eax
  803bca:	a9 ff 0f 00 00       	test   $0xfff,%eax
  803bcf:	74 4d                	je     803c1e <_Z6mallocj+0x8c>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803bd1:	89 c1                	mov    %eax,%ecx
  803bd3:	c1 e9 0c             	shr    $0xc,%ecx
  803bd6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  803bd9:	8d 54 18 03          	lea    0x3(%eax,%ebx,1),%edx
  803bdd:	c1 ea 0c             	shr    $0xc,%edx
  803be0:	39 d1                	cmp    %edx,%ecx
  803be2:	75 1e                	jne    803c02 <_Z6mallocj+0x70>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803be4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  803bea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  803bf0:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  803bf4:	8d 14 18             	lea    (%eax,%ebx,1),%edx
  803bf7:	89 15 00 90 80 00    	mov    %edx,0x809000
			return v;
  803bfd:	e9 2d 01 00 00       	jmp    803d2f <_Z6mallocj+0x19d>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803c02:	89 04 24             	mov    %eax,(%esp)
  803c05:	e8 b6 fe ff ff       	call   803ac0 <_Z4freePv>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803c0a:	a1 00 90 80 00       	mov    0x809000,%eax
  803c0f:	05 00 10 00 00       	add    $0x1000,%eax
  803c14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c19:	a3 00 90 80 00       	mov    %eax,0x809000
  803c1e:	8b 15 00 90 80 00    	mov    0x809000,%edx
	return 1;
}

void*
malloc(size_t n)
{
  803c24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  803c2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  803c2e:	83 c7 04             	add    $0x4,%edi
  803c31:	eb 05                	jmp    803c38 <_Z6mallocj+0xa6>
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
  803c33:	ba 00 00 00 08       	mov    $0x8000000,%edx
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  803c38:	89 7d e0             	mov    %edi,-0x20(%ebp)
  803c3b:	89 d3                	mov    %edx,%ebx
  803c3d:	8d 34 17             	lea    (%edi,%edx,1),%esi
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803c40:	39 f2                	cmp    %esi,%edx
  803c42:	0f 83 b1 00 00 00    	jae    803cf9 <_Z6mallocj+0x167>
  803c48:	89 d0                	mov    %edx,%eax
		if (va >= (uintptr_t) mend
  803c4a:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  803c4f:	77 2a                	ja     803c7b <_Z6mallocj+0xe9>
  803c51:	89 c1                	mov    %eax,%ecx
  803c53:	c1 e9 16             	shr    $0x16,%ecx
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[PGNUM(va)] & PTE_P)))
  803c56:	8b 0c 8d 00 e0 bb ef 	mov    -0x10442000(,%ecx,4),%ecx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  803c5d:	f6 c1 01             	test   $0x1,%cl
  803c60:	0f 84 d1 00 00 00    	je     803d37 <_Z6mallocj+0x1a5>
  803c66:	89 c1                	mov    %eax,%ecx
  803c68:	c1 e9 0c             	shr    $0xc,%ecx
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[PGNUM(va)] & PTE_P)))
  803c6b:	8b 0c 8d 00 00 80 ef 	mov    -0x10800000(,%ecx,4),%ecx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  803c72:	f6 c1 01             	test   $0x1,%cl
  803c75:	0f 84 bc 00 00 00    	je     803d37 <_Z6mallocj+0x1a5>
			return 0;
	return 1;
}

void*
malloc(size_t n)
  803c7b:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  803c81:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  803c87:	75 af                	jne    803c38 <_Z6mallocj+0xa6>
			mptr = mbegin;
			if (++nwrap == 2)
  803c89:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  803c8d:	83 7d dc 02          	cmpl   $0x2,-0x24(%ebp)
  803c91:	75 a0                	jne    803c33 <_Z6mallocj+0xa1>
  803c93:	c7 05 00 90 80 00 00 	movl   $0x8000000,0x809000
  803c9a:	00 00 08 
				return 0;	/* out of address space */
  803c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca2:	e9 88 00 00 00       	jmp    803d2f <_Z6mallocj+0x19d>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803ca7:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  803cad:	39 fe                	cmp    %edi,%esi
  803caf:	19 c0                	sbb    %eax,%eax
  803cb1:	25 00 04 00 00       	and    $0x400,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803cb6:	83 c8 07             	or     $0x7,%eax
  803cb9:	89 44 24 08          	mov    %eax,0x8(%esp)
  803cbd:	89 d8                	mov    %ebx,%eax
  803cbf:	03 05 00 90 80 00    	add    0x809000,%eax
  803cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cd0:	e8 fb d2 ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  803cd5:	85 c0                	test   %eax,%eax
  803cd7:	79 30                	jns    803d09 <_Z6mallocj+0x177>
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  803cd9:	89 d8                	mov    %ebx,%eax
  803cdb:	03 05 00 90 80 00    	add    0x809000,%eax
  803ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cec:	e8 9c d3 ff ff       	call   80108d <_Z14sys_page_unmapiPv>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  803cf1:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  803cf7:	eb e0                	jmp    803cd9 <_Z6mallocj+0x147>
  803cf9:	89 15 00 90 80 00    	mov    %edx,0x809000

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d04:	8b 7d e0             	mov    -0x20(%ebp),%edi
  803d07:	eb 02                	jmp    803d0b <_Z6mallocj+0x179>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803d09:	89 f3                	mov    %esi,%ebx
  803d0b:	39 fb                	cmp    %edi,%ebx
  803d0d:	72 98                	jb     803ca7 <_Z6mallocj+0x115>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803d0f:	a1 00 90 80 00       	mov    0x809000,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  803d14:	c7 44 18 fc 02 00 00 	movl   $0x2,-0x4(%eax,%ebx,1)
  803d1b:	00 
	v = mptr;
	mptr += n;
  803d1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d1f:	8d 14 10             	lea    (%eax,%edx,1),%edx
  803d22:	89 15 00 90 80 00    	mov    %edx,0x809000
	return v;
  803d28:	eb 05                	jmp    803d2f <_Z6mallocj+0x19d>
		mptr = mbegin;

	n = ROUNDUP(n, 4);

	if (n >= MAXMALLOC)
		return 0;
  803d2a:	b8 00 00 00 00       	mov    $0x0,%eax
	ref = (uint32_t*) (mptr + i - 4);
	*ref = 2;	/* reference for mptr, reference for returned block */
	v = mptr;
	mptr += n;
	return v;
}
  803d2f:	83 c4 2c             	add    $0x2c,%esp
  803d32:	5b                   	pop    %ebx
  803d33:	5e                   	pop    %esi
  803d34:	5f                   	pop    %edi
  803d35:	5d                   	pop    %ebp
  803d36:	c3                   	ret    
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803d37:	05 00 10 00 00       	add    $0x1000,%eax
  803d3c:	39 f0                	cmp    %esi,%eax
  803d3e:	0f 82 06 ff ff ff    	jb     803c4a <_Z6mallocj+0xb8>
  803d44:	89 15 00 90 80 00    	mov    %edx,0x809000
  803d4a:	eb b3                	jmp    803cff <_Z6mallocj+0x16d>
  803d4c:	00 00                	add    %al,(%eax)
	...

00803d50 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803d50:	55                   	push   %ebp
  803d51:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803d53:	b8 00 00 00 00       	mov    $0x0,%eax
  803d58:	5d                   	pop    %ebp
  803d59:	c3                   	ret    

00803d5a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d5a:	55                   	push   %ebp
  803d5b:	89 e5                	mov    %esp,%ebp
  803d5d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803d60:	c7 44 24 04 7f 53 80 	movl   $0x80537f,0x4(%esp)
  803d67:	00 
  803d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d6b:	89 04 24             	mov    %eax,(%esp)
  803d6e:	e8 77 cd ff ff       	call   800aea <_Z6strcpyPcPKc>
	return 0;
}
  803d73:	b8 00 00 00 00       	mov    $0x0,%eax
  803d78:	c9                   	leave  
  803d79:	c3                   	ret    

00803d7a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d7a:	55                   	push   %ebp
  803d7b:	89 e5                	mov    %esp,%ebp
  803d7d:	57                   	push   %edi
  803d7e:	56                   	push   %esi
  803d7f:	53                   	push   %ebx
  803d80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803d8f:	74 3e                	je     803dcf <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803d91:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803d97:	8b 75 10             	mov    0x10(%ebp),%esi
  803d9a:	29 de                	sub    %ebx,%esi
  803d9c:	83 fe 7f             	cmp    $0x7f,%esi
  803d9f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803da4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803da7:	89 74 24 08          	mov    %esi,0x8(%esp)
  803dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dae:	01 d8                	add    %ebx,%eax
  803db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803db4:	89 3c 24             	mov    %edi,(%esp)
  803db7:	e8 d0 ce ff ff       	call   800c8c <memmove>
		sys_cputs(buf, m);
  803dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  803dc0:	89 3c 24             	mov    %edi,(%esp)
  803dc3:	e8 dc d0 ff ff       	call   800ea4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dc8:	01 f3                	add    %esi,%ebx
  803dca:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803dcd:	77 c8                	ja     803d97 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803dcf:	89 d8                	mov    %ebx,%eax
  803dd1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803dd7:	5b                   	pop    %ebx
  803dd8:	5e                   	pop    %esi
  803dd9:	5f                   	pop    %edi
  803dda:	5d                   	pop    %ebp
  803ddb:	c3                   	ret    

00803ddc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ddc:	55                   	push   %ebp
  803ddd:	89 e5                	mov    %esp,%ebp
  803ddf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803de2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803de7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803deb:	75 07                	jne    803df4 <_ZL12devcons_readP2FdPvj+0x18>
  803ded:	eb 2a                	jmp    803e19 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803def:	e8 a8 d1 ff ff       	call   800f9c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803df4:	e8 de d0 ff ff       	call   800ed7 <_Z9sys_cgetcv>
  803df9:	85 c0                	test   %eax,%eax
  803dfb:	74 f2                	je     803def <_ZL12devcons_readP2FdPvj+0x13>
  803dfd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803dff:	85 c0                	test   %eax,%eax
  803e01:	78 16                	js     803e19 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803e03:	83 f8 04             	cmp    $0x4,%eax
  803e06:	74 0c                	je     803e14 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e0b:	88 10                	mov    %dl,(%eax)
	return 1;
  803e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e12:	eb 05                	jmp    803e19 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803e14:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803e19:	c9                   	leave  
  803e1a:	c3                   	ret    

00803e1b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e1b:	55                   	push   %ebp
  803e1c:	89 e5                	mov    %esp,%ebp
  803e1e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803e21:	8b 45 08             	mov    0x8(%ebp),%eax
  803e24:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803e2e:	00 
  803e2f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e32:	89 04 24             	mov    %eax,(%esp)
  803e35:	e8 6a d0 ff ff       	call   800ea4 <_Z9sys_cputsPKcj>
}
  803e3a:	c9                   	leave  
  803e3b:	c3                   	ret    

00803e3c <_Z7getcharv>:

int
getchar(void)
{
  803e3c:	55                   	push   %ebp
  803e3d:	89 e5                	mov    %esp,%ebp
  803e3f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e42:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e49:	00 
  803e4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e58:	e8 e1 d9 ff ff       	call   80183e <_Z4readiPvj>
	if (r < 0)
  803e5d:	85 c0                	test   %eax,%eax
  803e5f:	78 0f                	js     803e70 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803e61:	85 c0                	test   %eax,%eax
  803e63:	7e 06                	jle    803e6b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803e65:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803e69:	eb 05                	jmp    803e70 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803e6b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803e70:	c9                   	leave  
  803e71:	c3                   	ret    

00803e72 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803e72:	55                   	push   %ebp
  803e73:	89 e5                	mov    %esp,%ebp
  803e75:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803e78:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e7f:	00 
  803e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e87:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8a:	89 04 24             	mov    %eax,(%esp)
  803e8d:	e8 ff d5 ff ff       	call   801491 <_Z9fd_lookupiPP2Fdb>
  803e92:	85 c0                	test   %eax,%eax
  803e94:	78 11                	js     803ea7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e99:	8b 15 78 60 80 00    	mov    0x806078,%edx
  803e9f:	39 10                	cmp    %edx,(%eax)
  803ea1:	0f 94 c0             	sete   %al
  803ea4:	0f b6 c0             	movzbl %al,%eax
}
  803ea7:	c9                   	leave  
  803ea8:	c3                   	ret    

00803ea9 <_Z8openconsv>:

int
opencons(void)
{
  803ea9:	55                   	push   %ebp
  803eaa:	89 e5                	mov    %esp,%ebp
  803eac:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803eaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803eb2:	89 04 24             	mov    %eax,(%esp)
  803eb5:	e8 8d d6 ff ff       	call   801547 <_Z14fd_find_unusedPP2Fd>
  803eba:	85 c0                	test   %eax,%eax
  803ebc:	78 3c                	js     803efa <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ebe:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ec5:	00 
  803ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ecd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ed4:	e8 f7 d0 ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  803ed9:	85 c0                	test   %eax,%eax
  803edb:	78 1d                	js     803efa <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803edd:	8b 15 78 60 80 00    	mov    0x806078,%edx
  803ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eeb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803ef2:	89 04 24             	mov    %eax,(%esp)
  803ef5:	e8 ea d5 ff ff       	call   8014e4 <_Z6fd2numP2Fd>
}
  803efa:	c9                   	leave  
  803efb:	c3                   	ret    
  803efc:	00 00                	add    %al,(%eax)
	...

00803f00 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803f00:	55                   	push   %ebp
  803f01:	89 e5                	mov    %esp,%ebp
  803f03:	56                   	push   %esi
  803f04:	53                   	push   %ebx
  803f05:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803f08:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803f0d:	8b 04 9d 20 90 80 00 	mov    0x809020(,%ebx,4),%eax
  803f14:	85 c0                	test   %eax,%eax
  803f16:	74 08                	je     803f20 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803f18:	8d 55 08             	lea    0x8(%ebp),%edx
  803f1b:	89 14 24             	mov    %edx,(%esp)
  803f1e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803f20:	83 eb 01             	sub    $0x1,%ebx
  803f23:	83 fb ff             	cmp    $0xffffffff,%ebx
  803f26:	75 e5                	jne    803f0d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803f28:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803f2b:	8b 75 08             	mov    0x8(%ebp),%esi
  803f2e:	e8 35 d0 ff ff       	call   800f68 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803f33:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803f37:	89 74 24 10          	mov    %esi,0x10(%esp)
  803f3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f3f:	c7 44 24 08 8c 53 80 	movl   $0x80538c,0x8(%esp)
  803f46:	00 
  803f47:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803f4e:	00 
  803f4f:	c7 04 24 10 54 80 00 	movl   $0x805410,(%esp)
  803f56:	e8 51 c4 ff ff       	call   8003ac <_Z6_panicPKciS0_z>

00803f5b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803f5b:	55                   	push   %ebp
  803f5c:	89 e5                	mov    %esp,%ebp
  803f5e:	56                   	push   %esi
  803f5f:	53                   	push   %ebx
  803f60:	83 ec 10             	sub    $0x10,%esp
  803f63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803f66:	e8 fd cf ff ff       	call   800f68 <_Z12sys_getenvidv>
  803f6b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803f6d:	a1 00 70 80 00       	mov    0x807000,%eax
  803f72:	8b 40 5c             	mov    0x5c(%eax),%eax
  803f75:	85 c0                	test   %eax,%eax
  803f77:	75 4c                	jne    803fc5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803f79:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803f80:	00 
  803f81:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803f88:	ee 
  803f89:	89 34 24             	mov    %esi,(%esp)
  803f8c:	e8 3f d0 ff ff       	call   800fd0 <_Z14sys_page_allociPvi>
  803f91:	85 c0                	test   %eax,%eax
  803f93:	74 20                	je     803fb5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803f95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803f99:	c7 44 24 08 c4 53 80 	movl   $0x8053c4,0x8(%esp)
  803fa0:	00 
  803fa1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803fa8:	00 
  803fa9:	c7 04 24 10 54 80 00 	movl   $0x805410,(%esp)
  803fb0:	e8 f7 c3 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803fb5:	c7 44 24 04 00 3f 80 	movl   $0x803f00,0x4(%esp)
  803fbc:	00 
  803fbd:	89 34 24             	mov    %esi,(%esp)
  803fc0:	e8 40 d2 ff ff       	call   801205 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803fc5:	a1 20 90 80 00       	mov    0x809020,%eax
  803fca:	39 d8                	cmp    %ebx,%eax
  803fcc:	74 1a                	je     803fe8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 20                	je     803ff2 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803fd2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803fd7:	8b 14 85 20 90 80 00 	mov    0x809020(,%eax,4),%edx
  803fde:	39 da                	cmp    %ebx,%edx
  803fe0:	74 15                	je     803ff7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803fe2:	85 d2                	test   %edx,%edx
  803fe4:	75 1f                	jne    804005 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803fe6:	eb 0f                	jmp    803ff7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fed:	8d 76 00             	lea    0x0(%esi),%esi
  803ff0:	eb 05                	jmp    803ff7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803ff2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803ff7:	89 1c 85 20 90 80 00 	mov    %ebx,0x809020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803ffe:	83 c4 10             	add    $0x10,%esp
  804001:	5b                   	pop    %ebx
  804002:	5e                   	pop    %esi
  804003:	5d                   	pop    %ebp
  804004:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804005:	83 c0 01             	add    $0x1,%eax
  804008:	83 f8 08             	cmp    $0x8,%eax
  80400b:	75 ca                	jne    803fd7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80400d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804011:	c7 44 24 08 e8 53 80 	movl   $0x8053e8,0x8(%esp)
  804018:	00 
  804019:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804020:	00 
  804021:	c7 04 24 10 54 80 00 	movl   $0x805410,(%esp)
  804028:	e8 7f c3 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
  80402d:	00 00                	add    %al,(%eax)
	...

00804030 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804030:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804033:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804034:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804037:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80403b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80403f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804042:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804044:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804048:	61                   	popa   
    popf
  804049:	9d                   	popf   
    popl %esp
  80404a:	5c                   	pop    %esp
    ret
  80404b:	c3                   	ret    

0080404c <spin>:

spin:	jmp spin
  80404c:	eb fe                	jmp    80404c <spin>
	...

00804050 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804050:	55                   	push   %ebp
  804051:	89 e5                	mov    %esp,%ebp
  804053:	56                   	push   %esi
  804054:	53                   	push   %ebx
  804055:	83 ec 10             	sub    $0x10,%esp
  804058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80405b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80405e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804061:	85 c0                	test   %eax,%eax
  804063:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804068:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80406b:	89 04 24             	mov    %eax,(%esp)
  80406e:	e8 28 d2 ff ff       	call   80129b <_Z12sys_ipc_recvPv>
  804073:	85 c0                	test   %eax,%eax
  804075:	79 16                	jns    80408d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804077:	85 db                	test   %ebx,%ebx
  804079:	74 06                	je     804081 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80407b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804081:	85 f6                	test   %esi,%esi
  804083:	74 53                	je     8040d8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80408b:	eb 4b                	jmp    8040d8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80408d:	85 db                	test   %ebx,%ebx
  80408f:	74 17                	je     8040a8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804091:	e8 d2 ce ff ff       	call   800f68 <_Z12sys_getenvidv>
  804096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80409b:	6b c0 78             	imul   $0x78,%eax,%eax
  80409e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8040a3:	8b 40 60             	mov    0x60(%eax),%eax
  8040a6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  8040a8:	85 f6                	test   %esi,%esi
  8040aa:	74 17                	je     8040c3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  8040ac:	e8 b7 ce ff ff       	call   800f68 <_Z12sys_getenvidv>
  8040b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040b6:	6b c0 78             	imul   $0x78,%eax,%eax
  8040b9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8040be:	8b 40 70             	mov    0x70(%eax),%eax
  8040c1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8040c3:	e8 a0 ce ff ff       	call   800f68 <_Z12sys_getenvidv>
  8040c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040cd:	6b c0 78             	imul   $0x78,%eax,%eax
  8040d0:	05 08 00 00 ef       	add    $0xef000008,%eax
  8040d5:	8b 40 60             	mov    0x60(%eax),%eax

}
  8040d8:	83 c4 10             	add    $0x10,%esp
  8040db:	5b                   	pop    %ebx
  8040dc:	5e                   	pop    %esi
  8040dd:	5d                   	pop    %ebp
  8040de:	c3                   	ret    

008040df <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040df:	55                   	push   %ebp
  8040e0:	89 e5                	mov    %esp,%ebp
  8040e2:	57                   	push   %edi
  8040e3:	56                   	push   %esi
  8040e4:	53                   	push   %ebx
  8040e5:	83 ec 1c             	sub    $0x1c,%esp
  8040e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8040eb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8040ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8040f1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8040f3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8040f8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8040fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8040fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804102:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804106:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80410a:	89 34 24             	mov    %esi,(%esp)
  80410d:	e8 51 d1 ff ff       	call   801263 <_Z16sys_ipc_try_sendijPvi>
  804112:	85 c0                	test   %eax,%eax
  804114:	79 31                	jns    804147 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804116:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804119:	75 0c                	jne    804127 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80411b:	90                   	nop
  80411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804120:	e8 77 ce ff ff       	call   800f9c <_Z9sys_yieldv>
  804125:	eb d4                	jmp    8040fb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804127:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80412b:	c7 44 24 08 1e 54 80 	movl   $0x80541e,0x8(%esp)
  804132:	00 
  804133:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80413a:	00 
  80413b:	c7 04 24 2b 54 80 00 	movl   $0x80542b,(%esp)
  804142:	e8 65 c2 ff ff       	call   8003ac <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804147:	83 c4 1c             	add    $0x1c,%esp
  80414a:	5b                   	pop    %ebx
  80414b:	5e                   	pop    %esi
  80414c:	5f                   	pop    %edi
  80414d:	5d                   	pop    %ebp
  80414e:	c3                   	ret    
	...

00804150 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804150:	55                   	push   %ebp
  804151:	89 e5                	mov    %esp,%ebp
  804153:	57                   	push   %edi
  804154:	56                   	push   %esi
  804155:	53                   	push   %ebx
  804156:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804159:	8b 45 08             	mov    0x8(%ebp),%eax
  80415c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80415f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804162:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804165:	8d 45 ef             	lea    -0x11(%ebp),%eax
  804168:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80416b:	bb 40 90 80 00       	mov    $0x809040,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804170:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804173:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804176:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  80417b:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  804180:	f6 e1                	mul    %cl
  804182:	66 c1 e8 08          	shr    $0x8,%ax
  804186:	c0 e8 03             	shr    $0x3,%al
  804189:	89 c6                	mov    %eax,%esi
  80418b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80418e:	01 c0                	add    %eax,%eax
  804190:	28 c1                	sub    %al,%cl
  804192:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  804194:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  804196:	0f b6 fa             	movzbl %dl,%edi
  804199:	83 c0 30             	add    $0x30,%eax
  80419c:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  8041a0:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  8041a3:	84 c9                	test   %cl,%cl
  8041a5:	75 d4                	jne    80417b <inet_ntoa+0x2b>
  8041a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041aa:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8041ac:	84 d2                	test   %dl,%dl
  8041ae:	74 24                	je     8041d4 <inet_ntoa+0x84>
  8041b0:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  8041b3:	0f b6 fa             	movzbl %dl,%edi
  8041b6:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  8041ba:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8041bc:	0f b6 ca             	movzbl %dl,%ecx
  8041bf:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  8041c4:	88 08                	mov    %cl,(%eax)
  8041c6:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8041c9:	83 ea 01             	sub    $0x1,%edx
  8041cc:	39 f0                	cmp    %esi,%eax
  8041ce:	75 ec                	jne    8041bc <inet_ntoa+0x6c>
  8041d0:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  8041d4:	c6 03 2e             	movb   $0x2e,(%ebx)
  8041d7:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8041da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041dd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8041e0:	74 06                	je     8041e8 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8041e2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8041e6:	eb 88                	jmp    804170 <inet_ntoa+0x20>
  }
  *--rp = 0;
  8041e8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8041ec:	b8 40 90 80 00       	mov    $0x809040,%eax
  8041f1:	83 c4 18             	add    $0x18,%esp
  8041f4:	5b                   	pop    %ebx
  8041f5:	5e                   	pop    %esi
  8041f6:	5f                   	pop    %edi
  8041f7:	5d                   	pop    %ebp
  8041f8:	c3                   	ret    

008041f9 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8041f9:	55                   	push   %ebp
  8041fa:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8041fc:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  804200:	66 c1 c0 08          	rol    $0x8,%ax
}
  804204:	5d                   	pop    %ebp
  804205:	c3                   	ret    

00804206 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804206:	55                   	push   %ebp
  804207:	89 e5                	mov    %esp,%ebp
  804209:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  80420c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  804210:	89 04 24             	mov    %eax,(%esp)
  804213:	e8 e1 ff ff ff       	call   8041f9 <htons>
}
  804218:	c9                   	leave  
  804219:	c3                   	ret    

0080421a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80421a:	55                   	push   %ebp
  80421b:	89 e5                	mov    %esp,%ebp
  80421d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804220:	89 d1                	mov    %edx,%ecx
  804222:	c1 e9 18             	shr    $0x18,%ecx
  804225:	89 d0                	mov    %edx,%eax
  804227:	c1 e0 18             	shl    $0x18,%eax
  80422a:	09 c8                	or     %ecx,%eax
  80422c:	89 d1                	mov    %edx,%ecx
  80422e:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  804234:	c1 e1 08             	shl    $0x8,%ecx
  804237:	09 c8                	or     %ecx,%eax
  804239:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  80423f:	c1 ea 08             	shr    $0x8,%edx
  804242:	09 d0                	or     %edx,%eax
}
  804244:	5d                   	pop    %ebp
  804245:	c3                   	ret    

00804246 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804246:	55                   	push   %ebp
  804247:	89 e5                	mov    %esp,%ebp
  804249:	57                   	push   %edi
  80424a:	56                   	push   %esi
  80424b:	53                   	push   %ebx
  80424c:	83 ec 28             	sub    $0x28,%esp
  80424f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  804252:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804255:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  804258:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80425d:	80 fb 09             	cmp    $0x9,%bl
  804260:	0f 87 c4 01 00 00    	ja     80442a <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804266:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  804269:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80426c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80426f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  804272:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  804279:	83 fa 30             	cmp    $0x30,%edx
  80427c:	75 25                	jne    8042a3 <inet_aton+0x5d>
      c = *++cp;
  80427e:	83 c1 01             	add    $0x1,%ecx
  804281:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  804284:	83 fa 78             	cmp    $0x78,%edx
  804287:	74 0c                	je     804295 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  804289:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  804290:	83 fa 58             	cmp    $0x58,%edx
  804293:	75 0e                	jne    8042a3 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  804295:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  804299:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80429c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  8042a3:	8d 41 01             	lea    0x1(%ecx),%eax
  8042a6:	be 00 00 00 00       	mov    $0x0,%esi
  8042ab:	eb 03                	jmp    8042b0 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8042ad:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  8042b0:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8042b3:	89 d1                	mov    %edx,%ecx
  8042b5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8042b8:	80 fb 09             	cmp    $0x9,%bl
  8042bb:	77 0d                	ja     8042ca <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  8042bd:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  8042c1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8042c5:	0f be 10             	movsbl (%eax),%edx
  8042c8:	eb e3                	jmp    8042ad <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  8042ca:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  8042ce:	0f 85 5e 01 00 00    	jne    804432 <inet_aton+0x1ec>
  8042d4:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8042d7:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8042da:	80 fb 05             	cmp    $0x5,%bl
  8042dd:	76 0c                	jbe    8042eb <inet_aton+0xa5>
  8042df:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8042e2:	80 fb 05             	cmp    $0x5,%bl
  8042e5:	0f 87 4d 01 00 00    	ja     804438 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8042eb:	89 f1                	mov    %esi,%ecx
  8042ed:	c1 e1 04             	shl    $0x4,%ecx
  8042f0:	8d 72 0a             	lea    0xa(%edx),%esi
  8042f3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8042f7:	19 d2                	sbb    %edx,%edx
  8042f9:	83 e2 20             	and    $0x20,%edx
  8042fc:	83 c2 41             	add    $0x41,%edx
  8042ff:	29 d6                	sub    %edx,%esi
  804301:	09 ce                	or     %ecx,%esi
        c = *++cp;
  804303:	0f be 10             	movsbl (%eax),%edx
  804306:	eb a5                	jmp    8042ad <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80430b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80430e:	0f 83 0a 01 00 00    	jae    80441e <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  804314:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804317:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  804319:	8d 4f 01             	lea    0x1(%edi),%ecx
  80431c:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804320:	8d 42 d0             	lea    -0x30(%edx),%eax
  804323:	3c 09                	cmp    $0x9,%al
  804325:	0f 87 fa 00 00 00    	ja     804425 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  80432b:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  80432f:	e9 3e ff ff ff       	jmp    804272 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  804334:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804339:	80 f9 1f             	cmp    $0x1f,%cl
  80433c:	0f 86 e8 00 00 00    	jbe    80442a <inet_aton+0x1e4>
  804342:	84 d2                	test   %dl,%dl
  804344:	0f 88 e0 00 00 00    	js     80442a <inet_aton+0x1e4>
  80434a:	83 fa 20             	cmp    $0x20,%edx
  80434d:	74 1d                	je     80436c <inet_aton+0x126>
  80434f:	83 fa 0c             	cmp    $0xc,%edx
  804352:	74 18                	je     80436c <inet_aton+0x126>
  804354:	83 fa 0a             	cmp    $0xa,%edx
  804357:	74 13                	je     80436c <inet_aton+0x126>
  804359:	83 fa 0d             	cmp    $0xd,%edx
  80435c:	74 0e                	je     80436c <inet_aton+0x126>
  80435e:	83 fa 09             	cmp    $0x9,%edx
  804361:	74 09                	je     80436c <inet_aton+0x126>
  804363:	83 fa 0b             	cmp    $0xb,%edx
  804366:	0f 85 be 00 00 00    	jne    80442a <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80436c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80436f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804372:	29 c2                	sub    %eax,%edx
  804374:	c1 fa 02             	sar    $0x2,%edx
  804377:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80437a:	83 fa 02             	cmp    $0x2,%edx
  80437d:	74 25                	je     8043a4 <inet_aton+0x15e>
  80437f:	83 fa 02             	cmp    $0x2,%edx
  804382:	7f 0f                	jg     804393 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  804384:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  804389:	85 d2                	test   %edx,%edx
  80438b:	0f 84 99 00 00 00    	je     80442a <inet_aton+0x1e4>
  804391:	eb 6c                	jmp    8043ff <inet_aton+0x1b9>
  804393:	83 fa 03             	cmp    $0x3,%edx
  804396:	74 23                	je     8043bb <inet_aton+0x175>
  804398:	83 fa 04             	cmp    $0x4,%edx
  80439b:	90                   	nop
  80439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043a0:	75 5d                	jne    8043ff <inet_aton+0x1b9>
  8043a2:	eb 36                	jmp    8043da <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8043a4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8043a9:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8043af:	77 79                	ja     80442a <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  8043b1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8043b4:	c1 e6 18             	shl    $0x18,%esi
  8043b7:	09 de                	or     %ebx,%esi
    break;
  8043b9:	eb 44                	jmp    8043ff <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8043bb:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8043c0:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8043c6:	77 62                	ja     80442a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8043c8:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8043cb:	c1 e6 10             	shl    $0x10,%esi
  8043ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043d1:	c1 e0 18             	shl    $0x18,%eax
  8043d4:	09 c6                	or     %eax,%esi
  8043d6:	09 de                	or     %ebx,%esi
    break;
  8043d8:	eb 25                	jmp    8043ff <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8043da:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8043df:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8043e5:	77 43                	ja     80442a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8043e7:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8043ea:	c1 e6 10             	shl    $0x10,%esi
  8043ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f0:	c1 e0 18             	shl    $0x18,%eax
  8043f3:	09 c6                	or     %eax,%esi
  8043f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043f8:	c1 e0 08             	shl    $0x8,%eax
  8043fb:	09 c6                	or     %eax,%esi
  8043fd:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8043ff:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804408:	74 20                	je     80442a <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  80440a:	89 34 24             	mov    %esi,(%esp)
  80440d:	e8 08 fe ff ff       	call   80421a <htonl>
  804412:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  804415:	89 03                	mov    %eax,(%ebx)
  return (1);
  804417:	b8 01 00 00 00       	mov    $0x1,%eax
  80441c:	eb 0c                	jmp    80442a <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80441e:	b8 00 00 00 00       	mov    $0x0,%eax
  804423:	eb 05                	jmp    80442a <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  804425:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  80442a:	83 c4 28             	add    $0x28,%esp
  80442d:	5b                   	pop    %ebx
  80442e:	5e                   	pop    %esi
  80442f:	5f                   	pop    %edi
  804430:	5d                   	pop    %ebp
  804431:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804432:	89 d0                	mov    %edx,%eax
  804434:	89 f3                	mov    %esi,%ebx
  804436:	eb 04                	jmp    80443c <inet_aton+0x1f6>
  804438:	89 d0                	mov    %edx,%eax
  80443a:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  80443c:	83 f8 2e             	cmp    $0x2e,%eax
  80443f:	0f 84 c3 fe ff ff    	je     804308 <inet_aton+0xc2>
  804445:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804447:	85 d2                	test   %edx,%edx
  804449:	0f 84 1d ff ff ff    	je     80436c <inet_aton+0x126>
  80444f:	e9 e0 fe ff ff       	jmp    804334 <inet_aton+0xee>

00804454 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804454:	55                   	push   %ebp
  804455:	89 e5                	mov    %esp,%ebp
  804457:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80445a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80445d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804461:	8b 45 08             	mov    0x8(%ebp),%eax
  804464:	89 04 24             	mov    %eax,(%esp)
  804467:	e8 da fd ff ff       	call   804246 <inet_aton>
  80446c:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80446e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  804473:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  804477:	c9                   	leave  
  804478:	c3                   	ret    

00804479 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804479:	55                   	push   %ebp
  80447a:	89 e5                	mov    %esp,%ebp
  80447c:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  80447f:	8b 45 08             	mov    0x8(%ebp),%eax
  804482:	89 04 24             	mov    %eax,(%esp)
  804485:	e8 90 fd ff ff       	call   80421a <htonl>
}
  80448a:	c9                   	leave  
  80448b:	c3                   	ret    
  80448c:	00 00                	add    %al,(%eax)
	...

00804490 <__udivdi3>:
  804490:	55                   	push   %ebp
  804491:	89 e5                	mov    %esp,%ebp
  804493:	57                   	push   %edi
  804494:	56                   	push   %esi
  804495:	83 ec 20             	sub    $0x20,%esp
  804498:	8b 45 14             	mov    0x14(%ebp),%eax
  80449b:	8b 75 08             	mov    0x8(%ebp),%esi
  80449e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8044a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8044a4:	85 c0                	test   %eax,%eax
  8044a6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8044a9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8044ac:	75 3a                	jne    8044e8 <__udivdi3+0x58>
  8044ae:	39 f9                	cmp    %edi,%ecx
  8044b0:	77 66                	ja     804518 <__udivdi3+0x88>
  8044b2:	85 c9                	test   %ecx,%ecx
  8044b4:	75 0b                	jne    8044c1 <__udivdi3+0x31>
  8044b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8044bb:	31 d2                	xor    %edx,%edx
  8044bd:	f7 f1                	div    %ecx
  8044bf:	89 c1                	mov    %eax,%ecx
  8044c1:	89 f8                	mov    %edi,%eax
  8044c3:	31 d2                	xor    %edx,%edx
  8044c5:	f7 f1                	div    %ecx
  8044c7:	89 c7                	mov    %eax,%edi
  8044c9:	89 f0                	mov    %esi,%eax
  8044cb:	f7 f1                	div    %ecx
  8044cd:	89 fa                	mov    %edi,%edx
  8044cf:	89 c6                	mov    %eax,%esi
  8044d1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8044d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8044d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044dd:	83 c4 20             	add    $0x20,%esp
  8044e0:	5e                   	pop    %esi
  8044e1:	5f                   	pop    %edi
  8044e2:	5d                   	pop    %ebp
  8044e3:	c3                   	ret    
  8044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044e8:	31 d2                	xor    %edx,%edx
  8044ea:	31 f6                	xor    %esi,%esi
  8044ec:	39 f8                	cmp    %edi,%eax
  8044ee:	77 e1                	ja     8044d1 <__udivdi3+0x41>
  8044f0:	0f bd d0             	bsr    %eax,%edx
  8044f3:	83 f2 1f             	xor    $0x1f,%edx
  8044f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8044f9:	75 2d                	jne    804528 <__udivdi3+0x98>
  8044fb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8044fe:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804501:	76 06                	jbe    804509 <__udivdi3+0x79>
  804503:	39 f8                	cmp    %edi,%eax
  804505:	89 f2                	mov    %esi,%edx
  804507:	73 c8                	jae    8044d1 <__udivdi3+0x41>
  804509:	31 d2                	xor    %edx,%edx
  80450b:	be 01 00 00 00       	mov    $0x1,%esi
  804510:	eb bf                	jmp    8044d1 <__udivdi3+0x41>
  804512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804518:	89 f0                	mov    %esi,%eax
  80451a:	89 fa                	mov    %edi,%edx
  80451c:	f7 f1                	div    %ecx
  80451e:	31 d2                	xor    %edx,%edx
  804520:	89 c6                	mov    %eax,%esi
  804522:	eb ad                	jmp    8044d1 <__udivdi3+0x41>
  804524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804528:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80452c:	89 c2                	mov    %eax,%edx
  80452e:	b8 20 00 00 00       	mov    $0x20,%eax
  804533:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804536:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804539:	d3 e2                	shl    %cl,%edx
  80453b:	89 c1                	mov    %eax,%ecx
  80453d:	d3 ee                	shr    %cl,%esi
  80453f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804543:	09 d6                	or     %edx,%esi
  804545:	89 fa                	mov    %edi,%edx
  804547:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80454a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80454d:	d3 e6                	shl    %cl,%esi
  80454f:	89 c1                	mov    %eax,%ecx
  804551:	d3 ea                	shr    %cl,%edx
  804553:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804557:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80455a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80455d:	d3 e7                	shl    %cl,%edi
  80455f:	89 c1                	mov    %eax,%ecx
  804561:	d3 ee                	shr    %cl,%esi
  804563:	09 fe                	or     %edi,%esi
  804565:	89 f0                	mov    %esi,%eax
  804567:	f7 75 e4             	divl   -0x1c(%ebp)
  80456a:	89 d7                	mov    %edx,%edi
  80456c:	89 c6                	mov    %eax,%esi
  80456e:	f7 65 f0             	mull   -0x10(%ebp)
  804571:	39 d7                	cmp    %edx,%edi
  804573:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804576:	72 12                	jb     80458a <__udivdi3+0xfa>
  804578:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80457b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80457f:	d3 e2                	shl    %cl,%edx
  804581:	39 c2                	cmp    %eax,%edx
  804583:	73 08                	jae    80458d <__udivdi3+0xfd>
  804585:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804588:	75 03                	jne    80458d <__udivdi3+0xfd>
  80458a:	83 ee 01             	sub    $0x1,%esi
  80458d:	31 d2                	xor    %edx,%edx
  80458f:	e9 3d ff ff ff       	jmp    8044d1 <__udivdi3+0x41>
	...

008045a0 <__umoddi3>:
  8045a0:	55                   	push   %ebp
  8045a1:	89 e5                	mov    %esp,%ebp
  8045a3:	57                   	push   %edi
  8045a4:	56                   	push   %esi
  8045a5:	83 ec 20             	sub    $0x20,%esp
  8045a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8045ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8045b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8045b4:	85 ff                	test   %edi,%edi
  8045b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8045b9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8045bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8045bf:	89 f2                	mov    %esi,%edx
  8045c1:	75 15                	jne    8045d8 <__umoddi3+0x38>
  8045c3:	39 f1                	cmp    %esi,%ecx
  8045c5:	76 41                	jbe    804608 <__umoddi3+0x68>
  8045c7:	f7 f1                	div    %ecx
  8045c9:	89 d0                	mov    %edx,%eax
  8045cb:	31 d2                	xor    %edx,%edx
  8045cd:	83 c4 20             	add    $0x20,%esp
  8045d0:	5e                   	pop    %esi
  8045d1:	5f                   	pop    %edi
  8045d2:	5d                   	pop    %ebp
  8045d3:	c3                   	ret    
  8045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8045d8:	39 f7                	cmp    %esi,%edi
  8045da:	77 4c                	ja     804628 <__umoddi3+0x88>
  8045dc:	0f bd c7             	bsr    %edi,%eax
  8045df:	83 f0 1f             	xor    $0x1f,%eax
  8045e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8045e5:	75 51                	jne    804638 <__umoddi3+0x98>
  8045e7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8045ea:	0f 87 e8 00 00 00    	ja     8046d8 <__umoddi3+0x138>
  8045f0:	89 f2                	mov    %esi,%edx
  8045f2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8045f5:	29 ce                	sub    %ecx,%esi
  8045f7:	19 fa                	sbb    %edi,%edx
  8045f9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8045fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045ff:	83 c4 20             	add    $0x20,%esp
  804602:	5e                   	pop    %esi
  804603:	5f                   	pop    %edi
  804604:	5d                   	pop    %ebp
  804605:	c3                   	ret    
  804606:	66 90                	xchg   %ax,%ax
  804608:	85 c9                	test   %ecx,%ecx
  80460a:	75 0b                	jne    804617 <__umoddi3+0x77>
  80460c:	b8 01 00 00 00       	mov    $0x1,%eax
  804611:	31 d2                	xor    %edx,%edx
  804613:	f7 f1                	div    %ecx
  804615:	89 c1                	mov    %eax,%ecx
  804617:	89 f0                	mov    %esi,%eax
  804619:	31 d2                	xor    %edx,%edx
  80461b:	f7 f1                	div    %ecx
  80461d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804620:	eb a5                	jmp    8045c7 <__umoddi3+0x27>
  804622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804628:	89 f2                	mov    %esi,%edx
  80462a:	83 c4 20             	add    $0x20,%esp
  80462d:	5e                   	pop    %esi
  80462e:	5f                   	pop    %edi
  80462f:	5d                   	pop    %ebp
  804630:	c3                   	ret    
  804631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804638:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80463c:	89 f2                	mov    %esi,%edx
  80463e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804641:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804648:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80464b:	d3 e7                	shl    %cl,%edi
  80464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804650:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804654:	d3 e8                	shr    %cl,%eax
  804656:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80465a:	09 f8                	or     %edi,%eax
  80465c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80465f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804662:	d3 e0                	shl    %cl,%eax
  804664:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80466b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80466e:	d3 ea                	shr    %cl,%edx
  804670:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804674:	d3 e6                	shl    %cl,%esi
  804676:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80467a:	d3 e8                	shr    %cl,%eax
  80467c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804680:	09 f0                	or     %esi,%eax
  804682:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804685:	f7 75 e4             	divl   -0x1c(%ebp)
  804688:	d3 e6                	shl    %cl,%esi
  80468a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80468d:	89 d6                	mov    %edx,%esi
  80468f:	f7 65 f4             	mull   -0xc(%ebp)
  804692:	89 d7                	mov    %edx,%edi
  804694:	89 c2                	mov    %eax,%edx
  804696:	39 fe                	cmp    %edi,%esi
  804698:	89 f9                	mov    %edi,%ecx
  80469a:	72 30                	jb     8046cc <__umoddi3+0x12c>
  80469c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80469f:	72 27                	jb     8046c8 <__umoddi3+0x128>
  8046a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046a4:	29 d0                	sub    %edx,%eax
  8046a6:	19 ce                	sbb    %ecx,%esi
  8046a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046ac:	89 f2                	mov    %esi,%edx
  8046ae:	d3 e8                	shr    %cl,%eax
  8046b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8046b4:	d3 e2                	shl    %cl,%edx
  8046b6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046ba:	09 d0                	or     %edx,%eax
  8046bc:	89 f2                	mov    %esi,%edx
  8046be:	d3 ea                	shr    %cl,%edx
  8046c0:	83 c4 20             	add    $0x20,%esp
  8046c3:	5e                   	pop    %esi
  8046c4:	5f                   	pop    %edi
  8046c5:	5d                   	pop    %ebp
  8046c6:	c3                   	ret    
  8046c7:	90                   	nop
  8046c8:	39 fe                	cmp    %edi,%esi
  8046ca:	75 d5                	jne    8046a1 <__umoddi3+0x101>
  8046cc:	89 f9                	mov    %edi,%ecx
  8046ce:	89 c2                	mov    %eax,%edx
  8046d0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8046d3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8046d6:	eb c9                	jmp    8046a1 <__umoddi3+0x101>
  8046d8:	39 f7                	cmp    %esi,%edi
  8046da:	0f 82 10 ff ff ff    	jb     8045f0 <__umoddi3+0x50>
  8046e0:	e9 17 ff ff ff       	jmp    8045fc <__umoddi3+0x5c>
