
obj/user/sh:     file format elf32-i386


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
  80002c:	e8 bb 0a 00 00       	call   800aec <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_Z9_gettokenPcPS_S0_>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 10             	mov    0x10(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 1e                	jne    800071 <_Z9_gettokenPcPS_S0_+0x31>
		if (debug > 1)
  800053:	83 3d 00 80 80 00 01 	cmpl   $0x1,0x808000
  80005a:	0f 8e 14 01 00 00    	jle    800174 <_Z9_gettokenPcPS_S0_+0x134>
			cprintf("GETTOKEN NULL\n");
  800060:	c7 04 24 60 58 80 00 	movl   $0x805860,(%esp)
  800067:	e8 22 0c 00 00       	call   800c8e <_Z7cprintfPKcz>
  80006c:	e9 03 01 00 00       	jmp    800174 <_Z9_gettokenPcPS_S0_+0x134>
		return 0;
	}

	if (debug > 1)
  800071:	83 3d 00 80 80 00 01 	cmpl   $0x1,0x808000
  800078:	7e 10                	jle    80008a <_Z9_gettokenPcPS_S0_+0x4a>
		cprintf("GETTOKEN: %s\n", s);
  80007a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80007e:	c7 04 24 6f 58 80 00 	movl   $0x80586f,(%esp)
  800085:	e8 04 0c 00 00       	call   800c8e <_Z7cprintfPKcz>

	*p1 = 0;
  80008a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80008d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800093:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

	while (strchr(WHITESPACE, *s))
  800099:	eb 06                	jmp    8000a1 <_Z9_gettokenPcPS_S0_+0x61>
		*s++ = 0;
  80009b:	c6 03 00             	movb   $0x0,(%ebx)
  80009e:	83 c3 01             	add    $0x1,%ebx
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000a1:	0f be 03             	movsbl (%ebx),%eax
  8000a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000a8:	c7 04 24 7d 58 80 00 	movl   $0x80587d,(%esp)
  8000af:	e8 bf 13 00 00       	call   801473 <_Z6strchrPKcc>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 e3                	jne    80009b <_Z9_gettokenPcPS_S0_+0x5b>
  8000b8:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000ba:	0f b6 03             	movzbl (%ebx),%eax
  8000bd:	84 c0                	test   %al,%al
  8000bf:	75 23                	jne    8000e4 <_Z9_gettokenPcPS_S0_+0xa4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000c1:	bb 00 00 00 00       	mov    $0x0,%ebx
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000c6:	83 3d 00 80 80 00 01 	cmpl   $0x1,0x808000
  8000cd:	0f 8e a1 00 00 00    	jle    800174 <_Z9_gettokenPcPS_S0_+0x134>
			cprintf("EOL\n");
  8000d3:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  8000da:	e8 af 0b 00 00       	call   800c8e <_Z7cprintfPKcz>
  8000df:	e9 90 00 00 00       	jmp    800174 <_Z9_gettokenPcPS_S0_+0x134>
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
  8000e4:	0f be c0             	movsbl %al,%eax
  8000e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000eb:	c7 04 24 93 58 80 00 	movl   $0x805893,(%esp)
  8000f2:	e8 7c 13 00 00       	call   801473 <_Z6strchrPKcc>
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2b                	je     800126 <_Z9_gettokenPcPS_S0_+0xe6>
		t = *s;
  8000fb:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  8000fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800101:	89 3a                	mov    %edi,(%edx)
		*s++ = 0;
  800103:	c6 07 00             	movb   $0x0,(%edi)
  800106:	83 c7 01             	add    $0x1,%edi
  800109:	89 3e                	mov    %edi,(%esi)
		*p2 = s;
		if (debug > 1)
  80010b:	83 3d 00 80 80 00 01 	cmpl   $0x1,0x808000
  800112:	7e 60                	jle    800174 <_Z9_gettokenPcPS_S0_+0x134>
			cprintf("TOK %c\n", t);
  800114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800118:	c7 04 24 87 58 80 00 	movl   $0x805887,(%esp)
  80011f:	e8 6a 0b 00 00       	call   800c8e <_Z7cprintfPKcz>
  800124:	eb 4e                	jmp    800174 <_Z9_gettokenPcPS_S0_+0x134>
		return t;
	}
	*p1 = s;
  800126:	8b 45 0c             	mov    0xc(%ebp),%eax
  800129:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012b:	0f b6 03             	movzbl (%ebx),%eax
  80012e:	84 c0                	test   %al,%al
  800130:	74 4c                	je     80017e <_Z9_gettokenPcPS_S0_+0x13e>
  800132:	0f be c0             	movsbl %al,%eax
  800135:	89 44 24 04          	mov    %eax,0x4(%esp)
  800139:	c7 04 24 8f 58 80 00 	movl   $0x80588f,(%esp)
  800140:	e8 2e 13 00 00       	call   801473 <_Z6strchrPKcc>
  800145:	85 c0                	test   %eax,%eax
  800147:	75 35                	jne    80017e <_Z9_gettokenPcPS_S0_+0x13e>
		s++;
  800149:	83 c3 01             	add    $0x1,%ebx
  80014c:	eb dd                	jmp    80012b <_Z9_gettokenPcPS_S0_+0xeb>
	*p2 = s;
	if (debug > 1) {
		t = **p2;
  80014e:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800151:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800154:	8b 55 0c             	mov    0xc(%ebp),%edx
  800157:	8b 02                	mov    (%edx),%eax
  800159:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015d:	c7 04 24 9b 58 80 00 	movl   $0x80589b,(%esp)
  800164:	e8 25 0b 00 00       	call   800c8e <_Z7cprintfPKcz>
		**p2 = t;
  800169:	8b 06                	mov    (%esi),%eax
  80016b:	89 fa                	mov    %edi,%edx
  80016d:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  80016f:	bb 77 00 00 00       	mov    $0x77,%ebx
}
  800174:	89 d8                	mov    %ebx,%eax
  800176:	83 c4 1c             	add    $0x1c,%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
  80017e:	89 1e                	mov    %ebx,(%esi)
	if (debug > 1) {
  800180:	83 3d 00 80 80 00 01 	cmpl   $0x1,0x808000
  800187:	7f c5                	jg     80014e <_Z9_gettokenPcPS_S0_+0x10e>
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800189:	bb 77 00 00 00       	mov    $0x77,%ebx
  80018e:	eb e4                	jmp    800174 <_Z9_gettokenPcPS_S0_+0x134>

00800190 <_Z8gettokenPcPS_>:
}

int
gettoken(char *s, char **p1)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 18             	sub    $0x18,%esp
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800199:	85 c0                	test   %eax,%eax
  80019b:	74 24                	je     8001c1 <_Z8gettokenPcPS_+0x31>
		nc = _gettoken(s, &np1, &np2);
  80019d:	c7 44 24 08 04 80 80 	movl   $0x808004,0x8(%esp)
  8001a4:	00 
  8001a5:	c7 44 24 04 08 80 80 	movl   $0x808008,0x4(%esp)
  8001ac:	00 
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 8b fe ff ff       	call   800040 <_Z9_gettokenPcPS_S0_>
  8001b5:	a3 0c 80 80 00       	mov    %eax,0x80800c
		return 0;
  8001ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bf:	eb 3c                	jmp    8001fd <_Z8gettokenPcPS_+0x6d>
	}
	c = nc;
  8001c1:	a1 0c 80 80 00       	mov    0x80800c,%eax
  8001c6:	a3 10 80 80 00       	mov    %eax,0x808010
	*p1 = np1;
  8001cb:	8b 15 08 80 80 00    	mov    0x808008,%edx
  8001d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d4:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d6:	c7 44 24 08 04 80 80 	movl   $0x808004,0x8(%esp)
  8001dd:	00 
  8001de:	c7 44 24 04 08 80 80 	movl   $0x808008,0x4(%esp)
  8001e5:	00 
  8001e6:	a1 04 80 80 00       	mov    0x808004,%eax
  8001eb:	89 04 24             	mov    %eax,(%esp)
  8001ee:	e8 4d fe ff ff       	call   800040 <_Z9_gettokenPcPS_S0_>
  8001f3:	a3 0c 80 80 00       	mov    %eax,0x80800c
	return c;
  8001f8:	a1 10 80 80 00       	mov    0x808010,%eax
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <_Z6runcmdPc>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	57                   	push   %edi
  800203:	56                   	push   %esi
  800204:	53                   	push   %ebx
  800205:	81 ec 7c 04 00 00    	sub    $0x47c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
    fd = 0;
	gettoken(s, 0);
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8b 45 08             	mov    0x8(%ebp),%eax
  800216:	89 04 24             	mov    %eax,(%esp)
  800219:	e8 72 ff ff ff       	call   800190 <_Z8gettokenPcPS_>
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
    fd = 0;
  80021e:	bb 00 00 00 00       	mov    $0x0,%ebx
	gettoken(s, 0);

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800223:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	pipe_child = 0;
    fd = 0;
	gettoken(s, 0);

again:
	argc = 0;
  800226:	bf 00 00 00 00       	mov    $0x0,%edi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80022b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80022f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800236:	e8 55 ff ff ff       	call   800190 <_Z8gettokenPcPS_>
  80023b:	83 f8 77             	cmp    $0x77,%eax
  80023e:	74 38                	je     800278 <_Z6runcmdPc+0x79>
  800240:	83 f8 77             	cmp    $0x77,%eax
  800243:	7f 25                	jg     80026a <_Z6runcmdPc+0x6b>
  800245:	83 f8 3c             	cmp    $0x3c,%eax
  800248:	74 55                	je     80029f <_Z6runcmdPc+0xa0>
  80024a:	83 f8 3e             	cmp    $0x3e,%eax
  80024d:	0f 84 e8 00 00 00    	je     80033b <_Z6runcmdPc+0x13c>
  800253:	c7 85 94 fb ff ff 00 	movl   $0x0,-0x46c(%ebp)
  80025a:	00 00 00 
  80025d:	85 c0                	test   %eax,%eax
  80025f:	0f 84 dd 02 00 00    	je     800542 <_Z6runcmdPc+0x343>
  800265:	e9 b8 02 00 00       	jmp    800522 <_Z6runcmdPc+0x323>
  80026a:	83 f8 7c             	cmp    $0x7c,%eax
  80026d:	0f 85 af 02 00 00    	jne    800522 <_Z6runcmdPc+0x323>
  800273:	e9 8e 01 00 00       	jmp    800406 <_Z6runcmdPc+0x207>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  800278:	83 ff 10             	cmp    $0x10,%edi
  80027b:	90                   	nop
  80027c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800280:	75 11                	jne    800293 <_Z6runcmdPc+0x94>
				cprintf("too many arguments\n");
  800282:	c7 04 24 a5 58 80 00 	movl   $0x8058a5,(%esp)
  800289:	e8 00 0a 00 00       	call   800c8e <_Z7cprintfPKcz>
				exit();
  80028e:	e8 c1 08 00 00       	call   800b54 <_Z4exitv>
			}
			argv[argc++] = t;
  800293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800296:	89 44 bd 9c          	mov    %eax,-0x64(%ebp,%edi,4)
  80029a:	83 c7 01             	add    $0x1,%edi
			break;
  80029d:	eb 8c                	jmp    80022b <_Z6runcmdPc+0x2c>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80029f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002aa:	e8 e1 fe ff ff       	call   800190 <_Z8gettokenPcPS_>
  8002af:	83 f8 77             	cmp    $0x77,%eax
  8002b2:	74 11                	je     8002c5 <_Z6runcmdPc+0xc6>
				cprintf("syntax error: < not followed by word\n");
  8002b4:	c7 04 24 08 5a 80 00 	movl   $0x805a08,(%esp)
  8002bb:	e8 ce 09 00 00       	call   800c8e <_Z7cprintfPKcz>
				exit();
  8002c0:	e8 8f 08 00 00       	call   800b54 <_Z4exitv>
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
            if((fd = open(t, O_RDONLY)) < 0)
  8002c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002cc:	00 
  8002cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 36 39 00 00       	call   803c0e <_Z4openPKci>
  8002d8:	89 c3                	mov    %eax,%ebx
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 17                	jns    8002f5 <_Z6runcmdPc+0xf6>
            {
                cprintf("open: %e\n", fd);
  8002de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e2:	c7 04 24 b9 58 80 00 	movl   $0x8058b9,(%esp)
  8002e9:	e8 a0 09 00 00       	call   800c8e <_Z7cprintfPKcz>
                exit();
  8002ee:	e8 61 08 00 00       	call   800b54 <_Z4exitv>
  8002f3:	eb 08                	jmp    8002fd <_Z6runcmdPc+0xfe>
            }
			if (fd)
  8002f5:	85 c0                	test   %eax,%eax
  8002f7:	0f 84 2e ff ff ff    	je     80022b <_Z6runcmdPc+0x2c>
            {
                if ((r = dup(fd, 0)) < 0)
  8002fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800304:	00 
  800305:	89 1c 24             	mov    %ebx,(%esp)
  800308:	e8 23 2b 00 00       	call   802e30 <_Z3dupii>
  80030d:	85 c0                	test   %eax,%eax
  80030f:	79 1d                	jns    80032e <_Z6runcmdPc+0x12f>
                {
                    cprintf("dup: %e\n", r);
  800311:	89 44 24 04          	mov    %eax,0x4(%esp)
  800315:	c7 04 24 c3 58 80 00 	movl   $0x8058c3,(%esp)
  80031c:	e8 6d 09 00 00       	call   800c8e <_Z7cprintfPKcz>
                    close(fd);
  800321:	89 1c 24             	mov    %ebx,(%esp)
  800324:	e8 ac 2a 00 00       	call   802dd5 <_Z5closei>
                    exit();
  800329:	e8 26 08 00 00       	call   800b54 <_Z4exitv>
                }
                close(fd);
  80032e:	89 1c 24             	mov    %ebx,(%esp)
  800331:	e8 9f 2a 00 00       	call   802dd5 <_Z5closei>
  800336:	e9 f0 fe ff ff       	jmp    80022b <_Z6runcmdPc+0x2c>
            }
            break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80033b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80033f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800346:	e8 45 fe ff ff       	call   800190 <_Z8gettokenPcPS_>
  80034b:	83 f8 77             	cmp    $0x77,%eax
  80034e:	74 11                	je     800361 <_Z6runcmdPc+0x162>
				cprintf("syntax error: > not followed by word\n");
  800350:	c7 04 24 30 5a 80 00 	movl   $0x805a30,(%esp)
  800357:	e8 32 09 00 00       	call   800c8e <_Z7cprintfPKcz>
				exit();
  80035c:	e8 f3 07 00 00       	call   800b54 <_Z4exitv>
			// If not, dup 'fd' onto file descriptor 1,
			// then close the original 'fd'.
			// Also, truncate fd.

			// LAB 5: Your code here.
            if((fd = open(t, O_WRONLY | O_CREAT)) < 0)
  800361:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  800368:	00 
  800369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036c:	89 04 24             	mov    %eax,(%esp)
  80036f:	e8 9a 38 00 00       	call   803c0e <_Z4openPKci>
  800374:	89 c3                	mov    %eax,%ebx
  800376:	85 c0                	test   %eax,%eax
  800378:	79 15                	jns    80038f <_Z6runcmdPc+0x190>
            {
                cprintf("open: %e\n", fd);
  80037a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037e:	c7 04 24 b9 58 80 00 	movl   $0x8058b9,(%esp)
  800385:	e8 04 09 00 00       	call   800c8e <_Z7cprintfPKcz>
                exit();
  80038a:	e8 c5 07 00 00       	call   800b54 <_Z4exitv>
            }
            if ((r = ftruncate(fd, 0)) < 0)
  80038f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800396:	00 
  800397:	89 1c 24             	mov    %ebx,(%esp)
  80039a:	e8 70 2d 00 00       	call   80310f <_Z9ftruncateii>
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	79 1d                	jns    8003c0 <_Z6runcmdPc+0x1c1>
            {
                cprintf("ftruncate: %e\n", r);
  8003a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a7:	c7 04 24 cc 58 80 00 	movl   $0x8058cc,(%esp)
  8003ae:	e8 db 08 00 00       	call   800c8e <_Z7cprintfPKcz>
                close(fd);
  8003b3:	89 1c 24             	mov    %ebx,(%esp)
  8003b6:	e8 1a 2a 00 00       	call   802dd5 <_Z5closei>
                exit();
  8003bb:	e8 94 07 00 00       	call   800b54 <_Z4exitv>
            }
			if (fd)
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	0f 84 63 fe ff ff    	je     80022b <_Z6runcmdPc+0x2c>
            {
                if ((r = dup(fd, 1)) < 0)
  8003c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003cf:	00 
  8003d0:	89 1c 24             	mov    %ebx,(%esp)
  8003d3:	e8 58 2a 00 00       	call   802e30 <_Z3dupii>
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	79 1d                	jns    8003f9 <_Z6runcmdPc+0x1fa>
                {
                    cprintf("dup: %e\n", r);
  8003dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e0:	c7 04 24 c3 58 80 00 	movl   $0x8058c3,(%esp)
  8003e7:	e8 a2 08 00 00       	call   800c8e <_Z7cprintfPKcz>
                    close(fd);
  8003ec:	89 1c 24             	mov    %ebx,(%esp)
  8003ef:	e8 e1 29 00 00       	call   802dd5 <_Z5closei>
                    exit();
  8003f4:	e8 5b 07 00 00       	call   800b54 <_Z4exitv>
                }
                close(fd);
  8003f9:	89 1c 24             	mov    %ebx,(%esp)
  8003fc:	e8 d4 29 00 00       	call   802dd5 <_Z5closei>
  800401:	e9 25 fe ff ff       	jmp    80022b <_Z6runcmdPc+0x2c>
	gettoken(s, 0);

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800406:	89 9d 90 fb ff ff    	mov    %ebx,-0x470(%ebp)
			//	Then close the pipe.
			//	Then 'goto runit', to execute this piece of
			//	the pipeline.

			// LAB 5: Your code here.
            if ((r = pipe(p)) < 0)
  80040c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80040f:	89 04 24             	mov    %eax,(%esp)
  800412:	e8 9d 45 00 00       	call   8049b4 <_Z4pipePi>
  800417:	85 c0                	test   %eax,%eax
  800419:	79 15                	jns    800430 <_Z6runcmdPc+0x231>
            {
                cprintf("pipe: %e\n", r);
  80041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041f:	c7 04 24 db 58 80 00 	movl   $0x8058db,(%esp)
  800426:	e8 63 08 00 00       	call   800c8e <_Z7cprintfPKcz>
                exit();
  80042b:	e8 24 07 00 00       	call   800b54 <_Z4exitv>
            } 
			if ((pipe_child = fork()) < 0)
  800430:	e8 78 1a 00 00       	call   801ead <_Z4forkv>
  800435:	89 85 94 fb ff ff    	mov    %eax,-0x46c(%ebp)
  80043b:	85 c0                	test   %eax,%eax
  80043d:	79 23                	jns    800462 <_Z6runcmdPc+0x263>
            {
                cprintf("sys_exofork: %e\n", pipe_child);
  80043f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800443:	c7 04 24 e5 58 80 00 	movl   $0x8058e5,(%esp)
  80044a:	e8 3f 08 00 00       	call   800c8e <_Z7cprintfPKcz>
                close(fd);
  80044f:	8b 95 90 fb ff ff    	mov    -0x470(%ebp),%edx
  800455:	89 14 24             	mov    %edx,(%esp)
  800458:	e8 78 29 00 00       	call   802dd5 <_Z5closei>
                exit();
  80045d:	e8 f2 06 00 00       	call   800b54 <_Z4exitv>
            }
            if (!pipe_child)
  800462:	83 bd 94 fb ff ff 00 	cmpl   $0x0,-0x46c(%ebp)
  800469:	75 5d                	jne    8004c8 <_Z6runcmdPc+0x2c9>
            {
                if ((r = dup(p[0], 0)) < 0)
  80046b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800472:	00 
  800473:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	e8 b2 29 00 00       	call   802e30 <_Z3dupii>
  80047e:	85 c0                	test   %eax,%eax
  800480:	79 2b                	jns    8004ad <_Z6runcmdPc+0x2ae>
                {
                    cprintf("dup: %e\n", r);
  800482:	89 44 24 04          	mov    %eax,0x4(%esp)
  800486:	c7 04 24 c3 58 80 00 	movl   $0x8058c3,(%esp)
  80048d:	e8 fc 07 00 00       	call   800c8e <_Z7cprintfPKcz>
                    close(p[0]);
  800492:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 38 29 00 00       	call   802dd5 <_Z5closei>
                    close(p[1]);
  80049d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a0:	89 04 24             	mov    %eax,(%esp)
  8004a3:	e8 2d 29 00 00       	call   802dd5 <_Z5closei>
                    exit();
  8004a8:	e8 a7 06 00 00       	call   800b54 <_Z4exitv>
                }
                close(p[0]);
  8004ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b0:	89 04 24             	mov    %eax,(%esp)
  8004b3:	e8 1d 29 00 00       	call   802dd5 <_Z5closei>
                close(p[1]);
  8004b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bb:	89 04 24             	mov    %eax,(%esp)
  8004be:	e8 12 29 00 00       	call   802dd5 <_Z5closei>
                goto again;
  8004c3:	e9 5e fd ff ff       	jmp    800226 <_Z6runcmdPc+0x27>
            }
            if ((r = dup(p[1], 1)) < 0)
  8004c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8004cf:	00 
  8004d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	e8 55 29 00 00       	call   802e30 <_Z3dupii>
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	79 2b                	jns    80050a <_Z6runcmdPc+0x30b>
            {
                cprintf("dup: %e\n", r);
  8004df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e3:	c7 04 24 c3 58 80 00 	movl   $0x8058c3,(%esp)
  8004ea:	e8 9f 07 00 00       	call   800c8e <_Z7cprintfPKcz>
                close(p[0]);
  8004ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f2:	89 04 24             	mov    %eax,(%esp)
  8004f5:	e8 db 28 00 00       	call   802dd5 <_Z5closei>
                close(p[1]);
  8004fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 d0 28 00 00       	call   802dd5 <_Z5closei>
                exit();
  800505:	e8 4a 06 00 00       	call   800b54 <_Z4exitv>
            }
            close(p[0]);
  80050a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 c0 28 00 00       	call   802dd5 <_Z5closei>
            close(p[1]);
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	89 04 24             	mov    %eax,(%esp)
  80051b:	e8 b5 28 00 00       	call   802dd5 <_Z5closei>
            goto runit;
  800520:	eb 20                	jmp    800542 <_Z6runcmdPc+0x343>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800522:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800526:	c7 44 24 08 f6 58 80 	movl   $0x8058f6,0x8(%esp)
  80052d:	00 
  80052e:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  800535:	00 
  800536:	c7 04 24 12 59 80 00 	movl   $0x805912,(%esp)
  80053d:	e8 2e 06 00 00       	call   800b70 <_Z6_panicPKciS0_z>
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  800542:	85 ff                	test   %edi,%edi
  800544:	75 1e                	jne    800564 <_Z6runcmdPc+0x365>
		if (debug)
  800546:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80054d:	0f 84 8f 01 00 00    	je     8006e2 <_Z6runcmdPc+0x4e3>
			cprintf("EMPTY COMMAND\n");
  800553:	c7 04 24 1c 59 80 00 	movl   $0x80591c,(%esp)
  80055a:	e8 2f 07 00 00       	call   800c8e <_Z7cprintfPKcz>
  80055f:	e9 7e 01 00 00       	jmp    8006e2 <_Z6runcmdPc+0x4e3>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800564:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800567:	80 38 2f             	cmpb   $0x2f,(%eax)
  80056a:	74 22                	je     80058e <_Z6runcmdPc+0x38f>
		argv0buf[0] = '/';
  80056c:	c6 85 9c fb ff ff 2f 	movb   $0x2f,-0x464(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800573:	89 44 24 04          	mov    %eax,0x4(%esp)
  800577:	8d 9d 9c fb ff ff    	lea    -0x464(%ebp),%ebx
  80057d:	8d 85 9d fb ff ff    	lea    -0x463(%ebp),%eax
  800583:	89 04 24             	mov    %eax,(%esp)
  800586:	e8 ff 0d 00 00       	call   80138a <_Z6strcpyPcPKc>
		argv[0] = argv0buf;
  80058b:	89 5d 9c             	mov    %ebx,-0x64(%ebp)
	}
	argv[argc] = 0;
  80058e:	c7 44 bd 9c 00 00 00 	movl   $0x0,-0x64(%ebp,%edi,4)
  800595:	00 

	// Print the command.
	if (debug) {
  800596:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80059d:	74 47                	je     8005e6 <_Z6runcmdPc+0x3e7>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80059f:	a1 14 80 80 00       	mov    0x808014,%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ab:	c7 04 24 2b 59 80 00 	movl   $0x80592b,(%esp)
  8005b2:	e8 d7 06 00 00       	call   800c8e <_Z7cprintfPKcz>
		for (i = 0; argv[i]; i++)
  8005b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005ba:	85 c0                	test   %eax,%eax
  8005bc:	74 1c                	je     8005da <_Z6runcmdPc+0x3db>
  8005be:	8d 5d a0             	lea    -0x60(%ebp),%ebx
			cprintf(" %s", argv[i]);
  8005c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c5:	c7 04 24 c1 59 80 00 	movl   $0x8059c1,(%esp)
  8005cc:	e8 bd 06 00 00       	call   800c8e <_Z7cprintfPKcz>
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  8005d1:	8b 03                	mov    (%ebx),%eax
  8005d3:	83 c3 04             	add    $0x4,%ebx
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	75 e7                	jne    8005c1 <_Z6runcmdPc+0x3c2>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  8005da:	c7 04 24 80 58 80 00 	movl   $0x805880,(%esp)
  8005e1:	e8 a8 06 00 00       	call   800c8e <_Z7cprintfPKcz>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8005e6:	8d 45 9c             	lea    -0x64(%ebp),%eax
  8005e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	e8 05 1e 00 00       	call   8023fd <_Z5spawnPKcPS0_>
  8005f8:	89 c3                	mov    %eax,%ebx
  8005fa:	85 c0                	test   %eax,%eax
  8005fc:	79 1e                	jns    80061c <_Z6runcmdPc+0x41d>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800602:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800605:	89 44 24 04          	mov    %eax,0x4(%esp)
  800609:	c7 04 24 39 59 80 00 	movl   $0x805939,(%esp)
  800610:	e8 79 06 00 00       	call   800c8e <_Z7cprintfPKcz>

	// In the parent of the spawned command, close all file descriptors
	// and wait for the spawned command to exit.
	close_all();
  800615:	e8 f4 27 00 00       	call   802e0e <_Z9close_allv>
  80061a:	eb 5e                	jmp    80067a <_Z6runcmdPc+0x47b>
  80061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800620:	e8 e9 27 00 00       	call   802e0e <_Z9close_allv>
	if (r >= 0) {
		if (debug)
  800625:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80062c:	74 23                	je     800651 <_Z6runcmdPc+0x452>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80062e:	a1 14 80 80 00       	mov    0x808014,%eax
  800633:	8b 40 04             	mov    0x4(%eax),%eax
  800636:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80063a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80063d:	89 54 24 08          	mov    %edx,0x8(%esp)
  800641:	89 44 24 04          	mov    %eax,0x4(%esp)
  800645:	c7 04 24 47 59 80 00 	movl   $0x805947,(%esp)
  80064c:	e8 3d 06 00 00       	call   800c8e <_Z7cprintfPKcz>
		wait(r);
  800651:	89 1c 24             	mov    %ebx,(%esp)
  800654:	e8 f7 47 00 00       	call   804e50 <_Z4waiti>
		if (debug)
  800659:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  800660:	74 18                	je     80067a <_Z6runcmdPc+0x47b>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800662:	a1 14 80 80 00       	mov    0x808014,%eax
  800667:	8b 40 04             	mov    0x4(%eax),%eax
  80066a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066e:	c7 04 24 5c 59 80 00 	movl   $0x80595c,(%esp)
  800675:	e8 14 06 00 00       	call   800c8e <_Z7cprintfPKcz>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  80067a:	83 bd 94 fb ff ff 00 	cmpl   $0x0,-0x46c(%ebp)
  800681:	74 5a                	je     8006dd <_Z6runcmdPc+0x4de>
		if (debug)
  800683:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80068a:	74 22                	je     8006ae <_Z6runcmdPc+0x4af>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80068c:	a1 14 80 80 00       	mov    0x808014,%eax
  800691:	8b 40 04             	mov    0x4(%eax),%eax
  800694:	8b 95 94 fb ff ff    	mov    -0x46c(%ebp),%edx
  80069a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80069e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a2:	c7 04 24 72 59 80 00 	movl   $0x805972,(%esp)
  8006a9:	e8 e0 05 00 00       	call   800c8e <_Z7cprintfPKcz>
		wait(pipe_child);
  8006ae:	8b 85 94 fb ff ff    	mov    -0x46c(%ebp),%eax
  8006b4:	89 04 24             	mov    %eax,(%esp)
  8006b7:	e8 94 47 00 00       	call   804e50 <_Z4waiti>
		if (debug)
  8006bc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8006c3:	74 18                	je     8006dd <_Z6runcmdPc+0x4de>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8006c5:	a1 14 80 80 00       	mov    0x808014,%eax
  8006ca:	8b 40 04             	mov    0x4(%eax),%eax
  8006cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d1:	c7 04 24 5c 59 80 00 	movl   $0x80595c,(%esp)
  8006d8:	e8 b1 05 00 00       	call   800c8e <_Z7cprintfPKcz>
	}

	// Done!
	exit();
  8006dd:	e8 72 04 00 00       	call   800b54 <_Z4exitv>
}
  8006e2:	81 c4 7c 04 00 00    	add    $0x47c,%esp
  8006e8:	5b                   	pop    %ebx
  8006e9:	5e                   	pop    %esi
  8006ea:	5f                   	pop    %edi
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    

008006ed <_Z5usagev>:
}


void
usage(void)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  8006f3:	c7 04 24 58 5a 80 00 	movl   $0x805a58,(%esp)
  8006fa:	e8 8f 05 00 00       	call   800c8e <_Z7cprintfPKcz>
	exit();
  8006ff:	e8 50 04 00 00       	call   800b54 <_Z4exitv>
}
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	57                   	push   %edi
  80070a:	56                   	push   %esi
  80070b:	53                   	push   %ebx
  80070c:	83 ec 4c             	sub    $0x4c,%esp
  80070f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;
	cprintf("[%08x] sh\n", thisenv->env_id);
  800712:	a1 14 80 80 00       	mov    0x808014,%eax
  800717:	8b 40 04             	mov    0x4(%eax),%eax
  80071a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071e:	c7 04 24 92 59 80 00 	movl   $0x805992,(%esp)
  800725:	e8 64 05 00 00       	call   800c8e <_Z7cprintfPKcz>

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  80072a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80072d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800731:	89 74 24 04          	mov    %esi,0x4(%esp)
  800735:	8d 45 08             	lea    0x8(%ebp),%eax
  800738:	89 04 24             	mov    %eax,(%esp)
  80073b:	e8 a0 22 00 00       	call   8029e0 <_Z8argstartPiPPcP8Argstate>
	int r, interactive, echocmds;
	struct Argstate args;
	cprintf("[%08x] sh\n", thisenv->env_id);

	interactive = '?';
	echocmds = 0;
  800740:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
	int r, interactive, echocmds;
	struct Argstate args;
	cprintf("[%08x] sh\n", thisenv->env_id);

	interactive = '?';
  800747:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  80074c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80074f:	eb 31                	jmp    800782 <_Z5umainiPPc+0x7c>
		switch (r) {
  800751:	83 f8 69             	cmp    $0x69,%eax
  800754:	74 0e                	je     800764 <_Z5umainiPPc+0x5e>
  800756:	83 f8 78             	cmp    $0x78,%eax
  800759:	74 20                	je     80077b <_Z5umainiPPc+0x75>
  80075b:	83 f8 64             	cmp    $0x64,%eax
  80075e:	66 90                	xchg   %ax,%ax
  800760:	75 12                	jne    800774 <_Z5umainiPPc+0x6e>
  800762:	eb 07                	jmp    80076b <_Z5umainiPPc+0x65>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  800764:	bf 01 00 00 00       	mov    $0x1,%edi
  800769:	eb 17                	jmp    800782 <_Z5umainiPPc+0x7c>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  80076b:	83 05 00 80 80 00 01 	addl   $0x1,0x808000
			break;
  800772:	eb 0e                	jmp    800782 <_Z5umainiPPc+0x7c>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  800774:	e8 74 ff ff ff       	call   8006ed <_Z5usagev>
  800779:	eb 07                	jmp    800782 <_Z5umainiPPc+0x7c>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  80077b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	cprintf("[%08x] sh\n", thisenv->env_id);

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800782:	89 1c 24             	mov    %ebx,(%esp)
  800785:	e8 86 22 00 00       	call   802a10 <_Z7argnextP8Argstate>
  80078a:	85 c0                	test   %eax,%eax
  80078c:	79 c3                	jns    800751 <_Z5umainiPPc+0x4b>
  80078e:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  800790:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800794:	7e 05                	jle    80079b <_Z5umainiPPc+0x95>
		usage();
  800796:	e8 52 ff ff ff       	call   8006ed <_Z5usagev>
	if (argc == 2) {
  80079b:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80079f:	75 72                	jne    800813 <_Z5umainiPPc+0x10d>
		close(0);
  8007a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007a8:	e8 28 26 00 00       	call   802dd5 <_Z5closei>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8007ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8007b4:	00 
  8007b5:	8b 46 04             	mov    0x4(%esi),%eax
  8007b8:	89 04 24             	mov    %eax,(%esp)
  8007bb:	e8 4e 34 00 00       	call   803c0e <_Z4openPKci>
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	79 27                	jns    8007eb <_Z5umainiPPc+0xe5>
			panic("open %s: %e", argv[1], r);
  8007c4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007c8:	8b 46 04             	mov    0x4(%esi),%eax
  8007cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cf:	c7 44 24 08 9d 59 80 	movl   $0x80599d,0x8(%esp)
  8007d6:	00 
  8007d7:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  8007de:	00 
  8007df:	c7 04 24 12 59 80 00 	movl   $0x805912,(%esp)
  8007e6:	e8 85 03 00 00       	call   800b70 <_Z6_panicPKciS0_z>
		assert(r == 0);
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	74 24                	je     800813 <_Z5umainiPPc+0x10d>
  8007ef:	c7 44 24 0c a9 59 80 	movl   $0x8059a9,0xc(%esp)
  8007f6:	00 
  8007f7:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  8007fe:	00 
  8007ff:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
  800806:	00 
  800807:	c7 04 24 12 59 80 00 	movl   $0x805912,(%esp)
  80080e:	e8 5d 03 00 00       	call   800b70 <_Z6_panicPKciS0_z>
	}
	if (interactive == '?') {
  800813:	83 fb 3f             	cmp    $0x3f,%ebx
  800816:	75 36                	jne    80084e <_Z5umainiPPc+0x148>
		interactive = iscons(0);
  800818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80081f:	e8 3e 02 00 00       	call   800a62 <_Z6isconsi>
  800824:	89 c7                	mov    %eax,%edi
		assert(interactive >= 0);
  800826:	85 c0                	test   %eax,%eax
  800828:	79 24                	jns    80084e <_Z5umainiPPc+0x148>
  80082a:	c7 44 24 0c c5 59 80 	movl   $0x8059c5,0xc(%esp)
  800831:	00 
  800832:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  800839:	00 
  80083a:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
  800841:	00 
  800842:	c7 04 24 12 59 80 00 	movl   $0x805912,(%esp)
  800849:	e8 22 03 00 00       	call   800b70 <_Z6_panicPKciS0_z>
	}

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  80084e:	85 ff                	test   %edi,%edi
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	ba 8f 59 80 00       	mov    $0x80598f,%edx
  80085a:	0f 45 c2             	cmovne %edx,%eax
  80085d:	89 04 24             	mov    %eax,(%esp)
  800860:	e8 0b 0a 00 00       	call   801270 <_Z8readlinePKc>
  800865:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800867:	85 c0                	test   %eax,%eax
  800869:	75 1a                	jne    800885 <_Z5umainiPPc+0x17f>
			if (debug)
  80086b:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  800872:	74 0c                	je     800880 <_Z5umainiPPc+0x17a>
				cprintf("EXITING\n");
  800874:	c7 04 24 d6 59 80 00 	movl   $0x8059d6,(%esp)
  80087b:	e8 0e 04 00 00       	call   800c8e <_Z7cprintfPKcz>
			exit();	// end of file
  800880:	e8 cf 02 00 00       	call   800b54 <_Z4exitv>
		}
		if (debug)
  800885:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80088c:	74 10                	je     80089e <_Z5umainiPPc+0x198>
			cprintf("LINE: %s\n", buf);
  80088e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800892:	c7 04 24 df 59 80 00 	movl   $0x8059df,(%esp)
  800899:	e8 f0 03 00 00       	call   800c8e <_Z7cprintfPKcz>
		if (buf[0] == '#')
  80089e:	80 3b 23             	cmpb   $0x23,(%ebx)
  8008a1:	74 ab                	je     80084e <_Z5umainiPPc+0x148>
			continue;
		if (echocmds)
  8008a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008a7:	74 18                	je     8008c1 <_Z5umainiPPc+0x1bb>
			fprintf(1, "# %s\n", buf);
  8008a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008ad:	c7 44 24 04 e9 59 80 	movl   $0x8059e9,0x4(%esp)
  8008b4:	00 
  8008b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8008bc:	e8 0f 45 00 00       	call   804dd0 <_Z7fprintfiPKcz>
		if (debug)
  8008c1:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8008c8:	74 0c                	je     8008d6 <_Z5umainiPPc+0x1d0>
			cprintf("BEFORE FORK\n");
  8008ca:	c7 04 24 ef 59 80 00 	movl   $0x8059ef,(%esp)
  8008d1:	e8 b8 03 00 00       	call   800c8e <_Z7cprintfPKcz>
		if ((r = fork()) < 0)
  8008d6:	e8 d2 15 00 00       	call   801ead <_Z4forkv>
  8008db:	89 c6                	mov    %eax,%esi
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	79 20                	jns    800901 <_Z5umainiPPc+0x1fb>
			panic("fork: %e", r);
  8008e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e5:	c7 44 24 08 98 5e 80 	movl   $0x805e98,0x8(%esp)
  8008ec:	00 
  8008ed:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  8008f4:	00 
  8008f5:	c7 04 24 12 59 80 00 	movl   $0x805912,(%esp)
  8008fc:	e8 6f 02 00 00       	call   800b70 <_Z6_panicPKciS0_z>
		if (debug)
  800901:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  800908:	74 10                	je     80091a <_Z5umainiPPc+0x214>
			cprintf("FORK: %d\n", r);
  80090a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090e:	c7 04 24 fc 59 80 00 	movl   $0x8059fc,(%esp)
  800915:	e8 74 03 00 00       	call   800c8e <_Z7cprintfPKcz>
		if (r == 0) {
  80091a:	85 f6                	test   %esi,%esi
  80091c:	75 12                	jne    800930 <_Z5umainiPPc+0x22a>
			runcmd(buf);
  80091e:	89 1c 24             	mov    %ebx,(%esp)
  800921:	e8 d9 f8 ff ff       	call   8001ff <_Z6runcmdPc>
			exit();
  800926:	e8 29 02 00 00       	call   800b54 <_Z4exitv>
  80092b:	e9 1e ff ff ff       	jmp    80084e <_Z5umainiPPc+0x148>
		} else
			wait(r);
  800930:	89 34 24             	mov    %esi,(%esp)
  800933:	e8 18 45 00 00       	call   804e50 <_Z4waiti>
  800938:	e9 11 ff ff ff       	jmp    80084e <_Z5umainiPPc+0x148>
  80093d:	00 00                	add    %al,(%eax)
	...

