
obj/user/testkbd:     file format elf32-i386


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
  80002c:	e8 8b 02 00 00       	call   8002bc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	int r;

	close(0);
  80003a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800041:	e8 bf 16 00 00       	call   801705 <_Z5closei>
	if ((r = opencons()) < 0)
  800046:	e8 1e 02 00 00       	call   800269 <_Z8openconsv>
  80004b:	85 c0                	test   %eax,%eax
  80004d:	79 20                	jns    80006f <_Z5umainiPPc+0x3b>
		panic("opencons: %e", r);
  80004f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800053:	c7 44 24 08 20 41 80 	movl   $0x804120,0x8(%esp)
  80005a:	00 
  80005b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800062:	00 
  800063:	c7 04 24 2d 41 80 00 	movl   $0x80412d,(%esp)
  80006a:	e8 d1 02 00 00       	call   800340 <_Z6_panicPKciS0_z>
	if (r != 0)
  80006f:	85 c0                	test   %eax,%eax
  800071:	74 20                	je     800093 <_Z5umainiPPc+0x5f>
		panic("first opencons used fd %d", r);
  800073:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800077:	c7 44 24 08 3c 41 80 	movl   $0x80413c,0x8(%esp)
  80007e:	00 
  80007f:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800086:	00 
  800087:	c7 04 24 2d 41 80 00 	movl   $0x80412d,(%esp)
  80008e:	e8 ad 02 00 00       	call   800340 <_Z6_panicPKciS0_z>
	if ((r = dup(0, 1)) < 0)
  800093:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a2:	e8 b9 16 00 00       	call   801760 <_Z3dupii>
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	79 20                	jns    8000cb <_Z5umainiPPc+0x97>
		panic("dup: %e", r);
  8000ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000af:	c7 44 24 08 56 41 80 	movl   $0x804156,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 2d 41 80 00 	movl   $0x80412d,(%esp)
  8000c6:	e8 75 02 00 00       	call   800340 <_Z6_panicPKciS0_z>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000cb:	c7 04 24 5e 41 80 00 	movl   $0x80415e,(%esp)
  8000d2:	e8 69 09 00 00       	call   800a40 <_Z8readlinePKc>
		if (buf != NULL)
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	74 1a                	je     8000f5 <_Z5umainiPPc+0xc1>
			fprintf(1, "%s\n", buf);
  8000db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000df:	c7 44 24 04 6c 41 80 	movl   $0x80416c,0x4(%esp)
  8000e6:	00 
  8000e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ee:	e8 0d 36 00 00       	call   803700 <_Z7fprintfiPKcz>
  8000f3:	eb d6                	jmp    8000cb <_Z5umainiPPc+0x97>
		else
			fprintf(1, "(end of file received)\n");
  8000f5:	c7 44 24 04 70 41 80 	movl   $0x804170,0x4(%esp)
  8000fc:	00 
  8000fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800104:	e8 f7 35 00 00       	call   803700 <_Z7fprintfiPKcz>
  800109:	eb c0                	jmp    8000cb <_Z5umainiPPc+0x97>
  80010b:	00 00                	add    %al,(%eax)
  80010d:	00 00                	add    %al,(%eax)
	...

00800110 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800113:	b8 00 00 00 00       	mov    $0x0,%eax
  800118:	5d                   	pop    %ebp
  800119:	c3                   	ret    

0080011a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800120:	c7 44 24 04 88 41 80 	movl   $0x804188,0x4(%esp)
  800127:	00 
  800128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 27 0a 00 00       	call   800b5a <_Z6strcpyPcPKc>
	return 0;
}
  800133:	b8 00 00 00 00       	mov    $0x0,%eax
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	57                   	push   %edi
  80013e:	56                   	push   %esi
  80013f:	53                   	push   %ebx
  800140:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80014b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80014f:	74 3e                	je     80018f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800151:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800157:	8b 75 10             	mov    0x10(%ebp),%esi
  80015a:	29 de                	sub    %ebx,%esi
  80015c:	83 fe 7f             	cmp    $0x7f,%esi
  80015f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800164:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800167:	89 74 24 08          	mov    %esi,0x8(%esp)
  80016b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016e:	01 d8                	add    %ebx,%eax
  800170:	89 44 24 04          	mov    %eax,0x4(%esp)
  800174:	89 3c 24             	mov    %edi,(%esp)
  800177:	e8 80 0b 00 00       	call   800cfc <memmove>
		sys_cputs(buf, m);
  80017c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800180:	89 3c 24             	mov    %edi,(%esp)
  800183:	e8 8c 0d 00 00       	call   800f14 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800188:	01 f3                	add    %esi,%ebx
  80018a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80018d:	77 c8                	ja     800157 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80018f:	89 d8                	mov    %ebx,%eax
  800191:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    

0080019c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001ab:	75 07                	jne    8001b4 <_ZL12devcons_readP2FdPvj+0x18>
  8001ad:	eb 2a                	jmp    8001d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001af:	e8 58 0e 00 00       	call   80100c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001b4:	e8 8e 0d 00 00       	call   800f47 <_Z9sys_cgetcv>
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	74 f2                	je     8001af <_ZL12devcons_readP2FdPvj+0x13>
  8001bd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	78 16                	js     8001d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001c3:	83 f8 04             	cmp    $0x4,%eax
  8001c6:	74 0c                	je     8001d4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	88 10                	mov    %dl,(%eax)
	return 1;
  8001cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8001d2:	eb 05                	jmp    8001d9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001d4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

008001db <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001ee:	00 
  8001ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001f2:	89 04 24             	mov    %eax,(%esp)
  8001f5:	e8 1a 0d 00 00       	call   800f14 <_Z9sys_cputsPKcj>
}
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <_Z7getcharv>:

int
getchar(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800202:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800209:	00 
  80020a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80020d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800218:	e8 91 16 00 00       	call   8018ae <_Z4readiPvj>
	if (r < 0)
  80021d:	85 c0                	test   %eax,%eax
  80021f:	78 0f                	js     800230 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  800221:	85 c0                	test   %eax,%eax
  800223:	7e 06                	jle    80022b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  800225:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800229:	eb 05                	jmp    800230 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80022b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  800238:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80023f:	00 
  800240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800243:	89 44 24 04          	mov    %eax,0x4(%esp)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 af 12 00 00       	call   801501 <_Z9fd_lookupiPP2Fdb>
  800252:	85 c0                	test   %eax,%eax
  800254:	78 11                	js     800267 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  800256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800259:	8b 15 00 50 80 00    	mov    0x805000,%edx
  80025f:	39 10                	cmp    %edx,(%eax)
  800261:	0f 94 c0             	sete   %al
  800264:	0f b6 c0             	movzbl %al,%eax
}
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <_Z8openconsv>:

int
opencons(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80026f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800272:	89 04 24             	mov    %eax,(%esp)
  800275:	e8 3d 13 00 00       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  80027a:	85 c0                	test   %eax,%eax
  80027c:	78 3c                	js     8002ba <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80027e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800285:	00 
  800286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800294:	e8 a7 0d 00 00       	call   801040 <_Z14sys_page_allociPvi>
  800299:	85 c0                	test   %eax,%eax
  80029b:	78 1d                	js     8002ba <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80029d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8002a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002b2:	89 04 24             	mov    %eax,(%esp)
  8002b5:	e8 9a 12 00 00       	call   801554 <_Z6fd2numP2Fd>
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 1c             	sub    $0x1c,%esp
  8002c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8002cb:	e8 08 0d 00 00       	call   800fd8 <_Z12sys_getenvidv>
  8002d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d5:	6b c0 78             	imul   $0x78,%eax,%eax
  8002d8:	05 00 00 00 ef       	add    $0xef000000,%eax
  8002dd:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	85 ff                	test   %edi,%edi
  8002e4:	7e 07                	jle    8002ed <libmain+0x31>
		binaryname = argv[0];
  8002e6:	8b 06                	mov    (%esi),%eax
  8002e8:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8002ed:	b8 c5 4c 80 00       	mov    $0x804cc5,%eax
  8002f2:	3d c5 4c 80 00       	cmp    $0x804cc5,%eax
  8002f7:	76 0f                	jbe    800308 <libmain+0x4c>
  8002f9:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  8002fb:	83 eb 04             	sub    $0x4,%ebx
  8002fe:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800300:	81 fb c5 4c 80 00    	cmp    $0x804cc5,%ebx
  800306:	77 f3                	ja     8002fb <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800308:	89 74 24 04          	mov    %esi,0x4(%esp)
  80030c:	89 3c 24             	mov    %edi,(%esp)
  80030f:	e8 20 fd ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800314:	e8 0b 00 00 00       	call   800324 <_Z4exitv>
}
  800319:	83 c4 1c             	add    $0x1c,%esp
  80031c:	5b                   	pop    %ebx
  80031d:	5e                   	pop    %esi
  80031e:	5f                   	pop    %edi
  80031f:	5d                   	pop    %ebp
  800320:	c3                   	ret    
  800321:	00 00                	add    %al,(%eax)
	...

00800324 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80032a:	e8 0f 14 00 00       	call   80173e <_Z9close_allv>
	sys_env_destroy(0);
  80032f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800336:	e8 40 0c 00 00       	call   800f7b <_Z15sys_env_destroyi>
}
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    
  80033d:	00 00                	add    %al,(%eax)
	...

00800340 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800348:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80034b:	a1 04 60 80 00       	mov    0x806004,%eax
  800350:	85 c0                	test   %eax,%eax
  800352:	74 10                	je     800364 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800354:	89 44 24 04          	mov    %eax,0x4(%esp)
  800358:	c7 04 24 9e 41 80 00 	movl   $0x80419e,(%esp)
  80035f:	e8 fa 00 00 00       	call   80045e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800364:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  80036a:	e8 69 0c 00 00       	call   800fd8 <_Z12sys_getenvidv>
  80036f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800372:	89 54 24 10          	mov    %edx,0x10(%esp)
  800376:	8b 55 08             	mov    0x8(%ebp),%edx
  800379:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80037d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800381:	89 44 24 04          	mov    %eax,0x4(%esp)
  800385:	c7 04 24 a4 41 80 00 	movl   $0x8041a4,(%esp)
  80038c:	e8 cd 00 00 00       	call   80045e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800391:	89 74 24 04          	mov    %esi,0x4(%esp)
  800395:	8b 45 10             	mov    0x10(%ebp),%eax
  800398:	89 04 24             	mov    %eax,(%esp)
  80039b:	e8 5d 00 00 00       	call   8003fd <_Z8vcprintfPKcPc>
	cprintf("\n");
  8003a0:	c7 04 24 86 41 80 00 	movl   $0x804186,(%esp)
  8003a7:	e8 b2 00 00 00       	call   80045e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ac:	cc                   	int3   
  8003ad:	eb fd                	jmp    8003ac <_Z6_panicPKciS0_z+0x6c>
	...

008003b0 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 18             	sub    $0x18,%esp
  8003b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8003bf:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8003c1:	8b 03                	mov    (%ebx),%eax
  8003c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8003ca:	83 c0 01             	add    $0x1,%eax
  8003cd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d4:	75 19                	jne    8003ef <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8003d6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003dd:	00 
  8003de:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	e8 2b 0b 00 00       	call   800f14 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8003e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003ef:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8003f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8003f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8003f9:	89 ec                	mov    %ebp,%esp
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    

008003fd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800406:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040d:	00 00 00 
	b.cnt = 0;
  800410:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800417:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80041a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	89 44 24 08          	mov    %eax,0x8(%esp)
  800428:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800432:	c7 04 24 b0 03 80 00 	movl   $0x8003b0,(%esp)
  800439:	e8 a9 01 00 00       	call   8005e7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80043e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800444:	89 44 24 04          	mov    %eax,0x4(%esp)
  800448:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	e8 be 0a 00 00       	call   800f14 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800456:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800464:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	e8 87 ff ff ff       	call   8003fd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800476:	c9                   	leave  
  800477:	c3                   	ret    
	...

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
  8004ef:	e8 bc 39 00 00       	call   803eb0 <__udivdi3>
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
  80054a:	e8 71 3a 00 00       	call   803fc0 <__umoddi3>
  80054f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800553:	0f be 80 c7 41 80 00 	movsbl 0x8041c7(%eax),%eax
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
  800694:	ff 24 85 60 43 80 00 	jmp    *0x804360(,%eax,4)
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
  80074d:	8b 14 85 c0 44 80 00 	mov    0x8044c0(,%eax,4),%edx
  800754:	85 d2                	test   %edx,%edx
  800756:	0f 85 35 02 00 00    	jne    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80075c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800760:	c7 44 24 08 df 41 80 	movl   $0x8041df,0x8(%esp)
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
  800792:	ba d8 41 80 00       	mov    $0x8041d8,%edx
  800797:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80079a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80079e:	7e 72                	jle    800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8007a0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8007a4:	74 6c                	je     800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007aa:	89 1c 24             	mov    %ebx,(%esp)
  8007ad:	e8 89 03 00 00       	call   800b3b <_Z7strnlenPKcj>
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
  800995:	c7 44 24 08 6e 45 80 	movl   $0x80456e,0x8(%esp)
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