00800940 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800950:	c7 44 24 04 79 5a 80 	movl   $0x805a79,0x4(%esp)
  800957:	00 
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	89 04 24             	mov    %eax,(%esp)
  80095e:	e8 27 0a 00 00       	call   80138a <_Z6strcpyPcPKc>
	return 0;
}
  800963:	b8 00 00 00 00       	mov    $0x0,%eax
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	57                   	push   %edi
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800976:	bb 00 00 00 00       	mov    $0x0,%ebx
  80097b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80097f:	74 3e                	je     8009bf <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800981:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800987:	8b 75 10             	mov    0x10(%ebp),%esi
  80098a:	29 de                	sub    %ebx,%esi
  80098c:	83 fe 7f             	cmp    $0x7f,%esi
  80098f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800994:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800997:	89 74 24 08          	mov    %esi,0x8(%esp)
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099e:	01 d8                	add    %ebx,%eax
  8009a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a4:	89 3c 24             	mov    %edi,(%esp)
  8009a7:	e8 80 0b 00 00       	call   80152c <memmove>
		sys_cputs(buf, m);
  8009ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009b0:	89 3c 24             	mov    %edi,(%esp)
  8009b3:	e8 8c 0d 00 00       	call   801744 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8009b8:	01 f3                	add    %esi,%ebx
  8009ba:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8009bd:	77 c8                	ja     800987 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8009bf:	89 d8                	mov    %ebx,%eax
  8009c1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8009d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009db:	75 07                	jne    8009e4 <_ZL12devcons_readP2FdPvj+0x18>
  8009dd:	eb 2a                	jmp    800a09 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8009df:	e8 58 0e 00 00       	call   80183c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8009e4:	e8 8e 0d 00 00       	call   801777 <_Z9sys_cgetcv>
  8009e9:	85 c0                	test   %eax,%eax
  8009eb:	74 f2                	je     8009df <_ZL12devcons_readP2FdPvj+0x13>
  8009ed:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	78 16                	js     800a09 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8009f3:	83 f8 04             	cmp    $0x4,%eax
  8009f6:	74 0c                	je     800a04 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	88 10                	mov    %dl,(%eax)
	return 1;
  8009fd:	b8 01 00 00 00       	mov    $0x1,%eax
  800a02:	eb 05                	jmp    800a09 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800a17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800a1e:	00 
  800a1f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	e8 1a 0d 00 00       	call   801744 <_Z9sys_cputsPKcj>
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <_Z7getcharv>:

int
getchar(void)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800a32:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a39:	00 
  800a3a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a48:	e8 31 25 00 00       	call   802f7e <_Z4readiPvj>
	if (r < 0)
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	78 0f                	js     800a60 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  800a51:	85 c0                	test   %eax,%eax
  800a53:	7e 06                	jle    800a5b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  800a55:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800a59:	eb 05                	jmp    800a60 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800a5b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  800a68:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a6f:	00 
  800a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	89 04 24             	mov    %eax,(%esp)
  800a7d:	e8 4f 21 00 00       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  800a82:	85 c0                	test   %eax,%eax
  800a84:	78 11                	js     800a97 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  800a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a89:	8b 15 00 70 80 00    	mov    0x807000,%edx
  800a8f:	39 10                	cmp    %edx,(%eax)
  800a91:	0f 94 c0             	sete   %al
  800a94:	0f b6 c0             	movzbl %al,%eax
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <_Z8openconsv>:

int
opencons(void)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  800a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aa2:	89 04 24             	mov    %eax,(%esp)
  800aa5:	e8 dd 21 00 00       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	78 3c                	js     800aea <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800aae:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ab5:	00 
  800ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ac4:	e8 a7 0d 00 00       	call   801870 <_Z14sys_page_allociPvi>
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	78 1d                	js     800aea <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800acd:	8b 15 00 70 80 00    	mov    0x807000,%edx
  800ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800adb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 3a 21 00 00       	call   802c24 <_Z6fd2numP2Fd>
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	83 ec 1c             	sub    $0x1c,%esp
  800af5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af8:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800afb:	e8 08 0d 00 00       	call   801808 <_Z12sys_getenvidv>
  800b00:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b05:	6b c0 78             	imul   $0x78,%eax,%eax
  800b08:	05 00 00 00 ef       	add    $0xef000000,%eax
  800b0d:	a3 14 80 80 00       	mov    %eax,0x808014
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b12:	85 ff                	test   %edi,%edi
  800b14:	7e 07                	jle    800b1d <libmain+0x31>
		binaryname = argv[0];
  800b16:	8b 06                	mov    (%esi),%eax
  800b18:	a3 1c 70 80 00       	mov    %eax,0x80701c

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800b1d:	b8 a5 66 80 00       	mov    $0x8066a5,%eax
  800b22:	3d a5 66 80 00       	cmp    $0x8066a5,%eax
  800b27:	76 0f                	jbe    800b38 <libmain+0x4c>
  800b29:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800b2b:	83 eb 04             	sub    $0x4,%ebx
  800b2e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800b30:	81 fb a5 66 80 00    	cmp    $0x8066a5,%ebx
  800b36:	77 f3                	ja     800b2b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800b38:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b3c:	89 3c 24             	mov    %edi,(%esp)
  800b3f:	e8 c2 fb ff ff       	call   800706 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800b44:	e8 0b 00 00 00       	call   800b54 <_Z4exitv>
}
  800b49:	83 c4 1c             	add    $0x1c,%esp
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    
  800b51:	00 00                	add    %al,(%eax)
	...

00800b54 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800b5a:	e8 af 22 00 00       	call   802e0e <_Z9close_allv>
	sys_env_destroy(0);
  800b5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b66:	e8 40 0c 00 00       	call   8017ab <_Z15sys_env_destroyi>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    
  800b6d:	00 00                	add    %al,(%eax)
	...

00800b70 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800b78:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800b7b:	a1 18 80 80 00       	mov    0x808018,%eax
  800b80:	85 c0                	test   %eax,%eax
  800b82:	74 10                	je     800b94 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b88:	c7 04 24 8f 5a 80 00 	movl   $0x805a8f,(%esp)
  800b8f:	e8 fa 00 00 00       	call   800c8e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800b94:	8b 1d 1c 70 80 00    	mov    0x80701c,%ebx
  800b9a:	e8 69 0c 00 00       	call   801808 <_Z12sys_getenvidv>
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba2:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb5:	c7 04 24 94 5a 80 00 	movl   $0x805a94,(%esp)
  800bbc:	e8 cd 00 00 00       	call   800c8e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800bc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc8:	89 04 24             	mov    %eax,(%esp)
  800bcb:	e8 5d 00 00 00       	call   800c2d <_Z8vcprintfPKcPc>
	cprintf("\n");
  800bd0:	c7 04 24 80 58 80 00 	movl   $0x805880,(%esp)
  800bd7:	e8 b2 00 00 00       	call   800c8e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bdc:	cc                   	int3   
  800bdd:	eb fd                	jmp    800bdc <_Z6_panicPKciS0_z+0x6c>
	...

00800be0 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 18             	sub    $0x18,%esp
  800be6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800be9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800bef:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800bf1:	8b 03                	mov    (%ebx),%eax
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800bfa:	83 c0 01             	add    $0x1,%eax
  800bfd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800bff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c04:	75 19                	jne    800c1f <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800c06:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800c0d:	00 
  800c0e:	8d 43 08             	lea    0x8(%ebx),%eax
  800c11:	89 04 24             	mov    %eax,(%esp)
  800c14:	e8 2b 0b 00 00       	call   801744 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800c19:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800c1f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800c23:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800c26:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800c29:	89 ec                	mov    %ebp,%esp
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800c36:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c3d:	00 00 00 
	b.cnt = 0;
  800c40:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c47:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c58:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c62:	c7 04 24 e0 0b 80 00 	movl   $0x800be0,(%esp)
  800c69:	e8 a9 01 00 00       	call   800e17 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800c6e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c78:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800c7e:	89 04 24             	mov    %eax,(%esp)
  800c81:	e8 be 0a 00 00       	call   801744 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800c86:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c94:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 04 24             	mov    %eax,(%esp)
  800ca1:	e8 87 ff ff ff       	call   800c2d <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    
	...

00800cb0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 4c             	sub    $0x4c,%esp
  800cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cbc:	89 d6                	mov    %edx,%esi
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800cca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800ccd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd5:	39 d0                	cmp    %edx,%eax
  800cd7:	72 11                	jb     800cea <_ZL8printnumPFviPvES_yjii+0x3a>
  800cd9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800cdc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  800cdf:	76 09                	jbe    800cea <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ce1:	83 eb 01             	sub    $0x1,%ebx
  800ce4:	85 db                	test   %ebx,%ebx
  800ce6:	7f 5d                	jg     800d45 <_ZL8printnumPFviPvES_yjii+0x95>
  800ce8:	eb 6c                	jmp    800d56 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cea:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800cee:	83 eb 01             	sub    $0x1,%ebx
  800cf1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  800d00:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800d04:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d07:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800d0a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800d11:	00 
  800d12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800d15:	89 14 24             	mov    %edx,(%esp)
  800d18:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d1f:	e8 cc 48 00 00       	call   8055f0 <__udivdi3>
  800d24:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800d27:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800d2a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d2e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d32:	89 04 24             	mov    %eax,(%esp)
  800d35:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d39:	89 f2                	mov    %esi,%edx
  800d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d3e:	e8 6d ff ff ff       	call   800cb0 <_ZL8printnumPFviPvES_yjii>
  800d43:	eb 11                	jmp    800d56 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d49:	89 3c 24             	mov    %edi,(%esp)
  800d4c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d4f:	83 eb 01             	sub    $0x1,%ebx
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	7f ef                	jg     800d45 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d56:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d5a:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d65:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800d6c:	00 
  800d6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800d70:	89 14 24             	mov    %edx,(%esp)
  800d73:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800d76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d7a:	e8 81 49 00 00       	call   805700 <__umoddi3>
  800d7f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d83:	0f be 80 b7 5a 80 00 	movsbl 0x805ab7(%eax),%eax
  800d8a:	89 04 24             	mov    %eax,(%esp)
  800d8d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800d90:	83 c4 4c             	add    $0x4c,%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d9b:	83 fa 01             	cmp    $0x1,%edx
  800d9e:	7e 0e                	jle    800dae <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800da0:	8b 10                	mov    (%eax),%edx
  800da2:	8d 4a 08             	lea    0x8(%edx),%ecx
  800da5:	89 08                	mov    %ecx,(%eax)
  800da7:	8b 02                	mov    (%edx),%eax
  800da9:	8b 52 04             	mov    0x4(%edx),%edx
  800dac:	eb 22                	jmp    800dd0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  800dae:	85 d2                	test   %edx,%edx
  800db0:	74 10                	je     800dc2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800db2:	8b 10                	mov    (%eax),%edx
  800db4:	8d 4a 04             	lea    0x4(%edx),%ecx
  800db7:	89 08                	mov    %ecx,(%eax)
  800db9:	8b 02                	mov    (%edx),%eax
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	eb 0e                	jmp    800dd0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800dc2:	8b 10                	mov    (%eax),%edx
  800dc4:	8d 4a 04             	lea    0x4(%edx),%ecx
  800dc7:	89 08                	mov    %ecx,(%eax)
  800dc9:	8b 02                	mov    (%edx),%eax
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800dd8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800ddc:	8b 10                	mov    (%eax),%edx
  800dde:	3b 50 04             	cmp    0x4(%eax),%edx
  800de1:	73 0a                	jae    800ded <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800de3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de6:	88 0a                	mov    %cl,(%edx)
  800de8:	83 c2 01             	add    $0x1,%edx
  800deb:	89 10                	mov    %edx,(%eax)
}
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800df5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800df8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	89 04 24             	mov    %eax,(%esp)
  800e10:	e8 02 00 00 00       	call   800e17 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 3c             	sub    $0x3c,%esp
  800e20:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e23:	8b 55 10             	mov    0x10(%ebp),%edx
  800e26:	0f b6 02             	movzbl (%edx),%eax
  800e29:	89 d3                	mov    %edx,%ebx
  800e2b:	83 c3 01             	add    $0x1,%ebx
  800e2e:	83 f8 25             	cmp    $0x25,%eax
  800e31:	74 2b                	je     800e5e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800e33:	85 c0                	test   %eax,%eax
  800e35:	75 10                	jne    800e47 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800e37:	e9 a5 03 00 00       	jmp    8011e1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	66 90                	xchg   %ax,%ax
  800e40:	75 08                	jne    800e4a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800e42:	e9 9a 03 00 00       	jmp    8011e1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800e47:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  800e4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e4e:	89 04 24             	mov    %eax,(%esp)
  800e51:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e53:	0f b6 03             	movzbl (%ebx),%eax
  800e56:	83 c3 01             	add    $0x1,%ebx
  800e59:	83 f8 25             	cmp    $0x25,%eax
  800e5c:	75 de                	jne    800e3c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800e5e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800e62:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800e69:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800e6e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800e75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800e7d:	eb 2b                	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800e82:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800e86:	eb 22                	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e8b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800e8f:	eb 19                	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e91:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800e94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e9b:	eb 0d                	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800e9d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800ea0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800ea3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eaa:	0f b6 03             	movzbl (%ebx),%eax
  800ead:	0f b6 d0             	movzbl %al,%edx
  800eb0:	8d 73 01             	lea    0x1(%ebx),%esi
  800eb3:	89 75 10             	mov    %esi,0x10(%ebp)
  800eb6:	83 e8 23             	sub    $0x23,%eax
  800eb9:	3c 55                	cmp    $0x55,%al
  800ebb:	0f 87 d8 02 00 00    	ja     801199 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800ec1:	0f b6 c0             	movzbl %al,%eax
  800ec4:	ff 24 85 60 5c 80 00 	jmp    *0x805c60(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800ecb:	83 ea 30             	sub    $0x30,%edx
  800ece:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800ed1:	8b 55 10             	mov    0x10(%ebp),%edx
  800ed4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800ed7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eda:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800edd:	83 fa 09             	cmp    $0x9,%edx
  800ee0:	77 4e                	ja     800f30 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ee2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800ee8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800eeb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800eef:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800ef2:	8d 50 d0             	lea    -0x30(%eax),%edx
  800ef5:	83 fa 09             	cmp    $0x9,%edx
  800ef8:	76 eb                	jbe    800ee5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  800efa:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800efd:	eb 31                	jmp    800f30 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eff:	8b 45 14             	mov    0x14(%ebp),%eax
  800f02:	8d 50 04             	lea    0x4(%eax),%edx
  800f05:	89 55 14             	mov    %edx,0x14(%ebp)
  800f08:	8b 00                	mov    (%eax),%eax
  800f0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800f10:	eb 1e                	jmp    800f30 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f16:	0f 88 75 ff ff ff    	js     800e91 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1f:	eb 89                	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800f24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f2b:	e9 7a ff ff ff       	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800f30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f34:	0f 89 70 ff ff ff    	jns    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800f3a:	e9 5e ff ff ff       	jmp    800e9d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f3f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f45:	e9 60 ff ff ff       	jmp    800eaa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	8d 50 04             	lea    0x4(%eax),%edx
  800f50:	89 55 14             	mov    %edx,0x14(%ebp)
  800f53:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f57:	8b 00                	mov    (%eax),%eax
  800f59:	89 04 24             	mov    %eax,(%esp)
  800f5c:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f5f:	e9 bf fe ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f64:	8b 45 14             	mov    0x14(%ebp),%eax
  800f67:	8d 50 04             	lea    0x4(%eax),%edx
  800f6a:	89 55 14             	mov    %edx,0x14(%ebp)
  800f6d:	8b 00                	mov    (%eax),%eax
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	c1 fa 1f             	sar    $0x1f,%edx
  800f74:	31 d0                	xor    %edx,%eax
  800f76:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f78:	83 f8 14             	cmp    $0x14,%eax
  800f7b:	7f 0f                	jg     800f8c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  800f7d:	8b 14 85 c0 5d 80 00 	mov    0x805dc0(,%eax,4),%edx
  800f84:	85 d2                	test   %edx,%edx
  800f86:	0f 85 35 02 00 00    	jne    8011c1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  800f8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f90:	c7 44 24 08 cf 5a 80 	movl   $0x805acf,0x8(%esp)
  800f97:	00 
  800f98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f9f:	89 34 24             	mov    %esi,(%esp)
  800fa2:	e8 48 fe ff ff       	call   800def <_Z8printfmtPFviPvES_PKcz>
  800fa7:	e9 77 fe ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800fac:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	8d 50 04             	lea    0x4(%eax),%edx
  800fbb:	89 55 14             	mov    %edx,0x14(%ebp)
  800fbe:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800fc0:	85 db                	test   %ebx,%ebx
  800fc2:	ba c8 5a 80 00       	mov    $0x805ac8,%edx
  800fc7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  800fca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800fce:	7e 72                	jle    801042 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800fd0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800fd4:	74 6c                	je     801042 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fda:	89 1c 24             	mov    %ebx,(%esp)
  800fdd:	e8 89 03 00 00       	call   80136b <_Z7strnlenPKcj>
  800fe2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800fe5:	29 c2                	sub    %eax,%edx
  800fe7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800fea:	85 d2                	test   %edx,%edx
  800fec:	7e 54                	jle    801042 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  800fee:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800ff2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800ff5:	89 d3                	mov    %edx,%ebx
  800ff7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800ffa:	89 c6                	mov    %eax,%esi
  800ffc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801000:	89 34 24             	mov    %esi,(%esp)
  801003:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801006:	83 eb 01             	sub    $0x1,%ebx
  801009:	85 db                	test   %ebx,%ebx
  80100b:	7f ef                	jg     800ffc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80100d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  801010:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801013:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80101a:	eb 26                	jmp    801042 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80101c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80101f:	83 fa 5e             	cmp    $0x5e,%edx
  801022:	76 10                	jbe    801034 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  801024:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801028:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80102f:	ff 55 08             	call   *0x8(%ebp)
  801032:	eb 0a                	jmp    80103e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  801034:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801038:	89 04 24             	mov    %eax,(%esp)
  80103b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80103e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801042:	0f be 03             	movsbl (%ebx),%eax
  801045:	83 c3 01             	add    $0x1,%ebx
  801048:	85 c0                	test   %eax,%eax
  80104a:	74 11                	je     80105d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80104c:	85 f6                	test   %esi,%esi
  80104e:	78 05                	js     801055 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  801050:	83 ee 01             	sub    $0x1,%esi
  801053:	78 0d                	js     801062 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  801055:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801059:	75 c1                	jne    80101c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80105b:	eb d7                	jmp    801034 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80105d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801060:	eb 03                	jmp    801065 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  801062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801065:	85 c0                	test   %eax,%eax
  801067:	0f 8e b6 fd ff ff    	jle    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80106d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801070:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  801073:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801077:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80107e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801080:	83 eb 01             	sub    $0x1,%ebx
  801083:	85 db                	test   %ebx,%ebx
  801085:	7f ec                	jg     801073 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  801087:	e9 97 fd ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80108c:	83 f9 01             	cmp    $0x1,%ecx
  80108f:	90                   	nop
  801090:	7e 10                	jle    8010a2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  801092:	8b 45 14             	mov    0x14(%ebp),%eax
  801095:	8d 50 08             	lea    0x8(%eax),%edx
  801098:	89 55 14             	mov    %edx,0x14(%ebp)
  80109b:	8b 18                	mov    (%eax),%ebx
  80109d:	8b 70 04             	mov    0x4(%eax),%esi
  8010a0:	eb 26                	jmp    8010c8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8010a2:	85 c9                	test   %ecx,%ecx
  8010a4:	74 12                	je     8010b8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8d 50 04             	lea    0x4(%eax),%edx
  8010ac:	89 55 14             	mov    %edx,0x14(%ebp)
  8010af:	8b 18                	mov    (%eax),%ebx
  8010b1:	89 de                	mov    %ebx,%esi
  8010b3:	c1 fe 1f             	sar    $0x1f,%esi
  8010b6:	eb 10                	jmp    8010c8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	8d 50 04             	lea    0x4(%eax),%edx
  8010be:	89 55 14             	mov    %edx,0x14(%ebp)
  8010c1:	8b 18                	mov    (%eax),%ebx
  8010c3:	89 de                	mov    %ebx,%esi
  8010c5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8010c8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8010cd:	85 f6                	test   %esi,%esi
  8010cf:	0f 89 8c 00 00 00    	jns    801161 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8010d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010d9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8010e0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8010e3:	f7 db                	neg    %ebx
  8010e5:	83 d6 00             	adc    $0x0,%esi
  8010e8:	f7 de                	neg    %esi
			}
			base = 10;
  8010ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ef:	eb 70                	jmp    801161 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010f1:	89 ca                	mov    %ecx,%edx
  8010f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f6:	e8 9d fc ff ff       	call   800d98 <_ZL7getuintPPci>
  8010fb:	89 c3                	mov    %eax,%ebx
  8010fd:	89 d6                	mov    %edx,%esi
			base = 10;
  8010ff:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  801104:	eb 5b                	jmp    801161 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801106:	89 ca                	mov    %ecx,%edx
  801108:	8d 45 14             	lea    0x14(%ebp),%eax
  80110b:	e8 88 fc ff ff       	call   800d98 <_ZL7getuintPPci>
  801110:	89 c3                	mov    %eax,%ebx
  801112:	89 d6                	mov    %edx,%esi
			base = 8;
  801114:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801119:	eb 46                	jmp    801161 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80111b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80111f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801126:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801129:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80112d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801134:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801137:	8b 45 14             	mov    0x14(%ebp),%eax
  80113a:	8d 50 04             	lea    0x4(%eax),%edx
  80113d:	89 55 14             	mov    %edx,0x14(%ebp)
  801140:	8b 18                	mov    (%eax),%ebx
  801142:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  801147:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80114c:	eb 13                	jmp    801161 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80114e:	89 ca                	mov    %ecx,%edx
  801150:	8d 45 14             	lea    0x14(%ebp),%eax
  801153:	e8 40 fc ff ff       	call   800d98 <_ZL7getuintPPci>
  801158:	89 c3                	mov    %eax,%ebx
  80115a:	89 d6                	mov    %edx,%esi
			base = 16;
  80115c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801161:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  801165:	89 54 24 10          	mov    %edx,0x10(%esp)
  801169:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80116c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801170:	89 44 24 08          	mov    %eax,0x8(%esp)
  801174:	89 1c 24             	mov    %ebx,(%esp)
  801177:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	e8 2b fb ff ff       	call   800cb0 <_ZL8printnumPFviPvES_yjii>
			break;
  801185:	e9 99 fc ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80118a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80118e:	89 14 24             	mov    %edx,(%esp)
  801191:	ff 55 08             	call   *0x8(%ebp)
			break;
  801194:	e9 8a fc ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801199:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80119d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8011a4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011a7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011aa:	89 d8                	mov    %ebx,%eax
  8011ac:	eb 02                	jmp    8011b0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8011ae:	89 d0                	mov    %edx,%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8011b7:	75 f5                	jne    8011ae <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8011b9:	89 45 10             	mov    %eax,0x10(%ebp)
  8011bc:	e9 62 fc ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8011c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011c5:	c7 44 24 08 c2 59 80 	movl   $0x8059c2,0x8(%esp)
  8011cc:	00 
  8011cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d4:	89 34 24             	mov    %esi,(%esp)
  8011d7:	e8 13 fc ff ff       	call   800def <_Z8printfmtPFviPvES_PKcz>
  8011dc:	e9 42 fc ff ff       	jmp    800e23 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011e1:	83 c4 3c             	add    $0x3c,%esp
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 28             	sub    $0x28,%esp
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8011fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011ff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801203:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  801206:	85 c0                	test   %eax,%eax
  801208:	74 30                	je     80123a <_Z9vsnprintfPciPKcS_+0x51>
  80120a:	85 d2                	test   %edx,%edx
  80120c:	7e 2c                	jle    80123a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80121c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80121f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801223:	c7 04 24 d2 0d 80 00 	movl   $0x800dd2,(%esp)
  80122a:	e8 e8 fb ff ff       	call   800e17 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80122f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801238:	eb 05                	jmp    80123f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801247:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80124a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 44 24 08          	mov    %eax,0x8(%esp)
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 04 24             	mov    %eax,(%esp)
  801262:	e8 82 ff ff ff       	call   8011e9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    
  801269:	00 00                	add    %al,(%eax)
  80126b:	00 00                	add    %al,(%eax)
  80126d:	00 00                	add    %al,(%eax)
	...

00801270 <_Z8readlinePKc>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	57                   	push   %edi
  801274:	56                   	push   %esi
  801275:	53                   	push   %ebx
  801276:	83 ec 1c             	sub    $0x1c,%esp
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  80127c:	85 c0                	test   %eax,%eax
  80127e:	74 10                	je     801290 <_Z8readlinePKc+0x20>
		cprintf("%s", prompt);
  801280:	89 44 24 04          	mov    %eax,0x4(%esp)
  801284:	c7 04 24 c2 59 80 00 	movl   $0x8059c2,(%esp)
  80128b:	e8 fe f9 ff ff       	call   800c8e <_Z7cprintfPKcz>

	i = 0;
	echoing = iscons(0) > 0;
  801290:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801297:	e8 c6 f7 ff ff       	call   800a62 <_Z6isconsi>
  80129c:	85 c0                	test   %eax,%eax
  80129e:	0f 9f c0             	setg   %al
  8012a1:	0f b6 c0             	movzbl %al,%eax
  8012a4:	89 c7                	mov    %eax,%edi
	int i, c, echoing;

	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
  8012a6:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0) > 0;
	while (1) {
		c = getchar();
  8012ab:	e8 7c f7 ff ff       	call   800a2c <_Z7getcharv>
  8012b0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	79 17                	jns    8012cd <_Z8readlinePKc+0x5d>
			cprintf("read error: %e\n", c);
  8012b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ba:	c7 04 24 14 5e 80 00 	movl   $0x805e14,(%esp)
  8012c1:	e8 c8 f9 ff ff       	call   800c8e <_Z7cprintfPKcz>
			return NULL;
  8012c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cb:	eb 70                	jmp    80133d <_Z8readlinePKc+0xcd>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012cd:	83 f8 08             	cmp    $0x8,%eax
  8012d0:	74 05                	je     8012d7 <_Z8readlinePKc+0x67>
  8012d2:	83 f8 7f             	cmp    $0x7f,%eax
  8012d5:	75 1c                	jne    8012f3 <_Z8readlinePKc+0x83>
  8012d7:	85 f6                	test   %esi,%esi
  8012d9:	7e 18                	jle    8012f3 <_Z8readlinePKc+0x83>
			if (echoing)
  8012db:	85 ff                	test   %edi,%edi
  8012dd:	8d 76 00             	lea    0x0(%esi),%esi
  8012e0:	74 0c                	je     8012ee <_Z8readlinePKc+0x7e>
				cputchar('\b');
  8012e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8012e9:	e8 1d f7 ff ff       	call   800a0b <_Z8cputchari>
			i--;
  8012ee:	83 ee 01             	sub    $0x1,%esi
  8012f1:	eb b8                	jmp    8012ab <_Z8readlinePKc+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012f3:	83 fb 1f             	cmp    $0x1f,%ebx
  8012f6:	7e 1f                	jle    801317 <_Z8readlinePKc+0xa7>
  8012f8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8012fe:	7f 17                	jg     801317 <_Z8readlinePKc+0xa7>
			if (echoing)
  801300:	85 ff                	test   %edi,%edi
  801302:	74 08                	je     80130c <_Z8readlinePKc+0x9c>
				cputchar(c);
  801304:	89 1c 24             	mov    %ebx,(%esp)
  801307:	e8 ff f6 ff ff       	call   800a0b <_Z8cputchari>
			buf[i++] = c;
  80130c:	88 9e 20 80 80 00    	mov    %bl,0x808020(%esi)
  801312:	83 c6 01             	add    $0x1,%esi
  801315:	eb 94                	jmp    8012ab <_Z8readlinePKc+0x3b>
		} else if (c == '\n' || c == '\r') {
  801317:	83 fb 0a             	cmp    $0xa,%ebx
  80131a:	74 05                	je     801321 <_Z8readlinePKc+0xb1>
  80131c:	83 fb 0d             	cmp    $0xd,%ebx
  80131f:	75 8a                	jne    8012ab <_Z8readlinePKc+0x3b>
			if (echoing)
  801321:	85 ff                	test   %edi,%edi
  801323:	74 0c                	je     801331 <_Z8readlinePKc+0xc1>
				cputchar('\n');
  801325:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80132c:	e8 da f6 ff ff       	call   800a0b <_Z8cputchari>
			buf[i] = 0;
  801331:	c6 86 20 80 80 00 00 	movb   $0x0,0x808020(%esi)
			return buf;
  801338:	b8 20 80 80 00       	mov    $0x808020,%eax
		}
	}
}
  80133d:	83 c4 1c             	add    $0x1c,%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5f                   	pop    %edi
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    
	...

00801350 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801356:	b8 00 00 00 00       	mov    $0x0,%eax
  80135b:	80 3a 00             	cmpb   $0x0,(%edx)
  80135e:	74 09                	je     801369 <_Z6strlenPKc+0x19>
		n++;
  801360:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801367:	75 f7                	jne    801360 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801371:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801374:	b8 00 00 00 00       	mov    $0x0,%eax
  801379:	39 c2                	cmp    %eax,%edx
  80137b:	74 0b                	je     801388 <_Z7strnlenPKcj+0x1d>
  80137d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801381:	74 05                	je     801388 <_Z7strnlenPKcj+0x1d>
		n++;
  801383:	83 c0 01             	add    $0x1,%eax
  801386:	eb f1                	jmp    801379 <_Z7strnlenPKcj+0xe>
	return n;
}
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  801394:	ba 00 00 00 00       	mov    $0x0,%edx
  801399:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80139d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8013a0:	83 c2 01             	add    $0x1,%edx
  8013a3:	84 c9                	test   %cl,%cl
  8013a5:	75 f2                	jne    801399 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8013a7:	5b                   	pop    %ebx
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	56                   	push   %esi
  8013ae:	53                   	push   %ebx
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8013b8:	85 f6                	test   %esi,%esi
  8013ba:	74 18                	je     8013d4 <_Z7strncpyPcPKcj+0x2a>
  8013bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8013c1:	0f b6 1a             	movzbl (%edx),%ebx
  8013c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8013c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8013ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8013cd:	83 c1 01             	add    $0x1,%ecx
  8013d0:	39 ce                	cmp    %ecx,%esi
  8013d2:	77 ed                	ja     8013c1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	56                   	push   %esi
  8013dc:	53                   	push   %ebx
  8013dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8013e6:	89 f0                	mov    %esi,%eax
  8013e8:	85 d2                	test   %edx,%edx
  8013ea:	74 17                	je     801403 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8013ec:	83 ea 01             	sub    $0x1,%edx
  8013ef:	74 18                	je     801409 <_Z7strlcpyPcPKcj+0x31>
  8013f1:	80 39 00             	cmpb   $0x0,(%ecx)
  8013f4:	74 17                	je     80140d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8013f6:	0f b6 19             	movzbl (%ecx),%ebx
  8013f9:	88 18                	mov    %bl,(%eax)
  8013fb:	83 c0 01             	add    $0x1,%eax
  8013fe:	83 c1 01             	add    $0x1,%ecx
  801401:	eb e9                	jmp    8013ec <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  801403:	29 f0                	sub    %esi,%eax
}
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801409:	89 c2                	mov    %eax,%edx
  80140b:	eb 02                	jmp    80140f <_Z7strlcpyPcPKcj+0x37>
  80140d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80140f:	c6 02 00             	movb   $0x0,(%edx)
  801412:	eb ef                	jmp    801403 <_Z7strlcpyPcPKcj+0x2b>

00801414 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80141d:	0f b6 01             	movzbl (%ecx),%eax
  801420:	84 c0                	test   %al,%al
  801422:	74 0c                	je     801430 <_Z6strcmpPKcS0_+0x1c>
  801424:	3a 02                	cmp    (%edx),%al
  801426:	75 08                	jne    801430 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  801428:	83 c1 01             	add    $0x1,%ecx
  80142b:	83 c2 01             	add    $0x1,%edx
  80142e:	eb ed                	jmp    80141d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  801430:	0f b6 c0             	movzbl %al,%eax
  801433:	0f b6 12             	movzbl (%edx),%edx
  801436:	29 d0                	sub    %edx,%eax
}
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801444:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  801447:	85 d2                	test   %edx,%edx
  801449:	74 16                	je     801461 <_Z7strncmpPKcS0_j+0x27>
  80144b:	0f b6 01             	movzbl (%ecx),%eax
  80144e:	84 c0                	test   %al,%al
  801450:	74 17                	je     801469 <_Z7strncmpPKcS0_j+0x2f>
  801452:	3a 03                	cmp    (%ebx),%al
  801454:	75 13                	jne    801469 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  801456:	83 ea 01             	sub    $0x1,%edx
  801459:	83 c1 01             	add    $0x1,%ecx
  80145c:	83 c3 01             	add    $0x1,%ebx
  80145f:	eb e6                	jmp    801447 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  801466:	5b                   	pop    %ebx
  801467:	5d                   	pop    %ebp
  801468:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  801469:	0f b6 01             	movzbl (%ecx),%eax
  80146c:	0f b6 13             	movzbl (%ebx),%edx
  80146f:	29 d0                	sub    %edx,%eax
  801471:	eb f3                	jmp    801466 <_Z7strncmpPKcS0_j+0x2c>

00801473 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80147d:	0f b6 10             	movzbl (%eax),%edx
  801480:	84 d2                	test   %dl,%dl
  801482:	74 1f                	je     8014a3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  801484:	38 ca                	cmp    %cl,%dl
  801486:	75 0a                	jne    801492 <_Z6strchrPKcc+0x1f>
  801488:	eb 1e                	jmp    8014a8 <_Z6strchrPKcc+0x35>
  80148a:	38 ca                	cmp    %cl,%dl
  80148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801490:	74 16                	je     8014a8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801492:	83 c0 01             	add    $0x1,%eax
  801495:	0f b6 10             	movzbl (%eax),%edx
  801498:	84 d2                	test   %dl,%dl
  80149a:	75 ee                	jne    80148a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a1:	eb 05                	jmp    8014a8 <_Z6strchrPKcc+0x35>
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    

008014aa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014b4:	0f b6 10             	movzbl (%eax),%edx
  8014b7:	84 d2                	test   %dl,%dl
  8014b9:	74 14                	je     8014cf <_Z7strfindPKcc+0x25>
		if (*s == c)
  8014bb:	38 ca                	cmp    %cl,%dl
  8014bd:	75 06                	jne    8014c5 <_Z7strfindPKcc+0x1b>
  8014bf:	eb 0e                	jmp    8014cf <_Z7strfindPKcc+0x25>
  8014c1:	38 ca                	cmp    %cl,%dl
  8014c3:	74 0a                	je     8014cf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c5:	83 c0 01             	add    $0x1,%eax
  8014c8:	0f b6 10             	movzbl (%eax),%edx
  8014cb:	84 d2                	test   %dl,%dl
  8014cd:	75 f2                	jne    8014c1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8014eb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8014f1:	75 25                	jne    801518 <memset+0x47>
  8014f3:	f6 c1 03             	test   $0x3,%cl
  8014f6:	75 20                	jne    801518 <memset+0x47>
		c &= 0xFF;
  8014f8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014fb:	89 d3                	mov    %edx,%ebx
  8014fd:	c1 e3 08             	shl    $0x8,%ebx
  801500:	89 d6                	mov    %edx,%esi
  801502:	c1 e6 18             	shl    $0x18,%esi
  801505:	89 d0                	mov    %edx,%eax
  801507:	c1 e0 10             	shl    $0x10,%eax
  80150a:	09 f0                	or     %esi,%eax
  80150c:	09 d0                	or     %edx,%eax
  80150e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  801510:	c1 e9 02             	shr    $0x2,%ecx
  801513:	fc                   	cld    
  801514:	f3 ab                	rep stos %eax,%es:(%edi)
  801516:	eb 03                	jmp    80151b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  801518:	fc                   	cld    
  801519:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  80151b:	89 f8                	mov    %edi,%eax
  80151d:	8b 1c 24             	mov    (%esp),%ebx
  801520:	8b 74 24 04          	mov    0x4(%esp),%esi
  801524:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801528:	89 ec                	mov    %ebp,%esp
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    

0080152c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	89 34 24             	mov    %esi,(%esp)
  801535:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80153f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  801542:	39 c6                	cmp    %eax,%esi
  801544:	73 36                	jae    80157c <memmove+0x50>
  801546:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801549:	39 d0                	cmp    %edx,%eax
  80154b:	73 2f                	jae    80157c <memmove+0x50>
		s += n;
		d += n;
  80154d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  801550:	f6 c2 03             	test   $0x3,%dl
  801553:	75 1b                	jne    801570 <memmove+0x44>
  801555:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80155b:	75 13                	jne    801570 <memmove+0x44>
  80155d:	f6 c1 03             	test   $0x3,%cl
  801560:	75 0e                	jne    801570 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801562:	83 ef 04             	sub    $0x4,%edi
  801565:	8d 72 fc             	lea    -0x4(%edx),%esi
  801568:	c1 e9 02             	shr    $0x2,%ecx
  80156b:	fd                   	std    
  80156c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80156e:	eb 09                	jmp    801579 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801570:	83 ef 01             	sub    $0x1,%edi
  801573:	8d 72 ff             	lea    -0x1(%edx),%esi
  801576:	fd                   	std    
  801577:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801579:	fc                   	cld    
  80157a:	eb 20                	jmp    80159c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  80157c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801582:	75 13                	jne    801597 <memmove+0x6b>
  801584:	a8 03                	test   $0x3,%al
  801586:	75 0f                	jne    801597 <memmove+0x6b>
  801588:	f6 c1 03             	test   $0x3,%cl
  80158b:	75 0a                	jne    801597 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80158d:	c1 e9 02             	shr    $0x2,%ecx
  801590:	89 c7                	mov    %eax,%edi
  801592:	fc                   	cld    
  801593:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801595:	eb 05                	jmp    80159c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  801597:	89 c7                	mov    %eax,%edi
  801599:	fc                   	cld    
  80159a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  80159c:	8b 34 24             	mov    (%esp),%esi
  80159f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8015a3:	89 ec                	mov    %ebp,%esp
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	89 34 24             	mov    %esi,(%esp)
  8015b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  8015bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8015c3:	75 13                	jne    8015d8 <memcpy+0x31>
  8015c5:	a8 03                	test   $0x3,%al
  8015c7:	75 0f                	jne    8015d8 <memcpy+0x31>
  8015c9:	f6 c1 03             	test   $0x3,%cl
  8015cc:	75 0a                	jne    8015d8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015ce:	c1 e9 02             	shr    $0x2,%ecx
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	fc                   	cld    
  8015d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015d6:	eb 05                	jmp    8015dd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  8015d8:	89 c7                	mov    %eax,%edi
  8015da:	fc                   	cld    
  8015db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  8015dd:	8b 34 24             	mov    (%esp),%esi
  8015e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8015e4:	89 ec                	mov    %ebp,%esp
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    

008015e8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	57                   	push   %edi
  8015ec:	56                   	push   %esi
  8015ed:	53                   	push   %ebx
  8015ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015f4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  8015fc:	85 ff                	test   %edi,%edi
  8015fe:	74 38                	je     801638 <memcmp+0x50>
		if (*s1 != *s2)
  801600:	0f b6 03             	movzbl (%ebx),%eax
  801603:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  801606:	83 ef 01             	sub    $0x1,%edi
  801609:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80160e:	38 c8                	cmp    %cl,%al
  801610:	74 1d                	je     80162f <memcmp+0x47>
  801612:	eb 11                	jmp    801625 <memcmp+0x3d>
  801614:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801619:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  80161e:	83 c2 01             	add    $0x1,%edx
  801621:	38 c8                	cmp    %cl,%al
  801623:	74 0a                	je     80162f <memcmp+0x47>
			return *s1 - *s2;
  801625:	0f b6 c0             	movzbl %al,%eax
  801628:	0f b6 c9             	movzbl %cl,%ecx
  80162b:	29 c8                	sub    %ecx,%eax
  80162d:	eb 09                	jmp    801638 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80162f:	39 fa                	cmp    %edi,%edx
  801631:	75 e1                	jne    801614 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5f                   	pop    %edi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	53                   	push   %ebx
  801641:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  801644:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  801646:	89 da                	mov    %ebx,%edx
  801648:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  80164b:	39 d3                	cmp    %edx,%ebx
  80164d:	73 15                	jae    801664 <memfind+0x27>
		if (*s == (unsigned char) c)
  80164f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801653:	38 0b                	cmp    %cl,(%ebx)
  801655:	75 06                	jne    80165d <memfind+0x20>
  801657:	eb 0b                	jmp    801664 <memfind+0x27>
  801659:	38 08                	cmp    %cl,(%eax)
  80165b:	74 07                	je     801664 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  80165d:	83 c0 01             	add    $0x1,%eax
  801660:	39 c2                	cmp    %eax,%edx
  801662:	77 f5                	ja     801659 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  801664:	5b                   	pop    %ebx
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    

00801667 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	57                   	push   %edi
  80166b:	56                   	push   %esi
  80166c:	53                   	push   %ebx
  80166d:	8b 55 08             	mov    0x8(%ebp),%edx
  801670:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801673:	0f b6 02             	movzbl (%edx),%eax
  801676:	3c 20                	cmp    $0x20,%al
  801678:	74 04                	je     80167e <_Z6strtolPKcPPci+0x17>
  80167a:	3c 09                	cmp    $0x9,%al
  80167c:	75 0e                	jne    80168c <_Z6strtolPKcPPci+0x25>
		s++;
  80167e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801681:	0f b6 02             	movzbl (%edx),%eax
  801684:	3c 20                	cmp    $0x20,%al
  801686:	74 f6                	je     80167e <_Z6strtolPKcPPci+0x17>
  801688:	3c 09                	cmp    $0x9,%al
  80168a:	74 f2                	je     80167e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  80168c:	3c 2b                	cmp    $0x2b,%al
  80168e:	75 0a                	jne    80169a <_Z6strtolPKcPPci+0x33>
		s++;
  801690:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801693:	bf 00 00 00 00       	mov    $0x0,%edi
  801698:	eb 10                	jmp    8016aa <_Z6strtolPKcPPci+0x43>
  80169a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80169f:	3c 2d                	cmp    $0x2d,%al
  8016a1:	75 07                	jne    8016aa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  8016a3:	83 c2 01             	add    $0x1,%edx
  8016a6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016aa:	85 db                	test   %ebx,%ebx
  8016ac:	0f 94 c0             	sete   %al
  8016af:	74 05                	je     8016b6 <_Z6strtolPKcPPci+0x4f>
  8016b1:	83 fb 10             	cmp    $0x10,%ebx
  8016b4:	75 15                	jne    8016cb <_Z6strtolPKcPPci+0x64>
  8016b6:	80 3a 30             	cmpb   $0x30,(%edx)
  8016b9:	75 10                	jne    8016cb <_Z6strtolPKcPPci+0x64>
  8016bb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8016bf:	75 0a                	jne    8016cb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  8016c1:	83 c2 02             	add    $0x2,%edx
  8016c4:	bb 10 00 00 00       	mov    $0x10,%ebx
  8016c9:	eb 13                	jmp    8016de <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  8016cb:	84 c0                	test   %al,%al
  8016cd:	74 0f                	je     8016de <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016cf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016d4:	80 3a 30             	cmpb   $0x30,(%edx)
  8016d7:	75 05                	jne    8016de <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  8016d9:	83 c2 01             	add    $0x1,%edx
  8016dc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016e5:	0f b6 0a             	movzbl (%edx),%ecx
  8016e8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8016eb:	80 fb 09             	cmp    $0x9,%bl
  8016ee:	77 08                	ja     8016f8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  8016f0:	0f be c9             	movsbl %cl,%ecx
  8016f3:	83 e9 30             	sub    $0x30,%ecx
  8016f6:	eb 1e                	jmp    801716 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  8016f8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8016fb:	80 fb 19             	cmp    $0x19,%bl
  8016fe:	77 08                	ja     801708 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  801700:	0f be c9             	movsbl %cl,%ecx
  801703:	83 e9 57             	sub    $0x57,%ecx
  801706:	eb 0e                	jmp    801716 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801708:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  80170b:	80 fb 19             	cmp    $0x19,%bl
  80170e:	77 15                	ja     801725 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  801710:	0f be c9             	movsbl %cl,%ecx
  801713:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801716:	39 f1                	cmp    %esi,%ecx
  801718:	7d 0f                	jge    801729 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  80171a:	83 c2 01             	add    $0x1,%edx
  80171d:	0f af c6             	imul   %esi,%eax
  801720:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  801723:	eb c0                	jmp    8016e5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801725:	89 c1                	mov    %eax,%ecx
  801727:	eb 02                	jmp    80172b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801729:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80172b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172f:	74 05                	je     801736 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  801731:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801734:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801736:	89 ca                	mov    %ecx,%edx
  801738:	f7 da                	neg    %edx
  80173a:	85 ff                	test   %edi,%edi
  80173c:	0f 45 c2             	cmovne %edx,%eax
}
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5f                   	pop    %edi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	89 1c 24             	mov    %ebx,(%esp)
  80174d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801751:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175d:	8b 55 08             	mov    0x8(%ebp),%edx
  801760:	89 c3                	mov    %eax,%ebx
  801762:	89 c7                	mov    %eax,%edi
  801764:	89 c6                	mov    %eax,%esi
  801766:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801768:	8b 1c 24             	mov    (%esp),%ebx
  80176b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80176f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801773:	89 ec                	mov    %ebp,%esp
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	89 1c 24             	mov    %ebx,(%esp)
  801780:	89 74 24 04          	mov    %esi,0x4(%esp)
  801784:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801788:	ba 00 00 00 00       	mov    $0x0,%edx
  80178d:	b8 01 00 00 00       	mov    $0x1,%eax
  801792:	89 d1                	mov    %edx,%ecx
  801794:	89 d3                	mov    %edx,%ebx
  801796:	89 d7                	mov    %edx,%edi
  801798:	89 d6                	mov    %edx,%esi
  80179a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80179c:	8b 1c 24             	mov    (%esp),%ebx
  80179f:	8b 74 24 04          	mov    0x4(%esp),%esi
  8017a3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8017a7:	89 ec                	mov    %ebp,%esp
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 38             	sub    $0x38,%esp
  8017b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8017ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8017c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c7:	89 cb                	mov    %ecx,%ebx
  8017c9:	89 cf                	mov    %ecx,%edi
  8017cb:	89 ce                	mov    %ecx,%esi
  8017cd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	7e 28                	jle    8017fb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8017de:	00 
  8017df:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  8017e6:	00 
  8017e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017ee:	00 
  8017ef:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  8017f6:	e8 75 f3 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801801:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801804:	89 ec                	mov    %ebp,%esp
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	89 1c 24             	mov    %ebx,(%esp)
  801811:	89 74 24 04          	mov    %esi,0x4(%esp)
  801815:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	b8 02 00 00 00       	mov    $0x2,%eax
  801823:	89 d1                	mov    %edx,%ecx
  801825:	89 d3                	mov    %edx,%ebx
  801827:	89 d7                	mov    %edx,%edi
  801829:	89 d6                	mov    %edx,%esi
  80182b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80182d:	8b 1c 24             	mov    (%esp),%ebx
  801830:	8b 74 24 04          	mov    0x4(%esp),%esi
  801834:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801838:	89 ec                	mov    %ebp,%esp
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	89 1c 24             	mov    %ebx,(%esp)
  801845:	89 74 24 04          	mov    %esi,0x4(%esp)
  801849:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 04 00 00 00       	mov    $0x4,%eax
  801857:	89 d1                	mov    %edx,%ecx
  801859:	89 d3                	mov    %edx,%ebx
  80185b:	89 d7                	mov    %edx,%edi
  80185d:	89 d6                	mov    %edx,%esi
  80185f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801861:	8b 1c 24             	mov    (%esp),%ebx
  801864:	8b 74 24 04          	mov    0x4(%esp),%esi
  801868:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80186c:	89 ec                	mov    %ebp,%esp
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 38             	sub    $0x38,%esp
  801876:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801879:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80187c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80187f:	be 00 00 00 00       	mov    $0x0,%esi
  801884:	b8 08 00 00 00       	mov    $0x8,%eax
  801889:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80188c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188f:	8b 55 08             	mov    0x8(%ebp),%edx
  801892:	89 f7                	mov    %esi,%edi
  801894:	cd 30                	int    $0x30

	if(check && ret > 0)
  801896:	85 c0                	test   %eax,%eax
  801898:	7e 28                	jle    8018c2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80189a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80189e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8018a5:	00 
  8018a6:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  8018ad:	00 
  8018ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018b5:	00 
  8018b6:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  8018bd:	e8 ae f2 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8018c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018cb:	89 ec                	mov    %ebp,%esp
  8018cd:	5d                   	pop    %ebp
  8018ce:	c3                   	ret    

008018cf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 38             	sub    $0x38,%esp
  8018d5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018d8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018db:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8018de:	b8 09 00 00 00       	mov    $0x9,%eax
  8018e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f2:	cd 30                	int    $0x30

	if(check && ret > 0)
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	7e 28                	jle    801920 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018fc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801903:	00 
  801904:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  80190b:	00 
  80190c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801913:	00 
  801914:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  80191b:	e8 50 f2 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801920:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801923:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801926:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801929:	89 ec                	mov    %ebp,%esp
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 38             	sub    $0x38,%esp
  801933:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801936:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801939:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80193c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801941:	b8 0a 00 00 00       	mov    $0xa,%eax
  801946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801949:	8b 55 08             	mov    0x8(%ebp),%edx
  80194c:	89 df                	mov    %ebx,%edi
  80194e:	89 de                	mov    %ebx,%esi
  801950:	cd 30                	int    $0x30

	if(check && ret > 0)
  801952:	85 c0                	test   %eax,%eax
  801954:	7e 28                	jle    80197e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801956:	89 44 24 10          	mov    %eax,0x10(%esp)
  80195a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801961:	00 
  801962:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  801969:	00 
  80196a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801971:	00 
  801972:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  801979:	e8 f2 f1 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80197e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801981:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801984:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801987:	89 ec                	mov    %ebp,%esp
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 38             	sub    $0x38,%esp
  801991:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801994:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801997:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80199a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80199f:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019aa:	89 df                	mov    %ebx,%edi
  8019ac:	89 de                	mov    %ebx,%esi
  8019ae:	cd 30                	int    $0x30

	if(check && ret > 0)
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	7e 28                	jle    8019dc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019b8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8019bf:	00 
  8019c0:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  8019c7:	00 
  8019c8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019cf:	00 
  8019d0:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  8019d7:	e8 94 f1 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8019dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019df:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019e5:	89 ec                	mov    %ebp,%esp
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    

008019e9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 38             	sub    $0x38,%esp
  8019ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8019f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a05:	8b 55 08             	mov    0x8(%ebp),%edx
  801a08:	89 df                	mov    %ebx,%edi
  801a0a:	89 de                	mov    %ebx,%esi
  801a0c:	cd 30                	int    $0x30

	if(check && ret > 0)
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	7e 28                	jle    801a3a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a12:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a16:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801a1d:	00 
  801a1e:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  801a25:	00 
  801a26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a2d:	00 
  801a2e:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  801a35:	e8 36 f1 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801a3a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a3d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a40:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a43:	89 ec                	mov    %ebp,%esp
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 38             	sub    $0x38,%esp
  801a4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a53:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801a56:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a63:	8b 55 08             	mov    0x8(%ebp),%edx
  801a66:	89 df                	mov    %ebx,%edi
  801a68:	89 de                	mov    %ebx,%esi
  801a6a:	cd 30                	int    $0x30

	if(check && ret > 0)
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	7e 28                	jle    801a98 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a70:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a74:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801a7b:	00 
  801a7c:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  801a83:	00 
  801a84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a8b:	00 
  801a8c:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  801a93:	e8 d8 f0 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801a98:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a9b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a9e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801aa1:	89 ec                	mov    %ebp,%esp
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    

00801aa5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 38             	sub    $0x38,%esp
  801aab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ab1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801ab4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab9:	b8 0c 00 00 00       	mov    $0xc,%eax
  801abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac4:	89 df                	mov    %ebx,%edi
  801ac6:	89 de                	mov    %ebx,%esi
  801ac8:	cd 30                	int    $0x30

	if(check && ret > 0)
  801aca:	85 c0                	test   %eax,%eax
  801acc:	7e 28                	jle    801af6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ace:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ad2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801ad9:	00 
  801ada:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  801ae1:	00 
  801ae2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801ae9:	00 
  801aea:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  801af1:	e8 7a f0 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801af6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801af9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801afc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801aff:	89 ec                	mov    %ebp,%esp
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	89 1c 24             	mov    %ebx,(%esp)
  801b0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b10:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801b14:	be 00 00 00 00       	mov    $0x0,%esi
  801b19:	b8 0d 00 00 00       	mov    $0xd,%eax
  801b1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801b21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b27:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801b2c:	8b 1c 24             	mov    (%esp),%ebx
  801b2f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801b33:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801b37:	89 ec                	mov    %ebp,%esp
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    

00801b3b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 38             	sub    $0x38,%esp
  801b41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b47:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801b4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801b54:	8b 55 08             	mov    0x8(%ebp),%edx
  801b57:	89 cb                	mov    %ecx,%ebx
  801b59:	89 cf                	mov    %ecx,%edi
  801b5b:	89 ce                	mov    %ecx,%esi
  801b5d:	cd 30                	int    $0x30

	if(check && ret > 0)
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	7e 28                	jle    801b8b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b63:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b67:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 08 24 5e 80 	movl   $0x805e24,0x8(%esp)
  801b76:	00 
  801b77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b7e:	00 
  801b7f:	c7 04 24 41 5e 80 00 	movl   $0x805e41,(%esp)
  801b86:	e8 e5 ef ff ff       	call   800b70 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801b8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b8e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b94:	89 ec                	mov    %ebp,%esp
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    

00801b98 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	89 1c 24             	mov    %ebx,(%esp)
  801ba1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801ba9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bae:	b8 0f 00 00 00       	mov    $0xf,%eax
  801bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb9:	89 df                	mov    %ebx,%edi
  801bbb:	89 de                	mov    %ebx,%esi
  801bbd:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  801bbf:	8b 1c 24             	mov    (%esp),%ebx
  801bc2:	8b 74 24 04          	mov    0x4(%esp),%esi
  801bc6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801bca:	89 ec                	mov    %ebp,%esp
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	89 1c 24             	mov    %ebx,(%esp)
  801bd7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bdb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801be4:	b8 11 00 00 00       	mov    $0x11,%eax
  801be9:	89 d1                	mov    %edx,%ecx
  801beb:	89 d3                	mov    %edx,%ebx
  801bed:	89 d7                	mov    %edx,%edi
  801bef:	89 d6                	mov    %edx,%esi
  801bf1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801bf3:	8b 1c 24             	mov    (%esp),%ebx
  801bf6:	8b 74 24 04          	mov    0x4(%esp),%esi
  801bfa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801bfe:	89 ec                	mov    %ebp,%esp
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    

00801c02 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	89 1c 24             	mov    %ebx,(%esp)
  801c0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801c13:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c18:	b8 12 00 00 00       	mov    $0x12,%eax
  801c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c20:	8b 55 08             	mov    0x8(%ebp),%edx
  801c23:	89 df                	mov    %ebx,%edi
  801c25:	89 de                	mov    %ebx,%esi
  801c27:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801c29:	8b 1c 24             	mov    (%esp),%ebx
  801c2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801c30:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801c34:	89 ec                	mov    %ebp,%esp
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    

00801c38 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	89 1c 24             	mov    %ebx,(%esp)
  801c41:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c45:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4e:	b8 13 00 00 00       	mov    $0x13,%eax
  801c53:	8b 55 08             	mov    0x8(%ebp),%edx
  801c56:	89 cb                	mov    %ecx,%ebx
  801c58:	89 cf                	mov    %ecx,%edi
  801c5a:	89 ce                	mov    %ecx,%esi
  801c5c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  801c5e:	8b 1c 24             	mov    (%esp),%ebx
  801c61:	8b 74 24 04          	mov    0x4(%esp),%esi
  801c65:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801c69:	89 ec                	mov    %ebp,%esp
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	89 1c 24             	mov    %ebx,(%esp)
  801c76:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801c7e:	b8 10 00 00 00       	mov    $0x10,%eax
  801c83:	8b 75 18             	mov    0x18(%ebp),%esi
  801c86:	8b 7d 14             	mov    0x14(%ebp),%edi
  801c89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c92:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801c94:	8b 1c 24             	mov    (%esp),%ebx
  801c97:	8b 74 24 04          	mov    0x4(%esp),%esi
  801c9b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801c9f:	89 ec                	mov    %ebp,%esp
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
	...

00801ca4 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 38             	sub    $0x38,%esp
  801caa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cb0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  801cb3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  801cba:	f6 c7 04             	test   $0x4,%bh
  801cbd:	74 31                	je     801cf0 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  801cbf:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801cc6:	c1 e2 0c             	shl    $0xc,%edx
  801cc9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801ccf:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801cd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce6:	e8 e4 fb ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
        return r;
  801ceb:	e9 8c 00 00 00       	jmp    801d7c <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801cf0:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801cf7:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  801cfc:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801d02:	75 2a                	jne    801d2e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801d04:	84 c9                	test   %cl,%cl
  801d06:	74 0f                	je     801d17 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801d08:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  801d0f:	83 e3 02             	and    $0x2,%ebx
  801d12:	80 cf 02             	or     $0x2,%bh
  801d15:	eb 17                	jmp    801d2e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801d17:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801d1e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801d21:	83 f9 01             	cmp    $0x1,%ecx
  801d24:	19 db                	sbb    %ebx,%ebx
  801d26:	f7 d3                	not    %ebx
  801d28:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  801d2e:	89 df                	mov    %ebx,%edi
  801d30:	83 cf 05             	or     $0x5,%edi
  801d33:	89 d6                	mov    %edx,%esi
  801d35:	c1 e6 0c             	shl    $0xc,%esi
  801d38:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801d3c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d44:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4f:	e8 7b fb ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  801d54:	85 c0                	test   %eax,%eax
  801d56:	75 24                	jne    801d7c <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801d58:	85 db                	test   %ebx,%ebx
  801d5a:	74 20                	je     801d7c <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  801d5c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801d60:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d64:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d6b:	00 
  801d6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d77:	e8 53 fb ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  801d7c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d7f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d82:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d85:	89 ec                	mov    %ebp,%esp
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 28             	sub    $0x28,%esp
  801d8f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d92:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801d98:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801d9a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  801d9e:	0f 84 ff 00 00 00    	je     801ea3 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801da4:	89 f0                	mov    %esi,%eax
  801da6:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801da9:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801db0:	f6 c4 08             	test   $0x8,%ah
  801db3:	0f 84 ea 00 00 00    	je     801ea3 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801db9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dc0:	00 
  801dc1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801dc8:	00 
  801dc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd0:	e8 9b fa ff ff       	call   801870 <_Z14sys_page_allociPvi>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	79 20                	jns    801df9 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ddd:	c7 44 24 08 4f 5e 80 	movl   $0x805e4f,0x8(%esp)
  801de4:	00 
  801de5:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801dec:	00 
  801ded:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801df4:	e8 77 ed ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801df9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  801dff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e06:	00 
  801e07:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e0b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801e12:	e8 90 f7 ff ff       	call   8015a7 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801e17:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e1e:	00 
  801e1f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e2a:	00 
  801e2b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801e32:	00 
  801e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3a:	e8 90 fa ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	79 20                	jns    801e63 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801e43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e47:	c7 44 24 08 6d 5e 80 	movl   $0x805e6d,0x8(%esp)
  801e4e:	00 
  801e4f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e56:	00 
  801e57:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801e5e:	e8 0d ed ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801e63:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801e6a:	00 
  801e6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e72:	e8 b6 fa ff ff       	call   80192d <_Z14sys_page_unmapiPv>
  801e77:	85 c0                	test   %eax,%eax
  801e79:	79 20                	jns    801e9b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  801e7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e7f:	c7 44 24 08 7e 5e 80 	movl   $0x805e7e,0x8(%esp)
  801e86:	00 
  801e87:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  801e8e:	00 
  801e8f:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801e96:	e8 d5 ec ff ff       	call   800b70 <_Z6_panicPKciS0_z>
    resume(utf);
  801e9b:	89 1c 24             	mov    %ebx,(%esp)
  801e9e:	e8 2d 36 00 00       	call   8054d0 <resume>
}
  801ea3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ea6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ea9:	89 ec                	mov    %ebp,%esp
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    

00801ead <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	57                   	push   %edi
  801eb1:	56                   	push   %esi
  801eb2:	53                   	push   %ebx
  801eb3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  801eb6:	c7 04 24 89 1d 80 00 	movl   $0x801d89,(%esp)
  801ebd:	e8 39 35 00 00       	call   8053fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  801ec2:	be 07 00 00 00       	mov    $0x7,%esi
  801ec7:	89 f0                	mov    %esi,%eax
  801ec9:	cd 30                	int    $0x30
  801ecb:	89 c6                	mov    %eax,%esi
  801ecd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	79 20                	jns    801ef3 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ed7:	c7 44 24 08 91 5e 80 	movl   $0x805e91,0x8(%esp)
  801ede:	00 
  801edf:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801ee6:	00 
  801ee7:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801eee:	e8 7d ec ff ff       	call   800b70 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801ef3:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	75 1c                	jne    801f18 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  801efc:	e8 07 f9 ff ff       	call   801808 <_Z12sys_getenvidv>
  801f01:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f06:	6b c0 78             	imul   $0x78,%eax,%eax
  801f09:	05 00 00 00 ef       	add    $0xef000000,%eax
  801f0e:	a3 14 80 80 00       	mov    %eax,0x808014
        return 0;
  801f13:	e9 de 00 00 00       	jmp    801ff6 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801f18:	89 d8                	mov    %ebx,%eax
  801f1a:	c1 f8 0a             	sar    $0xa,%eax
  801f1d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801f24:	a8 01                	test   $0x1,%al
  801f26:	75 08                	jne    801f30 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801f28:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801f2e:	eb 19                	jmp    801f49 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801f30:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801f37:	a8 01                	test   $0x1,%al
  801f39:	74 0e                	je     801f49 <_Z4forkv+0x9c>
            duppage(envid, pn);
  801f3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f40:	89 da                	mov    %ebx,%edx
  801f42:	89 f8                	mov    %edi,%eax
  801f44:	e8 5b fd ff ff       	call   801ca4 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801f49:	83 eb 01             	sub    $0x1,%ebx
  801f4c:	79 ca                	jns    801f18 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  801f4e:	a1 14 80 80 00       	mov    0x808014,%eax
  801f53:	8b 40 5c             	mov    0x5c(%eax),%eax
  801f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5a:	89 34 24             	mov    %esi,(%esp)
  801f5d:	e8 43 fb ff ff       	call   801aa5 <_Z26sys_env_set_pgfault_upcalliPv>
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 20                	je     801f86 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801f66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f6a:	c7 44 24 08 b8 5e 80 	movl   $0x805eb8,0x8(%esp)
  801f71:	00 
  801f72:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  801f79:	00 
  801f7a:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801f81:	e8 ea eb ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f86:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f8d:	00 
  801f8e:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801f95:	ee 
  801f96:	89 34 24             	mov    %esi,(%esp)
  801f99:	e8 d2 f8 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	79 20                	jns    801fc2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801fa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fa6:	c7 44 24 08 4f 5e 80 	movl   $0x805e4f,0x8(%esp)
  801fad:	00 
  801fae:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  801fb5:	00 
  801fb6:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801fbd:	e8 ae eb ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801fc2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801fc9:	00 
  801fca:	89 34 24             	mov    %esi,(%esp)
  801fcd:	e8 b9 f9 ff ff       	call   80198b <_Z18sys_env_set_statusii>
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	79 20                	jns    801ff6 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801fd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fda:	c7 44 24 08 a1 5e 80 	movl   $0x805ea1,0x8(%esp)
  801fe1:	00 
  801fe2:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801fe9:	00 
  801fea:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  801ff1:	e8 7a eb ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    return envid;
}
  801ff6:	89 f0                	mov    %esi,%eax
  801ff8:	83 c4 1c             	add    $0x1c,%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	57                   	push   %edi
  802004:	56                   	push   %esi
  802005:	53                   	push   %ebx
  802006:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  802009:	c7 04 24 89 1d 80 00 	movl   $0x801d89,(%esp)
  802010:	e8 e6 33 00 00       	call   8053fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  802015:	be 07 00 00 00       	mov    $0x7,%esi
  80201a:	89 f0                	mov    %esi,%eax
  80201c:	cd 30                	int    $0x30
  80201e:	89 c6                	mov    %eax,%esi
  802020:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  802022:	85 c0                	test   %eax,%eax
  802024:	79 20                	jns    802046 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  802026:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80202a:	c7 44 24 08 91 5e 80 	movl   $0x805e91,0x8(%esp)
  802031:	00 
  802032:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  802039:	00 
  80203a:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  802041:	e8 2a eb ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  802046:	85 c0                	test   %eax,%eax
  802048:	0f 84 40 01 00 00    	je     80218e <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80204e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  802050:	c1 eb 0c             	shr    $0xc,%ebx
  802053:	83 eb 01             	sub    $0x1,%ebx
  802056:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  802059:	eb 31                	jmp    80208c <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80205b:	89 d8                	mov    %ebx,%eax
  80205d:	c1 f8 0a             	sar    $0xa,%eax
  802060:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  802067:	a8 01                	test   $0x1,%al
  802069:	75 08                	jne    802073 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80206b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  802071:	eb 19                	jmp    80208c <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  802073:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80207a:	a8 01                	test   $0x1,%al
  80207c:	74 0e                	je     80208c <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  80207e:	b9 01 00 00 00       	mov    $0x1,%ecx
  802083:	89 da                	mov    %ebx,%edx
  802085:	89 f8                	mov    %edi,%eax
  802087:	e8 18 fc ff ff       	call   801ca4 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  80208c:	83 eb 01             	sub    $0x1,%ebx
  80208f:	79 ca                	jns    80205b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  802091:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  802098:	7f 3f                	jg     8020d9 <_Z5sforkv+0xd9>
  80209a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  80209d:	89 d8                	mov    %ebx,%eax
  80209f:	c1 f8 0a             	sar    $0xa,%eax
  8020a2:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8020a9:	a8 01                	test   $0x1,%al
  8020ab:	75 08                	jne    8020b5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  8020ad:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8020b3:	eb 19                	jmp    8020ce <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  8020b5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8020bc:	a8 01                	test   $0x1,%al
  8020be:	74 0e                	je     8020ce <_Z5sforkv+0xce>
            duppage(envid, i);
  8020c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c5:	89 da                	mov    %ebx,%edx
  8020c7:	89 f8                	mov    %edi,%eax
  8020c9:	e8 d6 fb ff ff       	call   801ca4 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8020ce:	83 c3 01             	add    $0x1,%ebx
  8020d1:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  8020d7:	7e c4                	jle    80209d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  8020d9:	e8 2a f7 ff ff       	call   801808 <_Z12sys_getenvidv>
  8020de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020e3:	6b c0 78             	imul   $0x78,%eax,%eax
  8020e6:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8020eb:	8b 40 50             	mov    0x50(%eax),%eax
  8020ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f2:	89 34 24             	mov    %esi,(%esp)
  8020f5:	e8 ab f9 ff ff       	call   801aa5 <_Z26sys_env_set_pgfault_upcalliPv>
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	74 20                	je     80211e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8020fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802102:	c7 44 24 08 b8 5e 80 	movl   $0x805eb8,0x8(%esp)
  802109:	00 
  80210a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  802111:	00 
  802112:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  802119:	e8 52 ea ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80211e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802125:	00 
  802126:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80212d:	ee 
  80212e:	89 34 24             	mov    %esi,(%esp)
  802131:	e8 3a f7 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  802136:	85 c0                	test   %eax,%eax
  802138:	79 20                	jns    80215a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80213a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80213e:	c7 44 24 08 4f 5e 80 	movl   $0x805e4f,0x8(%esp)
  802145:	00 
  802146:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80214d:	00 
  80214e:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  802155:	e8 16 ea ff ff       	call   800b70 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80215a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802161:	00 
  802162:	89 34 24             	mov    %esi,(%esp)
  802165:	e8 21 f8 ff ff       	call   80198b <_Z18sys_env_set_statusii>
  80216a:	85 c0                	test   %eax,%eax
  80216c:	79 20                	jns    80218e <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80216e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802172:	c7 44 24 08 a1 5e 80 	movl   $0x805ea1,0x8(%esp)
  802179:	00 
  80217a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  802181:	00 
  802182:	c7 04 24 62 5e 80 00 	movl   $0x805e62,(%esp)
  802189:	e8 e2 e9 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

    return envid;
    
}
  80218e:	89 f0                	mov    %esi,%eax
  802190:	83 c4 2c             	add    $0x2c,%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    