00800a40 <_Z8readlinePKc>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	83 ec 1c             	sub    $0x1c,%esp
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	74 10                	je     800a60 <_Z8readlinePKc+0x20>
		cprintf("%s", prompt);
  800a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a54:	c7 04 24 6e 45 80 00 	movl   $0x80456e,(%esp)
  800a5b:	e8 fe f9 ff ff       	call   80045e <_Z7cprintfPKcz>

	i = 0;
	echoing = iscons(0) > 0;
  800a60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a67:	e8 c6 f7 ff ff       	call   800232 <_Z6isconsi>
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	0f 9f c0             	setg   %al
  800a71:	0f b6 c0             	movzbl %al,%eax
  800a74:	89 c7                	mov    %eax,%edi
	int i, c, echoing;

	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
  800a76:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0) > 0;
	while (1) {
		c = getchar();
  800a7b:	e8 7c f7 ff ff       	call   8001fc <_Z7getcharv>
  800a80:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a82:	85 c0                	test   %eax,%eax
  800a84:	79 17                	jns    800a9d <_Z8readlinePKc+0x5d>
			cprintf("read error: %e\n", c);
  800a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8a:	c7 04 24 14 45 80 00 	movl   $0x804514,(%esp)
  800a91:	e8 c8 f9 ff ff       	call   80045e <_Z7cprintfPKcz>
			return NULL;
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	eb 70                	jmp    800b0d <_Z8readlinePKc+0xcd>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a9d:	83 f8 08             	cmp    $0x8,%eax
  800aa0:	74 05                	je     800aa7 <_Z8readlinePKc+0x67>
  800aa2:	83 f8 7f             	cmp    $0x7f,%eax
  800aa5:	75 1c                	jne    800ac3 <_Z8readlinePKc+0x83>
  800aa7:	85 f6                	test   %esi,%esi
  800aa9:	7e 18                	jle    800ac3 <_Z8readlinePKc+0x83>
			if (echoing)
  800aab:	85 ff                	test   %edi,%edi
  800aad:	8d 76 00             	lea    0x0(%esi),%esi
  800ab0:	74 0c                	je     800abe <_Z8readlinePKc+0x7e>
				cputchar('\b');
  800ab2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800ab9:	e8 1d f7 ff ff       	call   8001db <_Z8cputchari>
			i--;
  800abe:	83 ee 01             	sub    $0x1,%esi
  800ac1:	eb b8                	jmp    800a7b <_Z8readlinePKc+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac3:	83 fb 1f             	cmp    $0x1f,%ebx
  800ac6:	7e 1f                	jle    800ae7 <_Z8readlinePKc+0xa7>
  800ac8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800ace:	7f 17                	jg     800ae7 <_Z8readlinePKc+0xa7>
			if (echoing)
  800ad0:	85 ff                	test   %edi,%edi
  800ad2:	74 08                	je     800adc <_Z8readlinePKc+0x9c>
				cputchar(c);
  800ad4:	89 1c 24             	mov    %ebx,(%esp)
  800ad7:	e8 ff f6 ff ff       	call   8001db <_Z8cputchari>
			buf[i++] = c;
  800adc:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  800ae2:	83 c6 01             	add    $0x1,%esi
  800ae5:	eb 94                	jmp    800a7b <_Z8readlinePKc+0x3b>
		} else if (c == '\n' || c == '\r') {
  800ae7:	83 fb 0a             	cmp    $0xa,%ebx
  800aea:	74 05                	je     800af1 <_Z8readlinePKc+0xb1>
  800aec:	83 fb 0d             	cmp    $0xd,%ebx
  800aef:	75 8a                	jne    800a7b <_Z8readlinePKc+0x3b>
			if (echoing)
  800af1:	85 ff                	test   %edi,%edi
  800af3:	74 0c                	je     800b01 <_Z8readlinePKc+0xc1>
				cputchar('\n');
  800af5:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800afc:	e8 da f6 ff ff       	call   8001db <_Z8cputchari>
			buf[i] = 0;
  800b01:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  800b08:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  800b0d:	83 c4 1c             	add    $0x1c,%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    
	...

00800b20 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b26:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b2e:	74 09                	je     800b39 <_Z6strlenPKc+0x19>
		n++;
  800b30:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b37:	75 f7                	jne    800b30 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	39 c2                	cmp    %eax,%edx
  800b4b:	74 0b                	je     800b58 <_Z7strnlenPKcj+0x1d>
  800b4d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b51:	74 05                	je     800b58 <_Z7strnlenPKcj+0x1d>
		n++;
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	eb f1                	jmp    800b49 <_Z7strnlenPKcj+0xe>
	return n;
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	53                   	push   %ebx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800b64:	ba 00 00 00 00       	mov    $0x0,%edx
  800b69:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b6d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b70:	83 c2 01             	add    $0x1,%edx
  800b73:	84 c9                	test   %cl,%cl
  800b75:	75 f2                	jne    800b69 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800b77:	5b                   	pop    %ebx
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b85:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b88:	85 f6                	test   %esi,%esi
  800b8a:	74 18                	je     800ba4 <_Z7strncpyPcPKcj+0x2a>
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b91:	0f b6 1a             	movzbl (%edx),%ebx
  800b94:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b97:	80 3a 01             	cmpb   $0x1,(%edx)
  800b9a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b9d:	83 c1 01             	add    $0x1,%ecx
  800ba0:	39 ce                	cmp    %ecx,%esi
  800ba2:	77 ed                	ja     800b91 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 75 08             	mov    0x8(%ebp),%esi
  800bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800bb6:	89 f0                	mov    %esi,%eax
  800bb8:	85 d2                	test   %edx,%edx
  800bba:	74 17                	je     800bd3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800bbc:	83 ea 01             	sub    $0x1,%edx
  800bbf:	74 18                	je     800bd9 <_Z7strlcpyPcPKcj+0x31>
  800bc1:	80 39 00             	cmpb   $0x0,(%ecx)
  800bc4:	74 17                	je     800bdd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800bc6:	0f b6 19             	movzbl (%ecx),%ebx
  800bc9:	88 18                	mov    %bl,(%eax)
  800bcb:	83 c0 01             	add    $0x1,%eax
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	eb e9                	jmp    800bbc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800bd3:	29 f0                	sub    %esi,%eax
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	eb 02                	jmp    800bdf <_Z7strlcpyPcPKcj+0x37>
  800bdd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800bdf:	c6 02 00             	movb   $0x0,(%edx)
  800be2:	eb ef                	jmp    800bd3 <_Z7strlcpyPcPKcj+0x2b>

00800be4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bed:	0f b6 01             	movzbl (%ecx),%eax
  800bf0:	84 c0                	test   %al,%al
  800bf2:	74 0c                	je     800c00 <_Z6strcmpPKcS0_+0x1c>
  800bf4:	3a 02                	cmp    (%edx),%al
  800bf6:	75 08                	jne    800c00 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	83 c2 01             	add    $0x1,%edx
  800bfe:	eb ed                	jmp    800bed <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800c00:	0f b6 c0             	movzbl %al,%eax
  800c03:	0f b6 12             	movzbl (%edx),%edx
  800c06:	29 d0                	sub    %edx,%eax
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c14:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c17:	85 d2                	test   %edx,%edx
  800c19:	74 16                	je     800c31 <_Z7strncmpPKcS0_j+0x27>
  800c1b:	0f b6 01             	movzbl (%ecx),%eax
  800c1e:	84 c0                	test   %al,%al
  800c20:	74 17                	je     800c39 <_Z7strncmpPKcS0_j+0x2f>
  800c22:	3a 03                	cmp    (%ebx),%al
  800c24:	75 13                	jne    800c39 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800c26:	83 ea 01             	sub    $0x1,%edx
  800c29:	83 c1 01             	add    $0x1,%ecx
  800c2c:	83 c3 01             	add    $0x1,%ebx
  800c2f:	eb e6                	jmp    800c17 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800c36:	5b                   	pop    %ebx
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800c39:	0f b6 01             	movzbl (%ecx),%eax
  800c3c:	0f b6 13             	movzbl (%ebx),%edx
  800c3f:	29 d0                	sub    %edx,%eax
  800c41:	eb f3                	jmp    800c36 <_Z7strncmpPKcS0_j+0x2c>

00800c43 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4d:	0f b6 10             	movzbl (%eax),%edx
  800c50:	84 d2                	test   %dl,%dl
  800c52:	74 1f                	je     800c73 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800c54:	38 ca                	cmp    %cl,%dl
  800c56:	75 0a                	jne    800c62 <_Z6strchrPKcc+0x1f>
  800c58:	eb 1e                	jmp    800c78 <_Z6strchrPKcc+0x35>
  800c5a:	38 ca                	cmp    %cl,%dl
  800c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c60:	74 16                	je     800c78 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c62:	83 c0 01             	add    $0x1,%eax
  800c65:	0f b6 10             	movzbl (%eax),%edx
  800c68:	84 d2                	test   %dl,%dl
  800c6a:	75 ee                	jne    800c5a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	eb 05                	jmp    800c78 <_Z6strchrPKcc+0x35>
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c84:	0f b6 10             	movzbl (%eax),%edx
  800c87:	84 d2                	test   %dl,%dl
  800c89:	74 14                	je     800c9f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800c8b:	38 ca                	cmp    %cl,%dl
  800c8d:	75 06                	jne    800c95 <_Z7strfindPKcc+0x1b>
  800c8f:	eb 0e                	jmp    800c9f <_Z7strfindPKcc+0x25>
  800c91:	38 ca                	cmp    %cl,%dl
  800c93:	74 0a                	je     800c9f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c95:	83 c0 01             	add    $0x1,%eax
  800c98:	0f b6 10             	movzbl (%eax),%edx
  800c9b:	84 d2                	test   %dl,%dl
  800c9d:	75 f2                	jne    800c91 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 0c             	sub    $0xc,%esp
  800ca7:	89 1c 24             	mov    %ebx,(%esp)
  800caa:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800cbb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cc1:	75 25                	jne    800ce8 <memset+0x47>
  800cc3:	f6 c1 03             	test   $0x3,%cl
  800cc6:	75 20                	jne    800ce8 <memset+0x47>
		c &= 0xFF;
  800cc8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ccb:	89 d3                	mov    %edx,%ebx
  800ccd:	c1 e3 08             	shl    $0x8,%ebx
  800cd0:	89 d6                	mov    %edx,%esi
  800cd2:	c1 e6 18             	shl    $0x18,%esi
  800cd5:	89 d0                	mov    %edx,%eax
  800cd7:	c1 e0 10             	shl    $0x10,%eax
  800cda:	09 f0                	or     %esi,%eax
  800cdc:	09 d0                	or     %edx,%eax
  800cde:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800ce0:	c1 e9 02             	shr    $0x2,%ecx
  800ce3:	fc                   	cld    
  800ce4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ce6:	eb 03                	jmp    800ceb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800ce8:	fc                   	cld    
  800ce9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800ceb:	89 f8                	mov    %edi,%eax
  800ced:	8b 1c 24             	mov    (%esp),%ebx
  800cf0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cf4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf8:	89 ec                	mov    %ebp,%esp
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	89 34 24             	mov    %esi,(%esp)
  800d05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800d12:	39 c6                	cmp    %eax,%esi
  800d14:	73 36                	jae    800d4c <memmove+0x50>
  800d16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d19:	39 d0                	cmp    %edx,%eax
  800d1b:	73 2f                	jae    800d4c <memmove+0x50>
		s += n;
		d += n;
  800d1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d20:	f6 c2 03             	test   $0x3,%dl
  800d23:	75 1b                	jne    800d40 <memmove+0x44>
  800d25:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d2b:	75 13                	jne    800d40 <memmove+0x44>
  800d2d:	f6 c1 03             	test   $0x3,%cl
  800d30:	75 0e                	jne    800d40 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d32:	83 ef 04             	sub    $0x4,%edi
  800d35:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d38:	c1 e9 02             	shr    $0x2,%ecx
  800d3b:	fd                   	std    
  800d3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d3e:	eb 09                	jmp    800d49 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d40:	83 ef 01             	sub    $0x1,%edi
  800d43:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d46:	fd                   	std    
  800d47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d49:	fc                   	cld    
  800d4a:	eb 20                	jmp    800d6c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d52:	75 13                	jne    800d67 <memmove+0x6b>
  800d54:	a8 03                	test   $0x3,%al
  800d56:	75 0f                	jne    800d67 <memmove+0x6b>
  800d58:	f6 c1 03             	test   $0x3,%cl
  800d5b:	75 0a                	jne    800d67 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d5d:	c1 e9 02             	shr    $0x2,%ecx
  800d60:	89 c7                	mov    %eax,%edi
  800d62:	fc                   	cld    
  800d63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d65:	eb 05                	jmp    800d6c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800d67:	89 c7                	mov    %eax,%edi
  800d69:	fc                   	cld    
  800d6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800d6c:	8b 34 24             	mov    (%esp),%esi
  800d6f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d73:	89 ec                	mov    %ebp,%esp
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 08             	sub    $0x8,%esp
  800d7d:	89 34 24             	mov    %esi,(%esp)
  800d80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d93:	75 13                	jne    800da8 <memcpy+0x31>
  800d95:	a8 03                	test   $0x3,%al
  800d97:	75 0f                	jne    800da8 <memcpy+0x31>
  800d99:	f6 c1 03             	test   $0x3,%cl
  800d9c:	75 0a                	jne    800da8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d9e:	c1 e9 02             	shr    $0x2,%ecx
  800da1:	89 c7                	mov    %eax,%edi
  800da3:	fc                   	cld    
  800da4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da6:	eb 05                	jmp    800dad <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800da8:	89 c7                	mov    %eax,%edi
  800daa:	fc                   	cld    
  800dab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800dad:	8b 34 24             	mov    (%esp),%esi
  800db0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800db4:	89 ec                	mov    %ebp,%esp
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800dc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dc4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800dc7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800dcc:	85 ff                	test   %edi,%edi
  800dce:	74 38                	je     800e08 <memcmp+0x50>
		if (*s1 != *s2)
  800dd0:	0f b6 03             	movzbl (%ebx),%eax
  800dd3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800dd6:	83 ef 01             	sub    $0x1,%edi
  800dd9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800dde:	38 c8                	cmp    %cl,%al
  800de0:	74 1d                	je     800dff <memcmp+0x47>
  800de2:	eb 11                	jmp    800df5 <memcmp+0x3d>
  800de4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800de9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800dee:	83 c2 01             	add    $0x1,%edx
  800df1:	38 c8                	cmp    %cl,%al
  800df3:	74 0a                	je     800dff <memcmp+0x47>
			return *s1 - *s2;
  800df5:	0f b6 c0             	movzbl %al,%eax
  800df8:	0f b6 c9             	movzbl %cl,%ecx
  800dfb:	29 c8                	sub    %ecx,%eax
  800dfd:	eb 09                	jmp    800e08 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800dff:	39 fa                	cmp    %edi,%edx
  800e01:	75 e1                	jne    800de4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	53                   	push   %ebx
  800e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800e14:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800e16:	89 da                	mov    %ebx,%edx
  800e18:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800e1b:	39 d3                	cmp    %edx,%ebx
  800e1d:	73 15                	jae    800e34 <memfind+0x27>
		if (*s == (unsigned char) c)
  800e1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e23:	38 0b                	cmp    %cl,(%ebx)
  800e25:	75 06                	jne    800e2d <memfind+0x20>
  800e27:	eb 0b                	jmp    800e34 <memfind+0x27>
  800e29:	38 08                	cmp    %cl,(%eax)
  800e2b:	74 07                	je     800e34 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800e2d:	83 c0 01             	add    $0x1,%eax
  800e30:	39 c2                	cmp    %eax,%edx
  800e32:	77 f5                	ja     800e29 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e34:	5b                   	pop    %ebx
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e43:	0f b6 02             	movzbl (%edx),%eax
  800e46:	3c 20                	cmp    $0x20,%al
  800e48:	74 04                	je     800e4e <_Z6strtolPKcPPci+0x17>
  800e4a:	3c 09                	cmp    $0x9,%al
  800e4c:	75 0e                	jne    800e5c <_Z6strtolPKcPPci+0x25>
		s++;
  800e4e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e51:	0f b6 02             	movzbl (%edx),%eax
  800e54:	3c 20                	cmp    $0x20,%al
  800e56:	74 f6                	je     800e4e <_Z6strtolPKcPPci+0x17>
  800e58:	3c 09                	cmp    $0x9,%al
  800e5a:	74 f2                	je     800e4e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e5c:	3c 2b                	cmp    $0x2b,%al
  800e5e:	75 0a                	jne    800e6a <_Z6strtolPKcPPci+0x33>
		s++;
  800e60:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e63:	bf 00 00 00 00       	mov    $0x0,%edi
  800e68:	eb 10                	jmp    800e7a <_Z6strtolPKcPPci+0x43>
  800e6a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e6f:	3c 2d                	cmp    $0x2d,%al
  800e71:	75 07                	jne    800e7a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800e73:	83 c2 01             	add    $0x1,%edx
  800e76:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7a:	85 db                	test   %ebx,%ebx
  800e7c:	0f 94 c0             	sete   %al
  800e7f:	74 05                	je     800e86 <_Z6strtolPKcPPci+0x4f>
  800e81:	83 fb 10             	cmp    $0x10,%ebx
  800e84:	75 15                	jne    800e9b <_Z6strtolPKcPPci+0x64>
  800e86:	80 3a 30             	cmpb   $0x30,(%edx)
  800e89:	75 10                	jne    800e9b <_Z6strtolPKcPPci+0x64>
  800e8b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e8f:	75 0a                	jne    800e9b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800e91:	83 c2 02             	add    $0x2,%edx
  800e94:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e99:	eb 13                	jmp    800eae <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800e9b:	84 c0                	test   %al,%al
  800e9d:	74 0f                	je     800eae <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e9f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ea4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ea7:	75 05                	jne    800eae <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800ea9:	83 c2 01             	add    $0x1,%edx
  800eac:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eb5:	0f b6 0a             	movzbl (%edx),%ecx
  800eb8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ebb:	80 fb 09             	cmp    $0x9,%bl
  800ebe:	77 08                	ja     800ec8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800ec0:	0f be c9             	movsbl %cl,%ecx
  800ec3:	83 e9 30             	sub    $0x30,%ecx
  800ec6:	eb 1e                	jmp    800ee6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ec8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800ecb:	80 fb 19             	cmp    $0x19,%bl
  800ece:	77 08                	ja     800ed8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800ed0:	0f be c9             	movsbl %cl,%ecx
  800ed3:	83 e9 57             	sub    $0x57,%ecx
  800ed6:	eb 0e                	jmp    800ee6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800ed8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800edb:	80 fb 19             	cmp    $0x19,%bl
  800ede:	77 15                	ja     800ef5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800ee0:	0f be c9             	movsbl %cl,%ecx
  800ee3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ee6:	39 f1                	cmp    %esi,%ecx
  800ee8:	7d 0f                	jge    800ef9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800eea:	83 c2 01             	add    $0x1,%edx
  800eed:	0f af c6             	imul   %esi,%eax
  800ef0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800ef3:	eb c0                	jmp    800eb5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800ef5:	89 c1                	mov    %eax,%ecx
  800ef7:	eb 02                	jmp    800efb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ef9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800efb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eff:	74 05                	je     800f06 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800f01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f04:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f06:	89 ca                	mov    %ecx,%edx
  800f08:	f7 da                	neg    %edx
  800f0a:	85 ff                	test   %edi,%edi
  800f0c:	0f 45 c2             	cmovne %edx,%eax
}
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	89 1c 24             	mov    %ebx,(%esp)
  800f1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f21:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	89 c3                	mov    %eax,%ebx
  800f32:	89 c7                	mov    %eax,%edi
  800f34:	89 c6                	mov    %eax,%esi
  800f36:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f38:	8b 1c 24             	mov    (%esp),%ebx
  800f3b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f3f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f43:	89 ec                	mov    %ebp,%esp
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	89 1c 24             	mov    %ebx,(%esp)
  800f50:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f54:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f58:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f62:	89 d1                	mov    %edx,%ecx
  800f64:	89 d3                	mov    %edx,%ebx
  800f66:	89 d7                	mov    %edx,%edi
  800f68:	89 d6                	mov    %edx,%esi
  800f6a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f6c:	8b 1c 24             	mov    (%esp),%ebx
  800f6f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f73:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f77:	89 ec                	mov    %ebp,%esp
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 38             	sub    $0x38,%esp
  800f81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f87:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	89 cb                	mov    %ecx,%ebx
  800f99:	89 cf                	mov    %ecx,%edi
  800f9b:	89 ce                	mov    %ecx,%esi
  800f9d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	7e 28                	jle    800fcb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fae:	00 
  800faf:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  800fb6:	00 
  800fb7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbe:	00 
  800fbf:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  800fc6:	e8 75 f3 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fcb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd4:	89 ec                	mov    %ebp,%esp
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	89 1c 24             	mov    %ebx,(%esp)
  800fe1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fe5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fe9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fee:	b8 02 00 00 00       	mov    $0x2,%eax
  800ff3:	89 d1                	mov    %edx,%ecx
  800ff5:	89 d3                	mov    %edx,%ebx
  800ff7:	89 d7                	mov    %edx,%edi
  800ff9:	89 d6                	mov    %edx,%esi
  800ffb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ffd:	8b 1c 24             	mov    (%esp),%ebx
  801000:	8b 74 24 04          	mov    0x4(%esp),%esi
  801004:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801008:	89 ec                	mov    %ebp,%esp
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	89 1c 24             	mov    %ebx,(%esp)
  801015:	89 74 24 04          	mov    %esi,0x4(%esp)
  801019:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80101d:	ba 00 00 00 00       	mov    $0x0,%edx
  801022:	b8 04 00 00 00       	mov    $0x4,%eax
  801027:	89 d1                	mov    %edx,%ecx
  801029:	89 d3                	mov    %edx,%ebx
  80102b:	89 d7                	mov    %edx,%edi
  80102d:	89 d6                	mov    %edx,%esi
  80102f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801031:	8b 1c 24             	mov    (%esp),%ebx
  801034:	8b 74 24 04          	mov    0x4(%esp),%esi
  801038:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80103c:	89 ec                	mov    %ebp,%esp
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 38             	sub    $0x38,%esp
  801046:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801049:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80104c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80104f:	be 00 00 00 00       	mov    $0x0,%esi
  801054:	b8 08 00 00 00       	mov    $0x8,%eax
  801059:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	89 f7                	mov    %esi,%edi
  801064:	cd 30                	int    $0x30

	if(check && ret > 0)
  801066:	85 c0                	test   %eax,%eax
  801068:	7e 28                	jle    801092 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80106e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801075:	00 
  801076:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  80107d:	00 
  80107e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801085:	00 
  801086:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  80108d:	e8 ae f2 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801092:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801095:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801098:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80109b:	89 ec                	mov    %ebp,%esp
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 38             	sub    $0x38,%esp
  8010a5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ab:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8010b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	7e 28                	jle    8010f0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010cc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  8010db:	00 
  8010dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  8010eb:	e8 50 f2 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f9:	89 ec                	mov    %ebp,%esp
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 38             	sub    $0x38,%esp
  801103:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801106:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801109:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80110c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801111:	b8 0a 00 00 00       	mov    $0xa,%eax
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	89 df                	mov    %ebx,%edi
  80111e:	89 de                	mov    %ebx,%esi
  801120:	cd 30                	int    $0x30

	if(check && ret > 0)
  801122:	85 c0                	test   %eax,%eax
  801124:	7e 28                	jle    80114e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801126:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801131:	00 
  801132:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  801139:	00 
  80113a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801141:	00 
  801142:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  801149:	e8 f2 f1 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801151:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801154:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801157:	89 ec                	mov    %ebp,%esp
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 38             	sub    $0x38,%esp
  801161:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801164:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801167:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80116a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116f:	b8 05 00 00 00       	mov    $0x5,%eax
  801174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
  80117a:	89 df                	mov    %ebx,%edi
  80117c:	89 de                	mov    %ebx,%esi
  80117e:	cd 30                	int    $0x30

	if(check && ret > 0)
  801180:	85 c0                	test   %eax,%eax
  801182:	7e 28                	jle    8011ac <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801184:	89 44 24 10          	mov    %eax,0x10(%esp)
  801188:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80118f:	00 
  801190:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  801197:	00 
  801198:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119f:	00 
  8011a0:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  8011a7:	e8 94 f1 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b5:	89 ec                	mov    %ebp,%esp
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 38             	sub    $0x38,%esp
  8011bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cd:	b8 06 00 00 00       	mov    $0x6,%eax
  8011d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	89 df                	mov    %ebx,%edi
  8011da:	89 de                	mov    %ebx,%esi
  8011dc:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	7e 28                	jle    80120a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011ed:	00 
  8011ee:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  8011f5:	00 
  8011f6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fd:	00 
  8011fe:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  801205:	e8 36 f1 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80120a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80120d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801210:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801213:	89 ec                	mov    %ebp,%esp
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 38             	sub    $0x38,%esp
  80121d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801220:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801223:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	89 df                	mov    %ebx,%edi
  801238:	89 de                	mov    %ebx,%esi
  80123a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80123c:	85 c0                	test   %eax,%eax
  80123e:	7e 28                	jle    801268 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801240:	89 44 24 10          	mov    %eax,0x10(%esp)
  801244:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80124b:	00 
  80124c:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  801253:	00 
  801254:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80125b:	00 
  80125c:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  801263:	e8 d8 f0 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801268:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80126b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80126e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801271:	89 ec                	mov    %ebp,%esp
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 38             	sub    $0x38,%esp
  80127b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80127e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801281:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801284:	bb 00 00 00 00       	mov    $0x0,%ebx
  801289:	b8 0c 00 00 00       	mov    $0xc,%eax
  80128e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801291:	8b 55 08             	mov    0x8(%ebp),%edx
  801294:	89 df                	mov    %ebx,%edi
  801296:	89 de                	mov    %ebx,%esi
  801298:	cd 30                	int    $0x30

	if(check && ret > 0)
  80129a:	85 c0                	test   %eax,%eax
  80129c:	7e 28                	jle    8012c6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8012a9:	00 
  8012aa:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  8012b1:	00 
  8012b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b9:	00 
  8012ba:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  8012c1:	e8 7a f0 ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012cf:	89 ec                	mov    %ebp,%esp
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 0c             	sub    $0xc,%esp
  8012d9:	89 1c 24             	mov    %ebx,(%esp)
  8012dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012e4:	be 00 00 00 00       	mov    $0x0,%esi
  8012e9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012ee:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fa:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012fc:	8b 1c 24             	mov    (%esp),%ebx
  8012ff:	8b 74 24 04          	mov    0x4(%esp),%esi
  801303:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801307:	89 ec                	mov    %ebp,%esp
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 38             	sub    $0x38,%esp
  801311:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801314:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801317:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80131a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80131f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	89 cb                	mov    %ecx,%ebx
  801329:	89 cf                	mov    %ecx,%edi
  80132b:	89 ce                	mov    %ecx,%esi
  80132d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80132f:	85 c0                	test   %eax,%eax
  801331:	7e 28                	jle    80135b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801333:	89 44 24 10          	mov    %eax,0x10(%esp)
  801337:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80133e:	00 
  80133f:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  801346:	00 
  801347:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80134e:	00 
  80134f:	c7 04 24 41 45 80 00 	movl   $0x804541,(%esp)
  801356:	e8 e5 ef ff ff       	call   800340 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80135b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80135e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801361:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801364:	89 ec                	mov    %ebp,%esp
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
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
  801379:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801383:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801386:	8b 55 08             	mov    0x8(%ebp),%edx
  801389:	89 df                	mov    %ebx,%edi
  80138b:	89 de                	mov    %ebx,%esi
  80138d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80138f:	8b 1c 24             	mov    (%esp),%ebx
  801392:	8b 74 24 04          	mov    0x4(%esp),%esi
  801396:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80139a:	89 ec                	mov    %ebp,%esp
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 0c             	sub    $0xc,%esp
  8013a4:	89 1c 24             	mov    %ebx,(%esp)
  8013a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ab:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013af:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b4:	b8 11 00 00 00       	mov    $0x11,%eax
  8013b9:	89 d1                	mov    %edx,%ecx
  8013bb:	89 d3                	mov    %edx,%ebx
  8013bd:	89 d7                	mov    %edx,%edi
  8013bf:	89 d6                	mov    %edx,%esi
  8013c1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013c3:	8b 1c 24             	mov    (%esp),%ebx
  8013c6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013ca:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ce:	89 ec                	mov    %ebp,%esp
  8013d0:	5d                   	pop    %ebp
  8013d1:	c3                   	ret    

008013d2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	89 1c 24             	mov    %ebx,(%esp)
  8013db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013df:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e8:	b8 12 00 00 00       	mov    $0x12,%eax
  8013ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f3:	89 df                	mov    %ebx,%edi
  8013f5:	89 de                	mov    %ebx,%esi
  8013f7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8013f9:	8b 1c 24             	mov    (%esp),%ebx
  8013fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801400:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801404:	89 ec                	mov    %ebp,%esp
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	89 1c 24             	mov    %ebx,(%esp)
  801411:	89 74 24 04          	mov    %esi,0x4(%esp)
  801415:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801419:	b9 00 00 00 00       	mov    $0x0,%ecx
  80141e:	b8 13 00 00 00       	mov    $0x13,%eax
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	89 cb                	mov    %ecx,%ebx
  801428:	89 cf                	mov    %ecx,%edi
  80142a:	89 ce                	mov    %ecx,%esi
  80142c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80142e:	8b 1c 24             	mov    (%esp),%ebx
  801431:	8b 74 24 04          	mov    0x4(%esp),%esi
  801435:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801439:	89 ec                	mov    %ebp,%esp
  80143b:	5d                   	pop    %ebp
  80143c:	c3                   	ret    