00802198 <_ZL24utemp_addr_to_stack_addrPv>:
//
// Shift an address from the UTEMP page to the corresponding value in the
// normal stack page (top address USTACKTOP).
//
static uintptr_t utemp_addr_to_stack_addr(void *ptr)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 18             	sub    $0x18,%esp
	uintptr_t addr = (uintptr_t) ptr;
	assert(ptr >= UTEMP && ptr < (char *) UTEMP + PGSIZE);
  80219e:	8d 90 00 00 c0 ff    	lea    -0x400000(%eax),%edx
  8021a4:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
  8021aa:	76 24                	jbe    8021d0 <_ZL24utemp_addr_to_stack_addrPv+0x38>
  8021ac:	c7 44 24 0c d8 5e 80 	movl   $0x805ed8,0xc(%esp)
  8021b3:	00 
  8021b4:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  8021bb:	00 
  8021bc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8021c3:	00 
  8021c4:	c7 04 24 06 5f 80 00 	movl   $0x805f06,(%esp)
  8021cb:	e8 a0 e9 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	return USTACKTOP - PGSIZE + PGOFF(addr);
  8021d0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021d5:	2d 00 30 00 11       	sub    $0x11003000,%eax
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <_Z10spawn_readiPvijji>:
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
           size_t len, int fs_read)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	57                   	push   %edi
  8021e0:	56                   	push   %esi
  8021e1:	53                   	push   %ebx
  8021e2:	83 ec 3c             	sub    $0x3c,%esp
  8021e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8021eb:	8b 45 14             	mov    0x14(%ebp),%eax
    int r;
    if(!fs_read)
  8021ee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8021f2:	75 25                	jne    802219 <_Z10spawn_readiPvijji+0x3d>
        return sys_program_read(dst_env, va, programid, offset, len);
  8021f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8021f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021ff:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802203:	89 74 24 04          	mov    %esi,0x4(%esp)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	89 04 24             	mov    %eax,(%esp)
  80220d:	e8 5b fa ff ff       	call   801c6d <_Z16sys_program_readiPvijj>
  802212:	89 c3                	mov    %eax,%ebx
  802214:	e9 7d 01 00 00       	jmp    802396 <_Z10spawn_readiPvijji+0x1ba>
    if((r = seek(programid, offset)))
  802219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221d:	89 3c 24             	mov    %edi,(%esp)
  802220:	e8 b6 0e 00 00       	call   8030db <_Z4seekii>
  802225:	89 c3                	mov    %eax,%ebx
  802227:	85 c0                	test   %eax,%eax
  802229:	0f 85 67 01 00 00    	jne    802396 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
  80222f:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802232:	89 f2                	mov    %esi,%edx
  802234:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80223a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80223d:	0f 84 ab 00 00 00    	je     8022ee <_Z10spawn_readiPvijji+0x112>
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  802243:	a1 14 80 80 00       	mov    0x808014,%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802252:	00 
  802253:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80225a:	00 
  80225b:	89 04 24             	mov    %eax,(%esp)
  80225e:	e8 0d f6 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  802263:	85 c0                	test   %eax,%eax
  802265:	0f 85 29 01 00 00    	jne    802394 <_Z10spawn_readiPvijji+0x1b8>
        return sys_program_read(dst_env, va, programid, offset, len);
    if((r = seek(programid, offset)))
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
  80226b:	66 b8 00 10          	mov    $0x1000,%ax
  80226f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  802272:	3b 45 18             	cmp    0x18(%ebp),%eax
  802275:	0f 47 45 18          	cmova  0x18(%ebp),%eax
  802279:	89 45 dc             	mov    %eax,-0x24(%ebp)
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  80227c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802283:	05 00 00 40 00       	add    $0x400000,%eax
  802288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228c:	89 3c 24             	mov    %edi,(%esp)
  80228f:	e8 84 0d 00 00       	call   803018 <_Z5readniPvj>
  802294:	89 c6                	mov    %eax,%esi
  802296:	85 c0                	test   %eax,%eax
  802298:	78 39                	js     8022d3 <_Z10spawn_readiPvijji+0xf7>
  80229a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8022a1:	00 
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
  8022a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  8022aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022bc:	00 
  8022bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c4:	e8 06 f6 ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  8022c9:	89 c6                	mov    %eax,%esi
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	0f 84 cd 00 00 00    	je     8023a0 <_Z10spawn_readiPvijji+0x1c4>
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  8022d3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022da:	00 
  8022db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e2:	e8 46 f6 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
            return r;
  8022e7:	89 f3                	mov    %esi,%ebx
  8022e9:	e9 a8 00 00 00       	jmp    802396 <_Z10spawn_readiPvijji+0x1ba>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  8022ee:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8022f1:	8b 55 18             	mov    0x18(%ebp),%edx
  8022f4:	01 f2                	add    %esi,%edx
  8022f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8022f9:	39 f2                	cmp    %esi,%edx
  8022fb:	0f 86 95 00 00 00    	jbe    802396 <_Z10spawn_readiPvijji+0x1ba>
// Returns the new environment's ID on success, and < 0 on error.
// If an error occurs, any new environment is destroyed.
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
  802301:	8b 75 18             	mov    0x18(%ebp),%esi
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
    {
        uint32_t bytes = (uint32_t)MIN((uint32_t)va + len - (uint32_t)i, (uint32_t)PGSIZE);
        if((r = sys_page_alloc(0, UTEMP, PTE_U | PTE_P|PTE_W)))
  802304:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80230b:	00 
  80230c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802313:	00 
  802314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231b:	e8 50 f5 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  802320:	89 c3                	mov    %eax,%ebx
  802322:	85 c0                	test   %eax,%eax
  802324:	75 70                	jne    802396 <_Z10spawn_readiPvijji+0x1ba>
            return r;
        if((r = readn(programid, UTEMP, bytes)) < 0 ||
  802326:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  80232c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802331:	0f 46 c6             	cmovbe %esi,%eax
  802334:	89 44 24 08          	mov    %eax,0x8(%esp)
  802338:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80233f:	00 
  802340:	89 3c 24             	mov    %edi,(%esp)
  802343:	e8 d0 0c 00 00       	call   803018 <_Z5readniPvj>
  802348:	89 c3                	mov    %eax,%ebx
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 30                	js     80237e <_Z10spawn_readiPvijji+0x1a2>
  80234e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802355:	00 
  802356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802359:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	89 54 24 08          	mov    %edx,0x8(%esp)
  802364:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80236b:	00 
  80236c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802373:	e8 57 f5 ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  802378:	89 c3                	mov    %eax,%ebx
  80237a:	85 c0                	test   %eax,%eax
  80237c:	74 50                	je     8023ce <_Z10spawn_readiPvijji+0x1f2>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  80237e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802385:	00 
  802386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80238d:	e8 9b f5 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
            return r;
  802392:	eb 02                	jmp    802396 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
  802394:	89 c3                	mov    %eax,%ebx
            return r;
        }
        sys_page_unmap(0, UTEMP);
    }
    return 0;
}
  802396:	89 d8                	mov    %ebx,%eax
  802398:	83 c4 3c             	add    $0x3c,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5e                   	pop    %esi
  80239d:	5f                   	pop    %edi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  8023a0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023a7:	00 
  8023a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023af:	e8 79 f5 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
        va = ROUNDUP(va, PGSIZE);
  8023b4:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8023b7:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
  8023bd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        len -= bytes;
  8023c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023c6:	29 45 18             	sub    %eax,0x18(%ebp)
  8023c9:	e9 20 ff ff ff       	jmp    8022ee <_Z10spawn_readiPvijji+0x112>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  8023ce:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023d5:	00 
  8023d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023dd:	e8 4b f5 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  8023e2:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  8023e9:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  8023ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f2:	39 55 e0             	cmp    %edx,-0x20(%ebp)
  8023f5:	0f 87 09 ff ff ff    	ja     802304 <_Z10spawn_readiPvijji+0x128>
  8023fb:	eb 99                	jmp    802396 <_Z10spawn_readiPvijji+0x1ba>

008023fd <_Z5spawnPKcPS0_>:
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
  802400:	81 ec b8 02 00 00    	sub    $0x2b8,%esp
  802406:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802409:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80240c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80240f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unfortunately, you cannot 'read' into a child address space,
	// so you'll need to code the 'read' case differently.
	//
	// Also, make sure you close the file descriptor, if any,
	// before returning from spawn().
    int fs_load = prog[0] == '/';
  802412:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  802415:	0f 94 c0             	sete   %al
  802418:	0f b6 c0             	movzbl %al,%eax
  80241b:	89 c6                	mov    %eax,%esi
    memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
  80241d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802424:	00 
  802425:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80242c:	00 
  80242d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802433:	89 04 24             	mov    %eax,(%esp)
  802436:	e8 96 f0 ff ff       	call   8014d1 <memset>
    if(fs_load)
  80243b:	85 f6                	test   %esi,%esi
  80243d:	74 41                	je     802480 <_Z5spawnPKcPS0_+0x83>
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
  80243f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802446:	00 
  802447:	89 1c 24             	mov    %ebx,(%esp)
  80244a:	e8 bf 17 00 00       	call   803c0e <_Z4openPKci>
  80244f:	89 c3                	mov    %eax,%ebx
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 88 4e 05 00 00    	js     8029a7 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
  802459:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802460:	00 
  802461:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246b:	89 1c 24             	mov    %ebx,(%esp)
  80246e:	e8 a5 0b 00 00       	call   803018 <_Z5readniPvj>
  802473:	3d 00 02 00 00       	cmp    $0x200,%eax
  802478:	0f 85 11 05 00 00    	jne    80298f <_Z5spawnPKcPS0_+0x592>
  80247e:	eb 51                	jmp    8024d1 <_Z5spawnPKcPS0_+0xd4>
            return -E_NOT_EXEC;
    }
    else
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
  802480:	89 1c 24             	mov    %ebx,(%esp)
  802483:	e8 c8 ee ff ff       	call   801350 <_Z6strlenPKc>
  802488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248c:	89 1c 24             	mov    %ebx,(%esp)
  80248f:	e8 04 f7 ff ff       	call   801b98 <_Z18sys_program_lookupPKcj>
  802494:	89 c3                	mov    %eax,%ebx
  802496:	85 c0                	test   %eax,%eax
  802498:	0f 88 09 05 00 00    	js     8029a7 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
  80249e:	c7 44 24 10 00 02 00 	movl   $0x200,0x10(%esp)
  8024a5:	00 
  8024a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024ad:	00 
  8024ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b2:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8024b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c3:	e8 a5 f7 ff ff       	call   801c6d <_Z16sys_program_readiPvijj>
  8024c8:	83 f8 04             	cmp    $0x4,%eax
  8024cb:	0f 85 c5 04 00 00    	jne    802996 <_Z5spawnPKcPS0_+0x599>
            return -E_NOT_EXEC;
    }
    if (elf->e_magic != ELF_MAGIC) {
  8024d1:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
  8024d7:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8024dc:	74 22                	je     802500 <_Z5spawnPKcPS0_+0x103>
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8024de:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8024e5:	46 
  8024e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ea:	c7 04 24 12 5f 80 00 	movl   $0x805f12,(%esp)
  8024f1:	e8 98 e7 ff ff       	call   800c8e <_Z7cprintfPKcz>
        return -E_NOT_EXEC;
  8024f6:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  8024fb:	e9 a7 04 00 00       	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  802500:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
  802506:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
    struct Proghdr *eph = ph + elf->e_phnum;
  80250c:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
  802513:	66 89 85 76 fd ff ff 	mov    %ax,-0x28a(%ebp)
  80251a:	ba 07 00 00 00       	mov    $0x7,%edx
  80251f:	89 d0                	mov    %edx,%eax
  802521:	cd 30                	int    $0x30
  802523:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802529:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
  80252f:	85 c0                	test   %eax,%eax
  802531:	0f 88 66 04 00 00    	js     80299d <_Z5spawnPKcPS0_+0x5a0>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
  802537:	25 ff 03 00 00       	and    $0x3ff,%eax
  80253c:	6b c0 78             	imul   $0x78,%eax,%eax
  80253f:	05 14 00 00 ef       	add    $0xef000014,%eax
  802544:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  80254b:	00 
  80254c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802550:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  802553:	89 04 24             	mov    %eax,(%esp)
  802556:	e8 4c f0 ff ff       	call   8015a7 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80255b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255e:	8b 02                	mov    (%edx),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	0f 84 93 00 00 00    	je     8025fb <_Z5spawnPKcPS0_+0x1fe>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802568:	bf 00 00 00 00       	mov    $0x0,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  80256d:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  802574:	00 00 00 
  802577:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80257d:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  802583:	bb 00 00 00 00       	mov    $0x0,%ebx
  802588:	89 d6                	mov    %edx,%esi
		string_size += strlen(argv[argc]) + 1;
  80258a:	89 04 24             	mov    %eax,(%esp)
  80258d:	e8 be ed ff ff       	call   801350 <_Z6strlenPKc>
  802592:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802596:	83 c3 01             	add    $0x1,%ebx
  802599:	89 da                	mov    %ebx,%edx
  80259b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8025a2:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 e1                	jne    80258a <_Z5spawnPKcPS0_+0x18d>
  8025a9:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  8025af:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8025b5:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
  8025bb:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  8025c1:	89 8d 70 fd ff ff    	mov    %ecx,-0x290(%ebp)
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  8025c7:	f7 df                	neg    %edi
  8025c9:	81 c7 00 10 40 00    	add    $0x401000,%edi

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  8025cf:	89 fa                	mov    %edi,%edx
  8025d1:	83 e2 fc             	and    $0xfffffffc,%edx
  8025d4:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8025da:	f7 d0                	not    %eax
  8025dc:	8d 04 82             	lea    (%edx,%eax,4),%eax
  8025df:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8025e5:	83 e8 08             	sub    $0x8,%eax
  8025e8:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  8025ee:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8025f3:	0f 86 78 01 00 00    	jbe    802771 <_Z5spawnPKcPS0_+0x374>
  8025f9:	eb 37                	jmp    802632 <_Z5spawnPKcPS0_+0x235>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8025fb:	c7 85 70 fd ff ff 00 	movl   $0x0,-0x290(%ebp)
  802602:	00 00 00 
  802605:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  80260c:	00 00 00 
  80260f:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  802616:	00 00 00 
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802619:	c7 85 84 fd ff ff f4 	movl   $0x400ff4,-0x27c(%ebp)
  802620:	0f 40 00 
	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  802623:	c7 85 8c fd ff ff fc 	movl   $0x400ffc,-0x274(%ebp)
  80262a:	0f 40 00 
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  80262d:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate a page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802632:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802639:	00 
  80263a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802641:	00 
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 22 f2 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  80264e:	85 c0                	test   %eax,%eax
  802650:	0f 88 1b 01 00 00    	js     802771 <_Z5spawnPKcPS0_+0x374>
		return r;

	// Store the 'argc' and 'argv' parameters themselves
	// below 'argv_store' on the stack.  These parameters will be passed
	// to umain().
	argv_store[-2] = argc;
  802656:	8b 95 7c fd ff ff    	mov    -0x284(%ebp),%edx
  80265c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802662:	89 10                	mov    %edx,(%eax)
	argv_store[-1] = utemp_addr_to_stack_addr(argv_store);
  802664:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80266a:	e8 29 fb ff ff       	call   802198 <_ZL24utemp_addr_to_stack_addrPv>
  80266f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802675:	89 42 fc             	mov    %eax,-0x4(%edx)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  802678:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  80267f:	7e 71                	jle    8026f2 <_Z5spawnPKcPS0_+0x2f5>
  802681:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802688:	00 00 00 
  80268b:	89 9d 6c fd ff ff    	mov    %ebx,-0x294(%ebp)
  802691:	89 b5 68 fd ff ff    	mov    %esi,-0x298(%ebp)
  802697:	be 00 00 00 00       	mov    $0x0,%esi
  80269c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  80269f:	89 f8                	mov    %edi,%eax
  8026a1:	e8 f2 fa ff ff       	call   802198 <_ZL24utemp_addr_to_stack_addrPv>
    }
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
  8026a6:	89 f1                	mov    %esi,%ecx
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  8026a8:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8026ae:	89 04 b2             	mov    %eax,(%edx,%esi,4)

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  8026b1:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8026b4:	0f b6 00             	movzbl (%eax),%eax
  8026b7:	84 c0                	test   %al,%al
  8026b9:	74 18                	je     8026d3 <_Z5spawnPKcPS0_+0x2d6>
  8026bb:	ba 00 00 00 00       	mov    $0x0,%edx
        {
            *string_store = argv[i][j];
  8026c0:	88 07                	mov    %al,(%edi)
            string_store++;
  8026c2:	83 c7 01             	add    $0x1,%edi
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  8026c5:	83 c2 01             	add    $0x1,%edx
  8026c8:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
  8026cb:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  8026cf:	84 c0                	test   %al,%al
  8026d1:	75 ed                	jne    8026c0 <_Z5spawnPKcPS0_+0x2c3>
        {
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
  8026d3:	c6 07 00             	movb   $0x0,(%edi)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  8026d6:	83 c6 01             	add    $0x1,%esi
  8026d9:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  8026df:	7d 05                	jge    8026e6 <_Z5spawnPKcPS0_+0x2e9>
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
        string_store++;
  8026e1:	83 c7 01             	add    $0x1,%edi
  8026e4:	eb b9                	jmp    80269f <_Z5spawnPKcPS0_+0x2a2>
  8026e6:	8b 9d 6c fd ff ff    	mov    -0x294(%ebp),%ebx
  8026ec:	8b b5 68 fd ff ff    	mov    -0x298(%ebp),%esi
    }   
    
    // null-terminate the whole argv array
    argv_store[argc] = 0;
  8026f2:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8026f8:	8b 85 70 fd ff ff    	mov    -0x290(%ebp),%eax
  8026fe:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)

	// Set *init_esp to the initial stack pointer for the child:
	// it should point at the "argc" value stored on the stack.
	// set the initial stack to point at argc
    *init_esp = utemp_addr_to_stack_addr(&argv_store[-2]);
  802705:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80270b:	e8 88 fa ff ff       	call   802198 <_ZL24utemp_addr_to_stack_addrPv>
  802710:	89 45 e0             	mov    %eax,-0x20(%ebp)


	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802713:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80271a:	00 
  80271b:	c7 44 24 0c 00 d0 ff 	movl   $0xeeffd000,0xc(%esp)
  802722:	ee 
  802723:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802729:	89 44 24 08          	mov    %eax,0x8(%esp)
  80272d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802734:	00 
  802735:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80273c:	e8 8e f1 ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  802741:	85 c0                	test   %eax,%eax
  802743:	78 18                	js     80275d <_Z5spawnPKcPS0_+0x360>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802745:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80274c:	00 
  80274d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802754:	e8 d4 f1 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
  802759:	85 c0                	test   %eax,%eax
  80275b:	79 14                	jns    802771 <_Z5spawnPKcPS0_+0x374>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80275d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802764:	00 
  802765:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276c:	e8 bc f1 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
  802771:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
  802777:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if ((r = sys_env_set_trapframe(envid, &tf)))
  80277a:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  80277d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802781:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802787:	89 14 24             	mov    %edx,(%esp)
  80278a:	e8 b8 f2 ff ff       	call   801a47 <_Z21sys_env_set_trapframeiP9Trapframe>
  80278f:	85 c0                	test   %eax,%eax
  802791:	0f 85 0e 02 00 00    	jne    8029a5 <_Z5spawnPKcPS0_+0x5a8>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  802797:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80279d:	03 bd 80 fd ff ff    	add    -0x280(%ebp),%edi
    struct Proghdr *eph = ph + elf->e_phnum;
  8027a3:	0f b7 85 76 fd ff ff 	movzwl -0x28a(%ebp),%eax
  8027aa:	c1 e0 05             	shl    $0x5,%eax
  8027ad:	8d 04 07             	lea    (%edi,%eax,1),%eax
  8027b0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  8027b6:	39 c7                	cmp    %eax,%edi
  8027b8:	0f 83 25 01 00 00    	jae    8028e3 <_Z5spawnPKcPS0_+0x4e6>
  8027be:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8027c4:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  8027ca:	89 fe                	mov    %edi,%esi
  8027cc:	8b bd 78 fd ff ff    	mov    -0x288(%ebp),%edi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
  8027d2:	83 3e 01             	cmpl   $0x1,(%esi)
  8027d5:	0f 85 ed 00 00 00    	jne    8028c8 <_Z5spawnPKcPS0_+0x4cb>
{
    // identical to segment alloc for load_elf!
    int r;

    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
  8027db:	8b 5e 08             	mov    0x8(%esi),%ebx
  8027de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    len = ROUNDUP(va + len, PGSIZE);
  8027e4:	8b 46 14             	mov    0x14(%esi),%eax
  8027e7:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
  8027ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027f3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  8027f9:	39 c3                	cmp    %eax,%ebx
  8027fb:	73 3c                	jae    802839 <_Z5spawnPKcPS0_+0x43c>
  8027fd:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  802803:	89 c6                	mov    %eax,%esi
        if ((r = sys_page_alloc(dst_env, (void *)i, PTE_P|PTE_U|PTE_W)))
  802805:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80280c:	00 
  80280d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802811:	89 3c 24             	mov    %edi,(%esp)
  802814:	e8 57 f0 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  802819:	85 c0                	test   %eax,%eax
  80281b:	74 0c                	je     802829 <_Z5spawnPKcPS0_+0x42c>
  80281d:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  802823:	f7 d8                	neg    %eax
  802825:	75 4b                	jne    802872 <_Z5spawnPKcPS0_+0x475>
  802827:	eb 10                	jmp    802839 <_Z5spawnPKcPS0_+0x43c>
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(va + len, PGSIZE);

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  802829:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80282f:	39 de                	cmp    %ebx,%esi
  802831:	77 d2                	ja     802805 <_Z5spawnPKcPS0_+0x408>
  802833:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  802839:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80283f:	89 44 24 14          	mov    %eax,0x14(%esp)
  802843:	8b 46 10             	mov    0x10(%esi),%eax
  802846:	89 44 24 10          	mov    %eax,0x10(%esp)
  80284a:	8b 46 04             	mov    0x4(%esi),%eax
  80284d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802851:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802857:	89 54 24 08          	mov    %edx,0x8(%esp)
  80285b:	8b 46 08             	mov    0x8(%esi),%eax
  80285e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802862:	89 3c 24             	mov    %edi,(%esp)
  802865:	e8 72 f9 ff ff       	call   8021dc <_Z10spawn_readiPvijji>
  80286a:	85 c0                	test   %eax,%eax
  80286c:	0f 89 44 01 00 00    	jns    8029b6 <_Z5spawnPKcPS0_+0x5b9>
  802872:	89 c7                	mov    %eax,%edi
               (r = spawn_read(envid, (void *)ph->p_va, progid, ph->p_offset, ph->p_filesz, fs_load)) < 0)
            {
                sys_env_destroy(envid);
  802874:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80287a:	89 04 24             	mov    %eax,(%esp)
  80287d:	e8 29 ef ff ff       	call   8017ab <_Z15sys_env_destroyi>
                return r;
  802882:	89 fb                	mov    %edi,%ebx
  802884:	e9 1e 01 00 00       	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  802889:	8b 46 08             	mov    0x8(%esi),%eax
  80288c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802891:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  802898:	00 
  802899:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80289d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8028a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a5:	89 3c 24             	mov    %edi,(%esp)
  8028a8:	e8 22 f0 ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 17                	je     8028c8 <_Z5spawnPKcPS0_+0x4cb>
  8028b1:	89 c7                	mov    %eax,%edi
            {
                sys_env_destroy(envid);
  8028b3:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8028b9:	89 14 24             	mov    %edx,(%esp)
  8028bc:	e8 ea ee ff ff       	call   8017ab <_Z15sys_env_destroyi>
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  8028c1:	89 fb                	mov    %edi,%ebx
            {
                sys_env_destroy(envid);
                return r;
  8028c3:	e9 df 00 00 00       	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  8028c8:	83 c6 20             	add    $0x20,%esi
  8028cb:	39 b5 94 fd ff ff    	cmp    %esi,-0x26c(%ebp)
  8028d1:	0f 87 fb fe ff ff    	ja     8027d2 <_Z5spawnPKcPS0_+0x3d5>
  8028d7:	8b 9d 84 fd ff ff    	mov    -0x27c(%ebp),%ebx
  8028dd:	8b b5 80 fd ff ff    	mov    -0x280(%ebp),%esi
            }
                 
        }
    }

    if(fs_load)
  8028e3:	85 f6                	test   %esi,%esi
  8028e5:	74 08                	je     8028ef <_Z5spawnPKcPS0_+0x4f2>
        close(progid);
  8028e7:	89 1c 24             	mov    %ebx,(%esp)
  8028ea:	e8 e6 04 00 00       	call   802dd5 <_Z5closei>
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  8028ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028f4:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
		if (!(vpd[PDX(va)] & PTE_P))
  8028fa:	89 d8                	mov    %ebx,%eax
  8028fc:	c1 e8 16             	shr    $0x16,%eax
  8028ff:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  802906:	a8 01                	test   $0x1,%al
  802908:	75 0e                	jne    802918 <_Z5spawnPKcPS0_+0x51b>
			va = ROUNDUP(va + 1, PTSIZE) - PGSIZE;
  80290a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  802910:	8d 9b 00 f0 3f 00    	lea    0x3ff000(%ebx),%ebx
  802916:	eb 46                	jmp    80295e <_Z5spawnPKcPS0_+0x561>
		else if ((vpt[PGNUM(va)] & (PTE_P|PTE_SHARE)) == (PTE_P|PTE_SHARE)) {
  802918:	89 d8                	mov    %ebx,%eax
  80291a:	c1 e8 0c             	shr    $0xc,%eax
  80291d:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  802924:	81 e2 01 04 00 00    	and    $0x401,%edx
  80292a:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  802930:	75 2c                	jne    80295e <_Z5spawnPKcPS0_+0x561>
			r = sys_page_map(0, (void *) va, child, (void *) va,
					 vpt[PGNUM(va)] & PTE_SYSCALL);
  802932:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  802939:	25 07 0e 00 00       	and    $0xe07,%eax
  80293e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802942:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802946:	89 74 24 08          	mov    %esi,0x8(%esp)
  80294a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80294e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802955:	e8 75 ef ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
			if (r < 0)
  80295a:	85 c0                	test   %eax,%eax
  80295c:	78 0e                	js     80296c <_Z5spawnPKcPS0_+0x56f>
static int
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
  80295e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802964:	81 fb ff ff ff ee    	cmp    $0xeeffffff,%ebx
  80296a:	76 8e                	jbe    8028fa <_Z5spawnPKcPS0_+0x4fd>
    if(fs_load)
        close(progid);
    copy_shared_pages(envid);
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80296c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802973:	00 
  802974:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80297a:	89 04 24             	mov    %eax,(%esp)
  80297d:	e8 09 f0 ff ff       	call   80198b <_Z18sys_env_set_statusii>
        return r;
  802982:	85 c0                	test   %eax,%eax
  802984:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  80298a:	0f 48 d8             	cmovs  %eax,%ebx
  80298d:	eb 18                	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
    if(fs_load)
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
            return -E_NOT_EXEC;
  80298f:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  802994:	eb 11                	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
            return -E_NOT_EXEC;
  802996:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  80299b:	eb 0a                	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    struct Proghdr *eph = ph + elf->e_phnum;
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
        return envid;
  80299d:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  8029a3:	eb 02                	jmp    8029a7 <_Z5spawnPKcPS0_+0x5aa>
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
  8029a5:	89 c3                	mov    %eax,%ebx
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        return r;
    return envid;
}
  8029a7:	89 d8                	mov    %ebx,%eax
  8029a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029ac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029af:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029b2:	89 ec                	mov    %ebp,%esp
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  8029b6:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  8029ba:	0f 85 08 ff ff ff    	jne    8028c8 <_Z5spawnPKcPS0_+0x4cb>
  8029c0:	e9 c4 fe ff ff       	jmp    802889 <_Z5spawnPKcPS0_+0x48c>

008029c5 <_Z6spawnlPKcS0_z>:
}

// Spawn, taking command-line arguments array directly on the stack.
envid_t
spawnl(const char *prog, const char *arg0, ...)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  8029cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8029ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	89 04 24             	mov    %eax,(%esp)
  8029d8:	e8 20 fa ff ff       	call   8023fd <_Z5spawnPKcPS0_>
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    
	...

008029e0 <_Z8argstartPiPPcP8Argstate>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
  8029e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029e9:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8029ec:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8029ee:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8029f1:	83 3a 01             	cmpl   $0x1,(%edx)
  8029f4:	7e 09                	jle    8029ff <_Z8argstartPiPPcP8Argstate+0x1f>
  8029f6:	ba 81 58 80 00       	mov    $0x805881,%edx
  8029fb:	85 c9                	test   %ecx,%ecx
  8029fd:	75 05                	jne    802a04 <_Z8argstartPiPPcP8Argstate+0x24>
  8029ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802a04:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  802a07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    

00802a10 <_Z7argnextP8Argstate>:

int
argnext(struct Argstate *args)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	83 ec 28             	sub    $0x28,%esp
  802a16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  802a22:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802a29:	8b 53 08             	mov    0x8(%ebx),%edx
		return -1;
  802a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	int arg;

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802a31:	85 d2                	test   %edx,%edx
  802a33:	74 6f                	je     802aa4 <_Z7argnextP8Argstate+0x94>
		return -1;

	if (!*args->curarg) {
  802a35:	80 3a 00             	cmpb   $0x0,(%edx)
  802a38:	75 50                	jne    802a8a <_Z7argnextP8Argstate+0x7a>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802a3a:	8b 0b                	mov    (%ebx),%ecx
  802a3c:	83 39 01             	cmpl   $0x1,(%ecx)
  802a3f:	74 57                	je     802a98 <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
  802a41:	8b 43 04             	mov    0x4(%ebx),%eax
  802a44:	8d 70 04             	lea    0x4(%eax),%esi
  802a47:	8b 50 04             	mov    0x4(%eax),%edx
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802a4a:	80 3a 2d             	cmpb   $0x2d,(%edx)
  802a4d:	75 49                	jne    802a98 <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  802a4f:	8d 7a 01             	lea    0x1(%edx),%edi
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802a52:	80 7a 01 00          	cmpb   $0x0,0x1(%edx)
  802a56:	74 40                	je     802a98 <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802a58:	89 7b 08             	mov    %edi,0x8(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802a5b:	8b 11                	mov    (%ecx),%edx
  802a5d:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  802a64:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a68:	83 c0 08             	add    $0x8,%eax
  802a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6f:	89 34 24             	mov    %esi,(%esp)
  802a72:	e8 30 eb ff ff       	call   8015a7 <memcpy>
		(*args->argc)--;
  802a77:	8b 03                	mov    (%ebx),%eax
  802a79:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802a7c:	8b 43 08             	mov    0x8(%ebx),%eax
  802a7f:	80 38 2d             	cmpb   $0x2d,(%eax)
  802a82:	75 06                	jne    802a8a <_Z7argnextP8Argstate+0x7a>
  802a84:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  802a88:	74 0e                	je     802a98 <_Z7argnextP8Argstate+0x88>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  802a8a:	8b 53 08             	mov    0x8(%ebx),%edx
  802a8d:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  802a90:	83 c2 01             	add    $0x1,%edx
  802a93:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  802a96:	eb 0c                	jmp    802aa4 <_Z7argnextP8Argstate+0x94>

    endofargs:
	args->curarg = 0;
  802a98:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  802a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802aa4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802aa7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802aaa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802aad:	89 ec                	mov    %ebp,%esp
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    

00802ab1 <_Z12argnextvalueP8Argstate>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
  802ab4:	83 ec 18             	sub    $0x18,%esp
  802ab7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802aba:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802abd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  802ac0:	8b 53 08             	mov    0x8(%ebx),%edx
		return 0;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
}

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
  802ac8:	85 d2                	test   %edx,%edx
  802aca:	74 58                	je     802b24 <_Z12argnextvalueP8Argstate+0x73>
		return 0;
	if (*args->curarg) {
  802acc:	80 3a 00             	cmpb   $0x0,(%edx)
  802acf:	74 0c                	je     802add <_Z12argnextvalueP8Argstate+0x2c>
		args->argvalue = args->curarg;
  802ad1:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  802ad4:	c7 43 08 81 58 80 00 	movl   $0x805881,0x8(%ebx)
  802adb:	eb 44                	jmp    802b21 <_Z12argnextvalueP8Argstate+0x70>
	} else if (*args->argc > 1) {
  802add:	8b 03                	mov    (%ebx),%eax
  802adf:	83 38 01             	cmpl   $0x1,(%eax)
  802ae2:	7e 2f                	jle    802b13 <_Z12argnextvalueP8Argstate+0x62>
		args->argvalue = args->argv[1];
  802ae4:	8b 53 04             	mov    0x4(%ebx),%edx
  802ae7:	8d 4a 04             	lea    0x4(%edx),%ecx
  802aea:	8b 72 04             	mov    0x4(%edx),%esi
  802aed:	89 73 0c             	mov    %esi,0xc(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  802af9:	89 44 24 08          	mov    %eax,0x8(%esp)
  802afd:	83 c2 08             	add    $0x8,%edx
  802b00:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b04:	89 0c 24             	mov    %ecx,(%esp)
  802b07:	e8 9b ea ff ff       	call   8015a7 <memcpy>
		(*args->argc)--;
  802b0c:	8b 03                	mov    (%ebx),%eax
  802b0e:	83 28 01             	subl   $0x1,(%eax)
  802b11:	eb 0e                	jmp    802b21 <_Z12argnextvalueP8Argstate+0x70>
	} else {
		args->argvalue = 0;
  802b13:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  802b1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  802b21:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  802b24:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802b27:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802b2a:	89 ec                	mov    %ebp,%esp
  802b2c:	5d                   	pop    %ebp
  802b2d:	c3                   	ret    

00802b2e <_Z8argvalueP8Argstate>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  802b2e:	55                   	push   %ebp
  802b2f:	89 e5                	mov    %esp,%ebp
  802b31:	83 ec 18             	sub    $0x18,%esp
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802b37:	8b 42 0c             	mov    0xc(%edx),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	75 08                	jne    802b46 <_Z8argvalueP8Argstate+0x18>
  802b3e:	89 14 24             	mov    %edx,(%esp)
  802b41:	e8 6b ff ff ff       	call   802ab1 <_Z12argnextvalueP8Argstate>
}
  802b46:	c9                   	leave  
  802b47:	c3                   	ret    
	...

00802b50 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  802b50:	55                   	push   %ebp
  802b51:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  802b53:	a9 ff 0f 00 00       	test   $0xfff,%eax
  802b58:	75 11                	jne    802b6b <_ZL8fd_validPK2Fd+0x1b>
  802b5a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  802b5f:	76 0a                	jbe    802b6b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  802b61:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  802b66:	0f 96 c0             	setbe  %al
  802b69:	eb 05                	jmp    802b70 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b70:	5d                   	pop    %ebp
  802b71:	c3                   	ret    

00802b72 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  802b72:	55                   	push   %ebp
  802b73:	89 e5                	mov    %esp,%ebp
  802b75:	53                   	push   %ebx
  802b76:	83 ec 14             	sub    $0x14,%esp
  802b79:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  802b7b:	e8 d0 ff ff ff       	call   802b50 <_ZL8fd_validPK2Fd>
  802b80:	84 c0                	test   %al,%al
  802b82:	75 24                	jne    802ba8 <_ZL9fd_isopenPK2Fd+0x36>
  802b84:	c7 44 24 0c 2c 5f 80 	movl   $0x805f2c,0xc(%esp)
  802b8b:	00 
  802b8c:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  802b93:	00 
  802b94:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  802b9b:	00 
  802b9c:	c7 04 24 39 5f 80 00 	movl   $0x805f39,(%esp)
  802ba3:	e8 c8 df ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  802ba8:	89 d8                	mov    %ebx,%eax
  802baa:	c1 e8 16             	shr    $0x16,%eax
  802bad:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  802bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb9:	f6 c2 01             	test   $0x1,%dl
  802bbc:	74 0d                	je     802bcb <_ZL9fd_isopenPK2Fd+0x59>
  802bbe:	c1 eb 0c             	shr    $0xc,%ebx
  802bc1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  802bc8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  802bcb:	83 c4 14             	add    $0x14,%esp
  802bce:	5b                   	pop    %ebx
  802bcf:	5d                   	pop    %ebp
  802bd0:	c3                   	ret    

00802bd1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 08             	sub    $0x8,%esp
  802bd7:	89 1c 24             	mov    %ebx,(%esp)
  802bda:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802be1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802be4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802be8:	83 fb 1f             	cmp    $0x1f,%ebx
  802beb:	77 18                	ja     802c05 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  802bed:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  802bf3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802bf6:	84 c0                	test   %al,%al
  802bf8:	74 21                	je     802c1b <_Z9fd_lookupiPP2Fdb+0x4a>
  802bfa:	89 d8                	mov    %ebx,%eax
  802bfc:	e8 71 ff ff ff       	call   802b72 <_ZL9fd_isopenPK2Fd>
  802c01:	84 c0                	test   %al,%al
  802c03:	75 16                	jne    802c1b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  802c05:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  802c0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  802c10:	8b 1c 24             	mov    (%esp),%ebx
  802c13:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c17:	89 ec                	mov    %ebp,%esp
  802c19:	5d                   	pop    %ebp
  802c1a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  802c1b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	eb ec                	jmp    802c10 <_Z9fd_lookupiPP2Fdb+0x3f>

00802c24 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
  802c27:	53                   	push   %ebx
  802c28:	83 ec 14             	sub    $0x14,%esp
  802c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  802c2e:	89 d8                	mov    %ebx,%eax
  802c30:	e8 1b ff ff ff       	call   802b50 <_ZL8fd_validPK2Fd>
  802c35:	84 c0                	test   %al,%al
  802c37:	75 24                	jne    802c5d <_Z6fd2numP2Fd+0x39>
  802c39:	c7 44 24 0c 2c 5f 80 	movl   $0x805f2c,0xc(%esp)
  802c40:	00 
  802c41:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  802c48:	00 
  802c49:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  802c50:	00 
  802c51:	c7 04 24 39 5f 80 00 	movl   $0x805f39,(%esp)
  802c58:	e8 13 df ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c5d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  802c63:	c1 e8 0c             	shr    $0xc,%eax
}
  802c66:	83 c4 14             	add    $0x14,%esp
  802c69:	5b                   	pop    %ebx
  802c6a:	5d                   	pop    %ebp
  802c6b:	c3                   	ret    

00802c6c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  802c6c:	55                   	push   %ebp
  802c6d:	89 e5                	mov    %esp,%ebp
  802c6f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	89 04 24             	mov    %eax,(%esp)
  802c78:	e8 a7 ff ff ff       	call   802c24 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  802c7d:	05 20 00 0d 00       	add    $0xd0020,%eax
  802c82:	c1 e0 0c             	shl    $0xc,%eax
}
  802c85:	c9                   	leave  
  802c86:	c3                   	ret    

00802c87 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
  802c8a:	57                   	push   %edi
  802c8b:	56                   	push   %esi
  802c8c:	53                   	push   %ebx
  802c8d:	83 ec 2c             	sub    $0x2c,%esp
  802c90:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  802c93:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  802c98:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  802c9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802ca2:	00 
  802ca3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ca7:	89 1c 24             	mov    %ebx,(%esp)
  802caa:	e8 22 ff ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  802caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb2:	e8 bb fe ff ff       	call   802b72 <_ZL9fd_isopenPK2Fd>
  802cb7:	84 c0                	test   %al,%al
  802cb9:	75 0c                	jne    802cc7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	89 07                	mov    %eax,(%edi)
			return 0;
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	eb 13                	jmp    802cda <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  802cc7:	83 c3 01             	add    $0x1,%ebx
  802cca:	83 fb 20             	cmp    $0x20,%ebx
  802ccd:	75 cc                	jne    802c9b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802ccf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  802cd5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802cda:	83 c4 2c             	add    $0x2c,%esp
  802cdd:	5b                   	pop    %ebx
  802cde:	5e                   	pop    %esi
  802cdf:	5f                   	pop    %edi
  802ce0:	5d                   	pop    %ebp
  802ce1:	c3                   	ret    

00802ce2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ce2:	55                   	push   %ebp
  802ce3:	89 e5                	mov    %esp,%ebp
  802ce5:	53                   	push   %ebx
  802ce6:	83 ec 14             	sub    $0x14,%esp
  802ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  802cf4:	39 0d 20 70 80 00    	cmp    %ecx,0x807020
  802cfa:	75 16                	jne    802d12 <_Z10dev_lookupiPP3Dev+0x30>
  802cfc:	eb 06                	jmp    802d04 <_Z10dev_lookupiPP3Dev+0x22>
  802cfe:	39 0a                	cmp    %ecx,(%edx)
  802d00:	75 10                	jne    802d12 <_Z10dev_lookupiPP3Dev+0x30>
  802d02:	eb 05                	jmp    802d09 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d04:	ba 20 70 80 00       	mov    $0x807020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  802d09:	89 13                	mov    %edx,(%ebx)
			return 0;
  802d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d10:	eb 35                	jmp    802d47 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d12:	83 c0 01             	add    $0x1,%eax
  802d15:	8b 14 85 a4 5f 80 00 	mov    0x805fa4(,%eax,4),%edx
  802d1c:	85 d2                	test   %edx,%edx
  802d1e:	75 de                	jne    802cfe <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d20:	a1 14 80 80 00       	mov    0x808014,%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d30:	c7 04 24 60 5f 80 00 	movl   $0x805f60,(%esp)
  802d37:	e8 52 df ff ff       	call   800c8e <_Z7cprintfPKcz>
	*dev = 0;
  802d3c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  802d42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d47:	83 c4 14             	add    $0x14,%esp
  802d4a:	5b                   	pop    %ebx
  802d4b:	5d                   	pop    %ebp
  802d4c:	c3                   	ret    

00802d4d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	56                   	push   %esi
  802d51:	53                   	push   %ebx
  802d52:	83 ec 20             	sub    $0x20,%esp
  802d55:	8b 75 08             	mov    0x8(%ebp),%esi
  802d58:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  802d5c:	89 34 24             	mov    %esi,(%esp)
  802d5f:	e8 c0 fe ff ff       	call   802c24 <_Z6fd2numP2Fd>
  802d64:	0f b6 d3             	movzbl %bl,%edx
  802d67:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d6b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802d6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d72:	89 04 24             	mov    %eax,(%esp)
  802d75:	e8 57 fe ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	78 05                	js     802d83 <_Z8fd_closeP2Fdb+0x36>
  802d7e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802d81:	74 0c                	je     802d8f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  802d83:	80 fb 01             	cmp    $0x1,%bl
  802d86:	19 db                	sbb    %ebx,%ebx
  802d88:	f7 d3                	not    %ebx
  802d8a:	83 e3 fd             	and    $0xfffffffd,%ebx
  802d8d:	eb 3d                	jmp    802dcc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802d8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d92:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d96:	8b 06                	mov    (%esi),%eax
  802d98:	89 04 24             	mov    %eax,(%esp)
  802d9b:	e8 42 ff ff ff       	call   802ce2 <_Z10dev_lookupiPP3Dev>
  802da0:	89 c3                	mov    %eax,%ebx
  802da2:	85 c0                	test   %eax,%eax
  802da4:	78 16                	js     802dbc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802dac:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 07                	je     802dbc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  802db5:	89 34 24             	mov    %esi,(%esp)
  802db8:	ff d0                	call   *%eax
  802dba:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc7:	e8 61 eb ff ff       	call   80192d <_Z14sys_page_unmapiPv>
	return r;
}
  802dcc:	89 d8                	mov    %ebx,%eax
  802dce:	83 c4 20             	add    $0x20,%esp
  802dd1:	5b                   	pop    %ebx
  802dd2:	5e                   	pop    %esi
  802dd3:	5d                   	pop    %ebp
  802dd4:	c3                   	ret    

00802dd5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  802dd5:	55                   	push   %ebp
  802dd6:	89 e5                	mov    %esp,%ebp
  802dd8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802ddb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802de2:	00 
  802de3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	89 04 24             	mov    %eax,(%esp)
  802df0:	e8 dc fd ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  802df5:	85 c0                	test   %eax,%eax
  802df7:	78 13                	js     802e0c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  802df9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802e00:	00 
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	89 04 24             	mov    %eax,(%esp)
  802e07:	e8 41 ff ff ff       	call   802d4d <_Z8fd_closeP2Fdb>
}
  802e0c:	c9                   	leave  
  802e0d:	c3                   	ret    

00802e0e <_Z9close_allv>:

void
close_all(void)
{
  802e0e:	55                   	push   %ebp
  802e0f:	89 e5                	mov    %esp,%ebp
  802e11:	53                   	push   %ebx
  802e12:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  802e15:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802e1a:	89 1c 24             	mov    %ebx,(%esp)
  802e1d:	e8 b3 ff ff ff       	call   802dd5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  802e22:	83 c3 01             	add    $0x1,%ebx
  802e25:	83 fb 20             	cmp    $0x20,%ebx
  802e28:	75 f0                	jne    802e1a <_Z9close_allv+0xc>
		close(i);
}
  802e2a:	83 c4 14             	add    $0x14,%esp
  802e2d:	5b                   	pop    %ebx
  802e2e:	5d                   	pop    %ebp
  802e2f:	c3                   	ret    

00802e30 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 48             	sub    $0x48,%esp
  802e36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802e39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802e3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802e3f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  802e42:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e49:	00 
  802e4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	89 04 24             	mov    %eax,(%esp)
  802e57:	e8 75 fd ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  802e5c:	89 c3                	mov    %eax,%ebx
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	0f 88 ce 00 00 00    	js     802f34 <_Z3dupii+0x104>
  802e66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802e6d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  802e6e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e71:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  802e75:	89 34 24             	mov    %esi,(%esp)
  802e78:	e8 54 fd ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  802e7d:	89 c3                	mov    %eax,%ebx
  802e7f:	85 c0                	test   %eax,%eax
  802e81:	0f 89 bc 00 00 00    	jns    802f43 <_Z3dupii+0x113>
  802e87:	e9 a8 00 00 00       	jmp    802f34 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  802e8c:	89 d8                	mov    %ebx,%eax
  802e8e:	c1 e8 0c             	shr    $0xc,%eax
  802e91:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  802e98:	f6 c2 01             	test   $0x1,%dl
  802e9b:	74 32                	je     802ecf <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e9d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  802ea4:	25 07 0e 00 00       	and    $0xe07,%eax
  802ea9:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ead:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eb1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802eb8:	00 
  802eb9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec4:	e8 06 ea ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  802ec9:	89 c3                	mov    %eax,%ebx
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	78 3e                	js     802f0d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed2:	89 c2                	mov    %eax,%edx
  802ed4:	c1 ea 0c             	shr    $0xc,%edx
  802ed7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  802ede:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802ee4:	89 54 24 10          	mov    %edx,0x10(%esp)
  802ee8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eeb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802eef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802ef6:	00 
  802ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802efb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f02:	e8 c8 e9 ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  802f07:	89 c3                	mov    %eax,%ebx
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	79 25                	jns    802f32 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f1b:	e8 0d ea ff ff       	call   80192d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  802f20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802f24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f2b:	e8 fd e9 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
	return r;
  802f30:	eb 02                	jmp    802f34 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  802f32:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802f34:	89 d8                	mov    %ebx,%eax
  802f36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802f39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802f3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802f3f:	89 ec                	mov    %ebp,%esp
  802f41:	5d                   	pop    %ebp
  802f42:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  802f43:	89 34 24             	mov    %esi,(%esp)
  802f46:	e8 8a fe ff ff       	call   802dd5 <_Z5closei>

	ova = fd2data(oldfd);
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	89 04 24             	mov    %eax,(%esp)
  802f51:	e8 16 fd ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  802f56:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5b:	89 04 24             	mov    %eax,(%esp)
  802f5e:	e8 09 fd ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  802f63:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  802f65:	89 d8                	mov    %ebx,%eax
  802f67:	c1 e8 16             	shr    $0x16,%eax
  802f6a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  802f71:	a8 01                	test   $0x1,%al
  802f73:	0f 85 13 ff ff ff    	jne    802e8c <_Z3dupii+0x5c>
  802f79:	e9 51 ff ff ff       	jmp    802ecf <_Z3dupii+0x9f>

00802f7e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
  802f81:	53                   	push   %ebx
  802f82:	83 ec 24             	sub    $0x24,%esp
  802f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802f88:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802f8f:	00 
  802f90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f97:	89 1c 24             	mov    %ebx,(%esp)
  802f9a:	e8 32 fc ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	78 5f                	js     803002 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	89 04 24             	mov    %eax,(%esp)
  802fb2:	e8 2b fd ff ff       	call   802ce2 <_Z10dev_lookupiPP3Dev>
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	79 4d                	jns    803008 <_Z4readiPvj+0x8a>
  802fbb:	eb 45                	jmp    803002 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fbd:	a1 14 80 80 00       	mov    0x808014,%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fcd:	c7 04 24 42 5f 80 00 	movl   $0x805f42,(%esp)
  802fd4:	e8 b5 dc ff ff       	call   800c8e <_Z7cprintfPKcz>
		return -E_INVAL;
  802fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fde:	eb 22                	jmp    803002 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  802fe6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802feb:	85 d2                	test   %edx,%edx
  802fed:	74 13                	je     803002 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802fef:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff2:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ffd:	89 0c 24             	mov    %ecx,(%esp)
  803000:	ff d2                	call   *%edx
}
  803002:	83 c4 24             	add    $0x24,%esp
  803005:	5b                   	pop    %ebx
  803006:	5d                   	pop    %ebp
  803007:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803008:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80300b:	8b 41 08             	mov    0x8(%ecx),%eax
  80300e:	83 e0 03             	and    $0x3,%eax
  803011:	83 f8 01             	cmp    $0x1,%eax
  803014:	75 ca                	jne    802fe0 <_Z4readiPvj+0x62>
  803016:	eb a5                	jmp    802fbd <_Z4readiPvj+0x3f>

00803018 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
  80301b:	57                   	push   %edi
  80301c:	56                   	push   %esi
  80301d:	53                   	push   %ebx
  80301e:	83 ec 1c             	sub    $0x1c,%esp
  803021:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803024:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  803027:	85 f6                	test   %esi,%esi
  803029:	74 2f                	je     80305a <_Z5readniPvj+0x42>
  80302b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  803030:	89 f0                	mov    %esi,%eax
  803032:	29 d8                	sub    %ebx,%eax
  803034:	89 44 24 08          	mov    %eax,0x8(%esp)
  803038:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80303b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	89 04 24             	mov    %eax,(%esp)
  803045:	e8 34 ff ff ff       	call   802f7e <_Z4readiPvj>
		if (m < 0)
  80304a:	85 c0                	test   %eax,%eax
  80304c:	78 13                	js     803061 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0d                	je     80305f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  803052:	01 c3                	add    %eax,%ebx
  803054:	39 de                	cmp    %ebx,%esi
  803056:	77 d8                	ja     803030 <_Z5readniPvj+0x18>
  803058:	eb 05                	jmp    80305f <_Z5readniPvj+0x47>
  80305a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80305f:	89 d8                	mov    %ebx,%eax
}
  803061:	83 c4 1c             	add    $0x1c,%esp
  803064:	5b                   	pop    %ebx
  803065:	5e                   	pop    %esi
  803066:	5f                   	pop    %edi
  803067:	5d                   	pop    %ebp
  803068:	c3                   	ret    

00803069 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803069:	55                   	push   %ebp
  80306a:	89 e5                	mov    %esp,%ebp
  80306c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80306f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803076:	00 
  803077:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80307a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	89 04 24             	mov    %eax,(%esp)
  803084:	e8 48 fb ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  803089:	85 c0                	test   %eax,%eax
  80308b:	78 3c                	js     8030c9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80308d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803090:	89 44 24 04          	mov    %eax,0x4(%esp)
  803094:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  803097:	8b 00                	mov    (%eax),%eax
  803099:	89 04 24             	mov    %eax,(%esp)
  80309c:	e8 41 fc ff ff       	call   802ce2 <_Z10dev_lookupiPP3Dev>
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	79 26                	jns    8030cb <_Z5writeiPKvj+0x62>
  8030a5:	eb 22                	jmp    8030c9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8030ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8030b2:	85 c9                	test   %ecx,%ecx
  8030b4:	74 13                	je     8030c9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8030b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c4:	89 14 24             	mov    %edx,(%esp)
  8030c7:	ff d1                	call   *%ecx
}
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8030cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  8030ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8030d3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8030d7:	74 f0                	je     8030c9 <_Z5writeiPKvj+0x60>
  8030d9:	eb cc                	jmp    8030a7 <_Z5writeiPKvj+0x3e>

008030db <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8030db:	55                   	push   %ebp
  8030dc:	89 e5                	mov    %esp,%ebp
  8030de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8030e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8030e8:	00 
  8030e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	89 04 24             	mov    %eax,(%esp)
  8030f6:	e8 d6 fa ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	78 0e                	js     80310d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 55 0c             	mov    0xc(%ebp),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310d:	c9                   	leave  
  80310e:	c3                   	ret    

0080310f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
  803112:	53                   	push   %ebx
  803113:	83 ec 24             	sub    $0x24,%esp
  803116:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  803119:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803120:	00 
  803121:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803124:	89 44 24 04          	mov    %eax,0x4(%esp)
  803128:	89 1c 24             	mov    %ebx,(%esp)
  80312b:	e8 a1 fa ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  803130:	85 c0                	test   %eax,%eax
  803132:	78 58                	js     80318c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803134:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	89 04 24             	mov    %eax,(%esp)
  803143:	e8 9a fb ff ff       	call   802ce2 <_Z10dev_lookupiPP3Dev>
  803148:	85 c0                	test   %eax,%eax
  80314a:	79 46                	jns    803192 <_Z9ftruncateii+0x83>
  80314c:	eb 3e                	jmp    80318c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80314e:	a1 14 80 80 00       	mov    0x808014,%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80315a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80315e:	c7 04 24 80 5f 80 00 	movl   $0x805f80,(%esp)
  803165:	e8 24 db ff ff       	call   800c8e <_Z7cprintfPKcz>
		return -E_INVAL;
  80316a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80316f:	eb 1b                	jmp    80318c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  803177:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80317c:	85 d2                	test   %edx,%edx
  80317e:	74 0c                	je     80318c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803180:	8b 45 0c             	mov    0xc(%ebp),%eax
  803183:	89 44 24 04          	mov    %eax,0x4(%esp)
  803187:	89 0c 24             	mov    %ecx,(%esp)
  80318a:	ff d2                	call   *%edx
}
  80318c:	83 c4 24             	add    $0x24,%esp
  80318f:	5b                   	pop    %ebx
  803190:	5d                   	pop    %ebp
  803191:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803192:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803195:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  803199:	75 d6                	jne    803171 <_Z9ftruncateii+0x62>
  80319b:	eb b1                	jmp    80314e <_Z9ftruncateii+0x3f>

0080319d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
  8031a0:	53                   	push   %ebx
  8031a1:	83 ec 24             	sub    $0x24,%esp
  8031a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8031a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8031ae:	00 
  8031af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	89 04 24             	mov    %eax,(%esp)
  8031bc:	e8 10 fa ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	78 3e                	js     803203 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	89 04 24             	mov    %eax,(%esp)
  8031d4:	e8 09 fb ff ff       	call   802ce2 <_Z10dev_lookupiPP3Dev>
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	79 2c                	jns    803209 <_Z5fstatiP4Stat+0x6c>
  8031dd:	eb 24                	jmp    803203 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8031df:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8031e2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  8031e9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  8031f0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8031f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	89 04 24             	mov    %eax,(%esp)
  803200:	ff 52 14             	call   *0x14(%edx)
}
  803203:	83 c4 24             	add    $0x24,%esp
  803206:	5b                   	pop    %ebx
  803207:	5d                   	pop    %ebp
  803208:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  803209:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80320c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  803211:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  803215:	75 c8                	jne    8031df <_Z5fstatiP4Stat+0x42>
  803217:	eb ea                	jmp    803203 <_Z5fstatiP4Stat+0x66>

00803219 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  803219:	55                   	push   %ebp
  80321a:	89 e5                	mov    %esp,%ebp
  80321c:	83 ec 18             	sub    $0x18,%esp
  80321f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803222:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803225:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80322c:	00 
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	89 04 24             	mov    %eax,(%esp)
  803233:	e8 d6 09 00 00       	call   803c0e <_Z4openPKci>
  803238:	89 c3                	mov    %eax,%ebx
  80323a:	85 c0                	test   %eax,%eax
  80323c:	78 1b                	js     803259 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80323e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803241:	89 44 24 04          	mov    %eax,0x4(%esp)
  803245:	89 1c 24             	mov    %ebx,(%esp)
  803248:	e8 50 ff ff ff       	call   80319d <_Z5fstatiP4Stat>
  80324d:	89 c6                	mov    %eax,%esi
	close(fd);
  80324f:	89 1c 24             	mov    %ebx,(%esp)
  803252:	e8 7e fb ff ff       	call   802dd5 <_Z5closei>
	return r;
  803257:	89 f3                	mov    %esi,%ebx
}
  803259:	89 d8                	mov    %ebx,%eax
  80325b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80325e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803261:	89 ec                	mov    %ebp,%esp
  803263:	5d                   	pop    %ebp
  803264:	c3                   	ret    
	...

00803270 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  803273:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  803278:	85 d2                	test   %edx,%edx
  80327a:	78 33                	js     8032af <_ZL10inode_dataP5Inodei+0x3f>
  80327c:	3b 50 08             	cmp    0x8(%eax),%edx
  80327f:	7d 2e                	jge    8032af <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  803281:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  803287:	85 d2                	test   %edx,%edx
  803289:	0f 49 ca             	cmovns %edx,%ecx
  80328c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80328f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  803293:	c1 e1 0c             	shl    $0xc,%ecx
  803296:	89 d0                	mov    %edx,%eax
  803298:	c1 f8 1f             	sar    $0x1f,%eax
  80329b:	c1 e8 14             	shr    $0x14,%eax
  80329e:	01 c2                	add    %eax,%edx
  8032a0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8032a6:	29 c2                	sub    %eax,%edx
  8032a8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8032af:	89 c8                	mov    %ecx,%eax
  8032b1:	5d                   	pop    %ebp
  8032b2:	c3                   	ret    

008032b3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8032b3:	55                   	push   %ebp
  8032b4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8032b6:	8b 48 08             	mov    0x8(%eax),%ecx
  8032b9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  8032c1:	c7 82 80 00 00 00 20 	movl   $0x807020,0x80(%edx)
  8032c8:	70 80 00 
}
  8032cb:	5d                   	pop    %ebp
  8032cc:	c3                   	ret    

008032cd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  8032cd:	55                   	push   %ebp
  8032ce:	89 e5                	mov    %esp,%ebp
  8032d0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  8032d3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 08                	je     8032e5 <_ZL9get_inodei+0x18>
  8032dd:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  8032e3:	7e 20                	jle    803305 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  8032e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032e9:	c7 44 24 08 b8 5f 80 	movl   $0x805fb8,0x8(%esp)
  8032f0:	00 
  8032f1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  8032f8:	00 
  8032f9:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  803300:	e8 6b d8 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  803305:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80330b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  803311:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  803317:	85 d2                	test   %edx,%edx
  803319:	0f 48 d1             	cmovs  %ecx,%edx
  80331c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80331f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  803326:	c1 e0 0c             	shl    $0xc,%eax
}
  803329:	c9                   	leave  
  80332a:	c3                   	ret    

0080332b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80332b:	55                   	push   %ebp
  80332c:	89 e5                	mov    %esp,%ebp
  80332e:	56                   	push   %esi
  80332f:	53                   	push   %ebx
  803330:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  803333:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  803339:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80333c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  803342:	76 20                	jbe    803364 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  803344:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803348:	c7 44 24 08 f4 5f 80 	movl   $0x805ff4,0x8(%esp)
  80334f:	00 
  803350:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  803357:	00 
  803358:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  80335f:	e8 0c d8 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  803364:	83 fe 01             	cmp    $0x1,%esi
  803367:	7e 08                	jle    803371 <_ZL10bcache_ipcPvi+0x46>
  803369:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  80336f:	7d 12                	jge    803383 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  803371:	89 f3                	mov    %esi,%ebx
  803373:	c1 e3 04             	shl    $0x4,%ebx
  803376:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  803378:	81 c6 00 00 05 00    	add    $0x50000,%esi
  80337e:	c1 e6 0c             	shl    $0xc,%esi
  803381:	eb 20                	jmp    8033a3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  803383:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803387:	c7 44 24 08 24 60 80 	movl   $0x806024,0x8(%esp)
  80338e:	00 
  80338f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803396:	00 
  803397:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  80339e:	e8 cd d7 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8033a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033aa:	00 
  8033ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8033b2:	00 
  8033b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033b7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  8033be:	e8 bc 21 00 00       	call   80557f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8033c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8033ca:	00 
  8033cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033d6:	e8 15 21 00 00       	call   8054f0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  8033db:	83 f8 f0             	cmp    $0xfffffff0,%eax
  8033de:	74 c3                	je     8033a3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5d                   	pop    %ebp
  8033e6:	c3                   	ret    

008033e7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  8033e7:	55                   	push   %ebp
  8033e8:	89 e5                	mov    %esp,%ebp
  8033ea:	83 ec 28             	sub    $0x28,%esp
  8033ed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8033f0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8033f3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8033f6:	89 c7                	mov    %eax,%edi
  8033f8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  8033fa:	c7 04 24 8d 36 80 00 	movl   $0x80368d,(%esp)
  803401:	e8 f5 1f 00 00       	call   8053fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  803406:	89 f8                	mov    %edi,%eax
  803408:	e8 c0 fe ff ff       	call   8032cd <_ZL9get_inodei>
  80340d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80340f:	ba 02 00 00 00       	mov    $0x2,%edx
  803414:	e8 12 ff ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  803419:	85 c0                	test   %eax,%eax
  80341b:	79 08                	jns    803425 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80341d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  803423:	eb 2e                	jmp    803453 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  803425:	85 c0                	test   %eax,%eax
  803427:	75 1c                	jne    803445 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  803429:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80342f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  803436:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  803439:	ba 06 00 00 00       	mov    $0x6,%edx
  80343e:	89 d8                	mov    %ebx,%eax
  803440:	e8 e6 fe ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  803445:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  80344c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  80344e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803453:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803456:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803459:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80345c:	89 ec                	mov    %ebp,%esp
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    

00803460 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
  803463:	57                   	push   %edi
  803464:	56                   	push   %esi
  803465:	53                   	push   %ebx
  803466:	83 ec 2c             	sub    $0x2c,%esp
  803469:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80346c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  80346f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  803474:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  80347a:	0f 87 3d 01 00 00    	ja     8035bd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  803480:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803483:	8b 42 08             	mov    0x8(%edx),%eax
  803486:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80348c:	85 c0                	test   %eax,%eax
  80348e:	0f 49 f0             	cmovns %eax,%esi
  803491:	c1 fe 0c             	sar    $0xc,%esi
  803494:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  803496:	8b 7d d8             	mov    -0x28(%ebp),%edi
  803499:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80349f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  8034a2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8034a5:	0f 82 a6 00 00 00    	jb     803551 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  8034ab:	39 fe                	cmp    %edi,%esi
  8034ad:	0f 8d f2 00 00 00    	jge    8035a5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8034b3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  8034b7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8034ba:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8034bd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  8034c0:	83 3e 00             	cmpl   $0x0,(%esi)
  8034c3:	75 77                	jne    80353c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8034c5:	ba 02 00 00 00       	mov    $0x2,%edx
  8034ca:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8034cf:	e8 57 fe ff ff       	call   80332b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8034d4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  8034da:	83 f9 02             	cmp    $0x2,%ecx
  8034dd:	7e 43                	jle    803522 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  8034df:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8034e4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  8034e9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  8034f0:	74 29                	je     80351b <_ZL14inode_set_sizeP5Inodej+0xbb>
  8034f2:	e9 ce 00 00 00       	jmp    8035c5 <_ZL14inode_set_sizeP5Inodej+0x165>
  8034f7:	89 c7                	mov    %eax,%edi
  8034f9:	0f b6 10             	movzbl (%eax),%edx
  8034fc:	83 c0 01             	add    $0x1,%eax
  8034ff:	84 d2                	test   %dl,%dl
  803501:	74 18                	je     80351b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  803503:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  803506:	ba 05 00 00 00       	mov    $0x5,%edx
  80350b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  803510:	e8 16 fe ff ff       	call   80332b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  803515:	85 db                	test   %ebx,%ebx
  803517:	79 1e                	jns    803537 <_ZL14inode_set_sizeP5Inodej+0xd7>
  803519:	eb 07                	jmp    803522 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80351b:	83 c3 01             	add    $0x1,%ebx
  80351e:	39 d9                	cmp    %ebx,%ecx
  803520:	7f d5                	jg     8034f7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  803522:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803525:	8b 50 08             	mov    0x8(%eax),%edx
  803528:	e8 33 ff ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80352d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  803532:	e9 86 00 00 00       	jmp    8035bd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  803537:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80353a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80353c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  803540:	83 c6 04             	add    $0x4,%esi
  803543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803546:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  803549:	0f 8f 6e ff ff ff    	jg     8034bd <_ZL14inode_set_sizeP5Inodej+0x5d>
  80354f:	eb 54                	jmp    8035a5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  803551:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803554:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  803559:	83 f8 01             	cmp    $0x1,%eax
  80355c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80355f:	ba 02 00 00 00       	mov    $0x2,%edx
  803564:	b8 00 20 00 50       	mov    $0x50002000,%eax
  803569:	e8 bd fd ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80356e:	39 f7                	cmp    %esi,%edi
  803570:	7d 24                	jge    803596 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  803572:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803575:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  803579:	8b 10                	mov    (%eax),%edx
  80357b:	85 d2                	test   %edx,%edx
  80357d:	74 0d                	je     80358c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80357f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  803586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80358c:	83 eb 01             	sub    $0x1,%ebx
  80358f:	83 e8 04             	sub    $0x4,%eax
  803592:	39 fb                	cmp    %edi,%ebx
  803594:	75 e3                	jne    803579 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  803596:	ba 05 00 00 00       	mov    $0x5,%edx
  80359b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8035a0:	e8 86 fd ff ff       	call   80332b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  8035a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  8035ae:	ba 04 00 00 00       	mov    $0x4,%edx
  8035b3:	e8 73 fd ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	return 0;
  8035b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035bd:	83 c4 2c             	add    $0x2c,%esp
  8035c0:	5b                   	pop    %ebx
  8035c1:	5e                   	pop    %esi
  8035c2:	5f                   	pop    %edi
  8035c3:	5d                   	pop    %ebp
  8035c4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  8035c5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8035cc:	ba 05 00 00 00       	mov    $0x5,%edx
  8035d1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8035d6:	e8 50 fd ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8035db:	bb 02 00 00 00       	mov    $0x2,%ebx
  8035e0:	e9 52 ff ff ff       	jmp    803537 <_ZL14inode_set_sizeP5Inodej+0xd7>

008035e5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  8035e5:	55                   	push   %ebp
  8035e6:	89 e5                	mov    %esp,%ebp
  8035e8:	53                   	push   %ebx
  8035e9:	83 ec 04             	sub    $0x4,%esp
  8035ec:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  8035ee:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  8035f4:	83 e8 01             	sub    $0x1,%eax
  8035f7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  8035fd:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  803601:	75 40                	jne    803643 <_ZL11inode_closeP5Inode+0x5e>
  803603:	85 c0                	test   %eax,%eax
  803605:	75 3c                	jne    803643 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  803607:	ba 02 00 00 00       	mov    $0x2,%edx
  80360c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  803611:	e8 15 fd ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  803616:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80361b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80361f:	85 d2                	test   %edx,%edx
  803621:	74 07                	je     80362a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  803623:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80362a:	83 c0 01             	add    $0x1,%eax
  80362d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  803632:	75 e7                	jne    80361b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  803634:	ba 05 00 00 00       	mov    $0x5,%edx
  803639:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80363e:	e8 e8 fc ff ff       	call   80332b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  803643:	ba 03 00 00 00       	mov    $0x3,%edx
  803648:	89 d8                	mov    %ebx,%eax
  80364a:	e8 dc fc ff ff       	call   80332b <_ZL10bcache_ipcPvi>
}
  80364f:	83 c4 04             	add    $0x4,%esp
  803652:	5b                   	pop    %ebx
  803653:	5d                   	pop    %ebp
  803654:	c3                   	ret    

00803655 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
  803658:	53                   	push   %ebx
  803659:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 40 0c             	mov    0xc(%eax),%eax
  803662:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803665:	e8 7d fd ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  80366a:	89 c3                	mov    %eax,%ebx
  80366c:	85 c0                	test   %eax,%eax
  80366e:	78 15                	js     803685 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  803670:	8b 55 0c             	mov    0xc(%ebp),%edx
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	e8 e5 fd ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
  80367b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	e8 60 ff ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
	return r;
}
  803685:	89 d8                	mov    %ebx,%eax
  803687:	83 c4 14             	add    $0x14,%esp
  80368a:	5b                   	pop    %ebx
  80368b:	5d                   	pop    %ebp
  80368c:	c3                   	ret    

0080368d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80368d:	55                   	push   %ebp
  80368e:	89 e5                	mov    %esp,%ebp
  803690:	53                   	push   %ebx
  803691:	83 ec 14             	sub    $0x14,%esp
  803694:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  803697:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  803699:	89 c2                	mov    %eax,%edx
  80369b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  8036a1:	78 32                	js     8036d5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  8036a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8036a8:	e8 7e fc ff ff       	call   80332b <_ZL10bcache_ipcPvi>
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 1c                	je     8036cd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  8036b1:	c7 44 24 08 d9 5f 80 	movl   $0x805fd9,0x8(%esp)
  8036b8:	00 
  8036b9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8036c0:	00 
  8036c1:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  8036c8:	e8 a3 d4 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
    resume(utf);
  8036cd:	89 1c 24             	mov    %ebx,(%esp)
  8036d0:	e8 fb 1d 00 00       	call   8054d0 <resume>
}
  8036d5:	83 c4 14             	add    $0x14,%esp
  8036d8:	5b                   	pop    %ebx
  8036d9:	5d                   	pop    %ebp
  8036da:	c3                   	ret    

008036db <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  8036db:	55                   	push   %ebp
  8036dc:	89 e5                	mov    %esp,%ebp
  8036de:	83 ec 28             	sub    $0x28,%esp
  8036e1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8036e4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8036e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8036ea:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8036ed:	8b 43 0c             	mov    0xc(%ebx),%eax
  8036f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8036f3:	e8 ef fc ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  8036f8:	85 c0                	test   %eax,%eax
  8036fa:	78 26                	js     803722 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  8036fc:	83 c3 10             	add    $0x10,%ebx
  8036ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803703:	89 34 24             	mov    %esi,(%esp)
  803706:	e8 7f dc ff ff       	call   80138a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80370b:	89 f2                	mov    %esi,%edx
  80370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803710:	e8 9e fb ff ff       	call   8032b3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	e8 c8 fe ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
	return 0;
  80371d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803722:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803725:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803728:	89 ec                	mov    %ebp,%esp
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    

0080372c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80372c:	55                   	push   %ebp
  80372d:	89 e5                	mov    %esp,%ebp
  80372f:	53                   	push   %ebx
  803730:	83 ec 24             	sub    $0x24,%esp
  803733:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  803736:	89 1c 24             	mov    %ebx,(%esp)
  803739:	e8 d6 16 00 00       	call   804e14 <_Z7pagerefPv>
  80373e:	89 c2                	mov    %eax,%edx
        return 0;
  803740:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  803745:	83 fa 01             	cmp    $0x1,%edx
  803748:	7f 1e                	jg     803768 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80374a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80374d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803750:	e8 92 fc ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803755:	85 c0                	test   %eax,%eax
  803757:	78 0f                	js     803768 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  803763:	e8 7d fe ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
}
  803768:	83 c4 24             	add    $0x24,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5d                   	pop    %ebp
  80376d:	c3                   	ret    