0080143d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	89 1c 24             	mov    %ebx,(%esp)
  801446:	89 74 24 04          	mov    %esi,0x4(%esp)
  80144a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80144e:	b8 10 00 00 00       	mov    $0x10,%eax
  801453:	8b 75 18             	mov    0x18(%ebp),%esi
  801456:	8b 7d 14             	mov    0x14(%ebp),%edi
  801459:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80145c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145f:	8b 55 08             	mov    0x8(%ebp),%edx
  801462:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801464:	8b 1c 24             	mov    (%esp),%ebx
  801467:	8b 74 24 04          	mov    0x4(%esp),%esi
  80146b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80146f:	89 ec                	mov    %ebp,%esp
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    
	...

00801480 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801483:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801488:	75 11                	jne    80149b <_ZL8fd_validPK2Fd+0x1b>
  80148a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80148f:	76 0a                	jbe    80149b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801491:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801496:	0f 96 c0             	setbe  %al
  801499:	eb 05                	jmp    8014a0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 14             	sub    $0x14,%esp
  8014a9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8014ab:	e8 d0 ff ff ff       	call   801480 <_ZL8fd_validPK2Fd>
  8014b0:	84 c0                	test   %al,%al
  8014b2:	75 24                	jne    8014d8 <_ZL9fd_isopenPK2Fd+0x36>
  8014b4:	c7 44 24 0c 4f 45 80 	movl   $0x80454f,0xc(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 08 5c 45 80 	movl   $0x80455c,0x8(%esp)
  8014c3:	00 
  8014c4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8014cb:	00 
  8014cc:	c7 04 24 71 45 80 00 	movl   $0x804571,(%esp)
  8014d3:	e8 68 ee ff ff       	call   800340 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8014d8:	89 d8                	mov    %ebx,%eax
  8014da:	c1 e8 16             	shr    $0x16,%eax
  8014dd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	f6 c2 01             	test   $0x1,%dl
  8014ec:	74 0d                	je     8014fb <_ZL9fd_isopenPK2Fd+0x59>
  8014ee:	c1 eb 0c             	shr    $0xc,%ebx
  8014f1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8014f8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8014fb:	83 c4 14             	add    $0x14,%esp
  8014fe:	5b                   	pop    %ebx
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	89 1c 24             	mov    %ebx,(%esp)
  80150a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80150e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801511:	8b 75 0c             	mov    0xc(%ebp),%esi
  801514:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801518:	83 fb 1f             	cmp    $0x1f,%ebx
  80151b:	77 18                	ja     801535 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80151d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801523:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801526:	84 c0                	test   %al,%al
  801528:	74 21                	je     80154b <_Z9fd_lookupiPP2Fdb+0x4a>
  80152a:	89 d8                	mov    %ebx,%eax
  80152c:	e8 71 ff ff ff       	call   8014a2 <_ZL9fd_isopenPK2Fd>
  801531:	84 c0                	test   %al,%al
  801533:	75 16                	jne    80154b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801535:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80153b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801540:	8b 1c 24             	mov    (%esp),%ebx
  801543:	8b 74 24 04          	mov    0x4(%esp),%esi
  801547:	89 ec                	mov    %ebp,%esp
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80154b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb ec                	jmp    801540 <_Z9fd_lookupiPP2Fdb+0x3f>

00801554 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	53                   	push   %ebx
  801558:	83 ec 14             	sub    $0x14,%esp
  80155b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80155e:	89 d8                	mov    %ebx,%eax
  801560:	e8 1b ff ff ff       	call   801480 <_ZL8fd_validPK2Fd>
  801565:	84 c0                	test   %al,%al
  801567:	75 24                	jne    80158d <_Z6fd2numP2Fd+0x39>
  801569:	c7 44 24 0c 4f 45 80 	movl   $0x80454f,0xc(%esp)
  801570:	00 
  801571:	c7 44 24 08 5c 45 80 	movl   $0x80455c,0x8(%esp)
  801578:	00 
  801579:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801580:	00 
  801581:	c7 04 24 71 45 80 00 	movl   $0x804571,(%esp)
  801588:	e8 b3 ed ff ff       	call   800340 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80158d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801593:	c1 e8 0c             	shr    $0xc,%eax
}
  801596:	83 c4 14             	add    $0x14,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 04 24             	mov    %eax,(%esp)
  8015a8:	e8 a7 ff ff ff       	call   801554 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8015ad:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015b2:	c1 e0 0c             	shl    $0xc,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	57                   	push   %edi
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 2c             	sub    $0x2c,%esp
  8015c0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8015c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8015c8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8015cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015d2:	00 
  8015d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d7:	89 1c 24             	mov    %ebx,(%esp)
  8015da:	e8 22 ff ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8015df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e2:	e8 bb fe ff ff       	call   8014a2 <_ZL9fd_isopenPK2Fd>
  8015e7:	84 c0                	test   %al,%al
  8015e9:	75 0c                	jne    8015f7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8015eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ee:	89 07                	mov    %eax,(%edi)
			return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f5:	eb 13                	jmp    80160a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8015f7:	83 c3 01             	add    $0x1,%ebx
  8015fa:	83 fb 20             	cmp    $0x20,%ebx
  8015fd:	75 cc                	jne    8015cb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801605:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80160a:	83 c4 2c             	add    $0x2c,%esp
  80160d:	5b                   	pop    %ebx
  80160e:	5e                   	pop    %esi
  80160f:	5f                   	pop    %edi
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 14             	sub    $0x14,%esp
  801619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801624:	39 0d 20 50 80 00    	cmp    %ecx,0x805020
  80162a:	75 16                	jne    801642 <_Z10dev_lookupiPP3Dev+0x30>
  80162c:	eb 06                	jmp    801634 <_Z10dev_lookupiPP3Dev+0x22>
  80162e:	39 0a                	cmp    %ecx,(%edx)
  801630:	75 10                	jne    801642 <_Z10dev_lookupiPP3Dev+0x30>
  801632:	eb 05                	jmp    801639 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801634:	ba 20 50 80 00       	mov    $0x805020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801639:	89 13                	mov    %edx,(%ebx)
			return 0;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
  801640:	eb 35                	jmp    801677 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801642:	83 c0 01             	add    $0x1,%eax
  801645:	8b 14 85 dc 45 80 00 	mov    0x8045dc(,%eax,4),%edx
  80164c:	85 d2                	test   %edx,%edx
  80164e:	75 de                	jne    80162e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801650:	a1 00 60 80 00       	mov    0x806000,%eax
  801655:	8b 40 04             	mov    0x4(%eax),%eax
  801658:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80165c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801660:	c7 04 24 98 45 80 00 	movl   $0x804598,(%esp)
  801667:	e8 f2 ed ff ff       	call   80045e <_Z7cprintfPKcz>
	*dev = 0;
  80166c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801672:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801677:	83 c4 14             	add    $0x14,%esp
  80167a:	5b                   	pop    %ebx
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    

0080167d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 20             	sub    $0x20,%esp
  801685:	8b 75 08             	mov    0x8(%ebp),%esi
  801688:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80168c:	89 34 24             	mov    %esi,(%esp)
  80168f:	e8 c0 fe ff ff       	call   801554 <_Z6fd2numP2Fd>
  801694:	0f b6 d3             	movzbl %bl,%edx
  801697:	89 54 24 08          	mov    %edx,0x8(%esp)
  80169b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80169e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 57 fe ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 05                	js     8016b3 <_Z8fd_closeP2Fdb+0x36>
  8016ae:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016b1:	74 0c                	je     8016bf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8016b3:	80 fb 01             	cmp    $0x1,%bl
  8016b6:	19 db                	sbb    %ebx,%ebx
  8016b8:	f7 d3                	not    %ebx
  8016ba:	83 e3 fd             	and    $0xfffffffd,%ebx
  8016bd:	eb 3d                	jmp    8016fc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c6:	8b 06                	mov    (%esi),%eax
  8016c8:	89 04 24             	mov    %eax,(%esp)
  8016cb:	e8 42 ff ff ff       	call   801612 <_Z10dev_lookupiPP3Dev>
  8016d0:	89 c3                	mov    %eax,%ebx
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 16                	js     8016ec <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016dc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	74 07                	je     8016ec <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8016e5:	89 34 24             	mov    %esi,(%esp)
  8016e8:	ff d0                	call   *%eax
  8016ea:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f7:	e8 01 fa ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
	return r;
}
  8016fc:	89 d8                	mov    %ebx,%eax
  8016fe:	83 c4 20             	add    $0x20,%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80170b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801712:	00 
  801713:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	89 04 24             	mov    %eax,(%esp)
  801720:	e8 dc fd ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  801725:	85 c0                	test   %eax,%eax
  801727:	78 13                	js     80173c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801729:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801730:	00 
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	89 04 24             	mov    %eax,(%esp)
  801737:	e8 41 ff ff ff       	call   80167d <_Z8fd_closeP2Fdb>
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <_Z9close_allv>:

void
close_all(void)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801745:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80174a:	89 1c 24             	mov    %ebx,(%esp)
  80174d:	e8 b3 ff ff ff       	call   801705 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801752:	83 c3 01             	add    $0x1,%ebx
  801755:	83 fb 20             	cmp    $0x20,%ebx
  801758:	75 f0                	jne    80174a <_Z9close_allv+0xc>
		close(i);
}
  80175a:	83 c4 14             	add    $0x14,%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 48             	sub    $0x48,%esp
  801766:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801769:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80176c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80176f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801772:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801779:	00 
  80177a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 75 fd ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  80178c:	89 c3                	mov    %eax,%ebx
  80178e:	85 c0                	test   %eax,%eax
  801790:	0f 88 ce 00 00 00    	js     801864 <_Z3dupii+0x104>
  801796:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80179d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80179e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017a1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8017a5:	89 34 24             	mov    %esi,(%esp)
  8017a8:	e8 54 fd ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	0f 89 bc 00 00 00    	jns    801873 <_Z3dupii+0x113>
  8017b7:	e9 a8 00 00 00       	jmp    801864 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	c1 e8 0c             	shr    $0xc,%eax
  8017c1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8017c8:	f6 c2 01             	test   $0x1,%dl
  8017cb:	74 32                	je     8017ff <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017cd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8017d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8017d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017e8:	00 
  8017e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f4:	e8 a6 f8 ff ff       	call   80109f <_Z12sys_page_mapiPviS_i>
  8017f9:	89 c3                	mov    %eax,%ebx
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 3e                	js     80183d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801802:	89 c2                	mov    %eax,%edx
  801804:	c1 ea 0c             	shr    $0xc,%edx
  801807:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80180e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801814:	89 54 24 10          	mov    %edx,0x10(%esp)
  801818:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80181b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80181f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801826:	00 
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801832:	e8 68 f8 ff ff       	call   80109f <_Z12sys_page_mapiPviS_i>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	85 c0                	test   %eax,%eax
  80183b:	79 25                	jns    801862 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80183d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801840:	89 44 24 04          	mov    %eax,0x4(%esp)
  801844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184b:	e8 ad f8 ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801854:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185b:	e8 9d f8 ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
	return r;
  801860:	eb 02                	jmp    801864 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801862:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801864:	89 d8                	mov    %ebx,%eax
  801866:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801869:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80186c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80186f:	89 ec                	mov    %ebp,%esp
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801873:	89 34 24             	mov    %esi,(%esp)
  801876:	e8 8a fe ff ff       	call   801705 <_Z5closei>

	ova = fd2data(oldfd);
  80187b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 16 fd ff ff       	call   80159c <_Z7fd2dataP2Fd>
  801886:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188b:	89 04 24             	mov    %eax,(%esp)
  80188e:	e8 09 fd ff ff       	call   80159c <_Z7fd2dataP2Fd>
  801893:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801895:	89 d8                	mov    %ebx,%eax
  801897:	c1 e8 16             	shr    $0x16,%eax
  80189a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8018a1:	a8 01                	test   $0x1,%al
  8018a3:	0f 85 13 ff ff ff    	jne    8017bc <_Z3dupii+0x5c>
  8018a9:	e9 51 ff ff ff       	jmp    8017ff <_Z3dupii+0x9f>

008018ae <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 24             	sub    $0x24,%esp
  8018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018bf:	00 
  8018c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	89 1c 24             	mov    %ebx,(%esp)
  8018ca:	e8 32 fc ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 5f                	js     801932 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018dd:	8b 00                	mov    (%eax),%eax
  8018df:	89 04 24             	mov    %eax,(%esp)
  8018e2:	e8 2b fd ff ff       	call   801612 <_Z10dev_lookupiPP3Dev>
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	79 4d                	jns    801938 <_Z4readiPvj+0x8a>
  8018eb:	eb 45                	jmp    801932 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ed:	a1 00 60 80 00       	mov    0x806000,%eax
  8018f2:	8b 40 04             	mov    0x4(%eax),%eax
  8018f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fd:	c7 04 24 7a 45 80 00 	movl   $0x80457a,(%esp)
  801904:	e8 55 eb ff ff       	call   80045e <_Z7cprintfPKcz>
		return -E_INVAL;
  801909:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190e:	eb 22                	jmp    801932 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801916:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80191b:	85 d2                	test   %edx,%edx
  80191d:	74 13                	je     801932 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	89 44 24 08          	mov    %eax,0x8(%esp)
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192d:	89 0c 24             	mov    %ecx,(%esp)
  801930:	ff d2                	call   *%edx
}
  801932:	83 c4 24             	add    $0x24,%esp
  801935:	5b                   	pop    %ebx
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801938:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80193b:	8b 41 08             	mov    0x8(%ecx),%eax
  80193e:	83 e0 03             	and    $0x3,%eax
  801941:	83 f8 01             	cmp    $0x1,%eax
  801944:	75 ca                	jne    801910 <_Z4readiPvj+0x62>
  801946:	eb a5                	jmp    8018ed <_Z4readiPvj+0x3f>

00801948 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	57                   	push   %edi
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
  80194e:	83 ec 1c             	sub    $0x1c,%esp
  801951:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801954:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801957:	85 f6                	test   %esi,%esi
  801959:	74 2f                	je     80198a <_Z5readniPvj+0x42>
  80195b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801960:	89 f0                	mov    %esi,%eax
  801962:	29 d8                	sub    %ebx,%eax
  801964:	89 44 24 08          	mov    %eax,0x8(%esp)
  801968:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 34 ff ff ff       	call   8018ae <_Z4readiPvj>
		if (m < 0)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 13                	js     801991 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80197e:	85 c0                	test   %eax,%eax
  801980:	74 0d                	je     80198f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801982:	01 c3                	add    %eax,%ebx
  801984:	39 de                	cmp    %ebx,%esi
  801986:	77 d8                	ja     801960 <_Z5readniPvj+0x18>
  801988:	eb 05                	jmp    80198f <_Z5readniPvj+0x47>
  80198a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80198f:	89 d8                	mov    %ebx,%eax
}
  801991:	83 c4 1c             	add    $0x1c,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80199f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8019a6:	00 
  8019a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	89 04 24             	mov    %eax,(%esp)
  8019b4:	e8 48 fb ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	78 3c                	js     8019f9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8019c7:	8b 00                	mov    (%eax),%eax
  8019c9:	89 04 24             	mov    %eax,(%esp)
  8019cc:	e8 41 fc ff ff       	call   801612 <_Z10dev_lookupiPP3Dev>
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	79 26                	jns    8019fb <_Z5writeiPKvj+0x62>
  8019d5:	eb 22                	jmp    8019f9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8019dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8019e2:	85 c9                	test   %ecx,%ecx
  8019e4:	74 13                	je     8019f9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f4:	89 14 24             	mov    %edx,(%esp)
  8019f7:	ff d1                	call   *%ecx
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8019fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  8019fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801a03:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a07:	74 f0                	je     8019f9 <_Z5writeiPKvj+0x60>
  801a09:	eb cc                	jmp    8019d7 <_Z5writeiPKvj+0x3e>

00801a0b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801a11:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a18:	00 
  801a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	89 04 24             	mov    %eax,(%esp)
  801a26:	e8 d6 fa ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 0e                	js     801a3d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a35:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 24             	sub    $0x24,%esp
  801a46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a49:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a50:	00 
  801a51:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a58:	89 1c 24             	mov    %ebx,(%esp)
  801a5b:	e8 a1 fa ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 58                	js     801abc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a6e:	8b 00                	mov    (%eax),%eax
  801a70:	89 04 24             	mov    %eax,(%esp)
  801a73:	e8 9a fb ff ff       	call   801612 <_Z10dev_lookupiPP3Dev>
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	79 46                	jns    801ac2 <_Z9ftruncateii+0x83>
  801a7c:	eb 3e                	jmp    801abc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801a7e:	a1 00 60 80 00       	mov    0x806000,%eax
  801a83:	8b 40 04             	mov    0x4(%eax),%eax
  801a86:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8e:	c7 04 24 b8 45 80 00 	movl   $0x8045b8,(%esp)
  801a95:	e8 c4 e9 ff ff       	call   80045e <_Z7cprintfPKcz>
		return -E_INVAL;
  801a9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a9f:	eb 1b                	jmp    801abc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801aa7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aac:	85 d2                	test   %edx,%edx
  801aae:	74 0c                	je     801abc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab7:	89 0c 24             	mov    %ecx,(%esp)
  801aba:	ff d2                	call   *%edx
}
  801abc:	83 c4 24             	add    $0x24,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ac5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801ac9:	75 d6                	jne    801aa1 <_Z9ftruncateii+0x62>
  801acb:	eb b1                	jmp    801a7e <_Z9ftruncateii+0x3f>

00801acd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	53                   	push   %ebx
  801ad1:	83 ec 24             	sub    $0x24,%esp
  801ad4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ad7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ade:	00 
  801adf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 10 fa ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 3e                	js     801b33 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801aff:	8b 00                	mov    (%eax),%eax
  801b01:	89 04 24             	mov    %eax,(%esp)
  801b04:	e8 09 fb ff ff       	call   801612 <_Z10dev_lookupiPP3Dev>
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	79 2c                	jns    801b39 <_Z5fstatiP4Stat+0x6c>
  801b0d:	eb 24                	jmp    801b33 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b0f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b12:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801b19:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801b20:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	ff 52 14             	call   *0x14(%edx)
}
  801b33:	83 c4 24             	add    $0x24,%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801b3c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801b41:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801b45:	75 c8                	jne    801b0f <_Z5fstatiP4Stat+0x42>
  801b47:	eb ea                	jmp    801b33 <_Z5fstatiP4Stat+0x66>

00801b49 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 18             	sub    $0x18,%esp
  801b4f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b52:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b55:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b5c:	00 
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	89 04 24             	mov    %eax,(%esp)
  801b63:	e8 d6 09 00 00       	call   80253e <_Z4openPKci>
  801b68:	89 c3                	mov    %eax,%ebx
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 1b                	js     801b89 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b75:	89 1c 24             	mov    %ebx,(%esp)
  801b78:	e8 50 ff ff ff       	call   801acd <_Z5fstatiP4Stat>
  801b7d:	89 c6                	mov    %eax,%esi
	close(fd);
  801b7f:	89 1c 24             	mov    %ebx,(%esp)
  801b82:	e8 7e fb ff ff       	call   801705 <_Z5closei>
	return r;
  801b87:	89 f3                	mov    %esi,%ebx
}
  801b89:	89 d8                	mov    %ebx,%eax
  801b8b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b8e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b91:	89 ec                	mov    %ebp,%esp
  801b93:	5d                   	pop    %ebp
  801b94:	c3                   	ret    
	...

00801ba0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801ba3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	78 33                	js     801bdf <_ZL10inode_dataP5Inodei+0x3f>
  801bac:	3b 50 08             	cmp    0x8(%eax),%edx
  801baf:	7d 2e                	jge    801bdf <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801bb1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801bb7:	85 d2                	test   %edx,%edx
  801bb9:	0f 49 ca             	cmovns %edx,%ecx
  801bbc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801bbf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801bc3:	c1 e1 0c             	shl    $0xc,%ecx
  801bc6:	89 d0                	mov    %edx,%eax
  801bc8:	c1 f8 1f             	sar    $0x1f,%eax
  801bcb:	c1 e8 14             	shr    $0x14,%eax
  801bce:	01 c2                	add    %eax,%edx
  801bd0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801bd6:	29 c2                	sub    %eax,%edx
  801bd8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801bdf:	89 c8                	mov    %ecx,%eax
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    

00801be3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801be6:	8b 48 08             	mov    0x8(%eax),%ecx
  801be9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801bf1:	c7 82 80 00 00 00 20 	movl   $0x805020,0x80(%edx)
  801bf8:	50 80 00 
}
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    

00801bfd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801c03:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	74 08                	je     801c15 <_ZL9get_inodei+0x18>
  801c0d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801c13:	7e 20                	jle    801c35 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801c15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c19:	c7 44 24 08 f0 45 80 	movl   $0x8045f0,0x8(%esp)
  801c20:	00 
  801c21:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801c28:	00 
  801c29:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  801c30:	e8 0b e7 ff ff       	call   800340 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801c35:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801c3b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801c41:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801c47:	85 d2                	test   %edx,%edx
  801c49:	0f 48 d1             	cmovs  %ecx,%edx
  801c4c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801c4f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801c56:	c1 e0 0c             	shl    $0xc,%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801c63:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801c69:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801c6c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801c72:	76 20                	jbe    801c94 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801c74:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c78:	c7 44 24 08 2c 46 80 	movl   $0x80462c,0x8(%esp)
  801c7f:	00 
  801c80:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801c87:	00 
  801c88:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  801c8f:	e8 ac e6 ff ff       	call   800340 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801c94:	83 fe 01             	cmp    $0x1,%esi
  801c97:	7e 08                	jle    801ca1 <_ZL10bcache_ipcPvi+0x46>
  801c99:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801c9f:	7d 12                	jge    801cb3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ca1:	89 f3                	mov    %esi,%ebx
  801ca3:	c1 e3 04             	shl    $0x4,%ebx
  801ca6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801ca8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801cae:	c1 e6 0c             	shl    $0xc,%esi
  801cb1:	eb 20                	jmp    801cd3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801cb3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cb7:	c7 44 24 08 5c 46 80 	movl   $0x80465c,0x8(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  801cce:	e8 6d e6 ff ff       	call   800340 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801cd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cda:	00 
  801cdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ce2:	00 
  801ce3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801cee:	e8 4c 21 00 00       	call   803e3f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801cf3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cfa:	00 
  801cfb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d06:	e8 a5 20 00 00       	call   803db0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801d0b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801d0e:	74 c3                	je     801cd3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    

00801d17 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 28             	sub    $0x28,%esp
  801d1d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d20:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d23:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d26:	89 c7                	mov    %eax,%edi
  801d28:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801d2a:	c7 04 24 bd 1f 80 00 	movl   $0x801fbd,(%esp)
  801d31:	e8 85 1f 00 00       	call   803cbb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801d36:	89 f8                	mov    %edi,%eax
  801d38:	e8 c0 fe ff ff       	call   801bfd <_ZL9get_inodei>
  801d3d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801d3f:	ba 02 00 00 00       	mov    $0x2,%edx
  801d44:	e8 12 ff ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	79 08                	jns    801d55 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801d4d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801d53:	eb 2e                	jmp    801d83 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801d55:	85 c0                	test   %eax,%eax
  801d57:	75 1c                	jne    801d75 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801d59:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801d5f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801d66:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801d69:	ba 06 00 00 00       	mov    $0x6,%edx
  801d6e:	89 d8                	mov    %ebx,%eax
  801d70:	e8 e6 fe ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801d75:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801d7c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d86:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d89:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d8c:	89 ec                	mov    %ebp,%esp
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	57                   	push   %edi
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	83 ec 2c             	sub    $0x2c,%esp
  801d99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d9c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801d9f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801da4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801daa:	0f 87 3d 01 00 00    	ja     801eed <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801db0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801db3:	8b 42 08             	mov    0x8(%edx),%eax
  801db6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 49 f0             	cmovns %eax,%esi
  801dc1:	c1 fe 0c             	sar    $0xc,%esi
  801dc4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801dc6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801dc9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801dcf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801dd2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801dd5:	0f 82 a6 00 00 00    	jb     801e81 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801ddb:	39 fe                	cmp    %edi,%esi
  801ddd:	0f 8d f2 00 00 00    	jge    801ed5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801de3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801de7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801dea:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801ded:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801df0:	83 3e 00             	cmpl   $0x0,(%esi)
  801df3:	75 77                	jne    801e6c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801df5:	ba 02 00 00 00       	mov    $0x2,%edx
  801dfa:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801dff:	e8 57 fe ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801e04:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801e0a:	83 f9 02             	cmp    $0x2,%ecx
  801e0d:	7e 43                	jle    801e52 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801e0f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801e14:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801e19:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801e20:	74 29                	je     801e4b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801e22:	e9 ce 00 00 00       	jmp    801ef5 <_ZL14inode_set_sizeP5Inodej+0x165>
  801e27:	89 c7                	mov    %eax,%edi
  801e29:	0f b6 10             	movzbl (%eax),%edx
  801e2c:	83 c0 01             	add    $0x1,%eax
  801e2f:	84 d2                	test   %dl,%dl
  801e31:	74 18                	je     801e4b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801e33:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801e36:	ba 05 00 00 00       	mov    $0x5,%edx
  801e3b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e40:	e8 16 fe ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801e45:	85 db                	test   %ebx,%ebx
  801e47:	79 1e                	jns    801e67 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801e49:	eb 07                	jmp    801e52 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801e4b:	83 c3 01             	add    $0x1,%ebx
  801e4e:	39 d9                	cmp    %ebx,%ecx
  801e50:	7f d5                	jg     801e27 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e55:	8b 50 08             	mov    0x8(%eax),%edx
  801e58:	e8 33 ff ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801e5d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e62:	e9 86 00 00 00       	jmp    801eed <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e6a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801e6c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801e70:	83 c6 04             	add    $0x4,%esi
  801e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e76:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801e79:	0f 8f 6e ff ff ff    	jg     801ded <_ZL14inode_set_sizeP5Inodej+0x5d>
  801e7f:	eb 54                	jmp    801ed5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801e81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e84:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801e89:	83 f8 01             	cmp    $0x1,%eax
  801e8c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801e8f:	ba 02 00 00 00       	mov    $0x2,%edx
  801e94:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e99:	e8 bd fd ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801e9e:	39 f7                	cmp    %esi,%edi
  801ea0:	7d 24                	jge    801ec6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801ea2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ea5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801ea9:	8b 10                	mov    (%eax),%edx
  801eab:	85 d2                	test   %edx,%edx
  801ead:	74 0d                	je     801ebc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801eaf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801ebc:	83 eb 01             	sub    $0x1,%ebx
  801ebf:	83 e8 04             	sub    $0x4,%eax
  801ec2:	39 fb                	cmp    %edi,%ebx
  801ec4:	75 e3                	jne    801ea9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801ec6:	ba 05 00 00 00       	mov    $0x5,%edx
  801ecb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ed0:	e8 86 fd ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801ed5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801edb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801ede:	ba 04 00 00 00       	mov    $0x4,%edx
  801ee3:	e8 73 fd ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eed:	83 c4 2c             	add    $0x2c,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801ef5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801efc:	ba 05 00 00 00       	mov    $0x5,%edx
  801f01:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801f06:	e8 50 fd ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801f0b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801f10:	e9 52 ff ff ff       	jmp    801e67 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801f15 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	53                   	push   %ebx
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801f1e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801f24:	83 e8 01             	sub    $0x1,%eax
  801f27:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801f2d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801f31:	75 40                	jne    801f73 <_ZL11inode_closeP5Inode+0x5e>
  801f33:	85 c0                	test   %eax,%eax
  801f35:	75 3c                	jne    801f73 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801f37:	ba 02 00 00 00       	mov    $0x2,%edx
  801f3c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801f41:	e8 15 fd ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801f4b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801f4f:	85 d2                	test   %edx,%edx
  801f51:	74 07                	je     801f5a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801f53:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801f5a:	83 c0 01             	add    $0x1,%eax
  801f5d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801f62:	75 e7                	jne    801f4b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801f64:	ba 05 00 00 00       	mov    $0x5,%edx
  801f69:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801f6e:	e8 e8 fc ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801f73:	ba 03 00 00 00       	mov    $0x3,%edx
  801f78:	89 d8                	mov    %ebx,%eax
  801f7a:	e8 dc fc ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
}
  801f7f:	83 c4 04             	add    $0x4,%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	53                   	push   %ebx
  801f89:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f92:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f95:	e8 7d fd ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  801f9a:	89 c3                	mov    %eax,%ebx
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 15                	js     801fb5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	e8 e5 fd ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
  801fab:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	e8 60 ff ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
	return r;
}
  801fb5:	89 d8                	mov    %ebx,%eax
  801fb7:	83 c4 14             	add    $0x14,%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    

00801fbd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	53                   	push   %ebx
  801fc1:	83 ec 14             	sub    $0x14,%esp
  801fc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801fc7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801fd1:	78 32                	js     802005 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd8:	e8 7e fc ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	74 1c                	je     801ffd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801fe1:	c7 44 24 08 11 46 80 	movl   $0x804611,0x8(%esp)
  801fe8:	00 
  801fe9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801ff0:	00 
  801ff1:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  801ff8:	e8 43 e3 ff ff       	call   800340 <_Z6_panicPKciS0_z>
    resume(utf);
  801ffd:	89 1c 24             	mov    %ebx,(%esp)
  802000:	e8 8b 1d 00 00       	call   803d90 <resume>
}
  802005:	83 c4 14             	add    $0x14,%esp
  802008:	5b                   	pop    %ebx
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    

0080200b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 28             	sub    $0x28,%esp
  802011:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802014:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80201a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80201d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802020:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802023:	e8 ef fc ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 26                	js     802052 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80202c:	83 c3 10             	add    $0x10,%ebx
  80202f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802033:	89 34 24             	mov    %esi,(%esp)
  802036:	e8 1f eb ff ff       	call   800b5a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80203b:	89 f2                	mov    %esi,%edx
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	e8 9e fb ff ff       	call   801be3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	e8 c8 fe ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
	return 0;
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802052:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802055:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802058:	89 ec                	mov    %ebp,%esp
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	53                   	push   %ebx
  802060:	83 ec 24             	sub    $0x24,%esp
  802063:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802066:	89 1c 24             	mov    %ebx,(%esp)
  802069:	e8 d6 16 00 00       	call   803744 <_Z7pagerefPv>
  80206e:	89 c2                	mov    %eax,%edx
        return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802075:	83 fa 01             	cmp    $0x1,%edx
  802078:	7f 1e                	jg     802098 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80207a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80207d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802080:	e8 92 fc ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802085:	85 c0                	test   %eax,%eax
  802087:	78 0f                	js     802098 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802093:	e8 7d fe ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
}
  802098:	83 c4 24             	add    $0x24,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	57                   	push   %edi
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 3c             	sub    $0x3c,%esp
  8020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8020aa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8020ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8020b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8020b3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020b6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8020b9:	e8 59 fc ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	0f 88 8c 00 00 00    	js     802152 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8020c6:	8b 53 04             	mov    0x4(%ebx),%edx
  8020c9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8020cf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8020d5:	29 d7                	sub    %edx,%edi
  8020d7:	39 f7                	cmp    %esi,%edi
  8020d9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8020dc:	85 ff                	test   %edi,%edi
  8020de:	74 16                	je     8020f6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8020e0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8020e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e6:	3b 50 08             	cmp    0x8(%eax),%edx
  8020e9:	76 6f                	jbe    80215a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8020eb:	e8 a0 fc ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	79 66                	jns    80215a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8020f4:	eb 4e                	jmp    802144 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8020f6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8020fc:	76 24                	jbe    802122 <_ZL13devfile_writeP2FdPKvj+0x84>
  8020fe:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802100:	8b 53 04             	mov    0x4(%ebx),%edx
  802103:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210c:	3b 50 08             	cmp    0x8(%eax),%edx
  80210f:	0f 86 83 00 00 00    	jbe    802198 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802115:	e8 76 fc ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80211a:	85 c0                	test   %eax,%eax
  80211c:	79 7a                	jns    802198 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80211e:	66 90                	xchg   %ax,%ax
  802120:	eb 22                	jmp    802144 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802122:	85 f6                	test   %esi,%esi
  802124:	74 1e                	je     802144 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802126:	89 f2                	mov    %esi,%edx
  802128:	03 53 04             	add    0x4(%ebx),%edx
  80212b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212e:	3b 50 08             	cmp    0x8(%eax),%edx
  802131:	0f 86 b8 00 00 00    	jbe    8021ef <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802137:	e8 54 fc ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 89 ab 00 00 00    	jns    8021ef <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802147:	e8 c9 fd ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80214c:	8b 43 04             	mov    0x4(%ebx),%eax
  80214f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802152:	83 c4 3c             	add    $0x3c,%esp
  802155:	5b                   	pop    %ebx
  802156:	5e                   	pop    %esi
  802157:	5f                   	pop    %edi
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80215a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80215c:	8b 53 04             	mov    0x4(%ebx),%edx
  80215f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802162:	e8 39 fa ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  802167:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80216a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80216e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802178:	89 04 24             	mov    %eax,(%esp)
  80217b:	e8 f7 eb ff ff       	call   800d77 <memcpy>
        fd->fd_offset += n2;
  802180:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802183:	ba 04 00 00 00       	mov    $0x4,%edx
  802188:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80218b:	e8 cb fa ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802190:	01 7d 0c             	add    %edi,0xc(%ebp)
  802193:	e9 5e ff ff ff       	jmp    8020f6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802198:	8b 53 04             	mov    0x4(%ebx),%edx
  80219b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80219e:	e8 fd f9 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  8021a3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8021a5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8021ac:	00 
  8021ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b4:	89 34 24             	mov    %esi,(%esp)
  8021b7:	e8 bb eb ff ff       	call   800d77 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8021bc:	ba 04 00 00 00       	mov    $0x4,%edx
  8021c1:	89 f0                	mov    %esi,%eax
  8021c3:	e8 93 fa ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8021c8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8021ce:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8021d5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8021dc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8021e2:	0f 87 18 ff ff ff    	ja     802100 <_ZL13devfile_writeP2FdPKvj+0x62>
  8021e8:	89 fe                	mov    %edi,%esi
  8021ea:	e9 33 ff ff ff       	jmp    802122 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8021ef:	8b 53 04             	mov    0x4(%ebx),%edx
  8021f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f5:	e8 a6 f9 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  8021fa:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8021fc:	89 74 24 08          	mov    %esi,0x8(%esp)
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	89 44 24 04          	mov    %eax,0x4(%esp)
  802207:	89 3c 24             	mov    %edi,(%esp)
  80220a:	e8 68 eb ff ff       	call   800d77 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80220f:	ba 04 00 00 00       	mov    $0x4,%edx
  802214:	89 f8                	mov    %edi,%eax
  802216:	e8 40 fa ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80221b:	01 73 04             	add    %esi,0x4(%ebx)
  80221e:	e9 21 ff ff ff       	jmp    802144 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802223 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	57                   	push   %edi
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	83 ec 3c             	sub    $0x3c,%esp
  80222c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80222f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802232:	8b 43 04             	mov    0x4(%ebx),%eax
  802235:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802238:	8b 43 0c             	mov    0xc(%ebx),%eax
  80223b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80223e:	e8 d4 fa ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802243:	85 c0                	test   %eax,%eax
  802245:	0f 88 d3 00 00 00    	js     80231e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80224b:	8b 73 04             	mov    0x4(%ebx),%esi
  80224e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802251:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802254:	8b 50 08             	mov    0x8(%eax),%edx
  802257:	29 f2                	sub    %esi,%edx
  802259:	3b 48 08             	cmp    0x8(%eax),%ecx
  80225c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80225f:	89 f2                	mov    %esi,%edx
  802261:	e8 3a f9 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  802266:	85 c0                	test   %eax,%eax
  802268:	0f 84 a2 00 00 00    	je     802310 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80226e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802274:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80227a:	29 f2                	sub    %esi,%edx
  80227c:	39 d7                	cmp    %edx,%edi
  80227e:	0f 46 d7             	cmovbe %edi,%edx
  802281:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802284:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802286:	01 d6                	add    %edx,%esi
  802288:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80228b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80228f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802293:	8b 45 0c             	mov    0xc(%ebp),%eax
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	e8 d9 ea ff ff       	call   800d77 <memcpy>
    buf = (void *)((char *)buf + n2);
  80229e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022a1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8022a4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8022aa:	76 3e                	jbe    8022ea <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8022ac:	8b 53 04             	mov    0x4(%ebx),%edx
  8022af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b2:	e8 e9 f8 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 55                	je     802310 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8022bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8022c2:	00 
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	89 34 24             	mov    %esi,(%esp)
  8022ca:	e8 a8 ea ff ff       	call   800d77 <memcpy>
        n -= PGSIZE;
  8022cf:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8022d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8022db:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8022e2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8022e8:	77 c2                	ja     8022ac <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8022ea:	85 ff                	test   %edi,%edi
  8022ec:	74 22                	je     802310 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8022ee:	8b 53 04             	mov    0x4(%ebx),%edx
  8022f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f4:	e8 a7 f8 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	74 13                	je     802310 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8022fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802301:	89 44 24 04          	mov    %eax,0x4(%esp)
  802305:	89 34 24             	mov    %esi,(%esp)
  802308:	e8 6a ea ff ff       	call   800d77 <memcpy>
        fd->fd_offset += n;
  80230d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802313:	e8 fd fb ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802318:	8b 43 04             	mov    0x4(%ebx),%eax
  80231b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80231e:	83 c4 3c             	add    $0x3c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    