0080376e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80376e:	55                   	push   %ebp
  80376f:	89 e5                	mov    %esp,%ebp
  803771:	57                   	push   %edi
  803772:	56                   	push   %esi
  803773:	53                   	push   %ebx
  803774:	83 ec 3c             	sub    $0x3c,%esp
  803777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80377a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80377d:	8b 43 04             	mov    0x4(%ebx),%eax
  803780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  803783:	8b 43 0c             	mov    0xc(%ebx),%eax
  803786:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803789:	e8 59 fc ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  80378e:	85 c0                	test   %eax,%eax
  803790:	0f 88 8c 00 00 00    	js     803822 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  803796:	8b 53 04             	mov    0x4(%ebx),%edx
  803799:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80379f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8037a5:	29 d7                	sub    %edx,%edi
  8037a7:	39 f7                	cmp    %esi,%edi
  8037a9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8037ac:	85 ff                	test   %edi,%edi
  8037ae:	74 16                	je     8037c6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8037b0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	3b 50 08             	cmp    0x8(%eax),%edx
  8037b9:	76 6f                	jbe    80382a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8037bb:	e8 a0 fc ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8037c0:	85 c0                	test   %eax,%eax
  8037c2:	79 66                	jns    80382a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8037c4:	eb 4e                	jmp    803814 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8037c6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8037cc:	76 24                	jbe    8037f2 <_ZL13devfile_writeP2FdPKvj+0x84>
  8037ce:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8037d0:	8b 53 04             	mov    0x4(%ebx),%edx
  8037d3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dc:	3b 50 08             	cmp    0x8(%eax),%edx
  8037df:	0f 86 83 00 00 00    	jbe    803868 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8037e5:	e8 76 fc ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	79 7a                	jns    803868 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	eb 22                	jmp    803814 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8037f2:	85 f6                	test   %esi,%esi
  8037f4:	74 1e                	je     803814 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8037f6:	89 f2                	mov    %esi,%edx
  8037f8:	03 53 04             	add    0x4(%ebx),%edx
  8037fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fe:	3b 50 08             	cmp    0x8(%eax),%edx
  803801:	0f 86 b8 00 00 00    	jbe    8038bf <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  803807:	e8 54 fc ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80380c:	85 c0                	test   %eax,%eax
  80380e:	0f 89 ab 00 00 00    	jns    8038bf <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	e8 c9 fd ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80381c:	8b 43 04             	mov    0x4(%ebx),%eax
  80381f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  803822:	83 c4 3c             	add    $0x3c,%esp
  803825:	5b                   	pop    %ebx
  803826:	5e                   	pop    %esi
  803827:	5f                   	pop    %edi
  803828:	5d                   	pop    %ebp
  803829:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80382a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80382c:	8b 53 04             	mov    0x4(%ebx),%edx
  80382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803832:	e8 39 fa ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803837:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80383a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	89 44 24 04          	mov    %eax,0x4(%esp)
  803845:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803848:	89 04 24             	mov    %eax,(%esp)
  80384b:	e8 57 dd ff ff       	call   8015a7 <memcpy>
        fd->fd_offset += n2;
  803850:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  803853:	ba 04 00 00 00       	mov    $0x4,%edx
  803858:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80385b:	e8 cb fa ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  803860:	01 7d 0c             	add    %edi,0xc(%ebp)
  803863:	e9 5e ff ff ff       	jmp    8037c6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  803868:	8b 53 04             	mov    0x4(%ebx),%edx
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	e8 fd f9 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803873:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  803875:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80387c:	00 
  80387d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803880:	89 44 24 04          	mov    %eax,0x4(%esp)
  803884:	89 34 24             	mov    %esi,(%esp)
  803887:	e8 1b dd ff ff       	call   8015a7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80388c:	ba 04 00 00 00       	mov    $0x4,%edx
  803891:	89 f0                	mov    %esi,%eax
  803893:	e8 93 fa ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  803898:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80389e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8038a5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8038ac:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8038b2:	0f 87 18 ff ff ff    	ja     8037d0 <_ZL13devfile_writeP2FdPKvj+0x62>
  8038b8:	89 fe                	mov    %edi,%esi
  8038ba:	e9 33 ff ff ff       	jmp    8037f2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8038bf:	8b 53 04             	mov    0x4(%ebx),%edx
  8038c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c5:	e8 a6 f9 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  8038ca:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8038cc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8038d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d7:	89 3c 24             	mov    %edi,(%esp)
  8038da:	e8 c8 dc ff ff       	call   8015a7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8038df:	ba 04 00 00 00       	mov    $0x4,%edx
  8038e4:	89 f8                	mov    %edi,%eax
  8038e6:	e8 40 fa ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8038eb:	01 73 04             	add    %esi,0x4(%ebx)
  8038ee:	e9 21 ff ff ff       	jmp    803814 <_ZL13devfile_writeP2FdPKvj+0xa6>

008038f3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8038f3:	55                   	push   %ebp
  8038f4:	89 e5                	mov    %esp,%ebp
  8038f6:	57                   	push   %edi
  8038f7:	56                   	push   %esi
  8038f8:	53                   	push   %ebx
  8038f9:	83 ec 3c             	sub    $0x3c,%esp
  8038fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8038ff:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  803902:	8b 43 04             	mov    0x4(%ebx),%eax
  803905:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  803908:	8b 43 0c             	mov    0xc(%ebx),%eax
  80390b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80390e:	e8 d4 fa ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803913:	85 c0                	test   %eax,%eax
  803915:	0f 88 d3 00 00 00    	js     8039ee <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80391b:	8b 73 04             	mov    0x4(%ebx),%esi
  80391e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803921:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  803924:	8b 50 08             	mov    0x8(%eax),%edx
  803927:	29 f2                	sub    %esi,%edx
  803929:	3b 48 08             	cmp    0x8(%eax),%ecx
  80392c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80392f:	89 f2                	mov    %esi,%edx
  803931:	e8 3a f9 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803936:	85 c0                	test   %eax,%eax
  803938:	0f 84 a2 00 00 00    	je     8039e0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80393e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  803944:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80394a:	29 f2                	sub    %esi,%edx
  80394c:	39 d7                	cmp    %edx,%edi
  80394e:	0f 46 d7             	cmovbe %edi,%edx
  803951:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  803954:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  803956:	01 d6                	add    %edx,%esi
  803958:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80395b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80395f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803963:	8b 45 0c             	mov    0xc(%ebp),%eax
  803966:	89 04 24             	mov    %eax,(%esp)
  803969:	e8 39 dc ff ff       	call   8015a7 <memcpy>
    buf = (void *)((char *)buf + n2);
  80396e:	8b 75 0c             	mov    0xc(%ebp),%esi
  803971:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  803974:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80397a:	76 3e                	jbe    8039ba <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80397c:	8b 53 04             	mov    0x4(%ebx),%edx
  80397f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803982:	e8 e9 f8 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803987:	85 c0                	test   %eax,%eax
  803989:	74 55                	je     8039e0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80398b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  803992:	00 
  803993:	89 44 24 04          	mov    %eax,0x4(%esp)
  803997:	89 34 24             	mov    %esi,(%esp)
  80399a:	e8 08 dc ff ff       	call   8015a7 <memcpy>
        n -= PGSIZE;
  80399f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8039a5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8039ab:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8039b2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8039b8:	77 c2                	ja     80397c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8039ba:	85 ff                	test   %edi,%edi
  8039bc:	74 22                	je     8039e0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8039be:	8b 53 04             	mov    0x4(%ebx),%edx
  8039c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c4:	e8 a7 f8 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  8039c9:	85 c0                	test   %eax,%eax
  8039cb:	74 13                	je     8039e0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8039cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8039d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d5:	89 34 24             	mov    %esi,(%esp)
  8039d8:	e8 ca db ff ff       	call   8015a7 <memcpy>
        fd->fd_offset += n;
  8039dd:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8039e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e3:	e8 fd fb ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8039e8:	8b 43 04             	mov    0x4(%ebx),%eax
  8039eb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8039ee:	83 c4 3c             	add    $0x3c,%esp
  8039f1:	5b                   	pop    %ebx
  8039f2:	5e                   	pop    %esi
  8039f3:	5f                   	pop    %edi
  8039f4:	5d                   	pop    %ebp
  8039f5:	c3                   	ret    

008039f6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8039f6:	55                   	push   %ebp
  8039f7:	89 e5                	mov    %esp,%ebp
  8039f9:	57                   	push   %edi
  8039fa:	56                   	push   %esi
  8039fb:	53                   	push   %ebx
  8039fc:	83 ec 4c             	sub    $0x4c,%esp
  8039ff:	89 c6                	mov    %eax,%esi
  803a01:	89 55 bc             	mov    %edx,-0x44(%ebp)
  803a04:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  803a07:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  803a0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  803a16:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803a19:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1e:	e8 c4 f9 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803a23:	89 c7                	mov    %eax,%edi
  803a25:	85 c0                	test   %eax,%eax
  803a27:	0f 88 cd 01 00 00    	js     803bfa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  803a2d:	89 f3                	mov    %esi,%ebx
  803a2f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  803a32:	75 08                	jne    803a3c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  803a34:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  803a37:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  803a3a:	74 f8                	je     803a34 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  803a3c:	0f b6 03             	movzbl (%ebx),%eax
  803a3f:	3c 2f                	cmp    $0x2f,%al
  803a41:	74 16                	je     803a59 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  803a43:	84 c0                	test   %al,%al
  803a45:	74 12                	je     803a59 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  803a47:	89 da                	mov    %ebx,%edx
		++path;
  803a49:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  803a4c:	0f b6 02             	movzbl (%edx),%eax
  803a4f:	3c 2f                	cmp    $0x2f,%al
  803a51:	74 08                	je     803a5b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  803a53:	84 c0                	test   %al,%al
  803a55:	75 f2                	jne    803a49 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  803a57:	eb 02                	jmp    803a5b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  803a59:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  803a5b:	89 d0                	mov    %edx,%eax
  803a5d:	29 d8                	sub    %ebx,%eax
  803a5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  803a62:	0f b6 02             	movzbl (%edx),%eax
  803a65:	89 d6                	mov    %edx,%esi
  803a67:	3c 2f                	cmp    $0x2f,%al
  803a69:	75 0a                	jne    803a75 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  803a6b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  803a6e:	0f b6 06             	movzbl (%esi),%eax
  803a71:	3c 2f                	cmp    $0x2f,%al
  803a73:	74 f6                	je     803a6b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  803a75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a79:	75 1b                	jne    803a96 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  803a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  803a81:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  803a83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a86:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  803a8c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a91:	e9 64 01 00 00       	jmp    803bfa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  803a96:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  803a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a9e:	74 06                	je     803aa6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  803aa0:	84 c0                	test   %al,%al
  803aa2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  803aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  803aac:	83 3a 02             	cmpl   $0x2,(%edx)
  803aaf:	0f 85 f4 00 00 00    	jne    803ba9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  803ab5:	89 d0                	mov    %edx,%eax
  803ab7:	8b 52 08             	mov    0x8(%edx),%edx
  803aba:	85 d2                	test   %edx,%edx
  803abc:	7e 78                	jle    803b36 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  803abe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  803ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  803aca:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  803acd:	89 fb                	mov    %edi,%ebx
  803acf:	89 75 c0             	mov    %esi,-0x40(%ebp)
  803ad2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  803ad4:	89 da                	mov    %ebx,%edx
  803ad6:	89 f0                	mov    %esi,%eax
  803ad8:	e8 93 f7 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803add:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  803adf:	83 38 00             	cmpl   $0x0,(%eax)
  803ae2:	74 26                	je     803b0a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  803ae4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ae7:	3b 50 04             	cmp    0x4(%eax),%edx
  803aea:	75 33                	jne    803b1f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  803aec:	89 54 24 08          	mov    %edx,0x8(%esp)
  803af0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af7:	8d 47 08             	lea    0x8(%edi),%eax
  803afa:	89 04 24             	mov    %eax,(%esp)
  803afd:	e8 e6 da ff ff       	call   8015e8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  803b02:	85 c0                	test   %eax,%eax
  803b04:	0f 84 fa 00 00 00    	je     803c04 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  803b0a:	83 3f 00             	cmpl   $0x0,(%edi)
  803b0d:	75 10                	jne    803b1f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  803b0f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b13:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  803b16:	84 c0                	test   %al,%al
  803b18:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  803b1c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  803b1f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  803b25:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  803b27:	8b 56 08             	mov    0x8(%esi),%edx
  803b2a:	39 d0                	cmp    %edx,%eax
  803b2c:	7c a6                	jl     803ad4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  803b2e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  803b31:	8b 75 c0             	mov    -0x40(%ebp),%esi
  803b34:	eb 07                	jmp    803b3d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  803b36:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  803b3d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  803b41:	74 6d                	je     803bb0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  803b43:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b47:	75 24                	jne    803b6d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  803b49:	83 ea 80             	sub    $0xffffff80,%edx
  803b4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b4f:	e8 0c f9 ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  803b54:	85 c0                	test   %eax,%eax
  803b56:	0f 88 90 00 00 00    	js     803bec <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  803b5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5f:	8b 50 08             	mov    0x8(%eax),%edx
  803b62:	83 c2 80             	add    $0xffffff80,%edx
  803b65:	e8 06 f7 ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  803b6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  803b6d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  803b74:	00 
  803b75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803b7c:	00 
  803b7d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803b80:	89 14 24             	mov    %edx,(%esp)
  803b83:	e8 49 d9 ff ff       	call   8014d1 <memset>
	empty->de_namelen = namelen;
  803b88:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b8e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  803b91:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803b99:	83 c0 08             	add    $0x8,%eax
  803b9c:	89 04 24             	mov    %eax,(%esp)
  803b9f:	e8 03 da ff ff       	call   8015a7 <memcpy>
	*de_store = empty;
  803ba4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  803ba7:	eb 5e                	jmp    803c07 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  803ba9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  803bae:	eb 42                	jmp    803bf2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  803bb0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  803bb5:	eb 3b                	jmp    803bf2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  803bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bba:	8b 55 bc             	mov    -0x44(%ebp),%edx
  803bbd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  803bbf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bc2:	89 38                	mov    %edi,(%eax)
			return 0;
  803bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc9:	eb 2f                	jmp    803bfa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  803bcb:	8d 55 e0             	lea    -0x20(%ebp),%edx
  803bce:	8b 07                	mov    (%edi),%eax
  803bd0:	e8 12 f8 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803bd5:	85 c0                	test   %eax,%eax
  803bd7:	78 17                	js     803bf0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  803bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdc:	e8 04 fa ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  803be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  803be7:	e9 41 fe ff ff       	jmp    803a2d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  803bec:	89 c7                	mov    %eax,%edi
  803bee:	eb 02                	jmp    803bf2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  803bf0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  803bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf5:	e8 eb f9 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
	return r;
}
  803bfa:	89 f8                	mov    %edi,%eax
  803bfc:	83 c4 4c             	add    $0x4c,%esp
  803bff:	5b                   	pop    %ebx
  803c00:	5e                   	pop    %esi
  803c01:	5f                   	pop    %edi
  803c02:	5d                   	pop    %ebp
  803c03:	c3                   	ret    
  803c04:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  803c07:	80 3e 00             	cmpb   $0x0,(%esi)
  803c0a:	75 bf                	jne    803bcb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  803c0c:	eb a9                	jmp    803bb7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

00803c0e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  803c0e:	55                   	push   %ebp
  803c0f:	89 e5                	mov    %esp,%ebp
  803c11:	57                   	push   %edi
  803c12:	56                   	push   %esi
  803c13:	53                   	push   %ebx
  803c14:	83 ec 3c             	sub    $0x3c,%esp
  803c17:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  803c1a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803c1d:	89 04 24             	mov    %eax,(%esp)
  803c20:	e8 62 f0 ff ff       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  803c25:	89 c3                	mov    %eax,%ebx
  803c27:	85 c0                	test   %eax,%eax
  803c29:	0f 88 16 02 00 00    	js     803e45 <_Z4openPKci+0x237>
  803c2f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c36:	00 
  803c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c45:	e8 26 dc ff ff       	call   801870 <_Z14sys_page_allociPvi>
  803c4a:	89 c3                	mov    %eax,%ebx
  803c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c51:	85 db                	test   %ebx,%ebx
  803c53:	0f 88 ec 01 00 00    	js     803e45 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  803c59:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  803c5d:	0f 84 ec 01 00 00    	je     803e4f <_Z4openPKci+0x241>
  803c63:	83 c0 01             	add    $0x1,%eax
  803c66:	83 f8 78             	cmp    $0x78,%eax
  803c69:	75 ee                	jne    803c59 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  803c6b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  803c70:	e9 b9 01 00 00       	jmp    803e2e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  803c75:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803c78:	81 e7 00 01 00 00    	and    $0x100,%edi
  803c7e:	89 3c 24             	mov    %edi,(%esp)
  803c81:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  803c84:	8d 55 e0             	lea    -0x20(%ebp),%edx
  803c87:	89 f0                	mov    %esi,%eax
  803c89:	e8 68 fd ff ff       	call   8039f6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  803c8e:	89 c3                	mov    %eax,%ebx
  803c90:	85 c0                	test   %eax,%eax
  803c92:	0f 85 96 01 00 00    	jne    803e2e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  803c98:	85 ff                	test   %edi,%edi
  803c9a:	75 41                	jne    803cdd <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  803c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c9f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  803ca4:	75 08                	jne    803cae <_Z4openPKci+0xa0>
            fileino = dirino;
  803ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  803cac:	eb 14                	jmp    803cc2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  803cae:	8d 55 d8             	lea    -0x28(%ebp),%edx
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	e8 2f f7 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803cb8:	89 c3                	mov    %eax,%ebx
  803cba:	85 c0                	test   %eax,%eax
  803cbc:	0f 88 5d 01 00 00    	js     803e1f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  803cc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803cc5:	83 38 02             	cmpl   $0x2,(%eax)
  803cc8:	0f 85 d2 00 00 00    	jne    803da0 <_Z4openPKci+0x192>
  803cce:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  803cd2:	0f 84 c8 00 00 00    	je     803da0 <_Z4openPKci+0x192>
  803cd8:	e9 38 01 00 00       	jmp    803e15 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  803cdd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  803ce4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  803ceb:	0f 8e a8 00 00 00    	jle    803d99 <_Z4openPKci+0x18b>
  803cf1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  803cf6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  803cf9:	89 f8                	mov    %edi,%eax
  803cfb:	e8 e7 f6 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803d00:	89 c3                	mov    %eax,%ebx
  803d02:	85 c0                	test   %eax,%eax
  803d04:	0f 88 15 01 00 00    	js     803e1f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  803d0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803d11:	75 68                	jne    803d7b <_Z4openPKci+0x16d>
  803d13:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  803d1a:	75 5f                	jne    803d7b <_Z4openPKci+0x16d>
			*ino_store = ino;
  803d1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  803d1f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  803d25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d28:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  803d2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  803d36:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  803d3d:	00 
  803d3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803d45:	00 
  803d46:	83 c0 0c             	add    $0xc,%eax
  803d49:	89 04 24             	mov    %eax,(%esp)
  803d4c:	e8 80 d7 ff ff       	call   8014d1 <memset>
        de->de_inum = fileino->i_inum;
  803d51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d54:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  803d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  803d5f:	ba 04 00 00 00       	mov    $0x4,%edx
  803d64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d67:	e8 bf f5 ff ff       	call   80332b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  803d6c:	ba 04 00 00 00       	mov    $0x4,%edx
  803d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d74:	e8 b2 f5 ff ff       	call   80332b <_ZL10bcache_ipcPvi>
  803d79:	eb 25                	jmp    803da0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  803d7b:	e8 65 f8 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  803d80:	83 c7 01             	add    $0x1,%edi
  803d83:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  803d89:	0f 8c 67 ff ff ff    	jl     803cf6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  803d8f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  803d94:	e9 86 00 00 00       	jmp    803e1f <_Z4openPKci+0x211>
  803d99:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  803d9e:	eb 7f                	jmp    803e1f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  803da0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  803da7:	74 0d                	je     803db6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  803da9:	ba 00 00 00 00       	mov    $0x0,%edx
  803dae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803db1:	e8 aa f6 ff ff       	call   803460 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  803db6:	8b 15 20 70 80 00    	mov    0x807020,%edx
  803dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbf:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  803dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  803dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dce:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  803dd1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803dd4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  803dda:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  803ddd:	89 74 24 04          	mov    %esi,0x4(%esp)
  803de1:	83 c0 10             	add    $0x10,%eax
  803de4:	89 04 24             	mov    %eax,(%esp)
  803de7:	e8 9e d5 ff ff       	call   80138a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  803dec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803def:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  803df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803df9:	e8 e7 f7 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  803dfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e01:	e8 df f7 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  803e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e09:	89 04 24             	mov    %eax,(%esp)
  803e0c:	e8 13 ee ff ff       	call   802c24 <_Z6fd2numP2Fd>
  803e11:	89 c3                	mov    %eax,%ebx
  803e13:	eb 30                	jmp    803e45 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  803e15:	e8 cb f7 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  803e1a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  803e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e22:	e8 be f7 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
  803e27:	eb 05                	jmp    803e2e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  803e29:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  803e2e:	a1 14 80 80 00       	mov    0x808014,%eax
  803e33:	8b 40 04             	mov    0x4(%eax),%eax
  803e36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e39:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e3d:	89 04 24             	mov    %eax,(%esp)
  803e40:	e8 e8 da ff ff       	call   80192d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  803e45:	89 d8                	mov    %ebx,%eax
  803e47:	83 c4 3c             	add    $0x3c,%esp
  803e4a:	5b                   	pop    %ebx
  803e4b:	5e                   	pop    %esi
  803e4c:	5f                   	pop    %edi
  803e4d:	5d                   	pop    %ebp
  803e4e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  803e4f:	83 f8 78             	cmp    $0x78,%eax
  803e52:	0f 85 1d fe ff ff    	jne    803c75 <_Z4openPKci+0x67>
  803e58:	eb cf                	jmp    803e29 <_Z4openPKci+0x21b>

00803e5a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  803e5a:	55                   	push   %ebp
  803e5b:	89 e5                	mov    %esp,%ebp
  803e5d:	53                   	push   %ebx
  803e5e:	83 ec 24             	sub    $0x24,%esp
  803e61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  803e64:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803e67:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6a:	e8 78 f5 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803e6f:	85 c0                	test   %eax,%eax
  803e71:	78 27                	js     803e9a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  803e73:	c7 44 24 04 ec 5f 80 	movl   $0x805fec,0x4(%esp)
  803e7a:	00 
  803e7b:	89 1c 24             	mov    %ebx,(%esp)
  803e7e:	e8 07 d5 ff ff       	call   80138a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  803e83:	89 da                	mov    %ebx,%edx
  803e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e88:	e8 26 f4 ff ff       	call   8032b3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  803e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e90:	e8 50 f7 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
	return 0;
  803e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e9a:	83 c4 24             	add    $0x24,%esp
  803e9d:	5b                   	pop    %ebx
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    

00803ea0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  803ea0:	55                   	push   %ebp
  803ea1:	89 e5                	mov    %esp,%ebp
  803ea3:	53                   	push   %ebx
  803ea4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  803ea7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803eae:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  803eb1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb7:	e8 3a fb ff ff       	call   8039f6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  803ebc:	89 c3                	mov    %eax,%ebx
  803ebe:	85 c0                	test   %eax,%eax
  803ec0:	78 5f                	js     803f21 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  803ec2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec8:	8b 00                	mov    (%eax),%eax
  803eca:	e8 18 f5 ff ff       	call   8033e7 <_ZL10inode_openiPP5Inode>
  803ecf:	89 c3                	mov    %eax,%ebx
  803ed1:	85 c0                	test   %eax,%eax
  803ed3:	78 44                	js     803f19 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  803ed5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  803eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803edd:	83 38 02             	cmpl   $0x2,(%eax)
  803ee0:	74 2f                	je     803f11 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  803ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  803eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eee:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  803ef2:	ba 04 00 00 00       	mov    $0x4,%edx
  803ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803efa:	e8 2c f4 ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  803eff:	ba 04 00 00 00       	mov    $0x4,%edx
  803f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f07:	e8 1f f4 ff ff       	call   80332b <_ZL10bcache_ipcPvi>
	r = 0;
  803f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  803f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f14:	e8 cc f6 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  803f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1c:	e8 c4 f6 ff ff       	call   8035e5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  803f21:	89 d8                	mov    %ebx,%eax
  803f23:	83 c4 24             	add    $0x24,%esp
  803f26:	5b                   	pop    %ebx
  803f27:	5d                   	pop    %ebp
  803f28:	c3                   	ret    

00803f29 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  803f29:	55                   	push   %ebp
  803f2a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  803f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f31:	5d                   	pop    %ebp
  803f32:	c3                   	ret    

00803f33 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  803f33:	55                   	push   %ebp
  803f34:	89 e5                	mov    %esp,%ebp
  803f36:	57                   	push   %edi
  803f37:	56                   	push   %esi
  803f38:	53                   	push   %ebx
  803f39:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  803f3f:	c7 04 24 8d 36 80 00 	movl   $0x80368d,(%esp)
  803f46:	e8 b0 14 00 00       	call   8053fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  803f4b:	a1 00 10 00 50       	mov    0x50001000,%eax
  803f50:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  803f55:	74 28                	je     803f7f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  803f57:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  803f5e:	4a 
  803f5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f63:	c7 44 24 08 54 60 80 	movl   $0x806054,0x8(%esp)
  803f6a:	00 
  803f6b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  803f72:	00 
  803f73:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  803f7a:	e8 f1 cb ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  803f7f:	a1 04 10 00 50       	mov    0x50001004,%eax
  803f84:	83 f8 03             	cmp    $0x3,%eax
  803f87:	7f 1c                	jg     803fa5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  803f89:	c7 44 24 08 88 60 80 	movl   $0x806088,0x8(%esp)
  803f90:	00 
  803f91:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  803f98:	00 
  803f99:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  803fa0:	e8 cb cb ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  803fa5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  803fab:	85 d2                	test   %edx,%edx
  803fad:	7f 1c                	jg     803fcb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  803faf:	c7 44 24 08 b8 60 80 	movl   $0x8060b8,0x8(%esp)
  803fb6:	00 
  803fb7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  803fbe:	00 
  803fbf:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  803fc6:	e8 a5 cb ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  803fcb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  803fd1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  803fd7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  803fdd:	85 c9                	test   %ecx,%ecx
  803fdf:	0f 48 cb             	cmovs  %ebx,%ecx
  803fe2:	c1 f9 0c             	sar    $0xc,%ecx
  803fe5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  803fe9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  803fef:	39 c8                	cmp    %ecx,%eax
  803ff1:	7c 13                	jl     804006 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	7f 3d                	jg     804034 <_Z4fsckv+0x101>
  803ff7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  803ffe:	00 00 00 
  804001:	e9 ac 00 00 00       	jmp    8040b2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  804006:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80400c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  804010:	89 44 24 10          	mov    %eax,0x10(%esp)
  804014:	89 54 24 0c          	mov    %edx,0xc(%esp)
  804018:	c7 44 24 08 e8 60 80 	movl   $0x8060e8,0x8(%esp)
  80401f:	00 
  804020:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  804027:	00 
  804028:	c7 04 24 ce 5f 80 00 	movl   $0x805fce,(%esp)
  80402f:	e8 3c cb ff ff       	call   800b70 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  804034:	be 00 20 00 50       	mov    $0x50002000,%esi
  804039:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  804040:	00 00 00 
  804043:	bb 00 00 00 00       	mov    $0x0,%ebx
  804048:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80404e:	39 df                	cmp    %ebx,%edi
  804050:	7e 27                	jle    804079 <_Z4fsckv+0x146>
  804052:	0f b6 06             	movzbl (%esi),%eax
  804055:	84 c0                	test   %al,%al
  804057:	74 4b                	je     8040a4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  804059:	0f be c0             	movsbl %al,%eax
  80405c:	89 44 24 08          	mov    %eax,0x8(%esp)
  804060:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804064:	c7 04 24 2c 61 80 00 	movl   $0x80612c,(%esp)
  80406b:	e8 1e cc ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804070:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804077:	eb 2b                	jmp    8040a4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  804079:	0f b6 06             	movzbl (%esi),%eax
  80407c:	3c 01                	cmp    $0x1,%al
  80407e:	76 24                	jbe    8040a4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  804080:	0f be c0             	movsbl %al,%eax
  804083:	89 44 24 08          	mov    %eax,0x8(%esp)
  804087:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80408b:	c7 04 24 60 61 80 00 	movl   $0x806160,(%esp)
  804092:	e8 f7 cb ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804097:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80409e:	80 3e 00             	cmpb   $0x0,(%esi)
  8040a1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8040a4:	83 c3 01             	add    $0x1,%ebx
  8040a7:	83 c6 01             	add    $0x1,%esi
  8040aa:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8040b0:	7f 9c                	jg     80404e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8040b2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8040b9:	0f 8e e1 02 00 00    	jle    8043a0 <_Z4fsckv+0x46d>
  8040bf:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  8040c6:	00 00 00 
		struct Inode *ino = get_inode(i);
  8040c9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8040cf:	e8 f9 f1 ff ff       	call   8032cd <_ZL9get_inodei>
  8040d4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  8040da:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  8040de:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  8040e5:	75 22                	jne    804109 <_Z4fsckv+0x1d6>
  8040e7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  8040ee:	0f 84 a9 06 00 00    	je     80479d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  8040f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8040f9:	e8 2d f2 ff ff       	call   80332b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  8040fe:	85 c0                	test   %eax,%eax
  804100:	74 3a                	je     80413c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  804102:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  804109:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80410f:	8b 02                	mov    (%edx),%eax
  804111:	83 f8 01             	cmp    $0x1,%eax
  804114:	74 26                	je     80413c <_Z4fsckv+0x209>
  804116:	83 f8 02             	cmp    $0x2,%eax
  804119:	74 21                	je     80413c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80411b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80411f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  804125:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804129:	c7 04 24 8c 61 80 00 	movl   $0x80618c,(%esp)
  804130:	e8 59 cb ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804135:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80413c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  804143:	75 3f                	jne    804184 <_Z4fsckv+0x251>
  804145:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80414b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80414f:	75 15                	jne    804166 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  804151:	c7 04 24 b0 61 80 00 	movl   $0x8061b0,(%esp)
  804158:	e8 31 cb ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  80415d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804164:	eb 1e                	jmp    804184 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  804166:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80416c:	83 3a 02             	cmpl   $0x2,(%edx)
  80416f:	74 13                	je     804184 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  804171:	c7 04 24 e4 61 80 00 	movl   $0x8061e4,(%esp)
  804178:	e8 11 cb ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  80417d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  804184:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  804189:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  804190:	0f 84 93 00 00 00    	je     804229 <_Z4fsckv+0x2f6>
  804196:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80419c:	8b 41 08             	mov    0x8(%ecx),%eax
  80419f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8041a4:	7e 23                	jle    8041c9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8041a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8041aa:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8041b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b4:	c7 04 24 14 62 80 00 	movl   $0x806214,(%esp)
  8041bb:	e8 ce ca ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  8041c0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8041c7:	eb 09                	jmp    8041d2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  8041c9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8041d0:	74 4b                	je     80421d <_Z4fsckv+0x2ea>
  8041d2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8041d8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  8041de:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  8041e4:	74 23                	je     804209 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  8041e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8041ea:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8041f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041f4:	c7 04 24 38 62 80 00 	movl   $0x806238,(%esp)
  8041fb:	e8 8e ca ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804200:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804207:	eb 09                	jmp    804212 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  804209:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  804210:	74 12                	je     804224 <_Z4fsckv+0x2f1>
  804212:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  804218:	8b 78 08             	mov    0x8(%eax),%edi
  80421b:	eb 0c                	jmp    804229 <_Z4fsckv+0x2f6>
  80421d:	bf 00 00 00 00       	mov    $0x0,%edi
  804222:	eb 05                	jmp    804229 <_Z4fsckv+0x2f6>
  804224:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  804229:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80422e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  804234:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  804238:	89 d8                	mov    %ebx,%eax
  80423a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80423d:	39 c7                	cmp    %eax,%edi
  80423f:	7e 2b                	jle    80426c <_Z4fsckv+0x339>
  804241:	85 f6                	test   %esi,%esi
  804243:	75 27                	jne    80426c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  804245:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804249:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80424d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  804253:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804257:	c7 04 24 5c 62 80 00 	movl   $0x80625c,(%esp)
  80425e:	e8 2b ca ff ff       	call   800c8e <_Z7cprintfPKcz>
				++errors;
  804263:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80426a:	eb 36                	jmp    8042a2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80426c:	39 f8                	cmp    %edi,%eax
  80426e:	7c 32                	jl     8042a2 <_Z4fsckv+0x36f>
  804270:	85 f6                	test   %esi,%esi
  804272:	74 2e                	je     8042a2 <_Z4fsckv+0x36f>
  804274:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  80427b:	74 25                	je     8042a2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  80427d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804281:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804285:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80428b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80428f:	c7 04 24 a0 62 80 00 	movl   $0x8062a0,(%esp)
  804296:	e8 f3 c9 ff ff       	call   800c8e <_Z7cprintfPKcz>
				++errors;
  80429b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8042a2:	85 f6                	test   %esi,%esi
  8042a4:	0f 84 a0 00 00 00    	je     80434a <_Z4fsckv+0x417>
  8042aa:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8042b1:	0f 84 93 00 00 00    	je     80434a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8042b7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8042bd:	7e 27                	jle    8042e6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8042bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8042c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042c7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8042cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8042d1:	c7 04 24 e4 62 80 00 	movl   $0x8062e4,(%esp)
  8042d8:	e8 b1 c9 ff ff       	call   800c8e <_Z7cprintfPKcz>
					++errors;
  8042dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8042e4:	eb 64                	jmp    80434a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  8042e6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  8042ed:	3c 01                	cmp    $0x1,%al
  8042ef:	75 27                	jne    804318 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  8042f1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8042f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042f9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8042ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804303:	c7 04 24 28 63 80 00 	movl   $0x806328,(%esp)
  80430a:	e8 7f c9 ff ff       	call   800c8e <_Z7cprintfPKcz>
					++errors;
  80430f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804316:	eb 32                	jmp    80434a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  804318:	3c ff                	cmp    $0xff,%al
  80431a:	75 27                	jne    804343 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80431c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804320:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804324:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80432a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80432e:	c7 04 24 64 63 80 00 	movl   $0x806364,(%esp)
  804335:	e8 54 c9 ff ff       	call   800c8e <_Z7cprintfPKcz>
					++errors;
  80433a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804341:	eb 07                	jmp    80434a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  804343:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  80434a:	83 c3 01             	add    $0x1,%ebx
  80434d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  804353:	0f 85 d5 fe ff ff    	jne    80422e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  804359:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  804360:	0f 94 c0             	sete   %al
  804363:	0f b6 c0             	movzbl %al,%eax
  804366:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80436c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  804372:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  804379:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  804380:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  804387:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80438e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  804394:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80439a:	0f 8f 29 fd ff ff    	jg     8040c9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8043a0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8043a7:	0f 8e 7f 03 00 00    	jle    80472c <_Z4fsckv+0x7f9>
  8043ad:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  8043b2:	89 f0                	mov    %esi,%eax
  8043b4:	e8 14 ef ff ff       	call   8032cd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  8043b9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8043c0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8043c7:	c1 e2 08             	shl    $0x8,%edx
  8043ca:	09 ca                	or     %ecx,%edx
  8043cc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  8043d3:	c1 e1 10             	shl    $0x10,%ecx
  8043d6:	09 ca                	or     %ecx,%edx
  8043d8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  8043df:	83 e1 7f             	and    $0x7f,%ecx
  8043e2:	c1 e1 18             	shl    $0x18,%ecx
  8043e5:	09 d1                	or     %edx,%ecx
  8043e7:	74 0e                	je     8043f7 <_Z4fsckv+0x4c4>
  8043e9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  8043f0:	78 05                	js     8043f7 <_Z4fsckv+0x4c4>
  8043f2:	83 38 02             	cmpl   $0x2,(%eax)
  8043f5:	74 1f                	je     804416 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8043f7:	83 c6 01             	add    $0x1,%esi
  8043fa:	a1 08 10 00 50       	mov    0x50001008,%eax
  8043ff:	39 f0                	cmp    %esi,%eax
  804401:	7f af                	jg     8043b2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  804403:	bb 01 00 00 00       	mov    $0x1,%ebx
  804408:	83 f8 01             	cmp    $0x1,%eax
  80440b:	0f 8f ad 02 00 00    	jg     8046be <_Z4fsckv+0x78b>
  804411:	e9 16 03 00 00       	jmp    80472c <_Z4fsckv+0x7f9>
  804416:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  804418:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80441f:	8b 40 08             	mov    0x8(%eax),%eax
  804422:	a8 7f                	test   $0x7f,%al
  804424:	74 23                	je     804449 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  804426:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80442d:	00 
  80442e:	89 44 24 08          	mov    %eax,0x8(%esp)
  804432:	89 74 24 04          	mov    %esi,0x4(%esp)
  804436:	c7 04 24 a0 63 80 00 	movl   $0x8063a0,(%esp)
  80443d:	e8 4c c8 ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804442:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  804449:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  804450:	00 00 00 
  804453:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  804459:	e9 3d 02 00 00       	jmp    80469b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  80445e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  804464:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80446a:	e8 01 ee ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
  80446f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  804471:	83 38 00             	cmpl   $0x0,(%eax)
  804474:	0f 84 15 02 00 00    	je     80468f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  80447a:	8b 40 04             	mov    0x4(%eax),%eax
  80447d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804480:	83 fa 76             	cmp    $0x76,%edx
  804483:	76 27                	jbe    8044ac <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  804485:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804489:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80448f:	89 44 24 08          	mov    %eax,0x8(%esp)
  804493:	89 74 24 04          	mov    %esi,0x4(%esp)
  804497:	c7 04 24 d4 63 80 00 	movl   $0x8063d4,(%esp)
  80449e:	e8 eb c7 ff ff       	call   800c8e <_Z7cprintfPKcz>
				++errors;
  8044a3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8044aa:	eb 28                	jmp    8044d4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  8044ac:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  8044b1:	74 21                	je     8044d4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  8044b3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8044b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8044bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8044c1:	c7 04 24 00 64 80 00 	movl   $0x806400,(%esp)
  8044c8:	e8 c1 c7 ff ff       	call   800c8e <_Z7cprintfPKcz>
				++errors;
  8044cd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  8044d4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  8044db:	00 
  8044dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8044df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044e3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8044e9:	89 0c 24             	mov    %ecx,(%esp)
  8044ec:	e8 b6 d0 ff ff       	call   8015a7 <memcpy>
  8044f1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8044f5:	bf 77 00 00 00       	mov    $0x77,%edi
  8044fa:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  8044fe:	85 ff                	test   %edi,%edi
  804500:	b8 00 00 00 00       	mov    $0x0,%eax
  804505:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  804508:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80450f:	00 

			if (de->de_inum >= super->s_ninodes) {
  804510:	8b 03                	mov    (%ebx),%eax
  804512:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  804518:	7c 3e                	jl     804558 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80451a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80451e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  804524:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804528:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80452e:	89 54 24 08          	mov    %edx,0x8(%esp)
  804532:	89 74 24 04          	mov    %esi,0x4(%esp)
  804536:	c7 04 24 34 64 80 00 	movl   $0x806434,(%esp)
  80453d:	e8 4c c7 ff ff       	call   800c8e <_Z7cprintfPKcz>
				++errors;
  804542:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  804549:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  804550:	00 00 00 
  804553:	e9 0b 01 00 00       	jmp    804663 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  804558:	e8 70 ed ff ff       	call   8032cd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80455d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  804564:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80456b:	c1 e2 08             	shl    $0x8,%edx
  80456e:	09 d1                	or     %edx,%ecx
  804570:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  804577:	c1 e2 10             	shl    $0x10,%edx
  80457a:	09 d1                	or     %edx,%ecx
  80457c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  804583:	83 e2 7f             	and    $0x7f,%edx
  804586:	c1 e2 18             	shl    $0x18,%edx
  804589:	09 ca                	or     %ecx,%edx
  80458b:	83 c2 01             	add    $0x1,%edx
  80458e:	89 d1                	mov    %edx,%ecx
  804590:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  804596:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80459c:	0f b6 d5             	movzbl %ch,%edx
  80459f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  8045a5:	89 ca                	mov    %ecx,%edx
  8045a7:	c1 ea 10             	shr    $0x10,%edx
  8045aa:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  8045b0:	c1 e9 18             	shr    $0x18,%ecx
  8045b3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8045ba:	83 e2 80             	and    $0xffffff80,%edx
  8045bd:	09 ca                	or     %ecx,%edx
  8045bf:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  8045c5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8045c9:	0f 85 7a ff ff ff    	jne    804549 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  8045cf:	8b 03                	mov    (%ebx),%eax
  8045d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8045d5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8045db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045df:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8045e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8045e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8045ed:	c7 04 24 64 64 80 00 	movl   $0x806464,(%esp)
  8045f4:	e8 95 c6 ff ff       	call   800c8e <_Z7cprintfPKcz>
					++errors;
  8045f9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  804600:	e9 44 ff ff ff       	jmp    804549 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  804605:	3b 78 04             	cmp    0x4(%eax),%edi
  804608:	75 52                	jne    80465c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80460a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80460e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  804614:	89 54 24 04          	mov    %edx,0x4(%esp)
  804618:	83 c0 08             	add    $0x8,%eax
  80461b:	89 04 24             	mov    %eax,(%esp)
  80461e:	e8 c5 cf ff ff       	call   8015e8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  804623:	85 c0                	test   %eax,%eax
  804625:	75 35                	jne    80465c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  804627:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80462d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  804631:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  804637:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80463b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  804641:	89 54 24 08          	mov    %edx,0x8(%esp)
  804645:	89 74 24 04          	mov    %esi,0x4(%esp)
  804649:	c7 04 24 94 64 80 00 	movl   $0x806494,(%esp)
  804650:	e8 39 c6 ff ff       	call   800c8e <_Z7cprintfPKcz>
					++errors;
  804655:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80465c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  804663:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  804669:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80466f:	7e 1e                	jle    80468f <_Z4fsckv+0x75c>
  804671:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  804675:	7f 18                	jg     80468f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  804677:	89 ca                	mov    %ecx,%edx
  804679:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80467f:	e8 ec eb ff ff       	call   803270 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  804684:	83 38 00             	cmpl   $0x0,(%eax)
  804687:	0f 85 78 ff ff ff    	jne    804605 <_Z4fsckv+0x6d2>
  80468d:	eb cd                	jmp    80465c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80468f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  804695:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80469b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8046a1:	83 ea 80             	sub    $0xffffff80,%edx
  8046a4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8046aa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8046b0:	3b 51 08             	cmp    0x8(%ecx),%edx
  8046b3:	0f 8f e7 fc ff ff    	jg     8043a0 <_Z4fsckv+0x46d>
  8046b9:	e9 a0 fd ff ff       	jmp    80445e <_Z4fsckv+0x52b>
  8046be:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  8046c4:	89 d8                	mov    %ebx,%eax
  8046c6:	e8 02 ec ff ff       	call   8032cd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  8046cb:	8b 50 04             	mov    0x4(%eax),%edx
  8046ce:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8046d5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  8046dc:	c1 e7 08             	shl    $0x8,%edi
  8046df:	09 f9                	or     %edi,%ecx
  8046e1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  8046e8:	c1 e7 10             	shl    $0x10,%edi
  8046eb:	09 f9                	or     %edi,%ecx
  8046ed:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  8046f4:	83 e7 7f             	and    $0x7f,%edi
  8046f7:	c1 e7 18             	shl    $0x18,%edi
  8046fa:	09 f9                	or     %edi,%ecx
  8046fc:	39 ca                	cmp    %ecx,%edx
  8046fe:	74 1b                	je     80471b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  804700:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804704:	89 54 24 08          	mov    %edx,0x8(%esp)
  804708:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80470c:	c7 04 24 c4 64 80 00 	movl   $0x8064c4,(%esp)
  804713:	e8 76 c5 ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804718:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80471b:	83 c3 01             	add    $0x1,%ebx
  80471e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  804724:	7f 9e                	jg     8046c4 <_Z4fsckv+0x791>
  804726:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80472c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  804733:	7e 4f                	jle    804784 <_Z4fsckv+0x851>
  804735:	bb 00 00 00 00       	mov    $0x0,%ebx
  80473a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  804740:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  804747:	3c ff                	cmp    $0xff,%al
  804749:	75 09                	jne    804754 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80474b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  804752:	eb 1f                	jmp    804773 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  804754:	84 c0                	test   %al,%al
  804756:	75 1b                	jne    804773 <_Z4fsckv+0x840>
  804758:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80475e:	7c 13                	jl     804773 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  804760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804764:	c7 04 24 f0 64 80 00 	movl   $0x8064f0,(%esp)
  80476b:	e8 1e c5 ff ff       	call   800c8e <_Z7cprintfPKcz>
			++errors;
  804770:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  804773:	83 c3 01             	add    $0x1,%ebx
  804776:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80477c:	7f c2                	jg     804740 <_Z4fsckv+0x80d>
  80477e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  804784:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80478b:	19 c0                	sbb    %eax,%eax
  80478d:	f7 d0                	not    %eax
  80478f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  804792:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  804798:	5b                   	pop    %ebx
  804799:	5e                   	pop    %esi
  80479a:	5f                   	pop    %edi
  80479b:	5d                   	pop    %ebp
  80479c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80479d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8047a4:	0f 84 92 f9 ff ff    	je     80413c <_Z4fsckv+0x209>
  8047aa:	e9 5a f9 ff ff       	jmp    804109 <_Z4fsckv+0x1d6>
	...

008047b0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047b0:	55                   	push   %ebp
  8047b1:	89 e5                	mov    %esp,%ebp
  8047b3:	83 ec 18             	sub    $0x18,%esp
  8047b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8047b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8047bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c2:	89 04 24             	mov    %eax,(%esp)
  8047c5:	e8 a2 e4 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  8047ca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8047cc:	c7 44 24 04 23 65 80 	movl   $0x806523,0x4(%esp)
  8047d3:	00 
  8047d4:	89 34 24             	mov    %esi,(%esp)
  8047d7:	e8 ae cb ff ff       	call   80138a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  8047dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8047df:	2b 03                	sub    (%ebx),%eax
  8047e1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8047e4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8047eb:	c7 86 80 00 00 00 3c 	movl   $0x80703c,0x80(%esi)
  8047f2:	70 80 00 
	return 0;
}
  8047f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8047fa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8047fd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  804800:	89 ec                	mov    %ebp,%esp
  804802:	5d                   	pop    %ebp
  804803:	c3                   	ret    