00802326 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	57                   	push   %edi
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	83 ec 4c             	sub    $0x4c,%esp
  80232f:	89 c6                	mov    %eax,%esi
  802331:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802334:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802337:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80233d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802346:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802349:	b8 01 00 00 00       	mov    $0x1,%eax
  80234e:	e8 c4 f9 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802353:	89 c7                	mov    %eax,%edi
  802355:	85 c0                	test   %eax,%eax
  802357:	0f 88 cd 01 00 00    	js     80252a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80235d:	89 f3                	mov    %esi,%ebx
  80235f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802362:	75 08                	jne    80236c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802364:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802367:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80236a:	74 f8                	je     802364 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80236c:	0f b6 03             	movzbl (%ebx),%eax
  80236f:	3c 2f                	cmp    $0x2f,%al
  802371:	74 16                	je     802389 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802373:	84 c0                	test   %al,%al
  802375:	74 12                	je     802389 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802377:	89 da                	mov    %ebx,%edx
		++path;
  802379:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80237c:	0f b6 02             	movzbl (%edx),%eax
  80237f:	3c 2f                	cmp    $0x2f,%al
  802381:	74 08                	je     80238b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802383:	84 c0                	test   %al,%al
  802385:	75 f2                	jne    802379 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802387:	eb 02                	jmp    80238b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802389:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	29 d8                	sub    %ebx,%eax
  80238f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802392:	0f b6 02             	movzbl (%edx),%eax
  802395:	89 d6                	mov    %edx,%esi
  802397:	3c 2f                	cmp    $0x2f,%al
  802399:	75 0a                	jne    8023a5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80239b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80239e:	0f b6 06             	movzbl (%esi),%eax
  8023a1:	3c 2f                	cmp    $0x2f,%al
  8023a3:	74 f6                	je     80239b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8023a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8023a9:	75 1b                	jne    8023c6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8023ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8023b1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8023b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023b6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8023bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c1:	e9 64 01 00 00       	jmp    80252a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8023c6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8023ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ce:	74 06                	je     8023d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8023d0:	84 c0                	test   %al,%al
  8023d2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8023d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023d9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8023dc:	83 3a 02             	cmpl   $0x2,(%edx)
  8023df:	0f 85 f4 00 00 00    	jne    8024d9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	8b 52 08             	mov    0x8(%edx),%edx
  8023ea:	85 d2                	test   %edx,%edx
  8023ec:	7e 78                	jle    802466 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8023ee:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8023f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fa:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8023fd:	89 fb                	mov    %edi,%ebx
  8023ff:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802402:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802404:	89 da                	mov    %ebx,%edx
  802406:	89 f0                	mov    %esi,%eax
  802408:	e8 93 f7 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  80240d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80240f:	83 38 00             	cmpl   $0x0,(%eax)
  802412:	74 26                	je     80243a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802414:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802417:	3b 50 04             	cmp    0x4(%eax),%edx
  80241a:	75 33                	jne    80244f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80241c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802420:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802423:	89 44 24 04          	mov    %eax,0x4(%esp)
  802427:	8d 47 08             	lea    0x8(%edi),%eax
  80242a:	89 04 24             	mov    %eax,(%esp)
  80242d:	e8 86 e9 ff ff       	call   800db8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 84 fa 00 00 00    	je     802534 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80243a:	83 3f 00             	cmpl   $0x0,(%edi)
  80243d:	75 10                	jne    80244f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80243f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802443:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802446:	84 c0                	test   %al,%al
  802448:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80244c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80244f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802455:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802457:	8b 56 08             	mov    0x8(%esi),%edx
  80245a:	39 d0                	cmp    %edx,%eax
  80245c:	7c a6                	jl     802404 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80245e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802461:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802464:	eb 07                	jmp    80246d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802466:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80246d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802471:	74 6d                	je     8024e0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802473:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802477:	75 24                	jne    80249d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802479:	83 ea 80             	sub    $0xffffff80,%edx
  80247c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80247f:	e8 0c f9 ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802484:	85 c0                	test   %eax,%eax
  802486:	0f 88 90 00 00 00    	js     80251c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80248c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80248f:	8b 50 08             	mov    0x8(%eax),%edx
  802492:	83 c2 80             	add    $0xffffff80,%edx
  802495:	e8 06 f7 ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  80249a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80249d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8024a4:	00 
  8024a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024ac:	00 
  8024ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8024b0:	89 14 24             	mov    %edx,(%esp)
  8024b3:	e8 e9 e7 ff ff       	call   800ca1 <memset>
	empty->de_namelen = namelen;
  8024b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024be:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8024c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024c9:	83 c0 08             	add    $0x8,%eax
  8024cc:	89 04 24             	mov    %eax,(%esp)
  8024cf:	e8 a3 e8 ff ff       	call   800d77 <memcpy>
	*de_store = empty;
  8024d4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8024d7:	eb 5e                	jmp    802537 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8024d9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8024de:	eb 42                	jmp    802522 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8024e0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8024e5:	eb 3b                	jmp    802522 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8024e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ea:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8024ed:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8024ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024f2:	89 38                	mov    %edi,(%eax)
			return 0;
  8024f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f9:	eb 2f                	jmp    80252a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8024fb:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8024fe:	8b 07                	mov    (%edi),%eax
  802500:	e8 12 f8 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802505:	85 c0                	test   %eax,%eax
  802507:	78 17                	js     802520 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250c:	e8 04 fa ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802517:	e9 41 fe ff ff       	jmp    80235d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	eb 02                	jmp    802522 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802520:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	e8 eb f9 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
	return r;
}
  80252a:	89 f8                	mov    %edi,%eax
  80252c:	83 c4 4c             	add    $0x4c,%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
  802534:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802537:	80 3e 00             	cmpb   $0x0,(%esi)
  80253a:	75 bf                	jne    8024fb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80253c:	eb a9                	jmp    8024e7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080253e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 3c             	sub    $0x3c,%esp
  802547:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80254a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80254d:	89 04 24             	mov    %eax,(%esp)
  802550:	e8 62 f0 ff ff       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 88 16 02 00 00    	js     802775 <_Z4openPKci+0x237>
  80255f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802566:	00 
  802567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802575:	e8 c6 ea ff ff       	call   801040 <_Z14sys_page_allociPvi>
  80257a:	89 c3                	mov    %eax,%ebx
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	85 db                	test   %ebx,%ebx
  802583:	0f 88 ec 01 00 00    	js     802775 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802589:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80258d:	0f 84 ec 01 00 00    	je     80277f <_Z4openPKci+0x241>
  802593:	83 c0 01             	add    $0x1,%eax
  802596:	83 f8 78             	cmp    $0x78,%eax
  802599:	75 ee                	jne    802589 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80259b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8025a0:	e9 b9 01 00 00       	jmp    80275e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8025a5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025a8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8025ae:	89 3c 24             	mov    %edi,(%esp)
  8025b1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8025b4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8025b7:	89 f0                	mov    %esi,%eax
  8025b9:	e8 68 fd ff ff       	call   802326 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8025be:	89 c3                	mov    %eax,%ebx
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	0f 85 96 01 00 00    	jne    80275e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8025c8:	85 ff                	test   %edi,%edi
  8025ca:	75 41                	jne    80260d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8025cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025cf:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8025d4:	75 08                	jne    8025de <_Z4openPKci+0xa0>
            fileino = dirino;
  8025d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8025dc:	eb 14                	jmp    8025f2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8025de:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	e8 2f f7 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  8025e8:	89 c3                	mov    %eax,%ebx
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	0f 88 5d 01 00 00    	js     80274f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8025f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025f5:	83 38 02             	cmpl   $0x2,(%eax)
  8025f8:	0f 85 d2 00 00 00    	jne    8026d0 <_Z4openPKci+0x192>
  8025fe:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802602:	0f 84 c8 00 00 00    	je     8026d0 <_Z4openPKci+0x192>
  802608:	e9 38 01 00 00       	jmp    802745 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80260d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802614:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80261b:	0f 8e a8 00 00 00    	jle    8026c9 <_Z4openPKci+0x18b>
  802621:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802626:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802629:	89 f8                	mov    %edi,%eax
  80262b:	e8 e7 f6 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  802630:	89 c3                	mov    %eax,%ebx
  802632:	85 c0                	test   %eax,%eax
  802634:	0f 88 15 01 00 00    	js     80274f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80263a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802641:	75 68                	jne    8026ab <_Z4openPKci+0x16d>
  802643:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80264a:	75 5f                	jne    8026ab <_Z4openPKci+0x16d>
			*ino_store = ino;
  80264c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80264f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802655:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802658:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80265f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802666:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80266d:	00 
  80266e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802675:	00 
  802676:	83 c0 0c             	add    $0xc,%eax
  802679:	89 04 24             	mov    %eax,(%esp)
  80267c:	e8 20 e6 ff ff       	call   800ca1 <memset>
        de->de_inum = fileino->i_inum;
  802681:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802684:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80268a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80268d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80268f:	ba 04 00 00 00       	mov    $0x4,%edx
  802694:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802697:	e8 bf f5 ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80269c:	ba 04 00 00 00       	mov    $0x4,%edx
  8026a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a4:	e8 b2 f5 ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
  8026a9:	eb 25                	jmp    8026d0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8026ab:	e8 65 f8 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8026b0:	83 c7 01             	add    $0x1,%edi
  8026b3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8026b9:	0f 8c 67 ff ff ff    	jl     802626 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8026bf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8026c4:	e9 86 00 00 00       	jmp    80274f <_Z4openPKci+0x211>
  8026c9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8026ce:	eb 7f                	jmp    80274f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8026d0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8026d7:	74 0d                	je     8026e6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8026d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e1:	e8 aa f6 ff ff       	call   801d90 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8026e6:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8026ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ef:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8026fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026fe:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802701:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802704:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80270a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80270d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802711:	83 c0 10             	add    $0x10,%eax
  802714:	89 04 24             	mov    %eax,(%esp)
  802717:	e8 3e e4 ff ff       	call   800b5a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80271c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80271f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802726:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802729:	e8 e7 f7 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80272e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802731:	e8 df f7 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802739:	89 04 24             	mov    %eax,(%esp)
  80273c:	e8 13 ee ff ff       	call   801554 <_Z6fd2numP2Fd>
  802741:	89 c3                	mov    %eax,%ebx
  802743:	eb 30                	jmp    802775 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802745:	e8 cb f7 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80274a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	e8 be f7 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
  802757:	eb 05                	jmp    80275e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802759:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80275e:	a1 00 60 80 00       	mov    0x806000,%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802769:	89 54 24 04          	mov    %edx,0x4(%esp)
  80276d:	89 04 24             	mov    %eax,(%esp)
  802770:	e8 88 e9 ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802775:	89 d8                	mov    %ebx,%eax
  802777:	83 c4 3c             	add    $0x3c,%esp
  80277a:	5b                   	pop    %ebx
  80277b:	5e                   	pop    %esi
  80277c:	5f                   	pop    %edi
  80277d:	5d                   	pop    %ebp
  80277e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80277f:	83 f8 78             	cmp    $0x78,%eax
  802782:	0f 85 1d fe ff ff    	jne    8025a5 <_Z4openPKci+0x67>
  802788:	eb cf                	jmp    802759 <_Z4openPKci+0x21b>

0080278a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	53                   	push   %ebx
  80278e:	83 ec 24             	sub    $0x24,%esp
  802791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802794:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	e8 78 f5 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	78 27                	js     8027ca <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8027a3:	c7 44 24 04 24 46 80 	movl   $0x804624,0x4(%esp)
  8027aa:	00 
  8027ab:	89 1c 24             	mov    %ebx,(%esp)
  8027ae:	e8 a7 e3 ff ff       	call   800b5a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8027b3:	89 da                	mov    %ebx,%edx
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	e8 26 f4 ff ff       	call   801be3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	e8 50 f7 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
	return 0;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ca:	83 c4 24             	add    $0x24,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    

008027d0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	53                   	push   %ebx
  8027d4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8027d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027de:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8027e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	e8 3a fb ff ff       	call   802326 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8027ec:	89 c3                	mov    %eax,%ebx
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 5f                	js     802851 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  8027f2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	e8 18 f5 ff ff       	call   801d17 <_ZL10inode_openiPP5Inode>
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	85 c0                	test   %eax,%eax
  802803:	78 44                	js     802849 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802805:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	83 38 02             	cmpl   $0x2,(%eax)
  802810:	74 2f                	je     802841 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802822:	ba 04 00 00 00       	mov    $0x4,%edx
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	e8 2c f4 ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80282f:	ba 04 00 00 00       	mov    $0x4,%edx
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	e8 1f f4 ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
	r = 0;
  80283c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	e8 cc f6 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	e8 c4 f6 ff ff       	call   801f15 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802851:	89 d8                	mov    %ebx,%eax
  802853:	83 c4 24             	add    $0x24,%esp
  802856:	5b                   	pop    %ebx
  802857:	5d                   	pop    %ebp
  802858:	c3                   	ret    

00802859 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
  802861:	5d                   	pop    %ebp
  802862:	c3                   	ret    

00802863 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	57                   	push   %edi
  802867:	56                   	push   %esi
  802868:	53                   	push   %ebx
  802869:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80286f:	c7 04 24 bd 1f 80 00 	movl   $0x801fbd,(%esp)
  802876:	e8 40 14 00 00       	call   803cbb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80287b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802880:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802885:	74 28                	je     8028af <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802887:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80288e:	4a 
  80288f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802893:	c7 44 24 08 8c 46 80 	movl   $0x80468c,0x8(%esp)
  80289a:	00 
  80289b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8028a2:	00 
  8028a3:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  8028aa:	e8 91 da ff ff       	call   800340 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8028af:	a1 04 10 00 50       	mov    0x50001004,%eax
  8028b4:	83 f8 03             	cmp    $0x3,%eax
  8028b7:	7f 1c                	jg     8028d5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8028b9:	c7 44 24 08 c0 46 80 	movl   $0x8046c0,0x8(%esp)
  8028c0:	00 
  8028c1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8028c8:	00 
  8028c9:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  8028d0:	e8 6b da ff ff       	call   800340 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8028d5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8028db:	85 d2                	test   %edx,%edx
  8028dd:	7f 1c                	jg     8028fb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8028df:	c7 44 24 08 f0 46 80 	movl   $0x8046f0,0x8(%esp)
  8028e6:	00 
  8028e7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  8028ee:	00 
  8028ef:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  8028f6:	e8 45 da ff ff       	call   800340 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  8028fb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802901:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802907:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80290d:	85 c9                	test   %ecx,%ecx
  80290f:	0f 48 cb             	cmovs  %ebx,%ecx
  802912:	c1 f9 0c             	sar    $0xc,%ecx
  802915:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802919:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80291f:	39 c8                	cmp    %ecx,%eax
  802921:	7c 13                	jl     802936 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802923:	85 c0                	test   %eax,%eax
  802925:	7f 3d                	jg     802964 <_Z4fsckv+0x101>
  802927:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80292e:	00 00 00 
  802931:	e9 ac 00 00 00       	jmp    8029e2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802936:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80293c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802940:	89 44 24 10          	mov    %eax,0x10(%esp)
  802944:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802948:	c7 44 24 08 20 47 80 	movl   $0x804720,0x8(%esp)
  80294f:	00 
  802950:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802957:	00 
  802958:	c7 04 24 06 46 80 00 	movl   $0x804606,(%esp)
  80295f:	e8 dc d9 ff ff       	call   800340 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802964:	be 00 20 00 50       	mov    $0x50002000,%esi
  802969:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802970:	00 00 00 
  802973:	bb 00 00 00 00       	mov    $0x0,%ebx
  802978:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80297e:	39 df                	cmp    %ebx,%edi
  802980:	7e 27                	jle    8029a9 <_Z4fsckv+0x146>
  802982:	0f b6 06             	movzbl (%esi),%eax
  802985:	84 c0                	test   %al,%al
  802987:	74 4b                	je     8029d4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802989:	0f be c0             	movsbl %al,%eax
  80298c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802994:	c7 04 24 64 47 80 00 	movl   $0x804764,(%esp)
  80299b:	e8 be da ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  8029a0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029a7:	eb 2b                	jmp    8029d4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8029a9:	0f b6 06             	movzbl (%esi),%eax
  8029ac:	3c 01                	cmp    $0x1,%al
  8029ae:	76 24                	jbe    8029d4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8029b0:	0f be c0             	movsbl %al,%eax
  8029b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029bb:	c7 04 24 98 47 80 00 	movl   $0x804798,(%esp)
  8029c2:	e8 97 da ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  8029c7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8029ce:	80 3e 00             	cmpb   $0x0,(%esi)
  8029d1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8029d4:	83 c3 01             	add    $0x1,%ebx
  8029d7:	83 c6 01             	add    $0x1,%esi
  8029da:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8029e0:	7f 9c                	jg     80297e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8029e2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8029e9:	0f 8e e1 02 00 00    	jle    802cd0 <_Z4fsckv+0x46d>
  8029ef:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  8029f6:	00 00 00 
		struct Inode *ino = get_inode(i);
  8029f9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029ff:	e8 f9 f1 ff ff       	call   801bfd <_ZL9get_inodei>
  802a04:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802a0a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802a0e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802a15:	75 22                	jne    802a39 <_Z4fsckv+0x1d6>
  802a17:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802a1e:	0f 84 a9 06 00 00    	je     8030cd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802a24:	ba 00 00 00 00       	mov    $0x0,%edx
  802a29:	e8 2d f2 ff ff       	call   801c5b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 3a                	je     802a6c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802a32:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802a39:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a3f:	8b 02                	mov    (%edx),%eax
  802a41:	83 f8 01             	cmp    $0x1,%eax
  802a44:	74 26                	je     802a6c <_Z4fsckv+0x209>
  802a46:	83 f8 02             	cmp    $0x2,%eax
  802a49:	74 21                	je     802a6c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802a4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a4f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a55:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a59:	c7 04 24 c4 47 80 00 	movl   $0x8047c4,(%esp)
  802a60:	e8 f9 d9 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802a65:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802a6c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802a73:	75 3f                	jne    802ab4 <_Z4fsckv+0x251>
  802a75:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802a7b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802a7f:	75 15                	jne    802a96 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802a81:	c7 04 24 e8 47 80 00 	movl   $0x8047e8,(%esp)
  802a88:	e8 d1 d9 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802a8d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a94:	eb 1e                	jmp    802ab4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802a96:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a9c:	83 3a 02             	cmpl   $0x2,(%edx)
  802a9f:	74 13                	je     802ab4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802aa1:	c7 04 24 1c 48 80 00 	movl   $0x80481c,(%esp)
  802aa8:	e8 b1 d9 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802aad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802ab4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802ab9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ac0:	0f 84 93 00 00 00    	je     802b59 <_Z4fsckv+0x2f6>
  802ac6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802acc:	8b 41 08             	mov    0x8(%ecx),%eax
  802acf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802ad4:	7e 23                	jle    802af9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802ad6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ada:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae4:	c7 04 24 4c 48 80 00 	movl   $0x80484c,(%esp)
  802aeb:	e8 6e d9 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802af0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802af7:	eb 09                	jmp    802b02 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802af9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802b00:	74 4b                	je     802b4d <_Z4fsckv+0x2ea>
  802b02:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b08:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802b0e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802b14:	74 23                	je     802b39 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802b16:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b1a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802b20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b24:	c7 04 24 70 48 80 00 	movl   $0x804870,(%esp)
  802b2b:	e8 2e d9 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802b30:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b37:	eb 09                	jmp    802b42 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802b39:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802b40:	74 12                	je     802b54 <_Z4fsckv+0x2f1>
  802b42:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802b48:	8b 78 08             	mov    0x8(%eax),%edi
  802b4b:	eb 0c                	jmp    802b59 <_Z4fsckv+0x2f6>
  802b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b52:	eb 05                	jmp    802b59 <_Z4fsckv+0x2f6>
  802b54:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802b59:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802b5e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b64:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802b68:	89 d8                	mov    %ebx,%eax
  802b6a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802b6d:	39 c7                	cmp    %eax,%edi
  802b6f:	7e 2b                	jle    802b9c <_Z4fsckv+0x339>
  802b71:	85 f6                	test   %esi,%esi
  802b73:	75 27                	jne    802b9c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b7d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b87:	c7 04 24 94 48 80 00 	movl   $0x804894,(%esp)
  802b8e:	e8 cb d8 ff ff       	call   80045e <_Z7cprintfPKcz>
				++errors;
  802b93:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b9a:	eb 36                	jmp    802bd2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802b9c:	39 f8                	cmp    %edi,%eax
  802b9e:	7c 32                	jl     802bd2 <_Z4fsckv+0x36f>
  802ba0:	85 f6                	test   %esi,%esi
  802ba2:	74 2e                	je     802bd2 <_Z4fsckv+0x36f>
  802ba4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802bab:	74 25                	je     802bd2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bb5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbf:	c7 04 24 d8 48 80 00 	movl   $0x8048d8,(%esp)
  802bc6:	e8 93 d8 ff ff       	call   80045e <_Z7cprintfPKcz>
				++errors;
  802bcb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802bd2:	85 f6                	test   %esi,%esi
  802bd4:	0f 84 a0 00 00 00    	je     802c7a <_Z4fsckv+0x417>
  802bda:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802be1:	0f 84 93 00 00 00    	je     802c7a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802be7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802bed:	7e 27                	jle    802c16 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802bef:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802bf3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bf7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802bfd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c01:	c7 04 24 1c 49 80 00 	movl   $0x80491c,(%esp)
  802c08:	e8 51 d8 ff ff       	call   80045e <_Z7cprintfPKcz>
					++errors;
  802c0d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c14:	eb 64                	jmp    802c7a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802c16:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802c1d:	3c 01                	cmp    $0x1,%al
  802c1f:	75 27                	jne    802c48 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802c21:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802c25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c29:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802c2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c33:	c7 04 24 60 49 80 00 	movl   $0x804960,(%esp)
  802c3a:	e8 1f d8 ff ff       	call   80045e <_Z7cprintfPKcz>
					++errors;
  802c3f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c46:	eb 32                	jmp    802c7a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802c48:	3c ff                	cmp    $0xff,%al
  802c4a:	75 27                	jne    802c73 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802c4c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802c50:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c54:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c5e:	c7 04 24 9c 49 80 00 	movl   $0x80499c,(%esp)
  802c65:	e8 f4 d7 ff ff       	call   80045e <_Z7cprintfPKcz>
					++errors;
  802c6a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c71:	eb 07                	jmp    802c7a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802c73:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802c7a:	83 c3 01             	add    $0x1,%ebx
  802c7d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802c83:	0f 85 d5 fe ff ff    	jne    802b5e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802c89:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802c90:	0f 94 c0             	sete   %al
  802c93:	0f b6 c0             	movzbl %al,%eax
  802c96:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c9c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802ca2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802ca9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802cb0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802cb7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802cbe:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802cc4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802cca:	0f 8f 29 fd ff ff    	jg     8029f9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802cd0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802cd7:	0f 8e 7f 03 00 00    	jle    80305c <_Z4fsckv+0x7f9>
  802cdd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802ce2:	89 f0                	mov    %esi,%eax
  802ce4:	e8 14 ef ff ff       	call   801bfd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802ce9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802cf0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802cf7:	c1 e2 08             	shl    $0x8,%edx
  802cfa:	09 ca                	or     %ecx,%edx
  802cfc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802d03:	c1 e1 10             	shl    $0x10,%ecx
  802d06:	09 ca                	or     %ecx,%edx
  802d08:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802d0f:	83 e1 7f             	and    $0x7f,%ecx
  802d12:	c1 e1 18             	shl    $0x18,%ecx
  802d15:	09 d1                	or     %edx,%ecx
  802d17:	74 0e                	je     802d27 <_Z4fsckv+0x4c4>
  802d19:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802d20:	78 05                	js     802d27 <_Z4fsckv+0x4c4>
  802d22:	83 38 02             	cmpl   $0x2,(%eax)
  802d25:	74 1f                	je     802d46 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802d27:	83 c6 01             	add    $0x1,%esi
  802d2a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802d2f:	39 f0                	cmp    %esi,%eax
  802d31:	7f af                	jg     802ce2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802d33:	bb 01 00 00 00       	mov    $0x1,%ebx
  802d38:	83 f8 01             	cmp    $0x1,%eax
  802d3b:	0f 8f ad 02 00 00    	jg     802fee <_Z4fsckv+0x78b>
  802d41:	e9 16 03 00 00       	jmp    80305c <_Z4fsckv+0x7f9>
  802d46:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802d48:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802d4f:	8b 40 08             	mov    0x8(%eax),%eax
  802d52:	a8 7f                	test   $0x7f,%al
  802d54:	74 23                	je     802d79 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802d56:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802d5d:	00 
  802d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d62:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d66:	c7 04 24 d8 49 80 00 	movl   $0x8049d8,(%esp)
  802d6d:	e8 ec d6 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  802d72:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802d79:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802d80:	00 00 00 
  802d83:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802d89:	e9 3d 02 00 00       	jmp    802fcb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802d8e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d94:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d9a:	e8 01 ee ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
  802d9f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802da1:	83 38 00             	cmpl   $0x0,(%eax)
  802da4:	0f 84 15 02 00 00    	je     802fbf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	8d 50 ff             	lea    -0x1(%eax),%edx
  802db0:	83 fa 76             	cmp    $0x76,%edx
  802db3:	76 27                	jbe    802ddc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802db5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802db9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dc7:	c7 04 24 0c 4a 80 00 	movl   $0x804a0c,(%esp)
  802dce:	e8 8b d6 ff ff       	call   80045e <_Z7cprintfPKcz>
				++errors;
  802dd3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802dda:	eb 28                	jmp    802e04 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802ddc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802de1:	74 21                	je     802e04 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802de3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802de9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ded:	89 74 24 04          	mov    %esi,0x4(%esp)
  802df1:	c7 04 24 38 4a 80 00 	movl   $0x804a38,(%esp)
  802df8:	e8 61 d6 ff ff       	call   80045e <_Z7cprintfPKcz>
				++errors;
  802dfd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802e04:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802e0b:	00 
  802e0c:	8d 43 08             	lea    0x8(%ebx),%eax
  802e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e13:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802e19:	89 0c 24             	mov    %ecx,(%esp)
  802e1c:	e8 56 df ff ff       	call   800d77 <memcpy>
  802e21:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802e25:	bf 77 00 00 00       	mov    $0x77,%edi
  802e2a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802e2e:	85 ff                	test   %edi,%edi
  802e30:	b8 00 00 00 00       	mov    $0x0,%eax
  802e35:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802e38:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802e3f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802e40:	8b 03                	mov    (%ebx),%eax
  802e42:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802e48:	7c 3e                	jl     802e88 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802e4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e4e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e58:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e62:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e66:	c7 04 24 6c 4a 80 00 	movl   $0x804a6c,(%esp)
  802e6d:	e8 ec d5 ff ff       	call   80045e <_Z7cprintfPKcz>
				++errors;
  802e72:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802e79:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802e80:	00 00 00 
  802e83:	e9 0b 01 00 00       	jmp    802f93 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802e88:	e8 70 ed ff ff       	call   801bfd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802e8d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e94:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802e9b:	c1 e2 08             	shl    $0x8,%edx
  802e9e:	09 d1                	or     %edx,%ecx
  802ea0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802ea7:	c1 e2 10             	shl    $0x10,%edx
  802eaa:	09 d1                	or     %edx,%ecx
  802eac:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802eb3:	83 e2 7f             	and    $0x7f,%edx
  802eb6:	c1 e2 18             	shl    $0x18,%edx
  802eb9:	09 ca                	or     %ecx,%edx
  802ebb:	83 c2 01             	add    $0x1,%edx
  802ebe:	89 d1                	mov    %edx,%ecx
  802ec0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802ec6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802ecc:	0f b6 d5             	movzbl %ch,%edx
  802ecf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802ed5:	89 ca                	mov    %ecx,%edx
  802ed7:	c1 ea 10             	shr    $0x10,%edx
  802eda:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802ee0:	c1 e9 18             	shr    $0x18,%ecx
  802ee3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802eea:	83 e2 80             	and    $0xffffff80,%edx
  802eed:	09 ca                	or     %ecx,%edx
  802eef:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802ef5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802ef9:	0f 85 7a ff ff ff    	jne    802e79 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802eff:	8b 03                	mov    (%ebx),%eax
  802f01:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f05:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802f0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f0f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802f15:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f19:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f1d:	c7 04 24 9c 4a 80 00 	movl   $0x804a9c,(%esp)
  802f24:	e8 35 d5 ff ff       	call   80045e <_Z7cprintfPKcz>
					++errors;
  802f29:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f30:	e9 44 ff ff ff       	jmp    802e79 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802f35:	3b 78 04             	cmp    0x4(%eax),%edi
  802f38:	75 52                	jne    802f8c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802f3a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802f3e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802f44:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f48:	83 c0 08             	add    $0x8,%eax
  802f4b:	89 04 24             	mov    %eax,(%esp)
  802f4e:	e8 65 de ff ff       	call   800db8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802f53:	85 c0                	test   %eax,%eax
  802f55:	75 35                	jne    802f8c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802f57:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802f5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802f61:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802f67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f6b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f71:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f75:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f79:	c7 04 24 cc 4a 80 00 	movl   $0x804acc,(%esp)
  802f80:	e8 d9 d4 ff ff       	call   80045e <_Z7cprintfPKcz>
					++errors;
  802f85:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802f8c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802f93:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802f99:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802f9f:	7e 1e                	jle    802fbf <_Z4fsckv+0x75c>
  802fa1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802fa5:	7f 18                	jg     802fbf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802fa7:	89 ca                	mov    %ecx,%edx
  802fa9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802faf:	e8 ec eb ff ff       	call   801ba0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802fb4:	83 38 00             	cmpl   $0x0,(%eax)
  802fb7:	0f 85 78 ff ff ff    	jne    802f35 <_Z4fsckv+0x6d2>
  802fbd:	eb cd                	jmp    802f8c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802fbf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802fc5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802fcb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fd1:	83 ea 80             	sub    $0xffffff80,%edx
  802fd4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802fda:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802fe0:	3b 51 08             	cmp    0x8(%ecx),%edx
  802fe3:	0f 8f e7 fc ff ff    	jg     802cd0 <_Z4fsckv+0x46d>
  802fe9:	e9 a0 fd ff ff       	jmp    802d8e <_Z4fsckv+0x52b>
  802fee:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802ff4:	89 d8                	mov    %ebx,%eax
  802ff6:	e8 02 ec ff ff       	call   801bfd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802ffb:	8b 50 04             	mov    0x4(%eax),%edx
  802ffe:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803005:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80300c:	c1 e7 08             	shl    $0x8,%edi
  80300f:	09 f9                	or     %edi,%ecx
  803011:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803018:	c1 e7 10             	shl    $0x10,%edi
  80301b:	09 f9                	or     %edi,%ecx
  80301d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803024:	83 e7 7f             	and    $0x7f,%edi
  803027:	c1 e7 18             	shl    $0x18,%edi
  80302a:	09 f9                	or     %edi,%ecx
  80302c:	39 ca                	cmp    %ecx,%edx
  80302e:	74 1b                	je     80304b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803030:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803034:	89 54 24 08          	mov    %edx,0x8(%esp)
  803038:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80303c:	c7 04 24 fc 4a 80 00 	movl   $0x804afc,(%esp)
  803043:	e8 16 d4 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  803048:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80304b:	83 c3 01             	add    $0x1,%ebx
  80304e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803054:	7f 9e                	jg     802ff4 <_Z4fsckv+0x791>
  803056:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80305c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803063:	7e 4f                	jle    8030b4 <_Z4fsckv+0x851>
  803065:	bb 00 00 00 00       	mov    $0x0,%ebx
  80306a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803070:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803077:	3c ff                	cmp    $0xff,%al
  803079:	75 09                	jne    803084 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80307b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803082:	eb 1f                	jmp    8030a3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803084:	84 c0                	test   %al,%al
  803086:	75 1b                	jne    8030a3 <_Z4fsckv+0x840>
  803088:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80308e:	7c 13                	jl     8030a3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803090:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803094:	c7 04 24 28 4b 80 00 	movl   $0x804b28,(%esp)
  80309b:	e8 be d3 ff ff       	call   80045e <_Z7cprintfPKcz>
			++errors;
  8030a0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8030a3:	83 c3 01             	add    $0x1,%ebx
  8030a6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8030ac:	7f c2                	jg     803070 <_Z4fsckv+0x80d>
  8030ae:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  8030b4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  8030bb:	19 c0                	sbb    %eax,%eax
  8030bd:	f7 d0                	not    %eax
  8030bf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8030c2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8030c8:	5b                   	pop    %ebx
  8030c9:	5e                   	pop    %esi
  8030ca:	5f                   	pop    %edi
  8030cb:	5d                   	pop    %ebp
  8030cc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8030cd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8030d4:	0f 84 92 f9 ff ff    	je     802a6c <_Z4fsckv+0x209>
  8030da:	e9 5a f9 ff ff       	jmp    802a39 <_Z4fsckv+0x1d6>
	...