00804804 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  804804:	55                   	push   %ebp
  804805:	89 e5                	mov    %esp,%ebp
  804807:	53                   	push   %ebx
  804808:	83 ec 14             	sub    $0x14,%esp
  80480b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80480e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804812:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804819:	e8 0f d1 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80481e:	89 1c 24             	mov    %ebx,(%esp)
  804821:	e8 46 e4 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804826:	89 44 24 04          	mov    %eax,0x4(%esp)
  80482a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804831:	e8 f7 d0 ff ff       	call   80192d <_Z14sys_page_unmapiPv>
}
  804836:	83 c4 14             	add    $0x14,%esp
  804839:	5b                   	pop    %ebx
  80483a:	5d                   	pop    %ebp
  80483b:	c3                   	ret    

0080483c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80483c:	55                   	push   %ebp
  80483d:	89 e5                	mov    %esp,%ebp
  80483f:	57                   	push   %edi
  804840:	56                   	push   %esi
  804841:	53                   	push   %ebx
  804842:	83 ec 2c             	sub    $0x2c,%esp
  804845:	89 c7                	mov    %eax,%edi
  804847:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80484a:	a1 14 80 80 00       	mov    0x808014,%eax
  80484f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  804852:	89 3c 24             	mov    %edi,(%esp)
  804855:	e8 ba 05 00 00       	call   804e14 <_Z7pagerefPv>
  80485a:	89 c3                	mov    %eax,%ebx
  80485c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80485f:	89 04 24             	mov    %eax,(%esp)
  804862:	e8 ad 05 00 00       	call   804e14 <_Z7pagerefPv>
  804867:	39 c3                	cmp    %eax,%ebx
  804869:	0f 94 c0             	sete   %al
  80486c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80486f:	8b 15 14 80 80 00    	mov    0x808014,%edx
  804875:	8b 52 58             	mov    0x58(%edx),%edx
  804878:	39 d6                	cmp    %edx,%esi
  80487a:	75 08                	jne    804884 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80487c:	83 c4 2c             	add    $0x2c,%esp
  80487f:	5b                   	pop    %ebx
  804880:	5e                   	pop    %esi
  804881:	5f                   	pop    %edi
  804882:	5d                   	pop    %ebp
  804883:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  804884:	85 c0                	test   %eax,%eax
  804886:	74 c2                	je     80484a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  804888:	c7 04 24 2a 65 80 00 	movl   $0x80652a,(%esp)
  80488f:	e8 fa c3 ff ff       	call   800c8e <_Z7cprintfPKcz>
  804894:	eb b4                	jmp    80484a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00804896 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804896:	55                   	push   %ebp
  804897:	89 e5                	mov    %esp,%ebp
  804899:	57                   	push   %edi
  80489a:	56                   	push   %esi
  80489b:	53                   	push   %ebx
  80489c:	83 ec 1c             	sub    $0x1c,%esp
  80489f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8048a2:	89 34 24             	mov    %esi,(%esp)
  8048a5:	e8 c2 e3 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  8048aa:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8048ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8048b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8048b5:	75 46                	jne    8048fd <_ZL13devpipe_writeP2FdPKvj+0x67>
  8048b7:	eb 52                	jmp    80490b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8048b9:	89 da                	mov    %ebx,%edx
  8048bb:	89 f0                	mov    %esi,%eax
  8048bd:	e8 7a ff ff ff       	call   80483c <_ZL13_pipeisclosedP2FdP4Pipe>
  8048c2:	85 c0                	test   %eax,%eax
  8048c4:	75 49                	jne    80490f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8048c6:	e8 71 cf ff ff       	call   80183c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8048cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8048ce:	89 c2                	mov    %eax,%edx
  8048d0:	2b 13                	sub    (%ebx),%edx
  8048d2:	83 fa 20             	cmp    $0x20,%edx
  8048d5:	74 e2                	je     8048b9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8048d7:	89 c2                	mov    %eax,%edx
  8048d9:	c1 fa 1f             	sar    $0x1f,%edx
  8048dc:	c1 ea 1b             	shr    $0x1b,%edx
  8048df:	01 d0                	add    %edx,%eax
  8048e1:	83 e0 1f             	and    $0x1f,%eax
  8048e4:	29 d0                	sub    %edx,%eax
  8048e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8048e9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8048ed:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8048f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8048f5:	83 c7 01             	add    $0x1,%edi
  8048f8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8048fb:	76 0e                	jbe    80490b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8048fd:	8b 43 04             	mov    0x4(%ebx),%eax
  804900:	89 c2                	mov    %eax,%edx
  804902:	2b 13                	sub    (%ebx),%edx
  804904:	83 fa 20             	cmp    $0x20,%edx
  804907:	74 b0                	je     8048b9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  804909:	eb cc                	jmp    8048d7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80490b:	89 f8                	mov    %edi,%eax
  80490d:	eb 05                	jmp    804914 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80490f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  804914:	83 c4 1c             	add    $0x1c,%esp
  804917:	5b                   	pop    %ebx
  804918:	5e                   	pop    %esi
  804919:	5f                   	pop    %edi
  80491a:	5d                   	pop    %ebp
  80491b:	c3                   	ret    

0080491c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80491c:	55                   	push   %ebp
  80491d:	89 e5                	mov    %esp,%ebp
  80491f:	83 ec 28             	sub    $0x28,%esp
  804922:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  804925:	89 75 f8             	mov    %esi,-0x8(%ebp)
  804928:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80492b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80492e:	89 3c 24             	mov    %edi,(%esp)
  804931:	e8 36 e3 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804936:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  804938:	be 00 00 00 00       	mov    $0x0,%esi
  80493d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804941:	75 47                	jne    80498a <_ZL12devpipe_readP2FdPvj+0x6e>
  804943:	eb 52                	jmp    804997 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  804945:	89 f0                	mov    %esi,%eax
  804947:	eb 5e                	jmp    8049a7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  804949:	89 da                	mov    %ebx,%edx
  80494b:	89 f8                	mov    %edi,%eax
  80494d:	8d 76 00             	lea    0x0(%esi),%esi
  804950:	e8 e7 fe ff ff       	call   80483c <_ZL13_pipeisclosedP2FdP4Pipe>
  804955:	85 c0                	test   %eax,%eax
  804957:	75 49                	jne    8049a2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  804959:	e8 de ce ff ff       	call   80183c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80495e:	8b 03                	mov    (%ebx),%eax
  804960:	3b 43 04             	cmp    0x4(%ebx),%eax
  804963:	74 e4                	je     804949 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804965:	89 c2                	mov    %eax,%edx
  804967:	c1 fa 1f             	sar    $0x1f,%edx
  80496a:	c1 ea 1b             	shr    $0x1b,%edx
  80496d:	01 d0                	add    %edx,%eax
  80496f:	83 e0 1f             	and    $0x1f,%eax
  804972:	29 d0                	sub    %edx,%eax
  804974:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  804979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80497c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80497f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  804982:	83 c6 01             	add    $0x1,%esi
  804985:	39 75 10             	cmp    %esi,0x10(%ebp)
  804988:	76 0d                	jbe    804997 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80498a:	8b 03                	mov    (%ebx),%eax
  80498c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80498f:	75 d4                	jne    804965 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  804991:	85 f6                	test   %esi,%esi
  804993:	75 b0                	jne    804945 <_ZL12devpipe_readP2FdPvj+0x29>
  804995:	eb b2                	jmp    804949 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  804997:	89 f0                	mov    %esi,%eax
  804999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8049a0:	eb 05                	jmp    8049a7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8049a2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8049a7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8049aa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8049ad:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8049b0:	89 ec                	mov    %ebp,%esp
  8049b2:	5d                   	pop    %ebp
  8049b3:	c3                   	ret    

008049b4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8049b4:	55                   	push   %ebp
  8049b5:	89 e5                	mov    %esp,%ebp
  8049b7:	83 ec 48             	sub    $0x48,%esp
  8049ba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8049bd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8049c0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8049c3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8049c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8049c9:	89 04 24             	mov    %eax,(%esp)
  8049cc:	e8 b6 e2 ff ff       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  8049d1:	89 c3                	mov    %eax,%ebx
  8049d3:	85 c0                	test   %eax,%eax
  8049d5:	0f 88 0b 01 00 00    	js     804ae6 <_Z4pipePi+0x132>
  8049db:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8049e2:	00 
  8049e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8049ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8049f1:	e8 7a ce ff ff       	call   801870 <_Z14sys_page_allociPvi>
  8049f6:	89 c3                	mov    %eax,%ebx
  8049f8:	85 c0                	test   %eax,%eax
  8049fa:	0f 89 f5 00 00 00    	jns    804af5 <_Z4pipePi+0x141>
  804a00:	e9 e1 00 00 00       	jmp    804ae6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  804a05:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804a0c:	00 
  804a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  804a14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804a1b:	e8 50 ce ff ff       	call   801870 <_Z14sys_page_allociPvi>
  804a20:	89 c3                	mov    %eax,%ebx
  804a22:	85 c0                	test   %eax,%eax
  804a24:	0f 89 e2 00 00 00    	jns    804b0c <_Z4pipePi+0x158>
  804a2a:	e9 a4 00 00 00       	jmp    804ad3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a32:	89 04 24             	mov    %eax,(%esp)
  804a35:	e8 32 e2 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804a3a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  804a41:	00 
  804a42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804a4d:	00 
  804a4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  804a52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804a59:	e8 71 ce ff ff       	call   8018cf <_Z12sys_page_mapiPviS_i>
  804a5e:	89 c3                	mov    %eax,%ebx
  804a60:	85 c0                	test   %eax,%eax
  804a62:	78 4c                	js     804ab0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804a64:	8b 15 3c 70 80 00    	mov    0x80703c,%edx
  804a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a6d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  804a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  804a79:	8b 15 3c 70 80 00    	mov    0x80703c,%edx
  804a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a82:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  804a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a91:	89 04 24             	mov    %eax,(%esp)
  804a94:	e8 8b e1 ff ff       	call   802c24 <_Z6fd2numP2Fd>
  804a99:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  804a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a9e:	89 04 24             	mov    %eax,(%esp)
  804aa1:	e8 7e e1 ff ff       	call   802c24 <_Z6fd2numP2Fd>
  804aa6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  804aa9:	bb 00 00 00 00       	mov    $0x0,%ebx
  804aae:	eb 36                	jmp    804ae6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  804ab0:	89 74 24 04          	mov    %esi,0x4(%esp)
  804ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804abb:	e8 6d ce ff ff       	call   80192d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  804ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ac7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804ace:	e8 5a ce ff ff       	call   80192d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  804ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804ae1:	e8 47 ce ff ff       	call   80192d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  804ae6:	89 d8                	mov    %ebx,%eax
  804ae8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  804aeb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  804aee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  804af1:	89 ec                	mov    %ebp,%esp
  804af3:	5d                   	pop    %ebp
  804af4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  804af5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804af8:	89 04 24             	mov    %eax,(%esp)
  804afb:	e8 87 e1 ff ff       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  804b00:	89 c3                	mov    %eax,%ebx
  804b02:	85 c0                	test   %eax,%eax
  804b04:	0f 89 fb fe ff ff    	jns    804a05 <_Z4pipePi+0x51>
  804b0a:	eb c7                	jmp    804ad3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b0f:	89 04 24             	mov    %eax,(%esp)
  804b12:	e8 55 e1 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804b17:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804b19:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804b20:	00 
  804b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804b2c:	e8 3f cd ff ff       	call   801870 <_Z14sys_page_allociPvi>
  804b31:	89 c3                	mov    %eax,%ebx
  804b33:	85 c0                	test   %eax,%eax
  804b35:	0f 89 f4 fe ff ff    	jns    804a2f <_Z4pipePi+0x7b>
  804b3b:	eb 83                	jmp    804ac0 <_Z4pipePi+0x10c>

00804b3d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  804b3d:	55                   	push   %ebp
  804b3e:	89 e5                	mov    %esp,%ebp
  804b40:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804b43:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804b4a:	00 
  804b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b52:	8b 45 08             	mov    0x8(%ebp),%eax
  804b55:	89 04 24             	mov    %eax,(%esp)
  804b58:	e8 74 e0 ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  804b5d:	85 c0                	test   %eax,%eax
  804b5f:	78 15                	js     804b76 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  804b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b64:	89 04 24             	mov    %eax,(%esp)
  804b67:	e8 00 e1 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  804b6c:	89 c2                	mov    %eax,%edx
  804b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b71:	e8 c6 fc ff ff       	call   80483c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  804b76:	c9                   	leave  
  804b77:	c3                   	ret    

00804b78 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  804b78:	55                   	push   %ebp
  804b79:	89 e5                	mov    %esp,%ebp
  804b7b:	53                   	push   %ebx
  804b7c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  804b7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804b82:	89 04 24             	mov    %eax,(%esp)
  804b85:	e8 fd e0 ff ff       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  804b8a:	89 c3                	mov    %eax,%ebx
  804b8c:	85 c0                	test   %eax,%eax
  804b8e:	0f 88 be 00 00 00    	js     804c52 <_Z18pipe_ipc_recv_readv+0xda>
  804b94:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804b9b:	00 
  804b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ba3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804baa:	e8 c1 cc ff ff       	call   801870 <_Z14sys_page_allociPvi>
  804baf:	89 c3                	mov    %eax,%ebx
  804bb1:	85 c0                	test   %eax,%eax
  804bb3:	0f 89 a1 00 00 00    	jns    804c5a <_Z18pipe_ipc_recv_readv+0xe2>
  804bb9:	e9 94 00 00 00       	jmp    804c52 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  804bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804bc1:	85 c0                	test   %eax,%eax
  804bc3:	75 0e                	jne    804bd3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  804bc5:	c7 04 24 88 65 80 00 	movl   $0x806588,(%esp)
  804bcc:	e8 bd c0 ff ff       	call   800c8e <_Z7cprintfPKcz>
  804bd1:	eb 10                	jmp    804be3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  804bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  804bd7:	c7 04 24 3d 65 80 00 	movl   $0x80653d,(%esp)
  804bde:	e8 ab c0 ff ff       	call   800c8e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  804be3:	c7 04 24 47 65 80 00 	movl   $0x806547,(%esp)
  804bea:	e8 9f c0 ff ff       	call   800c8e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  804bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804bf2:	a8 04                	test   $0x4,%al
  804bf4:	74 04                	je     804bfa <_Z18pipe_ipc_recv_readv+0x82>
  804bf6:	a8 01                	test   $0x1,%al
  804bf8:	75 24                	jne    804c1e <_Z18pipe_ipc_recv_readv+0xa6>
  804bfa:	c7 44 24 0c 5a 65 80 	movl   $0x80655a,0xc(%esp)
  804c01:	00 
  804c02:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  804c09:	00 
  804c0a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  804c11:	00 
  804c12:	c7 04 24 77 65 80 00 	movl   $0x806577,(%esp)
  804c19:	e8 52 bf ff ff       	call   800b70 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  804c1e:	8b 15 3c 70 80 00    	mov    0x80703c,%edx
  804c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c27:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  804c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  804c33:	89 04 24             	mov    %eax,(%esp)
  804c36:	e8 e9 df ff ff       	call   802c24 <_Z6fd2numP2Fd>
  804c3b:	89 c3                	mov    %eax,%ebx
  804c3d:	eb 13                	jmp    804c52 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  804c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  804c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804c4d:	e8 db cc ff ff       	call   80192d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  804c52:	89 d8                	mov    %ebx,%eax
  804c54:	83 c4 24             	add    $0x24,%esp
  804c57:	5b                   	pop    %ebx
  804c58:	5d                   	pop    %ebp
  804c59:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  804c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c5d:	89 04 24             	mov    %eax,(%esp)
  804c60:	e8 07 e0 ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804c65:	8d 55 ec             	lea    -0x14(%ebp),%edx
  804c68:	89 54 24 08          	mov    %edx,0x8(%esp)
  804c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804c70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  804c73:	89 04 24             	mov    %eax,(%esp)
  804c76:	e8 75 08 00 00       	call   8054f0 <_Z8ipc_recvPiPvS_>
  804c7b:	89 c3                	mov    %eax,%ebx
  804c7d:	85 c0                	test   %eax,%eax
  804c7f:	0f 89 39 ff ff ff    	jns    804bbe <_Z18pipe_ipc_recv_readv+0x46>
  804c85:	eb b8                	jmp    804c3f <_Z18pipe_ipc_recv_readv+0xc7>

00804c87 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  804c87:	55                   	push   %ebp
  804c88:	89 e5                	mov    %esp,%ebp
  804c8a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  804c8d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804c94:	00 
  804c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  804c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  804c9f:	89 04 24             	mov    %eax,(%esp)
  804ca2:	e8 2a df ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  804ca7:	85 c0                	test   %eax,%eax
  804ca9:	78 2f                	js     804cda <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  804cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804cae:	89 04 24             	mov    %eax,(%esp)
  804cb1:	e8 b6 df ff ff       	call   802c6c <_Z7fd2dataP2Fd>
  804cb6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  804cbd:	00 
  804cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  804cc2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804cc9:	00 
  804cca:	8b 45 08             	mov    0x8(%ebp),%eax
  804ccd:	89 04 24             	mov    %eax,(%esp)
  804cd0:	e8 aa 08 00 00       	call   80557f <_Z8ipc_sendijPvi>
    return 0;
  804cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804cda:	c9                   	leave  
  804cdb:	c3                   	ret    

00804cdc <_ZL8writebufP8printbuf>:
};


static void
writebuf(struct printbuf *b)
{
  804cdc:	55                   	push   %ebp
  804cdd:	89 e5                	mov    %esp,%ebp
  804cdf:	53                   	push   %ebx
  804ce0:	83 ec 14             	sub    $0x14,%esp
  804ce3:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  804ce5:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  804ce9:	7e 31                	jle    804d1c <_ZL8writebufP8printbuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  804ceb:	8b 40 04             	mov    0x4(%eax),%eax
  804cee:	89 44 24 08          	mov    %eax,0x8(%esp)
  804cf2:	8d 43 10             	lea    0x10(%ebx),%eax
  804cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  804cf9:	8b 03                	mov    (%ebx),%eax
  804cfb:	89 04 24             	mov    %eax,(%esp)
  804cfe:	e8 66 e3 ff ff       	call   803069 <_Z5writeiPKvj>
		if (result > 0)
  804d03:	85 c0                	test   %eax,%eax
  804d05:	7e 03                	jle    804d0a <_ZL8writebufP8printbuf+0x2e>
			b->result += result;
  804d07:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  804d0a:	39 43 04             	cmp    %eax,0x4(%ebx)
  804d0d:	74 0d                	je     804d1c <_ZL8writebufP8printbuf+0x40>
			b->error = (result < 0 ? result : 0);
  804d0f:	85 c0                	test   %eax,%eax
  804d11:	ba 00 00 00 00       	mov    $0x0,%edx
  804d16:	0f 4f c2             	cmovg  %edx,%eax
  804d19:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  804d1c:	83 c4 14             	add    $0x14,%esp
  804d1f:	5b                   	pop    %ebx
  804d20:	5d                   	pop    %ebp
  804d21:	c3                   	ret    

00804d22 <_ZL5putchiPv>:

static void
putch(int ch, void *thunk)
{
  804d22:	55                   	push   %ebp
  804d23:	89 e5                	mov    %esp,%ebp
  804d25:	53                   	push   %ebx
  804d26:	83 ec 04             	sub    $0x4,%esp
  804d29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  804d2c:	8b 43 04             	mov    0x4(%ebx),%eax
  804d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  804d32:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  804d36:	83 c0 01             	add    $0x1,%eax
  804d39:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  804d3c:	3d 00 01 00 00       	cmp    $0x100,%eax
  804d41:	75 0e                	jne    804d51 <_ZL5putchiPv+0x2f>
		writebuf(b);
  804d43:	89 d8                	mov    %ebx,%eax
  804d45:	e8 92 ff ff ff       	call   804cdc <_ZL8writebufP8printbuf>
		b->idx = 0;
  804d4a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  804d51:	83 c4 04             	add    $0x4,%esp
  804d54:	5b                   	pop    %ebx
  804d55:	5d                   	pop    %ebp
  804d56:	c3                   	ret    

00804d57 <_Z8vfprintfiPKcPc>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804d57:	55                   	push   %ebp
  804d58:	89 e5                	mov    %esp,%ebp
  804d5a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  804d60:	8b 45 08             	mov    0x8(%ebp),%eax
  804d63:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  804d69:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  804d70:	00 00 00 
	b.result = 0;
  804d73:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  804d7a:	00 00 00 
	b.error = 1;
  804d7d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  804d84:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804d87:	8b 45 10             	mov    0x10(%ebp),%eax
  804d8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804d91:	89 44 24 08          	mov    %eax,0x8(%esp)
  804d95:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  804d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  804d9f:	c7 04 24 22 4d 80 00 	movl   $0x804d22,(%esp)
  804da6:	e8 6c c0 ff ff       	call   800e17 <_Z9vprintfmtPFviPvES_PKcPc>
	if (b.idx > 0)
  804dab:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  804db2:	7e 0b                	jle    804dbf <_Z8vfprintfiPKcPc+0x68>
		writebuf(&b);
  804db4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  804dba:	e8 1d ff ff ff       	call   804cdc <_ZL8writebufP8printbuf>

	return (b.result ? b.result : b.error);
  804dbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  804dc5:	85 c0                	test   %eax,%eax
  804dc7:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  804dce:	c9                   	leave  
  804dcf:	c3                   	ret    

00804dd0 <_Z7fprintfiPKcz>:

int
fprintf(int fd, const char *fmt, ...)
{
  804dd0:	55                   	push   %ebp
  804dd1:	89 e5                	mov    %esp,%ebp
  804dd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804dd6:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  804dd9:	89 44 24 08          	mov    %eax,0x8(%esp)
  804ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  804de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  804de4:	8b 45 08             	mov    0x8(%ebp),%eax
  804de7:	89 04 24             	mov    %eax,(%esp)
  804dea:	e8 68 ff ff ff       	call   804d57 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  804def:	c9                   	leave  
  804df0:	c3                   	ret    

00804df1 <_Z6printfPKcz>:

int
printf(const char *fmt, ...)
{
  804df1:	55                   	push   %ebp
  804df2:	89 e5                	mov    %esp,%ebp
  804df4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804df7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  804dfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  804dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  804e01:	89 44 24 04          	mov    %eax,0x4(%esp)
  804e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  804e0c:	e8 46 ff ff ff       	call   804d57 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  804e11:	c9                   	leave  
  804e12:	c3                   	ret    
	...

00804e14 <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804e14:	55                   	push   %ebp
  804e15:	89 e5                	mov    %esp,%ebp
  804e17:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804e1a:	89 d0                	mov    %edx,%eax
  804e1c:	c1 e8 16             	shr    $0x16,%eax
  804e1f:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  804e26:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804e2b:	f6 c1 01             	test   $0x1,%cl
  804e2e:	74 1d                	je     804e4d <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  804e30:	c1 ea 0c             	shr    $0xc,%edx
  804e33:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  804e3a:	f6 c2 01             	test   $0x1,%dl
  804e3d:	74 0e                	je     804e4d <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  804e3f:	c1 ea 0c             	shr    $0xc,%edx
  804e42:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  804e49:	ef 
  804e4a:	0f b7 c0             	movzwl %ax,%eax
}
  804e4d:	5d                   	pop    %ebp
  804e4e:	c3                   	ret    
	...

00804e50 <_Z4waiti>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804e50:	55                   	push   %ebp
  804e51:	89 e5                	mov    %esp,%ebp
  804e53:	56                   	push   %esi
  804e54:	53                   	push   %ebx
  804e55:	83 ec 10             	sub    $0x10,%esp
  804e58:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  804e5b:	85 f6                	test   %esi,%esi
  804e5d:	75 24                	jne    804e83 <_Z4waiti+0x33>
  804e5f:	c7 44 24 0c ab 65 80 	movl   $0x8065ab,0xc(%esp)
  804e66:	00 
  804e67:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  804e6e:	00 
  804e6f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  804e76:	00 
  804e77:	c7 04 24 b6 65 80 00 	movl   $0x8065b6,(%esp)
  804e7e:	e8 ed bc ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	e = &envs[ENVX(envid)];
  804e83:	89 f3                	mov    %esi,%ebx
  804e85:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804e8b:	6b db 78             	imul   $0x78,%ebx,%ebx
  804e8e:	8b 83 04 00 00 ef    	mov    -0x10fffffc(%ebx),%eax
  804e94:	39 f0                	cmp    %esi,%eax
  804e96:	75 11                	jne    804ea9 <_Z4waiti+0x59>
  804e98:	8b 83 0c 00 00 ef    	mov    -0x10fffff4(%ebx),%eax
  804e9e:	85 c0                	test   %eax,%eax
  804ea0:	74 07                	je     804ea9 <_Z4waiti+0x59>
		sys_yield();
  804ea2:	e8 95 c9 ff ff       	call   80183c <_Z9sys_yieldv>
  804ea7:	eb e5                	jmp    804e8e <_Z4waiti+0x3e>
}
  804ea9:	83 c4 10             	add    $0x10,%esp
  804eac:	5b                   	pop    %ebx
  804ead:	5e                   	pop    %esi
  804eae:	5d                   	pop    %ebp
  804eaf:	90                   	nop
  804eb0:	c3                   	ret    
	...

00804ec0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804ec0:	55                   	push   %ebp
  804ec1:	89 e5                	mov    %esp,%ebp
  804ec3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  804ec6:	c7 44 24 04 c1 65 80 	movl   $0x8065c1,0x4(%esp)
  804ecd:	00 
  804ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  804ed1:	89 04 24             	mov    %eax,(%esp)
  804ed4:	e8 b1 c4 ff ff       	call   80138a <_Z6strcpyPcPKc>
	return 0;
}
  804ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  804ede:	c9                   	leave  
  804edf:	c3                   	ret    

00804ee0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  804ee0:	55                   	push   %ebp
  804ee1:	89 e5                	mov    %esp,%ebp
  804ee3:	53                   	push   %ebx
  804ee4:	83 ec 14             	sub    $0x14,%esp
  804ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  804eea:	89 1c 24             	mov    %ebx,(%esp)
  804eed:	e8 22 ff ff ff       	call   804e14 <_Z7pagerefPv>
  804ef2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  804ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  804ef9:	83 fa 01             	cmp    $0x1,%edx
  804efc:	75 0b                	jne    804f09 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  804efe:	8b 43 0c             	mov    0xc(%ebx),%eax
  804f01:	89 04 24             	mov    %eax,(%esp)
  804f04:	e8 fe 02 00 00       	call   805207 <_Z11nsipc_closei>
	else
		return 0;
}
  804f09:	83 c4 14             	add    $0x14,%esp
  804f0c:	5b                   	pop    %ebx
  804f0d:	5d                   	pop    %ebp
  804f0e:	c3                   	ret    

00804f0f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804f0f:	55                   	push   %ebp
  804f10:	89 e5                	mov    %esp,%ebp
  804f12:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804f15:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804f1c:	00 
  804f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  804f20:	89 44 24 08          	mov    %eax,0x8(%esp)
  804f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  804f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  804f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  804f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  804f31:	89 04 24             	mov    %eax,(%esp)
  804f34:	e8 c9 03 00 00       	call   805302 <_Z10nsipc_sendiPKvij>
}
  804f39:	c9                   	leave  
  804f3a:	c3                   	ret    

00804f3b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804f3b:	55                   	push   %ebp
  804f3c:	89 e5                	mov    %esp,%ebp
  804f3e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804f41:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804f48:	00 
  804f49:	8b 45 10             	mov    0x10(%ebp),%eax
  804f4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  804f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  804f53:	89 44 24 04          	mov    %eax,0x4(%esp)
  804f57:	8b 45 08             	mov    0x8(%ebp),%eax
  804f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  804f5d:	89 04 24             	mov    %eax,(%esp)
  804f60:	e8 1d 03 00 00       	call   805282 <_Z10nsipc_recviPvij>
}
  804f65:	c9                   	leave  
  804f66:	c3                   	ret    

00804f67 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  804f67:	55                   	push   %ebp
  804f68:	89 e5                	mov    %esp,%ebp
  804f6a:	83 ec 28             	sub    $0x28,%esp
  804f6d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  804f70:	89 75 fc             	mov    %esi,-0x4(%ebp)
  804f73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  804f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804f78:	89 04 24             	mov    %eax,(%esp)
  804f7b:	e8 07 dd ff ff       	call   802c87 <_Z14fd_find_unusedPP2Fd>
  804f80:	89 c3                	mov    %eax,%ebx
  804f82:	85 c0                	test   %eax,%eax
  804f84:	78 21                	js     804fa7 <_ZL12alloc_sockfdi+0x40>
  804f86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804f8d:	00 
  804f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  804f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804f9c:	e8 cf c8 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  804fa1:	89 c3                	mov    %eax,%ebx
  804fa3:	85 c0                	test   %eax,%eax
  804fa5:	79 14                	jns    804fbb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  804fa7:	89 34 24             	mov    %esi,(%esp)
  804faa:	e8 58 02 00 00       	call   805207 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  804faf:	89 d8                	mov    %ebx,%eax
  804fb1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  804fb4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  804fb7:	89 ec                	mov    %ebp,%esp
  804fb9:	5d                   	pop    %ebp
  804fba:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  804fbb:	8b 15 58 70 80 00    	mov    0x807058,%edx
  804fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fc4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  804fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fc9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  804fd0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  804fd3:	89 04 24             	mov    %eax,(%esp)
  804fd6:	e8 49 dc ff ff       	call   802c24 <_Z6fd2numP2Fd>
  804fdb:	89 c3                	mov    %eax,%ebx
  804fdd:	eb d0                	jmp    804faf <_ZL12alloc_sockfdi+0x48>

00804fdf <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  804fdf:	55                   	push   %ebp
  804fe0:	89 e5                	mov    %esp,%ebp
  804fe2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  804fe5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804fec:	00 
  804fed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  804ff0:	89 54 24 04          	mov    %edx,0x4(%esp)
  804ff4:	89 04 24             	mov    %eax,(%esp)
  804ff7:	e8 d5 db ff ff       	call   802bd1 <_Z9fd_lookupiPP2Fdb>
  804ffc:	85 c0                	test   %eax,%eax
  804ffe:	78 15                	js     805015 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  805000:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  805003:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  805008:	8b 0d 58 70 80 00    	mov    0x807058,%ecx
  80500e:	39 0a                	cmp    %ecx,(%edx)
  805010:	75 03                	jne    805015 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  805012:	8b 42 0c             	mov    0xc(%edx),%eax
}
  805015:	c9                   	leave  
  805016:	c3                   	ret    

00805017 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805017:	55                   	push   %ebp
  805018:	89 e5                	mov    %esp,%ebp
  80501a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80501d:	8b 45 08             	mov    0x8(%ebp),%eax
  805020:	e8 ba ff ff ff       	call   804fdf <_ZL9fd2sockidi>
  805025:	85 c0                	test   %eax,%eax
  805027:	78 1f                	js     805048 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  805029:	8b 55 10             	mov    0x10(%ebp),%edx
  80502c:	89 54 24 08          	mov    %edx,0x8(%esp)
  805030:	8b 55 0c             	mov    0xc(%ebp),%edx
  805033:	89 54 24 04          	mov    %edx,0x4(%esp)
  805037:	89 04 24             	mov    %eax,(%esp)
  80503a:	e8 19 01 00 00       	call   805158 <_Z12nsipc_acceptiP8sockaddrPj>
  80503f:	85 c0                	test   %eax,%eax
  805041:	78 05                	js     805048 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  805043:	e8 1f ff ff ff       	call   804f67 <_ZL12alloc_sockfdi>
}
  805048:	c9                   	leave  
  805049:	c3                   	ret    

0080504a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80504a:	55                   	push   %ebp
  80504b:	89 e5                	mov    %esp,%ebp
  80504d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  805050:	8b 45 08             	mov    0x8(%ebp),%eax
  805053:	e8 87 ff ff ff       	call   804fdf <_ZL9fd2sockidi>
  805058:	85 c0                	test   %eax,%eax
  80505a:	78 16                	js     805072 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80505c:	8b 55 10             	mov    0x10(%ebp),%edx
  80505f:	89 54 24 08          	mov    %edx,0x8(%esp)
  805063:	8b 55 0c             	mov    0xc(%ebp),%edx
  805066:	89 54 24 04          	mov    %edx,0x4(%esp)
  80506a:	89 04 24             	mov    %eax,(%esp)
  80506d:	e8 34 01 00 00       	call   8051a6 <_Z10nsipc_bindiP8sockaddrj>
}
  805072:	c9                   	leave  
  805073:	c3                   	ret    

00805074 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  805074:	55                   	push   %ebp
  805075:	89 e5                	mov    %esp,%ebp
  805077:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80507a:	8b 45 08             	mov    0x8(%ebp),%eax
  80507d:	e8 5d ff ff ff       	call   804fdf <_ZL9fd2sockidi>
  805082:	85 c0                	test   %eax,%eax
  805084:	78 0f                	js     805095 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  805086:	8b 55 0c             	mov    0xc(%ebp),%edx
  805089:	89 54 24 04          	mov    %edx,0x4(%esp)
  80508d:	89 04 24             	mov    %eax,(%esp)
  805090:	e8 50 01 00 00       	call   8051e5 <_Z14nsipc_shutdownii>
}
  805095:	c9                   	leave  
  805096:	c3                   	ret    

00805097 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805097:	55                   	push   %ebp
  805098:	89 e5                	mov    %esp,%ebp
  80509a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80509d:	8b 45 08             	mov    0x8(%ebp),%eax
  8050a0:	e8 3a ff ff ff       	call   804fdf <_ZL9fd2sockidi>
  8050a5:	85 c0                	test   %eax,%eax
  8050a7:	78 16                	js     8050bf <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8050a9:	8b 55 10             	mov    0x10(%ebp),%edx
  8050ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  8050b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8050b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8050b7:	89 04 24             	mov    %eax,(%esp)
  8050ba:	e8 62 01 00 00       	call   805221 <_Z13nsipc_connectiPK8sockaddrj>
}
  8050bf:	c9                   	leave  
  8050c0:	c3                   	ret    

008050c1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8050c1:	55                   	push   %ebp
  8050c2:	89 e5                	mov    %esp,%ebp
  8050c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8050c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8050ca:	e8 10 ff ff ff       	call   804fdf <_ZL9fd2sockidi>
  8050cf:	85 c0                	test   %eax,%eax
  8050d1:	78 0f                	js     8050e2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8050d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8050d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8050da:	89 04 24             	mov    %eax,(%esp)
  8050dd:	e8 7e 01 00 00       	call   805260 <_Z12nsipc_listenii>
}
  8050e2:	c9                   	leave  
  8050e3:	c3                   	ret    

008050e4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8050e4:	55                   	push   %ebp
  8050e5:	89 e5                	mov    %esp,%ebp
  8050e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8050ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8050ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8050f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8050f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8050f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8050fb:	89 04 24             	mov    %eax,(%esp)
  8050fe:	e8 72 02 00 00       	call   805375 <_Z12nsipc_socketiii>
  805103:	85 c0                	test   %eax,%eax
  805105:	78 05                	js     80510c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  805107:	e8 5b fe ff ff       	call   804f67 <_ZL12alloc_sockfdi>
}
  80510c:	c9                   	leave  
  80510d:	8d 76 00             	lea    0x0(%esi),%esi
  805110:	c3                   	ret    
  805111:	00 00                	add    %al,(%eax)
	...

00805114 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805114:	55                   	push   %ebp
  805115:	89 e5                	mov    %esp,%ebp
  805117:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80511a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  805121:	00 
  805122:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  805129:	00 
  80512a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80512e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  805135:	e8 45 04 00 00       	call   80557f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80513a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  805141:	00 
  805142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  805149:	00 
  80514a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  805151:	e8 9a 03 00 00       	call   8054f0 <_Z8ipc_recvPiPvS_>
}
  805156:	c9                   	leave  
  805157:	c3                   	ret    

00805158 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805158:	55                   	push   %ebp
  805159:	89 e5                	mov    %esp,%ebp
  80515b:	53                   	push   %ebx
  80515c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80515f:	8b 45 08             	mov    0x8(%ebp),%eax
  805162:	a3 00 90 80 00       	mov    %eax,0x809000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805167:	b8 01 00 00 00       	mov    $0x1,%eax
  80516c:	e8 a3 ff ff ff       	call   805114 <_ZL5nsipcj>
  805171:	89 c3                	mov    %eax,%ebx
  805173:	85 c0                	test   %eax,%eax
  805175:	78 27                	js     80519e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  805177:	a1 10 90 80 00       	mov    0x809010,%eax
  80517c:	89 44 24 08          	mov    %eax,0x8(%esp)
  805180:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  805187:	00 
  805188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80518b:	89 04 24             	mov    %eax,(%esp)
  80518e:	e8 99 c3 ff ff       	call   80152c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  805193:	8b 15 10 90 80 00    	mov    0x809010,%edx
  805199:	8b 45 10             	mov    0x10(%ebp),%eax
  80519c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80519e:	89 d8                	mov    %ebx,%eax
  8051a0:	83 c4 14             	add    $0x14,%esp
  8051a3:	5b                   	pop    %ebx
  8051a4:	5d                   	pop    %ebp
  8051a5:	c3                   	ret    

008051a6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8051a6:	55                   	push   %ebp
  8051a7:	89 e5                	mov    %esp,%ebp
  8051a9:	53                   	push   %ebx
  8051aa:	83 ec 14             	sub    $0x14,%esp
  8051ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8051b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8051b3:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8051b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8051bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8051bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8051c3:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  8051ca:	e8 5d c3 ff ff       	call   80152c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8051cf:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8051d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8051da:	e8 35 ff ff ff       	call   805114 <_ZL5nsipcj>
}
  8051df:	83 c4 14             	add    $0x14,%esp
  8051e2:	5b                   	pop    %ebx
  8051e3:	5d                   	pop    %ebp
  8051e4:	c3                   	ret    

008051e5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  8051e5:	55                   	push   %ebp
  8051e6:	89 e5                	mov    %esp,%ebp
  8051e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8051eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8051ee:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8051f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8051f6:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8051fb:	b8 03 00 00 00       	mov    $0x3,%eax
  805200:	e8 0f ff ff ff       	call   805114 <_ZL5nsipcj>
}
  805205:	c9                   	leave  
  805206:	c3                   	ret    

00805207 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  805207:	55                   	push   %ebp
  805208:	89 e5                	mov    %esp,%ebp
  80520a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80520d:	8b 45 08             	mov    0x8(%ebp),%eax
  805210:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  805215:	b8 04 00 00 00       	mov    $0x4,%eax
  80521a:	e8 f5 fe ff ff       	call   805114 <_ZL5nsipcj>
}
  80521f:	c9                   	leave  
  805220:	c3                   	ret    

00805221 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805221:	55                   	push   %ebp
  805222:	89 e5                	mov    %esp,%ebp
  805224:	53                   	push   %ebx
  805225:	83 ec 14             	sub    $0x14,%esp
  805228:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80522b:	8b 45 08             	mov    0x8(%ebp),%eax
  80522e:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805233:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  805237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80523a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80523e:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  805245:	e8 e2 c2 ff ff       	call   80152c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80524a:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  805250:	b8 05 00 00 00       	mov    $0x5,%eax
  805255:	e8 ba fe ff ff       	call   805114 <_ZL5nsipcj>
}
  80525a:	83 c4 14             	add    $0x14,%esp
  80525d:	5b                   	pop    %ebx
  80525e:	5d                   	pop    %ebp
  80525f:	c3                   	ret    

00805260 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  805260:	55                   	push   %ebp
  805261:	89 e5                	mov    %esp,%ebp
  805263:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  805266:	8b 45 08             	mov    0x8(%ebp),%eax
  805269:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  80526e:	8b 45 0c             	mov    0xc(%ebp),%eax
  805271:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  805276:	b8 06 00 00 00       	mov    $0x6,%eax
  80527b:	e8 94 fe ff ff       	call   805114 <_ZL5nsipcj>
}
  805280:	c9                   	leave  
  805281:	c3                   	ret    

00805282 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805282:	55                   	push   %ebp
  805283:	89 e5                	mov    %esp,%ebp
  805285:	56                   	push   %esi
  805286:	53                   	push   %ebx
  805287:	83 ec 10             	sub    $0x10,%esp
  80528a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80528d:	8b 45 08             	mov    0x8(%ebp),%eax
  805290:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  805295:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  80529b:	8b 45 14             	mov    0x14(%ebp),%eax
  80529e:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8052a3:	b8 07 00 00 00       	mov    $0x7,%eax
  8052a8:	e8 67 fe ff ff       	call   805114 <_ZL5nsipcj>
  8052ad:	89 c3                	mov    %eax,%ebx
  8052af:	85 c0                	test   %eax,%eax
  8052b1:	78 46                	js     8052f9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8052b3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8052b8:	7f 04                	jg     8052be <_Z10nsipc_recviPvij+0x3c>
  8052ba:	39 f0                	cmp    %esi,%eax
  8052bc:	7e 24                	jle    8052e2 <_Z10nsipc_recviPvij+0x60>
  8052be:	c7 44 24 0c cd 65 80 	movl   $0x8065cd,0xc(%esp)
  8052c5:	00 
  8052c6:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  8052cd:	00 
  8052ce:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8052d5:	00 
  8052d6:	c7 04 24 e2 65 80 00 	movl   $0x8065e2,(%esp)
  8052dd:	e8 8e b8 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8052e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8052e6:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8052ed:	00 
  8052ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8052f1:	89 04 24             	mov    %eax,(%esp)
  8052f4:	e8 33 c2 ff ff       	call   80152c <memmove>
	}

	return r;
}
  8052f9:	89 d8                	mov    %ebx,%eax
  8052fb:	83 c4 10             	add    $0x10,%esp
  8052fe:	5b                   	pop    %ebx
  8052ff:	5e                   	pop    %esi
  805300:	5d                   	pop    %ebp
  805301:	c3                   	ret    

00805302 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805302:	55                   	push   %ebp
  805303:	89 e5                	mov    %esp,%ebp
  805305:	53                   	push   %ebx
  805306:	83 ec 14             	sub    $0x14,%esp
  805309:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80530c:	8b 45 08             	mov    0x8(%ebp),%eax
  80530f:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  805314:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80531a:	7e 24                	jle    805340 <_Z10nsipc_sendiPKvij+0x3e>
  80531c:	c7 44 24 0c ee 65 80 	movl   $0x8065ee,0xc(%esp)
  805323:	00 
  805324:	c7 44 24 08 b0 59 80 	movl   $0x8059b0,0x8(%esp)
  80532b:	00 
  80532c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  805333:	00 
  805334:	c7 04 24 e2 65 80 00 	movl   $0x8065e2,(%esp)
  80533b:	e8 30 b8 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805340:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  805344:	8b 45 0c             	mov    0xc(%ebp),%eax
  805347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80534b:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  805352:	e8 d5 c1 ff ff       	call   80152c <memmove>
	nsipcbuf.send.req_size = size;
  805357:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  80535d:	8b 45 14             	mov    0x14(%ebp),%eax
  805360:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  805365:	b8 08 00 00 00       	mov    $0x8,%eax
  80536a:	e8 a5 fd ff ff       	call   805114 <_ZL5nsipcj>
}
  80536f:	83 c4 14             	add    $0x14,%esp
  805372:	5b                   	pop    %ebx
  805373:	5d                   	pop    %ebp
  805374:	c3                   	ret    

00805375 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805375:	55                   	push   %ebp
  805376:	89 e5                	mov    %esp,%ebp
  805378:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80537b:	8b 45 08             	mov    0x8(%ebp),%eax
  80537e:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  805383:	8b 45 0c             	mov    0xc(%ebp),%eax
  805386:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80538b:	8b 45 10             	mov    0x10(%ebp),%eax
  80538e:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  805393:	b8 09 00 00 00       	mov    $0x9,%eax
  805398:	e8 77 fd ff ff       	call   805114 <_ZL5nsipcj>
}
  80539d:	c9                   	leave  
  80539e:	c3                   	ret    
	...

008053a0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8053a0:	55                   	push   %ebp
  8053a1:	89 e5                	mov    %esp,%ebp
  8053a3:	56                   	push   %esi
  8053a4:	53                   	push   %ebx
  8053a5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8053a8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8053ad:	8b 04 9d 00 a0 80 00 	mov    0x80a000(,%ebx,4),%eax
  8053b4:	85 c0                	test   %eax,%eax
  8053b6:	74 08                	je     8053c0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8053b8:	8d 55 08             	lea    0x8(%ebp),%edx
  8053bb:	89 14 24             	mov    %edx,(%esp)
  8053be:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8053c0:	83 eb 01             	sub    $0x1,%ebx
  8053c3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8053c6:	75 e5                	jne    8053ad <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8053c8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8053cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8053ce:	e8 35 c4 ff ff       	call   801808 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8053d3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8053d7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8053db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8053df:	c7 44 24 08 fc 65 80 	movl   $0x8065fc,0x8(%esp)
  8053e6:	00 
  8053e7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8053ee:	00 
  8053ef:	c7 04 24 80 66 80 00 	movl   $0x806680,(%esp)
  8053f6:	e8 75 b7 ff ff       	call   800b70 <_Z6_panicPKciS0_z>

008053fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8053fb:	55                   	push   %ebp
  8053fc:	89 e5                	mov    %esp,%ebp
  8053fe:	56                   	push   %esi
  8053ff:	53                   	push   %ebx
  805400:	83 ec 10             	sub    $0x10,%esp
  805403:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  805406:	e8 fd c3 ff ff       	call   801808 <_Z12sys_getenvidv>
  80540b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80540d:	a1 14 80 80 00       	mov    0x808014,%eax
  805412:	8b 40 5c             	mov    0x5c(%eax),%eax
  805415:	85 c0                	test   %eax,%eax
  805417:	75 4c                	jne    805465 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  805419:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  805420:	00 
  805421:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  805428:	ee 
  805429:	89 34 24             	mov    %esi,(%esp)
  80542c:	e8 3f c4 ff ff       	call   801870 <_Z14sys_page_allociPvi>
  805431:	85 c0                	test   %eax,%eax
  805433:	74 20                	je     805455 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  805435:	89 74 24 0c          	mov    %esi,0xc(%esp)
  805439:	c7 44 24 08 34 66 80 	movl   $0x806634,0x8(%esp)
  805440:	00 
  805441:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  805448:	00 
  805449:	c7 04 24 80 66 80 00 	movl   $0x806680,(%esp)
  805450:	e8 1b b7 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  805455:	c7 44 24 04 a0 53 80 	movl   $0x8053a0,0x4(%esp)
  80545c:	00 
  80545d:	89 34 24             	mov    %esi,(%esp)
  805460:	e8 40 c6 ff ff       	call   801aa5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  805465:	a1 00 a0 80 00       	mov    0x80a000,%eax
  80546a:	39 d8                	cmp    %ebx,%eax
  80546c:	74 1a                	je     805488 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80546e:	85 c0                	test   %eax,%eax
  805470:	74 20                	je     805492 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  805472:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  805477:	8b 14 85 00 a0 80 00 	mov    0x80a000(,%eax,4),%edx
  80547e:	39 da                	cmp    %ebx,%edx
  805480:	74 15                	je     805497 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  805482:	85 d2                	test   %edx,%edx
  805484:	75 1f                	jne    8054a5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  805486:	eb 0f                	jmp    805497 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  805488:	b8 00 00 00 00       	mov    $0x0,%eax
  80548d:	8d 76 00             	lea    0x0(%esi),%esi
  805490:	eb 05                	jmp    805497 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  805492:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  805497:	89 1c 85 00 a0 80 00 	mov    %ebx,0x80a000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80549e:	83 c4 10             	add    $0x10,%esp
  8054a1:	5b                   	pop    %ebx
  8054a2:	5e                   	pop    %esi
  8054a3:	5d                   	pop    %ebp
  8054a4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8054a5:	83 c0 01             	add    $0x1,%eax
  8054a8:	83 f8 08             	cmp    $0x8,%eax
  8054ab:	75 ca                	jne    805477 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8054ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8054b1:	c7 44 24 08 58 66 80 	movl   $0x806658,0x8(%esp)
  8054b8:	00 
  8054b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8054c0:	00 
  8054c1:	c7 04 24 80 66 80 00 	movl   $0x806680,(%esp)
  8054c8:	e8 a3 b6 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
  8054cd:	00 00                	add    %al,(%eax)
	...

008054d0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8054d0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8054d3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8054d4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8054d7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8054db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8054df:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8054e2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8054e4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8054e8:	61                   	popa   
    popf
  8054e9:	9d                   	popf   
    popl %esp
  8054ea:	5c                   	pop    %esp
    ret
  8054eb:	c3                   	ret    

008054ec <spin>:

spin:	jmp spin
  8054ec:	eb fe                	jmp    8054ec <spin>
	...

008054f0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8054f0:	55                   	push   %ebp
  8054f1:	89 e5                	mov    %esp,%ebp
  8054f3:	56                   	push   %esi
  8054f4:	53                   	push   %ebx
  8054f5:	83 ec 10             	sub    $0x10,%esp
  8054f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8054fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8054fe:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  805501:	85 c0                	test   %eax,%eax
  805503:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  805508:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80550b:	89 04 24             	mov    %eax,(%esp)
  80550e:	e8 28 c6 ff ff       	call   801b3b <_Z12sys_ipc_recvPv>
  805513:	85 c0                	test   %eax,%eax
  805515:	79 16                	jns    80552d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  805517:	85 db                	test   %ebx,%ebx
  805519:	74 06                	je     805521 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80551b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  805521:	85 f6                	test   %esi,%esi
  805523:	74 53                	je     805578 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  805525:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80552b:	eb 4b                	jmp    805578 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80552d:	85 db                	test   %ebx,%ebx
  80552f:	74 17                	je     805548 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  805531:	e8 d2 c2 ff ff       	call   801808 <_Z12sys_getenvidv>
  805536:	25 ff 03 00 00       	and    $0x3ff,%eax
  80553b:	6b c0 78             	imul   $0x78,%eax,%eax
  80553e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  805543:	8b 40 60             	mov    0x60(%eax),%eax
  805546:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  805548:	85 f6                	test   %esi,%esi
  80554a:	74 17                	je     805563 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80554c:	e8 b7 c2 ff ff       	call   801808 <_Z12sys_getenvidv>
  805551:	25 ff 03 00 00       	and    $0x3ff,%eax
  805556:	6b c0 78             	imul   $0x78,%eax,%eax
  805559:	05 00 00 00 ef       	add    $0xef000000,%eax
  80555e:	8b 40 70             	mov    0x70(%eax),%eax
  805561:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  805563:	e8 a0 c2 ff ff       	call   801808 <_Z12sys_getenvidv>
  805568:	25 ff 03 00 00       	and    $0x3ff,%eax
  80556d:	6b c0 78             	imul   $0x78,%eax,%eax
  805570:	05 08 00 00 ef       	add    $0xef000008,%eax
  805575:	8b 40 60             	mov    0x60(%eax),%eax

}
  805578:	83 c4 10             	add    $0x10,%esp
  80557b:	5b                   	pop    %ebx
  80557c:	5e                   	pop    %esi
  80557d:	5d                   	pop    %ebp
  80557e:	c3                   	ret    

0080557f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80557f:	55                   	push   %ebp
  805580:	89 e5                	mov    %esp,%ebp
  805582:	57                   	push   %edi
  805583:	56                   	push   %esi
  805584:	53                   	push   %ebx
  805585:	83 ec 1c             	sub    $0x1c,%esp
  805588:	8b 75 08             	mov    0x8(%ebp),%esi
  80558b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80558e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  805591:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  805593:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  805598:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80559b:	8b 45 14             	mov    0x14(%ebp),%eax
  80559e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8055a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8055a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8055aa:	89 34 24             	mov    %esi,(%esp)
  8055ad:	e8 51 c5 ff ff       	call   801b03 <_Z16sys_ipc_try_sendijPvi>
  8055b2:	85 c0                	test   %eax,%eax
  8055b4:	79 31                	jns    8055e7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8055b6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8055b9:	75 0c                	jne    8055c7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8055bb:	90                   	nop
  8055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8055c0:	e8 77 c2 ff ff       	call   80183c <_Z9sys_yieldv>
  8055c5:	eb d4                	jmp    80559b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8055c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8055cb:	c7 44 24 08 8e 66 80 	movl   $0x80668e,0x8(%esp)
  8055d2:	00 
  8055d3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8055da:	00 
  8055db:	c7 04 24 9b 66 80 00 	movl   $0x80669b,(%esp)
  8055e2:	e8 89 b5 ff ff       	call   800b70 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  8055e7:	83 c4 1c             	add    $0x1c,%esp
  8055ea:	5b                   	pop    %ebx
  8055eb:	5e                   	pop    %esi
  8055ec:	5f                   	pop    %edi
  8055ed:	5d                   	pop    %ebp
  8055ee:	c3                   	ret    
	...

008055f0 <__udivdi3>:
  8055f0:	55                   	push   %ebp
  8055f1:	89 e5                	mov    %esp,%ebp
  8055f3:	57                   	push   %edi
  8055f4:	56                   	push   %esi
  8055f5:	83 ec 20             	sub    $0x20,%esp
  8055f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8055fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8055fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  805601:	8b 7d 0c             	mov    0xc(%ebp),%edi
  805604:	85 c0                	test   %eax,%eax
  805606:	89 75 e8             	mov    %esi,-0x18(%ebp)
  805609:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80560c:	75 3a                	jne    805648 <__udivdi3+0x58>
  80560e:	39 f9                	cmp    %edi,%ecx
  805610:	77 66                	ja     805678 <__udivdi3+0x88>
  805612:	85 c9                	test   %ecx,%ecx
  805614:	75 0b                	jne    805621 <__udivdi3+0x31>
  805616:	b8 01 00 00 00       	mov    $0x1,%eax
  80561b:	31 d2                	xor    %edx,%edx
  80561d:	f7 f1                	div    %ecx
  80561f:	89 c1                	mov    %eax,%ecx
  805621:	89 f8                	mov    %edi,%eax
  805623:	31 d2                	xor    %edx,%edx
  805625:	f7 f1                	div    %ecx
  805627:	89 c7                	mov    %eax,%edi
  805629:	89 f0                	mov    %esi,%eax
  80562b:	f7 f1                	div    %ecx
  80562d:	89 fa                	mov    %edi,%edx
  80562f:	89 c6                	mov    %eax,%esi
  805631:	89 75 f0             	mov    %esi,-0x10(%ebp)
  805634:	89 55 f4             	mov    %edx,-0xc(%ebp)
  805637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80563a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80563d:	83 c4 20             	add    $0x20,%esp
  805640:	5e                   	pop    %esi
  805641:	5f                   	pop    %edi
  805642:	5d                   	pop    %ebp
  805643:	c3                   	ret    
  805644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  805648:	31 d2                	xor    %edx,%edx
  80564a:	31 f6                	xor    %esi,%esi
  80564c:	39 f8                	cmp    %edi,%eax
  80564e:	77 e1                	ja     805631 <__udivdi3+0x41>
  805650:	0f bd d0             	bsr    %eax,%edx
  805653:	83 f2 1f             	xor    $0x1f,%edx
  805656:	89 55 ec             	mov    %edx,-0x14(%ebp)
  805659:	75 2d                	jne    805688 <__udivdi3+0x98>
  80565b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80565e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  805661:	76 06                	jbe    805669 <__udivdi3+0x79>
  805663:	39 f8                	cmp    %edi,%eax
  805665:	89 f2                	mov    %esi,%edx
  805667:	73 c8                	jae    805631 <__udivdi3+0x41>
  805669:	31 d2                	xor    %edx,%edx
  80566b:	be 01 00 00 00       	mov    $0x1,%esi
  805670:	eb bf                	jmp    805631 <__udivdi3+0x41>
  805672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  805678:	89 f0                	mov    %esi,%eax
  80567a:	89 fa                	mov    %edi,%edx
  80567c:	f7 f1                	div    %ecx
  80567e:	31 d2                	xor    %edx,%edx
  805680:	89 c6                	mov    %eax,%esi
  805682:	eb ad                	jmp    805631 <__udivdi3+0x41>
  805684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  805688:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80568c:	89 c2                	mov    %eax,%edx
  80568e:	b8 20 00 00 00       	mov    $0x20,%eax
  805693:	8b 75 f0             	mov    -0x10(%ebp),%esi
  805696:	2b 45 ec             	sub    -0x14(%ebp),%eax
  805699:	d3 e2                	shl    %cl,%edx
  80569b:	89 c1                	mov    %eax,%ecx
  80569d:	d3 ee                	shr    %cl,%esi
  80569f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8056a3:	09 d6                	or     %edx,%esi
  8056a5:	89 fa                	mov    %edi,%edx
  8056a7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8056aa:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8056ad:	d3 e6                	shl    %cl,%esi
  8056af:	89 c1                	mov    %eax,%ecx
  8056b1:	d3 ea                	shr    %cl,%edx
  8056b3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8056b7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8056ba:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8056bd:	d3 e7                	shl    %cl,%edi
  8056bf:	89 c1                	mov    %eax,%ecx
  8056c1:	d3 ee                	shr    %cl,%esi
  8056c3:	09 fe                	or     %edi,%esi
  8056c5:	89 f0                	mov    %esi,%eax
  8056c7:	f7 75 e4             	divl   -0x1c(%ebp)
  8056ca:	89 d7                	mov    %edx,%edi
  8056cc:	89 c6                	mov    %eax,%esi
  8056ce:	f7 65 f0             	mull   -0x10(%ebp)
  8056d1:	39 d7                	cmp    %edx,%edi
  8056d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8056d6:	72 12                	jb     8056ea <__udivdi3+0xfa>
  8056d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8056db:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8056df:	d3 e2                	shl    %cl,%edx
  8056e1:	39 c2                	cmp    %eax,%edx
  8056e3:	73 08                	jae    8056ed <__udivdi3+0xfd>
  8056e5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8056e8:	75 03                	jne    8056ed <__udivdi3+0xfd>
  8056ea:	83 ee 01             	sub    $0x1,%esi
  8056ed:	31 d2                	xor    %edx,%edx
  8056ef:	e9 3d ff ff ff       	jmp    805631 <__udivdi3+0x41>
	...

00805700 <__umoddi3>:
  805700:	55                   	push   %ebp
  805701:	89 e5                	mov    %esp,%ebp
  805703:	57                   	push   %edi
  805704:	56                   	push   %esi
  805705:	83 ec 20             	sub    $0x20,%esp
  805708:	8b 7d 14             	mov    0x14(%ebp),%edi
  80570b:	8b 45 08             	mov    0x8(%ebp),%eax
  80570e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  805711:	8b 75 0c             	mov    0xc(%ebp),%esi
  805714:	85 ff                	test   %edi,%edi
  805716:	89 45 e8             	mov    %eax,-0x18(%ebp)
  805719:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80571c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80571f:	89 f2                	mov    %esi,%edx
  805721:	75 15                	jne    805738 <__umoddi3+0x38>
  805723:	39 f1                	cmp    %esi,%ecx
  805725:	76 41                	jbe    805768 <__umoddi3+0x68>
  805727:	f7 f1                	div    %ecx
  805729:	89 d0                	mov    %edx,%eax
  80572b:	31 d2                	xor    %edx,%edx
  80572d:	83 c4 20             	add    $0x20,%esp
  805730:	5e                   	pop    %esi
  805731:	5f                   	pop    %edi
  805732:	5d                   	pop    %ebp
  805733:	c3                   	ret    
  805734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  805738:	39 f7                	cmp    %esi,%edi
  80573a:	77 4c                	ja     805788 <__umoddi3+0x88>
  80573c:	0f bd c7             	bsr    %edi,%eax
  80573f:	83 f0 1f             	xor    $0x1f,%eax
  805742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  805745:	75 51                	jne    805798 <__umoddi3+0x98>
  805747:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80574a:	0f 87 e8 00 00 00    	ja     805838 <__umoddi3+0x138>
  805750:	89 f2                	mov    %esi,%edx
  805752:	8b 75 f0             	mov    -0x10(%ebp),%esi
  805755:	29 ce                	sub    %ecx,%esi
  805757:	19 fa                	sbb    %edi,%edx
  805759:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80575c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80575f:	83 c4 20             	add    $0x20,%esp
  805762:	5e                   	pop    %esi
  805763:	5f                   	pop    %edi
  805764:	5d                   	pop    %ebp
  805765:	c3                   	ret    
  805766:	66 90                	xchg   %ax,%ax
  805768:	85 c9                	test   %ecx,%ecx
  80576a:	75 0b                	jne    805777 <__umoddi3+0x77>
  80576c:	b8 01 00 00 00       	mov    $0x1,%eax
  805771:	31 d2                	xor    %edx,%edx
  805773:	f7 f1                	div    %ecx
  805775:	89 c1                	mov    %eax,%ecx
  805777:	89 f0                	mov    %esi,%eax
  805779:	31 d2                	xor    %edx,%edx
  80577b:	f7 f1                	div    %ecx
  80577d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805780:	eb a5                	jmp    805727 <__umoddi3+0x27>
  805782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  805788:	89 f2                	mov    %esi,%edx
  80578a:	83 c4 20             	add    $0x20,%esp
  80578d:	5e                   	pop    %esi
  80578e:	5f                   	pop    %edi
  80578f:	5d                   	pop    %ebp
  805790:	c3                   	ret    
  805791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  805798:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80579c:	89 f2                	mov    %esi,%edx
  80579e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8057a1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8057a8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8057ab:	d3 e7                	shl    %cl,%edi
  8057ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8057b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8057b4:	d3 e8                	shr    %cl,%eax
  8057b6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8057ba:	09 f8                	or     %edi,%eax
  8057bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8057bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8057c2:	d3 e0                	shl    %cl,%eax
  8057c4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8057c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8057cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8057ce:	d3 ea                	shr    %cl,%edx
  8057d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8057d4:	d3 e6                	shl    %cl,%esi
  8057d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8057da:	d3 e8                	shr    %cl,%eax
  8057dc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8057e0:	09 f0                	or     %esi,%eax
  8057e2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8057e5:	f7 75 e4             	divl   -0x1c(%ebp)
  8057e8:	d3 e6                	shl    %cl,%esi
  8057ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8057ed:	89 d6                	mov    %edx,%esi
  8057ef:	f7 65 f4             	mull   -0xc(%ebp)
  8057f2:	89 d7                	mov    %edx,%edi
  8057f4:	89 c2                	mov    %eax,%edx
  8057f6:	39 fe                	cmp    %edi,%esi
  8057f8:	89 f9                	mov    %edi,%ecx
  8057fa:	72 30                	jb     80582c <__umoddi3+0x12c>
  8057fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8057ff:	72 27                	jb     805828 <__umoddi3+0x128>
  805801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805804:	29 d0                	sub    %edx,%eax
  805806:	19 ce                	sbb    %ecx,%esi
  805808:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80580c:	89 f2                	mov    %esi,%edx
  80580e:	d3 e8                	shr    %cl,%eax
  805810:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  805814:	d3 e2                	shl    %cl,%edx
  805816:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80581a:	09 d0                	or     %edx,%eax
  80581c:	89 f2                	mov    %esi,%edx
  80581e:	d3 ea                	shr    %cl,%edx
  805820:	83 c4 20             	add    $0x20,%esp
  805823:	5e                   	pop    %esi
  805824:	5f                   	pop    %edi
  805825:	5d                   	pop    %ebp
  805826:	c3                   	ret    
  805827:	90                   	nop
  805828:	39 fe                	cmp    %edi,%esi
  80582a:	75 d5                	jne    805801 <__umoddi3+0x101>
  80582c:	89 f9                	mov    %edi,%ecx
  80582e:	89 c2                	mov    %eax,%edx
  805830:	2b 55 f4             	sub    -0xc(%ebp),%edx
  805833:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  805836:	eb c9                	jmp    805801 <__umoddi3+0x101>
  805838:	39 f7                	cmp    %esi,%edi
  80583a:	0f 82 10 ff ff ff    	jb     805750 <__umoddi3+0x50>
  805840:	e9 17 ff ff ff       	jmp    80575c <__umoddi3+0x5c>