008030e0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 18             	sub    $0x18,%esp
  8030e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8030e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8030ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	89 04 24             	mov    %eax,(%esp)
  8030f5:	e8 a2 e4 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  8030fa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8030fc:	c7 44 24 04 5b 4b 80 	movl   $0x804b5b,0x4(%esp)
  803103:	00 
  803104:	89 34 24             	mov    %esi,(%esp)
  803107:	e8 4e da ff ff       	call   800b5a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80310c:	8b 43 04             	mov    0x4(%ebx),%eax
  80310f:	2b 03                	sub    (%ebx),%eax
  803111:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803114:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80311b:	c7 86 80 00 00 00 3c 	movl   $0x80503c,0x80(%esi)
  803122:	50 80 00 
	return 0;
}
  803125:	b8 00 00 00 00       	mov    $0x0,%eax
  80312a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80312d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803130:	89 ec                	mov    %ebp,%esp
  803132:	5d                   	pop    %ebp
  803133:	c3                   	ret    

00803134 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
  803137:	53                   	push   %ebx
  803138:	83 ec 14             	sub    $0x14,%esp
  80313b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80313e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803149:	e8 af df ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80314e:	89 1c 24             	mov    %ebx,(%esp)
  803151:	e8 46 e4 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  803156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80315a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803161:	e8 97 df ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
}
  803166:	83 c4 14             	add    $0x14,%esp
  803169:	5b                   	pop    %ebx
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    

0080316c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	57                   	push   %edi
  803170:	56                   	push   %esi
  803171:	53                   	push   %ebx
  803172:	83 ec 2c             	sub    $0x2c,%esp
  803175:	89 c7                	mov    %eax,%edi
  803177:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80317a:	a1 00 60 80 00       	mov    0x806000,%eax
  80317f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803182:	89 3c 24             	mov    %edi,(%esp)
  803185:	e8 ba 05 00 00       	call   803744 <_Z7pagerefPv>
  80318a:	89 c3                	mov    %eax,%ebx
  80318c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318f:	89 04 24             	mov    %eax,(%esp)
  803192:	e8 ad 05 00 00       	call   803744 <_Z7pagerefPv>
  803197:	39 c3                	cmp    %eax,%ebx
  803199:	0f 94 c0             	sete   %al
  80319c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80319f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8031a5:	8b 52 58             	mov    0x58(%edx),%edx
  8031a8:	39 d6                	cmp    %edx,%esi
  8031aa:	75 08                	jne    8031b4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8031ac:	83 c4 2c             	add    $0x2c,%esp
  8031af:	5b                   	pop    %ebx
  8031b0:	5e                   	pop    %esi
  8031b1:	5f                   	pop    %edi
  8031b2:	5d                   	pop    %ebp
  8031b3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 c2                	je     80317a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8031b8:	c7 04 24 62 4b 80 00 	movl   $0x804b62,(%esp)
  8031bf:	e8 9a d2 ff ff       	call   80045e <_Z7cprintfPKcz>
  8031c4:	eb b4                	jmp    80317a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008031c6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
  8031c9:	57                   	push   %edi
  8031ca:	56                   	push   %esi
  8031cb:	53                   	push   %ebx
  8031cc:	83 ec 1c             	sub    $0x1c,%esp
  8031cf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8031d2:	89 34 24             	mov    %esi,(%esp)
  8031d5:	e8 c2 e3 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  8031da:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8031dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8031e5:	75 46                	jne    80322d <_ZL13devpipe_writeP2FdPKvj+0x67>
  8031e7:	eb 52                	jmp    80323b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8031e9:	89 da                	mov    %ebx,%edx
  8031eb:	89 f0                	mov    %esi,%eax
  8031ed:	e8 7a ff ff ff       	call   80316c <_ZL13_pipeisclosedP2FdP4Pipe>
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	75 49                	jne    80323f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8031f6:	e8 11 de ff ff       	call   80100c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8031fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8031fe:	89 c2                	mov    %eax,%edx
  803200:	2b 13                	sub    (%ebx),%edx
  803202:	83 fa 20             	cmp    $0x20,%edx
  803205:	74 e2                	je     8031e9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803207:	89 c2                	mov    %eax,%edx
  803209:	c1 fa 1f             	sar    $0x1f,%edx
  80320c:	c1 ea 1b             	shr    $0x1b,%edx
  80320f:	01 d0                	add    %edx,%eax
  803211:	83 e0 1f             	and    $0x1f,%eax
  803214:	29 d0                	sub    %edx,%eax
  803216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803219:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80321d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803221:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803225:	83 c7 01             	add    $0x1,%edi
  803228:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80322b:	76 0e                	jbe    80323b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80322d:	8b 43 04             	mov    0x4(%ebx),%eax
  803230:	89 c2                	mov    %eax,%edx
  803232:	2b 13                	sub    (%ebx),%edx
  803234:	83 fa 20             	cmp    $0x20,%edx
  803237:	74 b0                	je     8031e9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803239:	eb cc                	jmp    803207 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80323b:	89 f8                	mov    %edi,%eax
  80323d:	eb 05                	jmp    803244 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803244:	83 c4 1c             	add    $0x1c,%esp
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    

0080324c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80324c:	55                   	push   %ebp
  80324d:	89 e5                	mov    %esp,%ebp
  80324f:	83 ec 28             	sub    $0x28,%esp
  803252:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803255:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803258:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80325b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80325e:	89 3c 24             	mov    %edi,(%esp)
  803261:	e8 36 e3 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  803266:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803268:	be 00 00 00 00       	mov    $0x0,%esi
  80326d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803271:	75 47                	jne    8032ba <_ZL12devpipe_readP2FdPvj+0x6e>
  803273:	eb 52                	jmp    8032c7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803275:	89 f0                	mov    %esi,%eax
  803277:	eb 5e                	jmp    8032d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803279:	89 da                	mov    %ebx,%edx
  80327b:	89 f8                	mov    %edi,%eax
  80327d:	8d 76 00             	lea    0x0(%esi),%esi
  803280:	e8 e7 fe ff ff       	call   80316c <_ZL13_pipeisclosedP2FdP4Pipe>
  803285:	85 c0                	test   %eax,%eax
  803287:	75 49                	jne    8032d2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803289:	e8 7e dd ff ff       	call   80100c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80328e:	8b 03                	mov    (%ebx),%eax
  803290:	3b 43 04             	cmp    0x4(%ebx),%eax
  803293:	74 e4                	je     803279 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803295:	89 c2                	mov    %eax,%edx
  803297:	c1 fa 1f             	sar    $0x1f,%edx
  80329a:	c1 ea 1b             	shr    $0x1b,%edx
  80329d:	01 d0                	add    %edx,%eax
  80329f:	83 e0 1f             	and    $0x1f,%eax
  8032a2:	29 d0                	sub    %edx,%eax
  8032a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8032a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ac:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8032af:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8032b2:	83 c6 01             	add    $0x1,%esi
  8032b5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8032b8:	76 0d                	jbe    8032c7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8032ba:	8b 03                	mov    (%ebx),%eax
  8032bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8032bf:	75 d4                	jne    803295 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8032c1:	85 f6                	test   %esi,%esi
  8032c3:	75 b0                	jne    803275 <_ZL12devpipe_readP2FdPvj+0x29>
  8032c5:	eb b2                	jmp    803279 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8032c7:	89 f0                	mov    %esi,%eax
  8032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032d0:	eb 05                	jmp    8032d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8032d2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8032d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8032da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8032dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8032e0:	89 ec                	mov    %ebp,%esp
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    

008032e4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032e4:	55                   	push   %ebp
  8032e5:	89 e5                	mov    %esp,%ebp
  8032e7:	83 ec 48             	sub    $0x48,%esp
  8032ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8032ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8032f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8032f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8032f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8032f9:	89 04 24             	mov    %eax,(%esp)
  8032fc:	e8 b6 e2 ff ff       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  803301:	89 c3                	mov    %eax,%ebx
  803303:	85 c0                	test   %eax,%eax
  803305:	0f 88 0b 01 00 00    	js     803416 <_Z4pipePi+0x132>
  80330b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803312:	00 
  803313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803316:	89 44 24 04          	mov    %eax,0x4(%esp)
  80331a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803321:	e8 1a dd ff ff       	call   801040 <_Z14sys_page_allociPvi>
  803326:	89 c3                	mov    %eax,%ebx
  803328:	85 c0                	test   %eax,%eax
  80332a:	0f 89 f5 00 00 00    	jns    803425 <_Z4pipePi+0x141>
  803330:	e9 e1 00 00 00       	jmp    803416 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803335:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80333c:	00 
  80333d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803340:	89 44 24 04          	mov    %eax,0x4(%esp)
  803344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80334b:	e8 f0 dc ff ff       	call   801040 <_Z14sys_page_allociPvi>
  803350:	89 c3                	mov    %eax,%ebx
  803352:	85 c0                	test   %eax,%eax
  803354:	0f 89 e2 00 00 00    	jns    80343c <_Z4pipePi+0x158>
  80335a:	e9 a4 00 00 00       	jmp    803403 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80335f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803362:	89 04 24             	mov    %eax,(%esp)
  803365:	e8 32 e2 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  80336a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803371:	00 
  803372:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803376:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80337d:	00 
  80337e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803382:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803389:	e8 11 dd ff ff       	call   80109f <_Z12sys_page_mapiPviS_i>
  80338e:	89 c3                	mov    %eax,%ebx
  803390:	85 c0                	test   %eax,%eax
  803392:	78 4c                	js     8033e0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803394:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  80339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033a9:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8033af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8033b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	89 04 24             	mov    %eax,(%esp)
  8033c4:	e8 8b e1 ff ff       	call   801554 <_Z6fd2numP2Fd>
  8033c9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8033cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ce:	89 04 24             	mov    %eax,(%esp)
  8033d1:	e8 7e e1 ff ff       	call   801554 <_Z6fd2numP2Fd>
  8033d6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8033d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8033de:	eb 36                	jmp    803416 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8033e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033eb:	e8 0d dd ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8033f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033fe:	e8 fa dc ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80340a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803411:	e8 e7 dc ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803416:	89 d8                	mov    %ebx,%eax
  803418:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80341b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80341e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803421:	89 ec                	mov    %ebp,%esp
  803423:	5d                   	pop    %ebp
  803424:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803425:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803428:	89 04 24             	mov    %eax,(%esp)
  80342b:	e8 87 e1 ff ff       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  803430:	89 c3                	mov    %eax,%ebx
  803432:	85 c0                	test   %eax,%eax
  803434:	0f 89 fb fe ff ff    	jns    803335 <_Z4pipePi+0x51>
  80343a:	eb c7                	jmp    803403 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80343c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343f:	89 04 24             	mov    %eax,(%esp)
  803442:	e8 55 e1 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  803447:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803449:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803450:	00 
  803451:	89 44 24 04          	mov    %eax,0x4(%esp)
  803455:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80345c:	e8 df db ff ff       	call   801040 <_Z14sys_page_allociPvi>
  803461:	89 c3                	mov    %eax,%ebx
  803463:	85 c0                	test   %eax,%eax
  803465:	0f 89 f4 fe ff ff    	jns    80335f <_Z4pipePi+0x7b>
  80346b:	eb 83                	jmp    8033f0 <_Z4pipePi+0x10c>

0080346d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80346d:	55                   	push   %ebp
  80346e:	89 e5                	mov    %esp,%ebp
  803470:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803473:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80347a:	00 
  80347b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80347e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	89 04 24             	mov    %eax,(%esp)
  803488:	e8 74 e0 ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  80348d:	85 c0                	test   %eax,%eax
  80348f:	78 15                	js     8034a6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	89 04 24             	mov    %eax,(%esp)
  803497:	e8 00 e1 ff ff       	call   80159c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80349c:	89 c2                	mov    %eax,%edx
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	e8 c6 fc ff ff       	call   80316c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8034a6:	c9                   	leave  
  8034a7:	c3                   	ret    

008034a8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8034a8:	55                   	push   %ebp
  8034a9:	89 e5                	mov    %esp,%ebp
  8034ab:	53                   	push   %ebx
  8034ac:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8034af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034b2:	89 04 24             	mov    %eax,(%esp)
  8034b5:	e8 fd e0 ff ff       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  8034ba:	89 c3                	mov    %eax,%ebx
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	0f 88 be 00 00 00    	js     803582 <_Z18pipe_ipc_recv_readv+0xda>
  8034c4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8034cb:	00 
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034da:	e8 61 db ff ff       	call   801040 <_Z14sys_page_allociPvi>
  8034df:	89 c3                	mov    %eax,%ebx
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	0f 89 a1 00 00 00    	jns    80358a <_Z18pipe_ipc_recv_readv+0xe2>
  8034e9:	e9 94 00 00 00       	jmp    803582 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8034ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f1:	85 c0                	test   %eax,%eax
  8034f3:	75 0e                	jne    803503 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8034f5:	c7 04 24 c0 4b 80 00 	movl   $0x804bc0,(%esp)
  8034fc:	e8 5d cf ff ff       	call   80045e <_Z7cprintfPKcz>
  803501:	eb 10                	jmp    803513 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803503:	89 44 24 04          	mov    %eax,0x4(%esp)
  803507:	c7 04 24 75 4b 80 00 	movl   $0x804b75,(%esp)
  80350e:	e8 4b cf ff ff       	call   80045e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803513:	c7 04 24 7f 4b 80 00 	movl   $0x804b7f,(%esp)
  80351a:	e8 3f cf ff ff       	call   80045e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80351f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803522:	a8 04                	test   $0x4,%al
  803524:	74 04                	je     80352a <_Z18pipe_ipc_recv_readv+0x82>
  803526:	a8 01                	test   $0x1,%al
  803528:	75 24                	jne    80354e <_Z18pipe_ipc_recv_readv+0xa6>
  80352a:	c7 44 24 0c 92 4b 80 	movl   $0x804b92,0xc(%esp)
  803531:	00 
  803532:	c7 44 24 08 5c 45 80 	movl   $0x80455c,0x8(%esp)
  803539:	00 
  80353a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803541:	00 
  803542:	c7 04 24 af 4b 80 00 	movl   $0x804baf,(%esp)
  803549:	e8 f2 cd ff ff       	call   800340 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80354e:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803557:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803563:	89 04 24             	mov    %eax,(%esp)
  803566:	e8 e9 df ff ff       	call   801554 <_Z6fd2numP2Fd>
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	eb 13                	jmp    803582 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	89 44 24 04          	mov    %eax,0x4(%esp)
  803576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80357d:	e8 7b db ff ff       	call   8010fd <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803582:	89 d8                	mov    %ebx,%eax
  803584:	83 c4 24             	add    $0x24,%esp
  803587:	5b                   	pop    %ebx
  803588:	5d                   	pop    %ebp
  803589:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358d:	89 04 24             	mov    %eax,(%esp)
  803590:	e8 07 e0 ff ff       	call   80159c <_Z7fd2dataP2Fd>
  803595:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803598:	89 54 24 08          	mov    %edx,0x8(%esp)
  80359c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8035a3:	89 04 24             	mov    %eax,(%esp)
  8035a6:	e8 05 08 00 00       	call   803db0 <_Z8ipc_recvPiPvS_>
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	0f 89 39 ff ff ff    	jns    8034ee <_Z18pipe_ipc_recv_readv+0x46>
  8035b5:	eb b8                	jmp    80356f <_Z18pipe_ipc_recv_readv+0xc7>

008035b7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
  8035ba:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8035bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8035c4:	00 
  8035c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cf:	89 04 24             	mov    %eax,(%esp)
  8035d2:	e8 2a df ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	78 2f                	js     80360a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	89 04 24             	mov    %eax,(%esp)
  8035e1:	e8 b6 df ff ff       	call   80159c <_Z7fd2dataP2Fd>
  8035e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8035ed:	00 
  8035ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8035f9:	00 
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	89 04 24             	mov    %eax,(%esp)
  803600:	e8 3a 08 00 00       	call   803e3f <_Z8ipc_sendijPvi>
    return 0;
  803605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80360a:	c9                   	leave  
  80360b:	c3                   	ret    

0080360c <_ZL8writebufP8printbuf>:
};


static void
writebuf(struct printbuf *b)
{
  80360c:	55                   	push   %ebp
  80360d:	89 e5                	mov    %esp,%ebp
  80360f:	53                   	push   %ebx
  803610:	83 ec 14             	sub    $0x14,%esp
  803613:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  803615:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  803619:	7e 31                	jle    80364c <_ZL8writebufP8printbuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803622:	8d 43 10             	lea    0x10(%ebx),%eax
  803625:	89 44 24 04          	mov    %eax,0x4(%esp)
  803629:	8b 03                	mov    (%ebx),%eax
  80362b:	89 04 24             	mov    %eax,(%esp)
  80362e:	e8 66 e3 ff ff       	call   801999 <_Z5writeiPKvj>
		if (result > 0)
  803633:	85 c0                	test   %eax,%eax
  803635:	7e 03                	jle    80363a <_ZL8writebufP8printbuf+0x2e>
			b->result += result;
  803637:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80363a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80363d:	74 0d                	je     80364c <_ZL8writebufP8printbuf+0x40>
			b->error = (result < 0 ? result : 0);
  80363f:	85 c0                	test   %eax,%eax
  803641:	ba 00 00 00 00       	mov    $0x0,%edx
  803646:	0f 4f c2             	cmovg  %edx,%eax
  803649:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80364c:	83 c4 14             	add    $0x14,%esp
  80364f:	5b                   	pop    %ebx
  803650:	5d                   	pop    %ebp
  803651:	c3                   	ret    

00803652 <_ZL5putchiPv>:

static void
putch(int ch, void *thunk)
{
  803652:	55                   	push   %ebp
  803653:	89 e5                	mov    %esp,%ebp
  803655:	53                   	push   %ebx
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80365c:	8b 43 04             	mov    0x4(%ebx),%eax
  80365f:	8b 55 08             	mov    0x8(%ebp),%edx
  803662:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  803666:	83 c0 01             	add    $0x1,%eax
  803669:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  80366c:	3d 00 01 00 00       	cmp    $0x100,%eax
  803671:	75 0e                	jne    803681 <_ZL5putchiPv+0x2f>
		writebuf(b);
  803673:	89 d8                	mov    %ebx,%eax
  803675:	e8 92 ff ff ff       	call   80360c <_ZL8writebufP8printbuf>
		b->idx = 0;
  80367a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  803681:	83 c4 04             	add    $0x4,%esp
  803684:	5b                   	pop    %ebx
  803685:	5d                   	pop    %ebp
  803686:	c3                   	ret    

00803687 <_Z8vfprintfiPKcPc>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  803699:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8036a0:	00 00 00 
	b.result = 0;
  8036a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8036aa:	00 00 00 
	b.error = 1;
  8036ad:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8036b4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8036b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036c5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8036cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036cf:	c7 04 24 52 36 80 00 	movl   $0x803652,(%esp)
  8036d6:	e8 0c cf ff ff       	call   8005e7 <_Z9vprintfmtPFviPvES_PKcPc>
	if (b.idx > 0)
  8036db:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8036e2:	7e 0b                	jle    8036ef <_Z8vfprintfiPKcPc+0x68>
		writebuf(&b);
  8036e4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8036ea:	e8 1d ff ff ff       	call   80360c <_ZL8writebufP8printbuf>

	return (b.result ? b.result : b.error);
  8036ef:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8036fe:	c9                   	leave  
  8036ff:	c3                   	ret    

00803700 <_Z7fprintfiPKcz>:

int
fprintf(int fd, const char *fmt, ...)
{
  803700:	55                   	push   %ebp
  803701:	89 e5                	mov    %esp,%ebp
  803703:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803706:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  803709:	89 44 24 08          	mov    %eax,0x8(%esp)
  80370d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803710:	89 44 24 04          	mov    %eax,0x4(%esp)
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	89 04 24             	mov    %eax,(%esp)
  80371a:	e8 68 ff ff ff       	call   803687 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  80371f:	c9                   	leave  
  803720:	c3                   	ret    

00803721 <_Z6printfPKcz>:

int
printf(const char *fmt, ...)
{
  803721:	55                   	push   %ebp
  803722:	89 e5                	mov    %esp,%ebp
  803724:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803727:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80372a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	89 44 24 04          	mov    %eax,0x4(%esp)
  803735:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80373c:	e8 46 ff ff ff       	call   803687 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  803741:	c9                   	leave  
  803742:	c3                   	ret    
	...

00803744 <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80374a:	89 d0                	mov    %edx,%eax
  80374c:	c1 e8 16             	shr    $0x16,%eax
  80374f:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803756:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80375b:	f6 c1 01             	test   $0x1,%cl
  80375e:	74 1d                	je     80377d <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803760:	c1 ea 0c             	shr    $0xc,%edx
  803763:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80376a:	f6 c2 01             	test   $0x1,%dl
  80376d:	74 0e                	je     80377d <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80376f:	c1 ea 0c             	shr    $0xc,%edx
  803772:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803779:	ef 
  80377a:	0f b7 c0             	movzwl %ax,%eax
}
  80377d:	5d                   	pop    %ebp
  80377e:	c3                   	ret    
	...

00803780 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803780:	55                   	push   %ebp
  803781:	89 e5                	mov    %esp,%ebp
  803783:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803786:	c7 44 24 04 e3 4b 80 	movl   $0x804be3,0x4(%esp)
  80378d:	00 
  80378e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803791:	89 04 24             	mov    %eax,(%esp)
  803794:	e8 c1 d3 ff ff       	call   800b5a <_Z6strcpyPcPKc>
	return 0;
}
  803799:	b8 00 00 00 00       	mov    $0x0,%eax
  80379e:	c9                   	leave  
  80379f:	c3                   	ret    

008037a0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8037a0:	55                   	push   %ebp
  8037a1:	89 e5                	mov    %esp,%ebp
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 14             	sub    $0x14,%esp
  8037a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8037aa:	89 1c 24             	mov    %ebx,(%esp)
  8037ad:	e8 92 ff ff ff       	call   803744 <_Z7pagerefPv>
  8037b2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8037b4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8037b9:	83 fa 01             	cmp    $0x1,%edx
  8037bc:	75 0b                	jne    8037c9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8037be:	8b 43 0c             	mov    0xc(%ebx),%eax
  8037c1:	89 04 24             	mov    %eax,(%esp)
  8037c4:	e8 fe 02 00 00       	call   803ac7 <_Z11nsipc_closei>
	else
		return 0;
}
  8037c9:	83 c4 14             	add    $0x14,%esp
  8037cc:	5b                   	pop    %ebx
  8037cd:	5d                   	pop    %ebp
  8037ce:	c3                   	ret    

008037cf <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
  8037d2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8037dc:	00 
  8037dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8037e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f1:	89 04 24             	mov    %eax,(%esp)
  8037f4:	e8 c9 03 00 00       	call   803bc2 <_Z10nsipc_sendiPKvij>
}
  8037f9:	c9                   	leave  
  8037fa:	c3                   	ret    

008037fb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037fb:	55                   	push   %ebp
  8037fc:	89 e5                	mov    %esp,%ebp
  8037fe:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803801:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803808:	00 
  803809:	8b 45 10             	mov    0x10(%ebp),%eax
  80380c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803810:	8b 45 0c             	mov    0xc(%ebp),%eax
  803813:	89 44 24 04          	mov    %eax,0x4(%esp)
  803817:	8b 45 08             	mov    0x8(%ebp),%eax
  80381a:	8b 40 0c             	mov    0xc(%eax),%eax
  80381d:	89 04 24             	mov    %eax,(%esp)
  803820:	e8 1d 03 00 00       	call   803b42 <_Z10nsipc_recviPvij>
}
  803825:	c9                   	leave  
  803826:	c3                   	ret    

00803827 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803827:	55                   	push   %ebp
  803828:	89 e5                	mov    %esp,%ebp
  80382a:	83 ec 28             	sub    $0x28,%esp
  80382d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803830:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803833:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803838:	89 04 24             	mov    %eax,(%esp)
  80383b:	e8 77 dd ff ff       	call   8015b7 <_Z14fd_find_unusedPP2Fd>
  803840:	89 c3                	mov    %eax,%ebx
  803842:	85 c0                	test   %eax,%eax
  803844:	78 21                	js     803867 <_ZL12alloc_sockfdi+0x40>
  803846:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80384d:	00 
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	89 44 24 04          	mov    %eax,0x4(%esp)
  803855:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80385c:	e8 df d7 ff ff       	call   801040 <_Z14sys_page_allociPvi>
  803861:	89 c3                	mov    %eax,%ebx
  803863:	85 c0                	test   %eax,%eax
  803865:	79 14                	jns    80387b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803867:	89 34 24             	mov    %esi,(%esp)
  80386a:	e8 58 02 00 00       	call   803ac7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80386f:	89 d8                	mov    %ebx,%eax
  803871:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803874:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803877:	89 ec                	mov    %ebp,%esp
  803879:	5d                   	pop    %ebp
  80387a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80387b:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803889:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803890:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803893:	89 04 24             	mov    %eax,(%esp)
  803896:	e8 b9 dc ff ff       	call   801554 <_Z6fd2numP2Fd>
  80389b:	89 c3                	mov    %eax,%ebx
  80389d:	eb d0                	jmp    80386f <_ZL12alloc_sockfdi+0x48>

0080389f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80389f:	55                   	push   %ebp
  8038a0:	89 e5                	mov    %esp,%ebp
  8038a2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  8038a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8038ac:	00 
  8038ad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8038b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8038b4:	89 04 24             	mov    %eax,(%esp)
  8038b7:	e8 45 dc ff ff       	call   801501 <_Z9fd_lookupiPP2Fdb>
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	78 15                	js     8038d5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8038c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8038c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8038c8:	8b 0d 58 50 80 00    	mov    0x805058,%ecx
  8038ce:	39 0a                	cmp    %ecx,(%edx)
  8038d0:	75 03                	jne    8038d5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8038d2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	e8 ba ff ff ff       	call   80389f <_ZL9fd2sockidi>
  8038e5:	85 c0                	test   %eax,%eax
  8038e7:	78 1f                	js     803908 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038e9:	8b 55 10             	mov    0x10(%ebp),%edx
  8038ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  8038f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8038f7:	89 04 24             	mov    %eax,(%esp)
  8038fa:	e8 19 01 00 00       	call   803a18 <_Z12nsipc_acceptiP8sockaddrPj>
  8038ff:	85 c0                	test   %eax,%eax
  803901:	78 05                	js     803908 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803903:	e8 1f ff ff ff       	call   803827 <_ZL12alloc_sockfdi>
}
  803908:	c9                   	leave  
  803909:	c3                   	ret    

0080390a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80390a:	55                   	push   %ebp
  80390b:	89 e5                	mov    %esp,%ebp
  80390d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	e8 87 ff ff ff       	call   80389f <_ZL9fd2sockidi>
  803918:	85 c0                	test   %eax,%eax
  80391a:	78 16                	js     803932 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80391c:	8b 55 10             	mov    0x10(%ebp),%edx
  80391f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803923:	8b 55 0c             	mov    0xc(%ebp),%edx
  803926:	89 54 24 04          	mov    %edx,0x4(%esp)
  80392a:	89 04 24             	mov    %eax,(%esp)
  80392d:	e8 34 01 00 00       	call   803a66 <_Z10nsipc_bindiP8sockaddrj>
}
  803932:	c9                   	leave  
  803933:	c3                   	ret    

00803934 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803934:	55                   	push   %ebp
  803935:	89 e5                	mov    %esp,%ebp
  803937:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	e8 5d ff ff ff       	call   80389f <_ZL9fd2sockidi>
  803942:	85 c0                	test   %eax,%eax
  803944:	78 0f                	js     803955 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803946:	8b 55 0c             	mov    0xc(%ebp),%edx
  803949:	89 54 24 04          	mov    %edx,0x4(%esp)
  80394d:	89 04 24             	mov    %eax,(%esp)
  803950:	e8 50 01 00 00       	call   803aa5 <_Z14nsipc_shutdownii>
}
  803955:	c9                   	leave  
  803956:	c3                   	ret    

00803957 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803957:	55                   	push   %ebp
  803958:	89 e5                	mov    %esp,%ebp
  80395a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	e8 3a ff ff ff       	call   80389f <_ZL9fd2sockidi>
  803965:	85 c0                	test   %eax,%eax
  803967:	78 16                	js     80397f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803969:	8b 55 10             	mov    0x10(%ebp),%edx
  80396c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803970:	8b 55 0c             	mov    0xc(%ebp),%edx
  803973:	89 54 24 04          	mov    %edx,0x4(%esp)
  803977:	89 04 24             	mov    %eax,(%esp)
  80397a:	e8 62 01 00 00       	call   803ae1 <_Z13nsipc_connectiPK8sockaddrj>
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	e8 10 ff ff ff       	call   80389f <_ZL9fd2sockidi>
  80398f:	85 c0                	test   %eax,%eax
  803991:	78 0f                	js     8039a2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803993:	8b 55 0c             	mov    0xc(%ebp),%edx
  803996:	89 54 24 04          	mov    %edx,0x4(%esp)
  80399a:	89 04 24             	mov    %eax,(%esp)
  80399d:	e8 7e 01 00 00       	call   803b20 <_Z12nsipc_listenii>
}
  8039a2:	c9                   	leave  
  8039a3:	c3                   	ret    

008039a4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8039a4:	55                   	push   %ebp
  8039a5:	89 e5                	mov    %esp,%ebp
  8039a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8039aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8039ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	89 04 24             	mov    %eax,(%esp)
  8039be:	e8 72 02 00 00       	call   803c35 <_Z12nsipc_socketiii>
  8039c3:	85 c0                	test   %eax,%eax
  8039c5:	78 05                	js     8039cc <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8039c7:	e8 5b fe ff ff       	call   803827 <_ZL12alloc_sockfdi>
}
  8039cc:	c9                   	leave  
  8039cd:	8d 76 00             	lea    0x0(%esi),%esi
  8039d0:	c3                   	ret    
  8039d1:	00 00                	add    %al,(%eax)
	...

008039d4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039d4:	55                   	push   %ebp
  8039d5:	89 e5                	mov    %esp,%ebp
  8039d7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039da:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8039e1:	00 
  8039e2:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8039e9:	00 
  8039ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039ee:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8039f5:	e8 45 04 00 00       	call   803e3f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8039fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a01:	00 
  803a02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a09:	00 
  803a0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a11:	e8 9a 03 00 00       	call   803db0 <_Z8ipc_recvPiPvS_>
}
  803a16:	c9                   	leave  
  803a17:	c3                   	ret    

00803a18 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a18:	55                   	push   %ebp
  803a19:	89 e5                	mov    %esp,%ebp
  803a1b:	53                   	push   %ebx
  803a1c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a27:	b8 01 00 00 00       	mov    $0x1,%eax
  803a2c:	e8 a3 ff ff ff       	call   8039d4 <_ZL5nsipcj>
  803a31:	89 c3                	mov    %eax,%ebx
  803a33:	85 c0                	test   %eax,%eax
  803a35:	78 27                	js     803a5e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803a37:	a1 10 70 80 00       	mov    0x807010,%eax
  803a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a40:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803a47:	00 
  803a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4b:	89 04 24             	mov    %eax,(%esp)
  803a4e:	e8 a9 d2 ff ff       	call   800cfc <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803a53:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803a59:	8b 45 10             	mov    0x10(%ebp),%eax
  803a5c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803a5e:	89 d8                	mov    %ebx,%eax
  803a60:	83 c4 14             	add    $0x14,%esp
  803a63:	5b                   	pop    %ebx
  803a64:	5d                   	pop    %ebp
  803a65:	c3                   	ret    

00803a66 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a66:	55                   	push   %ebp
  803a67:	89 e5                	mov    %esp,%ebp
  803a69:	53                   	push   %ebx
  803a6a:	83 ec 14             	sub    $0x14,%esp
  803a6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a83:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803a8a:	e8 6d d2 ff ff       	call   800cfc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803a8f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803a95:	b8 02 00 00 00       	mov    $0x2,%eax
  803a9a:	e8 35 ff ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803a9f:	83 c4 14             	add    $0x14,%esp
  803aa2:	5b                   	pop    %ebx
  803aa3:	5d                   	pop    %ebp
  803aa4:	c3                   	ret    

00803aa5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803aa5:	55                   	push   %ebp
  803aa6:	89 e5                	mov    %esp,%ebp
  803aa8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803abb:	b8 03 00 00 00       	mov    $0x3,%eax
  803ac0:	e8 0f ff ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803ac5:	c9                   	leave  
  803ac6:	c3                   	ret    

00803ac7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803ac7:	55                   	push   %ebp
  803ac8:	89 e5                	mov    %esp,%ebp
  803aca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803acd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803ad5:	b8 04 00 00 00       	mov    $0x4,%eax
  803ada:	e8 f5 fe ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803adf:	c9                   	leave  
  803ae0:	c3                   	ret    

00803ae1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ae1:	55                   	push   %ebp
  803ae2:	89 e5                	mov    %esp,%ebp
  803ae4:	53                   	push   %ebx
  803ae5:	83 ec 14             	sub    $0x14,%esp
  803ae8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803aee:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803af3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803afe:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803b05:	e8 f2 d1 ff ff       	call   800cfc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803b0a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803b10:	b8 05 00 00 00       	mov    $0x5,%eax
  803b15:	e8 ba fe ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803b1a:	83 c4 14             	add    $0x14,%esp
  803b1d:	5b                   	pop    %ebx
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    

00803b20 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803b20:	55                   	push   %ebp
  803b21:	89 e5                	mov    %esp,%ebp
  803b23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803b26:	8b 45 08             	mov    0x8(%ebp),%eax
  803b29:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b31:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803b36:	b8 06 00 00 00       	mov    $0x6,%eax
  803b3b:	e8 94 fe ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803b40:	c9                   	leave  
  803b41:	c3                   	ret    

00803b42 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b42:	55                   	push   %ebp
  803b43:	89 e5                	mov    %esp,%ebp
  803b45:	56                   	push   %esi
  803b46:	53                   	push   %ebx
  803b47:	83 ec 10             	sub    $0x10,%esp
  803b4a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803b55:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  803b5e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b63:	b8 07 00 00 00       	mov    $0x7,%eax
  803b68:	e8 67 fe ff ff       	call   8039d4 <_ZL5nsipcj>
  803b6d:	89 c3                	mov    %eax,%ebx
  803b6f:	85 c0                	test   %eax,%eax
  803b71:	78 46                	js     803bb9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803b73:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803b78:	7f 04                	jg     803b7e <_Z10nsipc_recviPvij+0x3c>
  803b7a:	39 f0                	cmp    %esi,%eax
  803b7c:	7e 24                	jle    803ba2 <_Z10nsipc_recviPvij+0x60>
  803b7e:	c7 44 24 0c ef 4b 80 	movl   $0x804bef,0xc(%esp)
  803b85:	00 
  803b86:	c7 44 24 08 5c 45 80 	movl   $0x80455c,0x8(%esp)
  803b8d:	00 
  803b8e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803b95:	00 
  803b96:	c7 04 24 04 4c 80 00 	movl   $0x804c04,(%esp)
  803b9d:	e8 9e c7 ff ff       	call   800340 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ba2:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ba6:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803bad:	00 
  803bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb1:	89 04 24             	mov    %eax,(%esp)
  803bb4:	e8 43 d1 ff ff       	call   800cfc <memmove>
	}

	return r;
}
  803bb9:	89 d8                	mov    %ebx,%eax
  803bbb:	83 c4 10             	add    $0x10,%esp
  803bbe:	5b                   	pop    %ebx
  803bbf:	5e                   	pop    %esi
  803bc0:	5d                   	pop    %ebp
  803bc1:	c3                   	ret    

00803bc2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bc2:	55                   	push   %ebp
  803bc3:	89 e5                	mov    %esp,%ebp
  803bc5:	53                   	push   %ebx
  803bc6:	83 ec 14             	sub    $0x14,%esp
  803bc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcf:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803bd4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803bda:	7e 24                	jle    803c00 <_Z10nsipc_sendiPKvij+0x3e>
  803bdc:	c7 44 24 0c 10 4c 80 	movl   $0x804c10,0xc(%esp)
  803be3:	00 
  803be4:	c7 44 24 08 5c 45 80 	movl   $0x80455c,0x8(%esp)
  803beb:	00 
  803bec:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803bf3:	00 
  803bf4:	c7 04 24 04 4c 80 00 	movl   $0x804c04,(%esp)
  803bfb:	e8 40 c7 ff ff       	call   800340 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c0b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803c12:	e8 e5 d0 ff ff       	call   800cfc <memmove>
	nsipcbuf.send.req_size = size;
  803c17:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  803c20:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803c25:	b8 08 00 00 00       	mov    $0x8,%eax
  803c2a:	e8 a5 fd ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803c2f:	83 c4 14             	add    $0x14,%esp
  803c32:	5b                   	pop    %ebx
  803c33:	5d                   	pop    %ebp
  803c34:	c3                   	ret    

00803c35 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c35:	55                   	push   %ebp
  803c36:	89 e5                	mov    %esp,%ebp
  803c38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c46:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  803c4e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803c53:	b8 09 00 00 00       	mov    $0x9,%eax
  803c58:	e8 77 fd ff ff       	call   8039d4 <_ZL5nsipcj>
}
  803c5d:	c9                   	leave  
  803c5e:	c3                   	ret    
	...

00803c60 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803c60:	55                   	push   %ebp
  803c61:	89 e5                	mov    %esp,%ebp
  803c63:	56                   	push   %esi
  803c64:	53                   	push   %ebx
  803c65:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803c68:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803c6d:	8b 04 9d 00 80 80 00 	mov    0x808000(,%ebx,4),%eax
  803c74:	85 c0                	test   %eax,%eax
  803c76:	74 08                	je     803c80 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803c78:	8d 55 08             	lea    0x8(%ebp),%edx
  803c7b:	89 14 24             	mov    %edx,(%esp)
  803c7e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803c80:	83 eb 01             	sub    $0x1,%ebx
  803c83:	83 fb ff             	cmp    $0xffffffff,%ebx
  803c86:	75 e5                	jne    803c6d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803c88:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803c8b:	8b 75 08             	mov    0x8(%ebp),%esi
  803c8e:	e8 45 d3 ff ff       	call   800fd8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803c93:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803c97:	89 74 24 10          	mov    %esi,0x10(%esp)
  803c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c9f:	c7 44 24 08 1c 4c 80 	movl   $0x804c1c,0x8(%esp)
  803ca6:	00 
  803ca7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803cae:	00 
  803caf:	c7 04 24 a0 4c 80 00 	movl   $0x804ca0,(%esp)
  803cb6:	e8 85 c6 ff ff       	call   800340 <_Z6_panicPKciS0_z>

00803cbb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803cbb:	55                   	push   %ebp
  803cbc:	89 e5                	mov    %esp,%ebp
  803cbe:	56                   	push   %esi
  803cbf:	53                   	push   %ebx
  803cc0:	83 ec 10             	sub    $0x10,%esp
  803cc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803cc6:	e8 0d d3 ff ff       	call   800fd8 <_Z12sys_getenvidv>
  803ccb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803ccd:	a1 00 60 80 00       	mov    0x806000,%eax
  803cd2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803cd5:	85 c0                	test   %eax,%eax
  803cd7:	75 4c                	jne    803d25 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803cd9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803ce0:	00 
  803ce1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803ce8:	ee 
  803ce9:	89 34 24             	mov    %esi,(%esp)
  803cec:	e8 4f d3 ff ff       	call   801040 <_Z14sys_page_allociPvi>
  803cf1:	85 c0                	test   %eax,%eax
  803cf3:	74 20                	je     803d15 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803cf5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803cf9:	c7 44 24 08 54 4c 80 	movl   $0x804c54,0x8(%esp)
  803d00:	00 
  803d01:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803d08:	00 
  803d09:	c7 04 24 a0 4c 80 00 	movl   $0x804ca0,(%esp)
  803d10:	e8 2b c6 ff ff       	call   800340 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803d15:	c7 44 24 04 60 3c 80 	movl   $0x803c60,0x4(%esp)
  803d1c:	00 
  803d1d:	89 34 24             	mov    %esi,(%esp)
  803d20:	e8 50 d5 ff ff       	call   801275 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803d25:	a1 00 80 80 00       	mov    0x808000,%eax
  803d2a:	39 d8                	cmp    %ebx,%eax
  803d2c:	74 1a                	je     803d48 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803d2e:	85 c0                	test   %eax,%eax
  803d30:	74 20                	je     803d52 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d32:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803d37:	8b 14 85 00 80 80 00 	mov    0x808000(,%eax,4),%edx
  803d3e:	39 da                	cmp    %ebx,%edx
  803d40:	74 15                	je     803d57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803d42:	85 d2                	test   %edx,%edx
  803d44:	75 1f                	jne    803d65 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803d46:	eb 0f                	jmp    803d57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d48:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4d:	8d 76 00             	lea    0x0(%esi),%esi
  803d50:	eb 05                	jmp    803d57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803d52:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803d57:	89 1c 85 00 80 80 00 	mov    %ebx,0x808000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803d5e:	83 c4 10             	add    $0x10,%esp
  803d61:	5b                   	pop    %ebx
  803d62:	5e                   	pop    %esi
  803d63:	5d                   	pop    %ebp
  803d64:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d65:	83 c0 01             	add    $0x1,%eax
  803d68:	83 f8 08             	cmp    $0x8,%eax
  803d6b:	75 ca                	jne    803d37 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803d6d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803d71:	c7 44 24 08 78 4c 80 	movl   $0x804c78,0x8(%esp)
  803d78:	00 
  803d79:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803d80:	00 
  803d81:	c7 04 24 a0 4c 80 00 	movl   $0x804ca0,(%esp)
  803d88:	e8 b3 c5 ff ff       	call   800340 <_Z6_panicPKciS0_z>
  803d8d:	00 00                	add    %al,(%eax)
	...

00803d90 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803d90:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803d93:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803d94:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803d97:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803d9b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803d9f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803da2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803da4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803da8:	61                   	popa   
    popf
  803da9:	9d                   	popf   
    popl %esp
  803daa:	5c                   	pop    %esp
    ret
  803dab:	c3                   	ret    

00803dac <spin>:

spin:	jmp spin
  803dac:	eb fe                	jmp    803dac <spin>
	...

00803db0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803db0:	55                   	push   %ebp
  803db1:	89 e5                	mov    %esp,%ebp
  803db3:	56                   	push   %esi
  803db4:	53                   	push   %ebx
  803db5:	83 ec 10             	sub    $0x10,%esp
  803db8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dbe:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803dc1:	85 c0                	test   %eax,%eax
  803dc3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803dc8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803dcb:	89 04 24             	mov    %eax,(%esp)
  803dce:	e8 38 d5 ff ff       	call   80130b <_Z12sys_ipc_recvPv>
  803dd3:	85 c0                	test   %eax,%eax
  803dd5:	79 16                	jns    803ded <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803dd7:	85 db                	test   %ebx,%ebx
  803dd9:	74 06                	je     803de1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803ddb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803de1:	85 f6                	test   %esi,%esi
  803de3:	74 53                	je     803e38 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803de5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803deb:	eb 4b                	jmp    803e38 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803ded:	85 db                	test   %ebx,%ebx
  803def:	74 17                	je     803e08 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803df1:	e8 e2 d1 ff ff       	call   800fd8 <_Z12sys_getenvidv>
  803df6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803dfb:	6b c0 78             	imul   $0x78,%eax,%eax
  803dfe:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803e03:	8b 40 60             	mov    0x60(%eax),%eax
  803e06:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803e08:	85 f6                	test   %esi,%esi
  803e0a:	74 17                	je     803e23 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803e0c:	e8 c7 d1 ff ff       	call   800fd8 <_Z12sys_getenvidv>
  803e11:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e16:	6b c0 78             	imul   $0x78,%eax,%eax
  803e19:	05 00 00 00 ef       	add    $0xef000000,%eax
  803e1e:	8b 40 70             	mov    0x70(%eax),%eax
  803e21:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803e23:	e8 b0 d1 ff ff       	call   800fd8 <_Z12sys_getenvidv>
  803e28:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e2d:	6b c0 78             	imul   $0x78,%eax,%eax
  803e30:	05 08 00 00 ef       	add    $0xef000008,%eax
  803e35:	8b 40 60             	mov    0x60(%eax),%eax

}
  803e38:	83 c4 10             	add    $0x10,%esp
  803e3b:	5b                   	pop    %ebx
  803e3c:	5e                   	pop    %esi
  803e3d:	5d                   	pop    %ebp
  803e3e:	c3                   	ret    

00803e3f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e3f:	55                   	push   %ebp
  803e40:	89 e5                	mov    %esp,%ebp
  803e42:	57                   	push   %edi
  803e43:	56                   	push   %esi
  803e44:	53                   	push   %ebx
  803e45:	83 ec 1c             	sub    $0x1c,%esp
  803e48:	8b 75 08             	mov    0x8(%ebp),%esi
  803e4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803e4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803e51:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803e53:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803e58:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803e5b:	8b 45 14             	mov    0x14(%ebp),%eax
  803e5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e66:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803e6a:	89 34 24             	mov    %esi,(%esp)
  803e6d:	e8 61 d4 ff ff       	call   8012d3 <_Z16sys_ipc_try_sendijPvi>
  803e72:	85 c0                	test   %eax,%eax
  803e74:	79 31                	jns    803ea7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803e76:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803e79:	75 0c                	jne    803e87 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803e7b:	90                   	nop
  803e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e80:	e8 87 d1 ff ff       	call   80100c <_Z9sys_yieldv>
  803e85:	eb d4                	jmp    803e5b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e8b:	c7 44 24 08 ae 4c 80 	movl   $0x804cae,0x8(%esp)
  803e92:	00 
  803e93:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803e9a:	00 
  803e9b:	c7 04 24 bb 4c 80 00 	movl   $0x804cbb,(%esp)
  803ea2:	e8 99 c4 ff ff       	call   800340 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803ea7:	83 c4 1c             	add    $0x1c,%esp
  803eaa:	5b                   	pop    %ebx
  803eab:	5e                   	pop    %esi
  803eac:	5f                   	pop    %edi
  803ead:	5d                   	pop    %ebp
  803eae:	c3                   	ret    
	...

00803eb0 <__udivdi3>:
  803eb0:	55                   	push   %ebp
  803eb1:	89 e5                	mov    %esp,%ebp
  803eb3:	57                   	push   %edi
  803eb4:	56                   	push   %esi
  803eb5:	83 ec 20             	sub    $0x20,%esp
  803eb8:	8b 45 14             	mov    0x14(%ebp),%eax
  803ebb:	8b 75 08             	mov    0x8(%ebp),%esi
  803ebe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803ec1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803ec9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803ecc:	75 3a                	jne    803f08 <__udivdi3+0x58>
  803ece:	39 f9                	cmp    %edi,%ecx
  803ed0:	77 66                	ja     803f38 <__udivdi3+0x88>
  803ed2:	85 c9                	test   %ecx,%ecx
  803ed4:	75 0b                	jne    803ee1 <__udivdi3+0x31>
  803ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  803edb:	31 d2                	xor    %edx,%edx
  803edd:	f7 f1                	div    %ecx
  803edf:	89 c1                	mov    %eax,%ecx
  803ee1:	89 f8                	mov    %edi,%eax
  803ee3:	31 d2                	xor    %edx,%edx
  803ee5:	f7 f1                	div    %ecx
  803ee7:	89 c7                	mov    %eax,%edi
  803ee9:	89 f0                	mov    %esi,%eax
  803eeb:	f7 f1                	div    %ecx
  803eed:	89 fa                	mov    %edi,%edx
  803eef:	89 c6                	mov    %eax,%esi
  803ef1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803ef4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803efd:	83 c4 20             	add    $0x20,%esp
  803f00:	5e                   	pop    %esi
  803f01:	5f                   	pop    %edi
  803f02:	5d                   	pop    %ebp
  803f03:	c3                   	ret    
  803f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f08:	31 d2                	xor    %edx,%edx
  803f0a:	31 f6                	xor    %esi,%esi
  803f0c:	39 f8                	cmp    %edi,%eax
  803f0e:	77 e1                	ja     803ef1 <__udivdi3+0x41>
  803f10:	0f bd d0             	bsr    %eax,%edx
  803f13:	83 f2 1f             	xor    $0x1f,%edx
  803f16:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803f19:	75 2d                	jne    803f48 <__udivdi3+0x98>
  803f1b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803f1e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803f21:	76 06                	jbe    803f29 <__udivdi3+0x79>
  803f23:	39 f8                	cmp    %edi,%eax
  803f25:	89 f2                	mov    %esi,%edx
  803f27:	73 c8                	jae    803ef1 <__udivdi3+0x41>
  803f29:	31 d2                	xor    %edx,%edx
  803f2b:	be 01 00 00 00       	mov    $0x1,%esi
  803f30:	eb bf                	jmp    803ef1 <__udivdi3+0x41>
  803f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803f38:	89 f0                	mov    %esi,%eax
  803f3a:	89 fa                	mov    %edi,%edx
  803f3c:	f7 f1                	div    %ecx
  803f3e:	31 d2                	xor    %edx,%edx
  803f40:	89 c6                	mov    %eax,%esi
  803f42:	eb ad                	jmp    803ef1 <__udivdi3+0x41>
  803f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f48:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f4c:	89 c2                	mov    %eax,%edx
  803f4e:	b8 20 00 00 00       	mov    $0x20,%eax
  803f53:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803f56:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803f59:	d3 e2                	shl    %cl,%edx
  803f5b:	89 c1                	mov    %eax,%ecx
  803f5d:	d3 ee                	shr    %cl,%esi
  803f5f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f63:	09 d6                	or     %edx,%esi
  803f65:	89 fa                	mov    %edi,%edx
  803f67:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  803f6a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803f6d:	d3 e6                	shl    %cl,%esi
  803f6f:	89 c1                	mov    %eax,%ecx
  803f71:	d3 ea                	shr    %cl,%edx
  803f73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f77:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803f7a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803f7d:	d3 e7                	shl    %cl,%edi
  803f7f:	89 c1                	mov    %eax,%ecx
  803f81:	d3 ee                	shr    %cl,%esi
  803f83:	09 fe                	or     %edi,%esi
  803f85:	89 f0                	mov    %esi,%eax
  803f87:	f7 75 e4             	divl   -0x1c(%ebp)
  803f8a:	89 d7                	mov    %edx,%edi
  803f8c:	89 c6                	mov    %eax,%esi
  803f8e:	f7 65 f0             	mull   -0x10(%ebp)
  803f91:	39 d7                	cmp    %edx,%edi
  803f93:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803f96:	72 12                	jb     803faa <__udivdi3+0xfa>
  803f98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f9b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f9f:	d3 e2                	shl    %cl,%edx
  803fa1:	39 c2                	cmp    %eax,%edx
  803fa3:	73 08                	jae    803fad <__udivdi3+0xfd>
  803fa5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  803fa8:	75 03                	jne    803fad <__udivdi3+0xfd>
  803faa:	83 ee 01             	sub    $0x1,%esi
  803fad:	31 d2                	xor    %edx,%edx
  803faf:	e9 3d ff ff ff       	jmp    803ef1 <__udivdi3+0x41>
	...

00803fc0 <__umoddi3>:
  803fc0:	55                   	push   %ebp
  803fc1:	89 e5                	mov    %esp,%ebp
  803fc3:	57                   	push   %edi
  803fc4:	56                   	push   %esi
  803fc5:	83 ec 20             	sub    $0x20,%esp
  803fc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  803fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803fd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  803fd4:	85 ff                	test   %edi,%edi
  803fd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803fd9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fdf:	89 f2                	mov    %esi,%edx
  803fe1:	75 15                	jne    803ff8 <__umoddi3+0x38>
  803fe3:	39 f1                	cmp    %esi,%ecx
  803fe5:	76 41                	jbe    804028 <__umoddi3+0x68>
  803fe7:	f7 f1                	div    %ecx
  803fe9:	89 d0                	mov    %edx,%eax
  803feb:	31 d2                	xor    %edx,%edx
  803fed:	83 c4 20             	add    $0x20,%esp
  803ff0:	5e                   	pop    %esi
  803ff1:	5f                   	pop    %edi
  803ff2:	5d                   	pop    %ebp
  803ff3:	c3                   	ret    
  803ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ff8:	39 f7                	cmp    %esi,%edi
  803ffa:	77 4c                	ja     804048 <__umoddi3+0x88>
  803ffc:	0f bd c7             	bsr    %edi,%eax
  803fff:	83 f0 1f             	xor    $0x1f,%eax
  804002:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804005:	75 51                	jne    804058 <__umoddi3+0x98>
  804007:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80400a:	0f 87 e8 00 00 00    	ja     8040f8 <__umoddi3+0x138>
  804010:	89 f2                	mov    %esi,%edx
  804012:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804015:	29 ce                	sub    %ecx,%esi
  804017:	19 fa                	sbb    %edi,%edx
  804019:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80401c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401f:	83 c4 20             	add    $0x20,%esp
  804022:	5e                   	pop    %esi
  804023:	5f                   	pop    %edi
  804024:	5d                   	pop    %ebp
  804025:	c3                   	ret    
  804026:	66 90                	xchg   %ax,%ax
  804028:	85 c9                	test   %ecx,%ecx
  80402a:	75 0b                	jne    804037 <__umoddi3+0x77>
  80402c:	b8 01 00 00 00       	mov    $0x1,%eax
  804031:	31 d2                	xor    %edx,%edx
  804033:	f7 f1                	div    %ecx
  804035:	89 c1                	mov    %eax,%ecx
  804037:	89 f0                	mov    %esi,%eax
  804039:	31 d2                	xor    %edx,%edx
  80403b:	f7 f1                	div    %ecx
  80403d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804040:	eb a5                	jmp    803fe7 <__umoddi3+0x27>
  804042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804048:	89 f2                	mov    %esi,%edx
  80404a:	83 c4 20             	add    $0x20,%esp
  80404d:	5e                   	pop    %esi
  80404e:	5f                   	pop    %edi
  80404f:	5d                   	pop    %ebp
  804050:	c3                   	ret    
  804051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804058:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80405c:	89 f2                	mov    %esi,%edx
  80405e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804061:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804068:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80406b:	d3 e7                	shl    %cl,%edi
  80406d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804070:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804074:	d3 e8                	shr    %cl,%eax
  804076:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80407a:	09 f8                	or     %edi,%eax
  80407c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80407f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804082:	d3 e0                	shl    %cl,%eax
  804084:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80408b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80408e:	d3 ea                	shr    %cl,%edx
  804090:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804094:	d3 e6                	shl    %cl,%esi
  804096:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80409a:	d3 e8                	shr    %cl,%eax
  80409c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8040a0:	09 f0                	or     %esi,%eax
  8040a2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8040a5:	f7 75 e4             	divl   -0x1c(%ebp)
  8040a8:	d3 e6                	shl    %cl,%esi
  8040aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8040ad:	89 d6                	mov    %edx,%esi
  8040af:	f7 65 f4             	mull   -0xc(%ebp)
  8040b2:	89 d7                	mov    %edx,%edi
  8040b4:	89 c2                	mov    %eax,%edx
  8040b6:	39 fe                	cmp    %edi,%esi
  8040b8:	89 f9                	mov    %edi,%ecx
  8040ba:	72 30                	jb     8040ec <__umoddi3+0x12c>
  8040bc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8040bf:	72 27                	jb     8040e8 <__umoddi3+0x128>
  8040c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040c4:	29 d0                	sub    %edx,%eax
  8040c6:	19 ce                	sbb    %ecx,%esi
  8040c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8040cc:	89 f2                	mov    %esi,%edx
  8040ce:	d3 e8                	shr    %cl,%eax
  8040d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8040d4:	d3 e2                	shl    %cl,%edx
  8040d6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8040da:	09 d0                	or     %edx,%eax
  8040dc:	89 f2                	mov    %esi,%edx
  8040de:	d3 ea                	shr    %cl,%edx
  8040e0:	83 c4 20             	add    $0x20,%esp
  8040e3:	5e                   	pop    %esi
  8040e4:	5f                   	pop    %edi
  8040e5:	5d                   	pop    %ebp
  8040e6:	c3                   	ret    
  8040e7:	90                   	nop
  8040e8:	39 fe                	cmp    %edi,%esi
  8040ea:	75 d5                	jne    8040c1 <__umoddi3+0x101>
  8040ec:	89 f9                	mov    %edi,%ecx
  8040ee:	89 c2                	mov    %eax,%edx
  8040f0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8040f3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8040f6:	eb c9                	jmp    8040c1 <__umoddi3+0x101>
  8040f8:	39 f7                	cmp    %esi,%edi
  8040fa:	0f 82 10 ff ff ff    	jb     804010 <__umoddi3+0x50>
  804100:	e9 17 ff ff ff       	jmp    80401c <__umoddi3+0x5c>
