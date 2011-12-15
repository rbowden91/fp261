
obj/user/ls:     file format elf32-i386


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
  80002c:	e8 8b 03 00 00       	call   8003bc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_Z3ls1PKcbiS0_>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	const char *sep;

	if (flag[(int) 'l'])
  80004f:	83 3d b0 71 80 00 00 	cmpl   $0x0,0x8071b0
  800056:	74 2b                	je     800083 <_Z3ls1PKcbiS0_+0x43>
		fprintf(1, "%11d %c ", size, isdir ? 'd' : '-');
  800058:	89 f0                	mov    %esi,%eax
  80005a:	3c 01                	cmp    $0x1,%al
  80005c:	19 c0                	sbb    %eax,%eax
  80005e:	83 e0 c9             	and    $0xffffffc9,%eax
  800061:	83 c0 64             	add    $0x64,%eax
  800064:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800068:	8b 45 10             	mov    0x10(%ebp),%eax
  80006b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006f:	c7 44 24 04 42 44 80 	movl   $0x804442,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80007e:	e8 fd 37 00 00       	call   803880 <_Z7fprintfiPKcz>
	if (prefix) {
  800083:	85 db                	test   %ebx,%ebx
  800085:	74 39                	je     8000c0 <_Z3ls1PKcbiS0_+0x80>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800087:	80 3b 00             	cmpb   $0x0,(%ebx)
  80008a:	0f 84 89 00 00 00    	je     800119 <_Z3ls1PKcbiS0_+0xd9>
  800090:	89 1c 24             	mov    %ebx,(%esp)
  800093:	e8 a8 0a 00 00       	call   800b40 <_Z6strlenPKc>
  800098:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  80009d:	74 7a                	je     800119 <_Z3ls1PKcbiS0_+0xd9>
			sep = "/";
  80009f:	b8 40 44 80 00       	mov    $0x804440,%eax
		else
			sep = "";
		fprintf(1, "%s%s", prefix, sep);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000ac:	c7 44 24 04 4b 44 80 	movl   $0x80444b,0x4(%esp)
  8000b3:	00 
  8000b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000bb:	e8 c0 37 00 00       	call   803880 <_Z7fprintfiPKcz>
	}
	fprintf(1, "%s", name);
  8000c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8000c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c7:	c7 44 24 04 9e 48 80 	movl   $0x80489e,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d6:	e8 a5 37 00 00       	call   803880 <_Z7fprintfiPKcz>
	if (flag[(int) 'F'] && isdir)
  8000db:	83 3d 18 71 80 00 00 	cmpl   $0x0,0x807118
  8000e2:	74 1a                	je     8000fe <_Z3ls1PKcbiS0_+0xbe>
  8000e4:	89 f0                	mov    %esi,%eax
  8000e6:	84 c0                	test   %al,%al
  8000e8:	74 14                	je     8000fe <_Z3ls1PKcbiS0_+0xbe>
		fprintf(1, "/");
  8000ea:	c7 44 24 04 40 44 80 	movl   $0x804440,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f9:	e8 82 37 00 00       	call   803880 <_Z7fprintfiPKcz>
	fprintf(1, "\n");
  8000fe:	c7 44 24 04 a7 44 80 	movl   $0x8044a7,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010d:	e8 6e 37 00 00       	call   803880 <_Z7fprintfiPKcz>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	5b                   	pop    %ebx
  800116:	5e                   	pop    %esi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    
		fprintf(1, "%11d %c ", size, isdir ? 'd' : '-');
	if (prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  800119:	b8 a8 44 80 00       	mov    $0x8044a8,%eax
  80011e:	eb 84                	jmp    8000a4 <_Z3ls1PKcbiS0_+0x64>

00800120 <_Z5lsdirPKcS0_>:
		ls1(0, st.st_ftype == FTYPE_DIR, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
  800126:	81 ec ac 01 00 00    	sub    $0x1ac,%esp
	int fd, n;
	char name[MAXNAMELEN];
	struct Direntry de;
	struct Stat st;

	if ((fd = open(path, O_RDONLY)) < 0)
  80012c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800133:	00 
  800134:	8b 45 08             	mov    0x8(%ebp),%eax
  800137:	89 04 24             	mov    %eax,(%esp)
  80013a:	e8 7f 25 00 00       	call   8026be <_Z4openPKci>
  80013f:	89 c3                	mov    %eax,%ebx
  800141:	85 c0                	test   %eax,%eax
  800143:	0f 89 a2 00 00 00    	jns    8001eb <_Z5lsdirPKcS0_+0xcb>
		panic("open %s: %e", path, fd);
  800149:	89 44 24 10          	mov    %eax,0x10(%esp)
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800154:	c7 44 24 08 50 44 80 	movl   $0x804450,0x8(%esp)
  80015b:	00 
  80015c:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  800163:	00 
  800164:	c7 04 24 5c 44 80 00 	movl   $0x80445c,(%esp)
  80016b:	e8 d0 02 00 00       	call   800440 <_Z6_panicPKciS0_z>
	while ((n = readn(fd, &de, sizeof de)) == sizeof de)
		if (de.de_inum) {
  800170:	83 bd f0 fe ff ff 00 	cmpl   $0x0,-0x110(%ebp)
  800177:	74 78                	je     8001f1 <_Z5lsdirPKcS0_+0xd1>
			memcpy(name, de.de_name, MAXNAMELEN);
  800179:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  800180:	00 
  800181:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018b:	8d bd 70 ff ff ff    	lea    -0x90(%ebp),%edi
  800191:	89 3c 24             	mov    %edi,(%esp)
  800194:	e8 fe 0b 00 00       	call   800d97 <memcpy>
			name[de.de_namelen] = 0;
  800199:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019f:	c6 84 05 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%eax,1)
  8001a6:	00 
			istat(de.de_inum, &st);
  8001a7:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 4b 27 00 00       	call   80290a <_Z5istatiP4Stat>
			ls1(prefix, st.st_ftype==FTYPE_DIR, st.st_size, name);
  8001bf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c3:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8001c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cd:	83 bd e8 fe ff ff 02 	cmpl   $0x2,-0x118(%ebp)
  8001d4:	0f 94 c0             	sete   %al
  8001d7:	0f b6 c0             	movzbl %al,%eax
  8001da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 57 fe ff ff       	call   800040 <_Z3ls1PKcbiS0_>
  8001e9:	eb 06                	jmp    8001f1 <_Z5lsdirPKcS0_+0xd1>
	struct Direntry de;
	struct Stat st;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &de, sizeof de)) == sizeof de)
  8001eb:	8d b5 f0 fe ff ff    	lea    -0x110(%ebp),%esi
  8001f1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8001f8:	00 
  8001f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001fd:	89 1c 24             	mov    %ebx,(%esp)
  800200:	e8 c3 18 00 00       	call   801ac8 <_Z5readniPvj>
  800205:	3d 80 00 00 00       	cmp    $0x80,%eax
  80020a:	0f 84 60 ff ff ff    	je     800170 <_Z5lsdirPKcS0_+0x50>
			memcpy(name, de.de_name, MAXNAMELEN);
			name[de.de_namelen] = 0;
			istat(de.de_inum, &st);
			ls1(prefix, st.st_ftype==FTYPE_DIR, st.st_size, name);
		}
	if (n > 0)
  800210:	85 c0                	test   %eax,%eax
  800212:	7e 23                	jle    800237 <_Z5lsdirPKcS0_+0x117>
		panic("short read in directory %s", path);
  800214:	8b 45 08             	mov    0x8(%ebp),%eax
  800217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021b:	c7 44 24 08 66 44 80 	movl   $0x804466,0x8(%esp)
  800222:	00 
  800223:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  80022a:	00 
  80022b:	c7 04 24 5c 44 80 00 	movl   $0x80445c,(%esp)
  800232:	e8 09 02 00 00       	call   800440 <_Z6_panicPKciS0_z>
	if (n < 0)
  800237:	85 c0                	test   %eax,%eax
  800239:	79 27                	jns    800262 <_Z5lsdirPKcS0_+0x142>
		panic("error reading directory %s: %e", path, n);
  80023b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80023f:	8b 45 08             	mov    0x8(%ebp),%eax
  800242:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800246:	c7 44 24 08 ac 44 80 	movl   $0x8044ac,0x8(%esp)
  80024d:	00 
  80024e:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  800255:	00 
  800256:	c7 04 24 5c 44 80 00 	movl   $0x80445c,(%esp)
  80025d:	e8 de 01 00 00       	call   800440 <_Z6_panicPKciS0_z>
}
  800262:	81 c4 ac 01 00 00    	add    $0x1ac,%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    

0080026d <_Z2lsPKcS0_>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	53                   	push   %ebx
  800271:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  800277:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80027a:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800280:	89 44 24 04          	mov    %eax,0x4(%esp)
  800284:	89 1c 24             	mov    %ebx,(%esp)
  800287:	e8 3d 1a 00 00       	call   801cc9 <_Z4statPKcP4Stat>
  80028c:	85 c0                	test   %eax,%eax
  80028e:	79 24                	jns    8002b4 <_Z2lsPKcS0_+0x47>
		panic("stat %s: %e", path, r);
  800290:	89 44 24 10          	mov    %eax,0x10(%esp)
  800294:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800298:	c7 44 24 08 81 44 80 	movl   $0x804481,0x8(%esp)
  80029f:	00 
  8002a0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8002a7:	00 
  8002a8:	c7 04 24 5c 44 80 00 	movl   $0x80445c,(%esp)
  8002af:	e8 8c 01 00 00       	call   800440 <_Z6_panicPKciS0_z>
	if (st.st_ftype == FTYPE_DIR && !flag[(int) 'd'])
  8002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b7:	83 f8 02             	cmp    $0x2,%eax
  8002ba:	75 1a                	jne    8002d6 <_Z2lsPKcS0_+0x69>
  8002bc:	83 3d 90 71 80 00 00 	cmpl   $0x0,0x807190
  8002c3:	75 11                	jne    8002d6 <_Z2lsPKcS0_+0x69>
		lsdir(path, prefix);
  8002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	89 1c 24             	mov    %ebx,(%esp)
  8002cf:	e8 4c fe ff ff       	call   800120 <_Z5lsdirPKcS0_>
  8002d4:	eb 24                	jmp    8002fa <_Z2lsPKcS0_+0x8d>
	else
		ls1(0, st.st_ftype == FTYPE_DIR, st.st_size, path);
  8002d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8002dd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002e1:	83 f8 02             	cmp    $0x2,%eax
  8002e4:	0f 94 c0             	sete   %al
  8002e7:	0f b6 c0             	movzbl %al,%eax
  8002ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002f5:	e8 46 fd ff ff       	call   800040 <_Z3ls1PKcbiS0_>
}
  8002fa:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  800300:	5b                   	pop    %ebx
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <_Z5usagev>:
	fprintf(1, "\n");
}

void
usage(void)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 18             	sub    $0x18,%esp
	fprintf(1, "usage: ls [-dFl] [file...]\n");
  800309:	c7 44 24 04 8d 44 80 	movl   $0x80448d,0x4(%esp)
  800310:	00 
  800311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800318:	e8 63 35 00 00       	call   803880 <_Z7fprintfiPKcz>
	exit();
  80031d:	e8 02 01 00 00       	call   800424 <_Z4exitv>
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 20             	sub    $0x20,%esp
  80032c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80032f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800332:	89 44 24 08          	mov    %eax,0x8(%esp)
  800336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80033a:	8d 45 08             	lea    0x8(%ebp),%eax
  80033d:	89 04 24             	mov    %eax,(%esp)
  800340:	e8 4f 11 00 00       	call   801494 <_Z8argstartPiPPcP8Argstate>
	while ((i = argnext(&args)) >= 0)
  800345:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800348:	eb 1e                	jmp    800368 <_Z5umainiPPc+0x44>
		switch (i) {
  80034a:	83 f8 64             	cmp    $0x64,%eax
  80034d:	74 0a                	je     800359 <_Z5umainiPPc+0x35>
  80034f:	83 f8 6c             	cmp    $0x6c,%eax
  800352:	74 05                	je     800359 <_Z5umainiPPc+0x35>
  800354:	83 f8 46             	cmp    $0x46,%eax
  800357:	75 0a                	jne    800363 <_Z5umainiPPc+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800359:	83 04 85 00 70 80 00 	addl   $0x1,0x807000(,%eax,4)
  800360:	01 
			break;
  800361:	eb 05                	jmp    800368 <_Z5umainiPPc+0x44>
		default:
			usage();
  800363:	e8 9b ff ff ff       	call   800303 <_Z5usagev>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800368:	89 1c 24             	mov    %ebx,(%esp)
  80036b:	e8 54 11 00 00       	call   8014c4 <_Z7argnextP8Argstate>
  800370:	85 c0                	test   %eax,%eax
  800372:	79 d6                	jns    80034a <_Z5umainiPPc+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	83 f8 01             	cmp    $0x1,%eax
  80037a:	74 0c                	je     800388 <_Z5umainiPPc+0x64>
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80037c:	bb 01 00 00 00       	mov    $0x1,%ebx
  800381:	83 f8 01             	cmp    $0x1,%eax
  800384:	7f 18                	jg     80039e <_Z5umainiPPc+0x7a>
  800386:	eb 2d                	jmp    8003b5 <_Z5umainiPPc+0x91>
		default:
			usage();
		}

	if (argc == 1)
		ls("/", "");
  800388:	c7 44 24 04 a8 44 80 	movl   $0x8044a8,0x4(%esp)
  80038f:	00 
  800390:	c7 04 24 40 44 80 00 	movl   $0x804440,(%esp)
  800397:	e8 d1 fe ff ff       	call   80026d <_Z2lsPKcS0_>
  80039c:	eb 17                	jmp    8003b5 <_Z5umainiPPc+0x91>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80039e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8003a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	e8 c0 fe ff ff       	call   80026d <_Z2lsPKcS0_>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8003ad:	83 c3 01             	add    $0x1,%ebx
  8003b0:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8003b3:	7f e9                	jg     80039e <_Z5umainiPPc+0x7a>
			ls(argv[i], argv[i]);
	}
}
  8003b5:	83 c4 20             	add    $0x20,%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	57                   	push   %edi
  8003c0:	56                   	push   %esi
  8003c1:	53                   	push   %ebx
  8003c2:	83 ec 1c             	sub    $0x1c,%esp
  8003c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8003cb:	e8 28 0c 00 00       	call   800ff8 <_Z12sys_getenvidv>
  8003d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003d5:	6b c0 78             	imul   $0x78,%eax,%eax
  8003d8:	05 00 00 00 ef       	add    $0xef000000,%eax
  8003dd:	a3 00 74 80 00       	mov    %eax,0x807400
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e2:	85 ff                	test   %edi,%edi
  8003e4:	7e 07                	jle    8003ed <libmain+0x31>
		binaryname = argv[0];
  8003e6:	8b 06                	mov    (%esi),%eax
  8003e8:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8003ed:	b8 01 50 80 00       	mov    $0x805001,%eax
  8003f2:	3d 01 50 80 00       	cmp    $0x805001,%eax
  8003f7:	76 0f                	jbe    800408 <libmain+0x4c>
  8003f9:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  8003fb:	83 eb 04             	sub    $0x4,%ebx
  8003fe:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800400:	81 fb 01 50 80 00    	cmp    $0x805001,%ebx
  800406:	77 f3                	ja     8003fb <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800408:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040c:	89 3c 24             	mov    %edi,(%esp)
  80040f:	e8 10 ff ff ff       	call   800324 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800414:	e8 0b 00 00 00       	call   800424 <_Z4exitv>
}
  800419:	83 c4 1c             	add    $0x1c,%esp
  80041c:	5b                   	pop    %ebx
  80041d:	5e                   	pop    %esi
  80041e:	5f                   	pop    %edi
  80041f:	5d                   	pop    %ebp
  800420:	c3                   	ret    
  800421:	00 00                	add    %al,(%eax)
	...

00800424 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80042a:	e8 8f 14 00 00       	call   8018be <_Z9close_allv>
	sys_env_destroy(0);
  80042f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800436:	e8 60 0b 00 00       	call   800f9b <_Z15sys_env_destroyi>
}
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    
  80043d:	00 00                	add    %al,(%eax)
	...

00800440 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	56                   	push   %esi
  800444:	53                   	push   %ebx
  800445:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800448:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80044b:	a1 04 74 80 00       	mov    0x807404,%eax
  800450:	85 c0                	test   %eax,%eax
  800452:	74 10                	je     800464 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800454:	89 44 24 04          	mov    %eax,0x4(%esp)
  800458:	c7 04 24 d5 44 80 00 	movl   $0x8044d5,(%esp)
  80045f:	e8 fa 00 00 00       	call   80055e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800464:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  80046a:	e8 89 0b 00 00       	call   800ff8 <_Z12sys_getenvidv>
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	89 54 24 10          	mov    %edx,0x10(%esp)
  800476:	8b 55 08             	mov    0x8(%ebp),%edx
  800479:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800481:	89 44 24 04          	mov    %eax,0x4(%esp)
  800485:	c7 04 24 dc 44 80 00 	movl   $0x8044dc,(%esp)
  80048c:	e8 cd 00 00 00       	call   80055e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800491:	89 74 24 04          	mov    %esi,0x4(%esp)
  800495:	8b 45 10             	mov    0x10(%ebp),%eax
  800498:	89 04 24             	mov    %eax,(%esp)
  80049b:	e8 5d 00 00 00       	call   8004fd <_Z8vcprintfPKcPc>
	cprintf("\n");
  8004a0:	c7 04 24 a7 44 80 00 	movl   $0x8044a7,(%esp)
  8004a7:	e8 b2 00 00 00       	call   80055e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ac:	cc                   	int3   
  8004ad:	eb fd                	jmp    8004ac <_Z6_panicPKciS0_z+0x6c>
	...

008004b0 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 18             	sub    $0x18,%esp
  8004b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8004b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8004bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8004bf:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8004c1:	8b 03                	mov    (%ebx),%eax
  8004c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8004ca:	83 c0 01             	add    $0x1,%eax
  8004cd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8004cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d4:	75 19                	jne    8004ef <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8004d6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004dd:	00 
  8004de:	8d 43 08             	lea    0x8(%ebx),%eax
  8004e1:	89 04 24             	mov    %eax,(%esp)
  8004e4:	e8 4b 0a 00 00       	call   800f34 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8004e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004ef:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8004f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8004f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8004f9:	89 ec                	mov    %ebp,%esp
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800506:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050d:	00 00 00 
	b.cnt = 0;
  800510:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800517:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	89 44 24 08          	mov    %eax,0x8(%esp)
  800528:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800532:	c7 04 24 b0 04 80 00 	movl   $0x8004b0,(%esp)
  800539:	e8 a9 01 00 00       	call   8006e7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80053e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800544:	89 44 24 04          	mov    %eax,0x4(%esp)
  800548:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80054e:	89 04 24             	mov    %eax,(%esp)
  800551:	e8 de 09 00 00       	call   800f34 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800564:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 87 ff ff ff       	call   8004fd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800576:	c9                   	leave  
  800577:	c3                   	ret    
	...

00800580 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 4c             	sub    $0x4c,%esp
  800589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058c:	89 d6                	mov    %edx,%esi
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800594:	8b 55 0c             	mov    0xc(%ebp),%edx
  800597:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80059a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80059d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	39 d0                	cmp    %edx,%eax
  8005a7:	72 11                	jb     8005ba <_ZL8printnumPFviPvES_yjii+0x3a>
  8005a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ac:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8005af:	76 09                	jbe    8005ba <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b1:	83 eb 01             	sub    $0x1,%ebx
  8005b4:	85 db                	test   %ebx,%ebx
  8005b6:	7f 5d                	jg     800615 <_ZL8printnumPFviPvES_yjii+0x95>
  8005b8:	eb 6c                	jmp    800626 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005be:	83 eb 01             	sub    $0x1,%ebx
  8005c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8005d0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8005d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005e1:	00 
  8005e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e5:	89 14 24             	mov    %edx,(%esp)
  8005e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005ef:	e8 ec 3b 00 00       	call   8041e0 <__udivdi3>
  8005f4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800602:	89 04 24             	mov    %eax,(%esp)
  800605:	89 54 24 04          	mov    %edx,0x4(%esp)
  800609:	89 f2                	mov    %esi,%edx
  80060b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060e:	e8 6d ff ff ff       	call   800580 <_ZL8printnumPFviPvES_yjii>
  800613:	eb 11                	jmp    800626 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800615:	89 74 24 04          	mov    %esi,0x4(%esp)
  800619:	89 3c 24             	mov    %edi,(%esp)
  80061c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061f:	83 eb 01             	sub    $0x1,%ebx
  800622:	85 db                	test   %ebx,%ebx
  800624:	7f ef                	jg     800615 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80062e:	8b 45 10             	mov    0x10(%ebp),%eax
  800631:	89 44 24 08          	mov    %eax,0x8(%esp)
  800635:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80063c:	00 
  80063d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800640:	89 14 24             	mov    %edx,(%esp)
  800643:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800646:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80064a:	e8 a1 3c 00 00       	call   8042f0 <__umoddi3>
  80064f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800653:	0f be 80 ff 44 80 00 	movsbl 0x8044ff(%eax),%eax
  80065a:	89 04 24             	mov    %eax,(%esp)
  80065d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800660:	83 c4 4c             	add    $0x4c,%esp
  800663:	5b                   	pop    %ebx
  800664:	5e                   	pop    %esi
  800665:	5f                   	pop    %edi
  800666:	5d                   	pop    %ebp
  800667:	c3                   	ret    

00800668 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066b:	83 fa 01             	cmp    $0x1,%edx
  80066e:	7e 0e                	jle    80067e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800670:	8b 10                	mov    (%eax),%edx
  800672:	8d 4a 08             	lea    0x8(%edx),%ecx
  800675:	89 08                	mov    %ecx,(%eax)
  800677:	8b 02                	mov    (%edx),%eax
  800679:	8b 52 04             	mov    0x4(%edx),%edx
  80067c:	eb 22                	jmp    8006a0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80067e:	85 d2                	test   %edx,%edx
  800680:	74 10                	je     800692 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800682:	8b 10                	mov    (%eax),%edx
  800684:	8d 4a 04             	lea    0x4(%edx),%ecx
  800687:	89 08                	mov    %ecx,(%eax)
  800689:	8b 02                	mov    (%edx),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	eb 0e                	jmp    8006a0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800692:	8b 10                	mov    (%eax),%edx
  800694:	8d 4a 04             	lea    0x4(%edx),%ecx
  800697:	89 08                	mov    %ecx,(%eax)
  800699:	8b 02                	mov    (%edx),%eax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a0:	5d                   	pop    %ebp
  8006a1:	c3                   	ret    

008006a2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8006a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006ac:	8b 10                	mov    (%eax),%edx
  8006ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8006b1:	73 0a                	jae    8006bd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8006b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b6:	88 0a                	mov    %cl,(%edx)
  8006b8:	83 c2 01             	add    $0x1,%edx
  8006bb:	89 10                	mov    %edx,(%eax)
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006c5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 04 24             	mov    %eax,(%esp)
  8006e0:	e8 02 00 00 00       	call   8006e7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	57                   	push   %edi
  8006eb:	56                   	push   %esi
  8006ec:	53                   	push   %ebx
  8006ed:	83 ec 3c             	sub    $0x3c,%esp
  8006f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8006f6:	0f b6 02             	movzbl (%edx),%eax
  8006f9:	89 d3                	mov    %edx,%ebx
  8006fb:	83 c3 01             	add    $0x1,%ebx
  8006fe:	83 f8 25             	cmp    $0x25,%eax
  800701:	74 2b                	je     80072e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800703:	85 c0                	test   %eax,%eax
  800705:	75 10                	jne    800717 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800707:	e9 a5 03 00 00       	jmp    800ab1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80070c:	85 c0                	test   %eax,%eax
  80070e:	66 90                	xchg   %ax,%ax
  800710:	75 08                	jne    80071a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800712:	e9 9a 03 00 00       	jmp    800ab1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800717:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80071a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071e:	89 04 24             	mov    %eax,(%esp)
  800721:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800723:	0f b6 03             	movzbl (%ebx),%eax
  800726:	83 c3 01             	add    $0x1,%ebx
  800729:	83 f8 25             	cmp    $0x25,%eax
  80072c:	75 de                	jne    80070c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80072e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800732:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800739:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80073e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800745:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80074d:	eb 2b                	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800752:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800756:	eb 22                	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800758:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80075b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80075f:	eb 19                	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800764:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80076b:	eb 0d                	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80076d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800770:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800773:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077a:	0f b6 03             	movzbl (%ebx),%eax
  80077d:	0f b6 d0             	movzbl %al,%edx
  800780:	8d 73 01             	lea    0x1(%ebx),%esi
  800783:	89 75 10             	mov    %esi,0x10(%ebp)
  800786:	83 e8 23             	sub    $0x23,%eax
  800789:	3c 55                	cmp    $0x55,%al
  80078b:	0f 87 d8 02 00 00    	ja     800a69 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800791:	0f b6 c0             	movzbl %al,%eax
  800794:	ff 24 85 a0 46 80 00 	jmp    *0x8046a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80079b:	83 ea 30             	sub    $0x30,%edx
  80079e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8007a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8007a4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8007a7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8007ad:	83 fa 09             	cmp    $0x9,%edx
  8007b0:	77 4e                	ja     800800 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8007b8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8007bb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8007bf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8007c2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8007c5:	83 fa 09             	cmp    $0x9,%edx
  8007c8:	76 eb                	jbe    8007b5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8007ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007cd:	eb 31                	jmp    800800 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 50 04             	lea    0x4(%eax),%edx
  8007d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007e0:	eb 1e                	jmp    800800 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8007e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e6:	0f 88 75 ff ff ff    	js     800761 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007ef:	eb 89                	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8007f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8007f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007fb:	e9 7a ff ff ff       	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800804:	0f 89 70 ff ff ff    	jns    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80080a:	e9 5e ff ff ff       	jmp    80076d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800812:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800815:	e9 60 ff ff ff       	jmp    80077a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8d 50 04             	lea    0x4(%eax),%edx
  800820:	89 55 14             	mov    %edx,0x14(%ebp)
  800823:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800827:	8b 00                	mov    (%eax),%eax
  800829:	89 04 24             	mov    %eax,(%esp)
  80082c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80082f:	e9 bf fe ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8d 50 04             	lea    0x4(%eax),%edx
  80083a:	89 55 14             	mov    %edx,0x14(%ebp)
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	89 c2                	mov    %eax,%edx
  800841:	c1 fa 1f             	sar    $0x1f,%edx
  800844:	31 d0                	xor    %edx,%eax
  800846:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800848:	83 f8 14             	cmp    $0x14,%eax
  80084b:	7f 0f                	jg     80085c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80084d:	8b 14 85 00 48 80 00 	mov    0x804800(,%eax,4),%edx
  800854:	85 d2                	test   %edx,%edx
  800856:	0f 85 35 02 00 00    	jne    800a91 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80085c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800860:	c7 44 24 08 17 45 80 	movl   $0x804517,0x8(%esp)
  800867:	00 
  800868:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086c:	8b 75 08             	mov    0x8(%ebp),%esi
  80086f:	89 34 24             	mov    %esi,(%esp)
  800872:	e8 48 fe ff ff       	call   8006bf <_Z8printfmtPFviPvES_PKcz>
  800877:	e9 77 fe ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80087c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 50 04             	lea    0x4(%eax),%edx
  80088b:	89 55 14             	mov    %edx,0x14(%ebp)
  80088e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800890:	85 db                	test   %ebx,%ebx
  800892:	ba 10 45 80 00       	mov    $0x804510,%edx
  800897:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80089a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80089e:	7e 72                	jle    800912 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8008a0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8008a4:	74 6c                	je     800912 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008aa:	89 1c 24             	mov    %ebx,(%esp)
  8008ad:	e8 a9 02 00 00       	call   800b5b <_Z7strnlenPKcj>
  8008b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008b5:	29 c2                	sub    %eax,%edx
  8008b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008ba:	85 d2                	test   %edx,%edx
  8008bc:	7e 54                	jle    800912 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8008be:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8008c2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8008c5:	89 d3                	mov    %edx,%ebx
  8008c7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8008ca:	89 c6                	mov    %eax,%esi
  8008cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d0:	89 34 24             	mov    %esi,(%esp)
  8008d3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d6:	83 eb 01             	sub    $0x1,%ebx
  8008d9:	85 db                	test   %ebx,%ebx
  8008db:	7f ef                	jg     8008cc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8008dd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8008e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8008e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008ea:	eb 26                	jmp    800912 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008ec:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008ef:	83 fa 5e             	cmp    $0x5e,%edx
  8008f2:	76 10                	jbe    800904 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8008f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008ff:	ff 55 08             	call   *0x8(%ebp)
  800902:	eb 0a                	jmp    80090e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800904:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800908:	89 04 24             	mov    %eax,(%esp)
  80090b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800912:	0f be 03             	movsbl (%ebx),%eax
  800915:	83 c3 01             	add    $0x1,%ebx
  800918:	85 c0                	test   %eax,%eax
  80091a:	74 11                	je     80092d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80091c:	85 f6                	test   %esi,%esi
  80091e:	78 05                	js     800925 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800920:	83 ee 01             	sub    $0x1,%esi
  800923:	78 0d                	js     800932 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	75 c1                	jne    8008ec <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80092b:	eb d7                	jmp    800904 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800930:	eb 03                	jmp    800935 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	85 c0                	test   %eax,%eax
  800937:	0f 8e b6 fd ff ff    	jle    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80093d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800943:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800947:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80094e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800950:	83 eb 01             	sub    $0x1,%ebx
  800953:	85 db                	test   %ebx,%ebx
  800955:	7f ec                	jg     800943 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800957:	e9 97 fd ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80095c:	83 f9 01             	cmp    $0x1,%ecx
  80095f:	90                   	nop
  800960:	7e 10                	jle    800972 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	8d 50 08             	lea    0x8(%eax),%edx
  800968:	89 55 14             	mov    %edx,0x14(%ebp)
  80096b:	8b 18                	mov    (%eax),%ebx
  80096d:	8b 70 04             	mov    0x4(%eax),%esi
  800970:	eb 26                	jmp    800998 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800972:	85 c9                	test   %ecx,%ecx
  800974:	74 12                	je     800988 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	8d 50 04             	lea    0x4(%eax),%edx
  80097c:	89 55 14             	mov    %edx,0x14(%ebp)
  80097f:	8b 18                	mov    (%eax),%ebx
  800981:	89 de                	mov    %ebx,%esi
  800983:	c1 fe 1f             	sar    $0x1f,%esi
  800986:	eb 10                	jmp    800998 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8d 50 04             	lea    0x4(%eax),%edx
  80098e:	89 55 14             	mov    %edx,0x14(%ebp)
  800991:	8b 18                	mov    (%eax),%ebx
  800993:	89 de                	mov    %ebx,%esi
  800995:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800998:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80099d:	85 f6                	test   %esi,%esi
  80099f:	0f 89 8c 00 00 00    	jns    800a31 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8009a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009a9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009b0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8009b3:	f7 db                	neg    %ebx
  8009b5:	83 d6 00             	adc    $0x0,%esi
  8009b8:	f7 de                	neg    %esi
			}
			base = 10;
  8009ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009bf:	eb 70                	jmp    800a31 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c1:	89 ca                	mov    %ecx,%edx
  8009c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c6:	e8 9d fc ff ff       	call   800668 <_ZL7getuintPPci>
  8009cb:	89 c3                	mov    %eax,%ebx
  8009cd:	89 d6                	mov    %edx,%esi
			base = 10;
  8009cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8009d4:	eb 5b                	jmp    800a31 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8009d6:	89 ca                	mov    %ecx,%edx
  8009d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009db:	e8 88 fc ff ff       	call   800668 <_ZL7getuintPPci>
  8009e0:	89 c3                	mov    %eax,%ebx
  8009e2:	89 d6                	mov    %edx,%esi
			base = 8;
  8009e4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8009e9:	eb 46                	jmp    800a31 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8009eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ef:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009f6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8009f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009fd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a04:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	8d 50 04             	lea    0x4(%eax),%edx
  800a0d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a10:	8b 18                	mov    (%eax),%ebx
  800a12:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800a17:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800a1c:	eb 13                	jmp    800a31 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a1e:	89 ca                	mov    %ecx,%edx
  800a20:	8d 45 14             	lea    0x14(%ebp),%eax
  800a23:	e8 40 fc ff ff       	call   800668 <_ZL7getuintPPci>
  800a28:	89 c3                	mov    %eax,%ebx
  800a2a:	89 d6                	mov    %edx,%esi
			base = 16;
  800a2c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a31:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800a35:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a40:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a44:	89 1c 24             	mov    %ebx,(%esp)
  800a47:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4b:	89 fa                	mov    %edi,%edx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	e8 2b fb ff ff       	call   800580 <_ZL8printnumPFviPvES_yjii>
			break;
  800a55:	e9 99 fc ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a5e:	89 14 24             	mov    %edx,(%esp)
  800a61:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a64:	e9 8a fc ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a69:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a6d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a74:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a77:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a7a:	89 d8                	mov    %ebx,%eax
  800a7c:	eb 02                	jmp    800a80 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a83:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a87:	75 f5                	jne    800a7e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800a89:	89 45 10             	mov    %eax,0x10(%ebp)
  800a8c:	e9 62 fc ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a95:	c7 44 24 08 9e 48 80 	movl   $0x80489e,0x8(%esp)
  800a9c:	00 
  800a9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa1:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa4:	89 34 24             	mov    %esi,(%esp)
  800aa7:	e8 13 fc ff ff       	call   8006bf <_Z8printfmtPFviPvES_PKcz>
  800aac:	e9 42 fc ff ff       	jmp    8006f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ab1:	83 c4 3c             	add    $0x3c,%esp
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5f                   	pop    %edi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	83 ec 28             	sub    $0x28,%esp
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800acf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	74 30                	je     800b0a <_Z9vsnprintfPciPKcS_+0x51>
  800ada:	85 d2                	test   %edx,%edx
  800adc:	7e 2c                	jle    800b0a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af3:	c7 04 24 a2 06 80 00 	movl   $0x8006a2,(%esp)
  800afa:	e8 e8 fb ff ff       	call   8006e7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b08:	eb 05                	jmp    800b0f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b17:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b21:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	89 04 24             	mov    %eax,(%esp)
  800b32:	e8 82 ff ff ff       	call   800ab9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    
  800b39:	00 00                	add    %al,(%eax)
  800b3b:	00 00                	add    %al,(%eax)
  800b3d:	00 00                	add    %al,(%eax)
	...

00800b40 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b4e:	74 09                	je     800b59 <_Z6strlenPKc+0x19>
		n++;
  800b50:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b57:	75 f7                	jne    800b50 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b64:	b8 00 00 00 00       	mov    $0x0,%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	74 0b                	je     800b78 <_Z7strnlenPKcj+0x1d>
  800b6d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b71:	74 05                	je     800b78 <_Z7strnlenPKcj+0x1d>
		n++;
  800b73:	83 c0 01             	add    $0x1,%eax
  800b76:	eb f1                	jmp    800b69 <_Z7strnlenPKcj+0xe>
	return n;
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	53                   	push   %ebx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b8d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	84 c9                	test   %cl,%cl
  800b95:	75 f2                	jne    800b89 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800b97:	5b                   	pop    %ebx
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800ba8:	85 f6                	test   %esi,%esi
  800baa:	74 18                	je     800bc4 <_Z7strncpyPcPKcj+0x2a>
  800bac:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800bb1:	0f b6 1a             	movzbl (%edx),%ebx
  800bb4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bb7:	80 3a 01             	cmpb   $0x1,(%edx)
  800bba:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800bbd:	83 c1 01             	add    $0x1,%ecx
  800bc0:	39 ce                	cmp    %ecx,%esi
  800bc2:	77 ed                	ja     800bb1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	56                   	push   %esi
  800bcc:	53                   	push   %ebx
  800bcd:	8b 75 08             	mov    0x8(%ebp),%esi
  800bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800bd6:	89 f0                	mov    %esi,%eax
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	74 17                	je     800bf3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800bdc:	83 ea 01             	sub    $0x1,%edx
  800bdf:	74 18                	je     800bf9 <_Z7strlcpyPcPKcj+0x31>
  800be1:	80 39 00             	cmpb   $0x0,(%ecx)
  800be4:	74 17                	je     800bfd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800be6:	0f b6 19             	movzbl (%ecx),%ebx
  800be9:	88 18                	mov    %bl,(%eax)
  800beb:	83 c0 01             	add    $0x1,%eax
  800bee:	83 c1 01             	add    $0x1,%ecx
  800bf1:	eb e9                	jmp    800bdc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800bf3:	29 f0                	sub    %esi,%eax
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	eb 02                	jmp    800bff <_Z7strlcpyPcPKcj+0x37>
  800bfd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800bff:	c6 02 00             	movb   $0x0,(%edx)
  800c02:	eb ef                	jmp    800bf3 <_Z7strlcpyPcPKcj+0x2b>

00800c04 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c0d:	0f b6 01             	movzbl (%ecx),%eax
  800c10:	84 c0                	test   %al,%al
  800c12:	74 0c                	je     800c20 <_Z6strcmpPKcS0_+0x1c>
  800c14:	3a 02                	cmp    (%edx),%al
  800c16:	75 08                	jne    800c20 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	83 c2 01             	add    $0x1,%edx
  800c1e:	eb ed                	jmp    800c0d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800c20:	0f b6 c0             	movzbl %al,%eax
  800c23:	0f b6 12             	movzbl (%edx),%edx
  800c26:	29 d0                	sub    %edx,%eax
}
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	53                   	push   %ebx
  800c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c34:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c37:	85 d2                	test   %edx,%edx
  800c39:	74 16                	je     800c51 <_Z7strncmpPKcS0_j+0x27>
  800c3b:	0f b6 01             	movzbl (%ecx),%eax
  800c3e:	84 c0                	test   %al,%al
  800c40:	74 17                	je     800c59 <_Z7strncmpPKcS0_j+0x2f>
  800c42:	3a 03                	cmp    (%ebx),%al
  800c44:	75 13                	jne    800c59 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800c46:	83 ea 01             	sub    $0x1,%edx
  800c49:	83 c1 01             	add    $0x1,%ecx
  800c4c:	83 c3 01             	add    $0x1,%ebx
  800c4f:	eb e6                	jmp    800c37 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800c56:	5b                   	pop    %ebx
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800c59:	0f b6 01             	movzbl (%ecx),%eax
  800c5c:	0f b6 13             	movzbl (%ebx),%edx
  800c5f:	29 d0                	sub    %edx,%eax
  800c61:	eb f3                	jmp    800c56 <_Z7strncmpPKcS0_j+0x2c>

00800c63 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c6d:	0f b6 10             	movzbl (%eax),%edx
  800c70:	84 d2                	test   %dl,%dl
  800c72:	74 1f                	je     800c93 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800c74:	38 ca                	cmp    %cl,%dl
  800c76:	75 0a                	jne    800c82 <_Z6strchrPKcc+0x1f>
  800c78:	eb 1e                	jmp    800c98 <_Z6strchrPKcc+0x35>
  800c7a:	38 ca                	cmp    %cl,%dl
  800c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c80:	74 16                	je     800c98 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	0f b6 10             	movzbl (%eax),%edx
  800c88:	84 d2                	test   %dl,%dl
  800c8a:	75 ee                	jne    800c7a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	eb 05                	jmp    800c98 <_Z6strchrPKcc+0x35>
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	0f b6 10             	movzbl (%eax),%edx
  800ca7:	84 d2                	test   %dl,%dl
  800ca9:	74 14                	je     800cbf <_Z7strfindPKcc+0x25>
		if (*s == c)
  800cab:	38 ca                	cmp    %cl,%dl
  800cad:	75 06                	jne    800cb5 <_Z7strfindPKcc+0x1b>
  800caf:	eb 0e                	jmp    800cbf <_Z7strfindPKcc+0x25>
  800cb1:	38 ca                	cmp    %cl,%dl
  800cb3:	74 0a                	je     800cbf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb5:	83 c0 01             	add    $0x1,%eax
  800cb8:	0f b6 10             	movzbl (%eax),%edx
  800cbb:	84 d2                	test   %dl,%dl
  800cbd:	75 f2                	jne    800cb1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 0c             	sub    $0xc,%esp
  800cc7:	89 1c 24             	mov    %ebx,(%esp)
  800cca:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800cdb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ce1:	75 25                	jne    800d08 <memset+0x47>
  800ce3:	f6 c1 03             	test   $0x3,%cl
  800ce6:	75 20                	jne    800d08 <memset+0x47>
		c &= 0xFF;
  800ce8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ceb:	89 d3                	mov    %edx,%ebx
  800ced:	c1 e3 08             	shl    $0x8,%ebx
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	c1 e6 18             	shl    $0x18,%esi
  800cf5:	89 d0                	mov    %edx,%eax
  800cf7:	c1 e0 10             	shl    $0x10,%eax
  800cfa:	09 f0                	or     %esi,%eax
  800cfc:	09 d0                	or     %edx,%eax
  800cfe:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800d00:	c1 e9 02             	shr    $0x2,%ecx
  800d03:	fc                   	cld    
  800d04:	f3 ab                	rep stos %eax,%es:(%edi)
  800d06:	eb 03                	jmp    800d0b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800d08:	fc                   	cld    
  800d09:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800d0b:	89 f8                	mov    %edi,%eax
  800d0d:	8b 1c 24             	mov    (%esp),%ebx
  800d10:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d18:	89 ec                	mov    %ebp,%esp
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	89 34 24             	mov    %esi,(%esp)
  800d25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800d32:	39 c6                	cmp    %eax,%esi
  800d34:	73 36                	jae    800d6c <memmove+0x50>
  800d36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d39:	39 d0                	cmp    %edx,%eax
  800d3b:	73 2f                	jae    800d6c <memmove+0x50>
		s += n;
		d += n;
  800d3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d40:	f6 c2 03             	test   $0x3,%dl
  800d43:	75 1b                	jne    800d60 <memmove+0x44>
  800d45:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d4b:	75 13                	jne    800d60 <memmove+0x44>
  800d4d:	f6 c1 03             	test   $0x3,%cl
  800d50:	75 0e                	jne    800d60 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d52:	83 ef 04             	sub    $0x4,%edi
  800d55:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d58:	c1 e9 02             	shr    $0x2,%ecx
  800d5b:	fd                   	std    
  800d5c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5e:	eb 09                	jmp    800d69 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d60:	83 ef 01             	sub    $0x1,%edi
  800d63:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d66:	fd                   	std    
  800d67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d69:	fc                   	cld    
  800d6a:	eb 20                	jmp    800d8c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d6c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d72:	75 13                	jne    800d87 <memmove+0x6b>
  800d74:	a8 03                	test   $0x3,%al
  800d76:	75 0f                	jne    800d87 <memmove+0x6b>
  800d78:	f6 c1 03             	test   $0x3,%cl
  800d7b:	75 0a                	jne    800d87 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d7d:	c1 e9 02             	shr    $0x2,%ecx
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	fc                   	cld    
  800d83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d85:	eb 05                	jmp    800d8c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800d87:	89 c7                	mov    %eax,%edi
  800d89:	fc                   	cld    
  800d8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800d8c:	8b 34 24             	mov    (%esp),%esi
  800d8f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d93:	89 ec                	mov    %ebp,%esp
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 08             	sub    $0x8,%esp
  800d9d:	89 34 24             	mov    %esi,(%esp)
  800da0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800daa:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800dad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800db3:	75 13                	jne    800dc8 <memcpy+0x31>
  800db5:	a8 03                	test   $0x3,%al
  800db7:	75 0f                	jne    800dc8 <memcpy+0x31>
  800db9:	f6 c1 03             	test   $0x3,%cl
  800dbc:	75 0a                	jne    800dc8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dbe:	c1 e9 02             	shr    $0x2,%ecx
  800dc1:	89 c7                	mov    %eax,%edi
  800dc3:	fc                   	cld    
  800dc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dc6:	eb 05                	jmp    800dcd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800dc8:	89 c7                	mov    %eax,%edi
  800dca:	fc                   	cld    
  800dcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800dcd:	8b 34 24             	mov    (%esp),%esi
  800dd0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dd4:	89 ec                	mov    %ebp,%esp
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800de1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800dec:	85 ff                	test   %edi,%edi
  800dee:	74 38                	je     800e28 <memcmp+0x50>
		if (*s1 != *s2)
  800df0:	0f b6 03             	movzbl (%ebx),%eax
  800df3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800df6:	83 ef 01             	sub    $0x1,%edi
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800dfe:	38 c8                	cmp    %cl,%al
  800e00:	74 1d                	je     800e1f <memcmp+0x47>
  800e02:	eb 11                	jmp    800e15 <memcmp+0x3d>
  800e04:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800e09:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800e0e:	83 c2 01             	add    $0x1,%edx
  800e11:	38 c8                	cmp    %cl,%al
  800e13:	74 0a                	je     800e1f <memcmp+0x47>
			return *s1 - *s2;
  800e15:	0f b6 c0             	movzbl %al,%eax
  800e18:	0f b6 c9             	movzbl %cl,%ecx
  800e1b:	29 c8                	sub    %ecx,%eax
  800e1d:	eb 09                	jmp    800e28 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800e1f:	39 fa                	cmp    %edi,%edx
  800e21:	75 e1                	jne    800e04 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	53                   	push   %ebx
  800e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800e34:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800e36:	89 da                	mov    %ebx,%edx
  800e38:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800e3b:	39 d3                	cmp    %edx,%ebx
  800e3d:	73 15                	jae    800e54 <memfind+0x27>
		if (*s == (unsigned char) c)
  800e3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e43:	38 0b                	cmp    %cl,(%ebx)
  800e45:	75 06                	jne    800e4d <memfind+0x20>
  800e47:	eb 0b                	jmp    800e54 <memfind+0x27>
  800e49:	38 08                	cmp    %cl,(%eax)
  800e4b:	74 07                	je     800e54 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800e4d:	83 c0 01             	add    $0x1,%eax
  800e50:	39 c2                	cmp    %eax,%edx
  800e52:	77 f5                	ja     800e49 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e54:	5b                   	pop    %ebx
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e63:	0f b6 02             	movzbl (%edx),%eax
  800e66:	3c 20                	cmp    $0x20,%al
  800e68:	74 04                	je     800e6e <_Z6strtolPKcPPci+0x17>
  800e6a:	3c 09                	cmp    $0x9,%al
  800e6c:	75 0e                	jne    800e7c <_Z6strtolPKcPPci+0x25>
		s++;
  800e6e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e71:	0f b6 02             	movzbl (%edx),%eax
  800e74:	3c 20                	cmp    $0x20,%al
  800e76:	74 f6                	je     800e6e <_Z6strtolPKcPPci+0x17>
  800e78:	3c 09                	cmp    $0x9,%al
  800e7a:	74 f2                	je     800e6e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7c:	3c 2b                	cmp    $0x2b,%al
  800e7e:	75 0a                	jne    800e8a <_Z6strtolPKcPPci+0x33>
		s++;
  800e80:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e83:	bf 00 00 00 00       	mov    $0x0,%edi
  800e88:	eb 10                	jmp    800e9a <_Z6strtolPKcPPci+0x43>
  800e8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e8f:	3c 2d                	cmp    $0x2d,%al
  800e91:	75 07                	jne    800e9a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800e93:	83 c2 01             	add    $0x1,%edx
  800e96:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9a:	85 db                	test   %ebx,%ebx
  800e9c:	0f 94 c0             	sete   %al
  800e9f:	74 05                	je     800ea6 <_Z6strtolPKcPPci+0x4f>
  800ea1:	83 fb 10             	cmp    $0x10,%ebx
  800ea4:	75 15                	jne    800ebb <_Z6strtolPKcPPci+0x64>
  800ea6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ea9:	75 10                	jne    800ebb <_Z6strtolPKcPPci+0x64>
  800eab:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800eaf:	75 0a                	jne    800ebb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800eb1:	83 c2 02             	add    $0x2,%edx
  800eb4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800eb9:	eb 13                	jmp    800ece <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800ebb:	84 c0                	test   %al,%al
  800ebd:	74 0f                	je     800ece <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ebf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ec4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ec7:	75 05                	jne    800ece <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800ec9:	83 c2 01             	add    $0x1,%edx
  800ecc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed5:	0f b6 0a             	movzbl (%edx),%ecx
  800ed8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800edb:	80 fb 09             	cmp    $0x9,%bl
  800ede:	77 08                	ja     800ee8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800ee0:	0f be c9             	movsbl %cl,%ecx
  800ee3:	83 e9 30             	sub    $0x30,%ecx
  800ee6:	eb 1e                	jmp    800f06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ee8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800eeb:	80 fb 19             	cmp    $0x19,%bl
  800eee:	77 08                	ja     800ef8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800ef0:	0f be c9             	movsbl %cl,%ecx
  800ef3:	83 e9 57             	sub    $0x57,%ecx
  800ef6:	eb 0e                	jmp    800f06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800ef8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800efb:	80 fb 19             	cmp    $0x19,%bl
  800efe:	77 15                	ja     800f15 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800f00:	0f be c9             	movsbl %cl,%ecx
  800f03:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f06:	39 f1                	cmp    %esi,%ecx
  800f08:	7d 0f                	jge    800f19 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800f0a:	83 c2 01             	add    $0x1,%edx
  800f0d:	0f af c6             	imul   %esi,%eax
  800f10:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800f13:	eb c0                	jmp    800ed5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800f15:	89 c1                	mov    %eax,%ecx
  800f17:	eb 02                	jmp    800f1b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f19:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f1f:	74 05                	je     800f26 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800f21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f24:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f26:	89 ca                	mov    %ecx,%edx
  800f28:	f7 da                	neg    %edx
  800f2a:	85 ff                	test   %edi,%edi
  800f2c:	0f 45 c2             	cmovne %edx,%eax
}
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	89 1c 24             	mov    %ebx,(%esp)
  800f3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f41:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	89 c3                	mov    %eax,%ebx
  800f52:	89 c7                	mov    %eax,%edi
  800f54:	89 c6                	mov    %eax,%esi
  800f56:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f58:	8b 1c 24             	mov    (%esp),%ebx
  800f5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f63:	89 ec                	mov    %ebp,%esp
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	89 1c 24             	mov    %ebx,(%esp)
  800f70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f74:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f78:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f82:	89 d1                	mov    %edx,%ecx
  800f84:	89 d3                	mov    %edx,%ebx
  800f86:	89 d7                	mov    %edx,%edi
  800f88:	89 d6                	mov    %edx,%esi
  800f8a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f8c:	8b 1c 24             	mov    (%esp),%ebx
  800f8f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f93:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f97:	89 ec                	mov    %ebp,%esp
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 38             	sub    $0x38,%esp
  800fa1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800faa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800faf:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	89 cb                	mov    %ecx,%ebx
  800fb9:	89 cf                	mov    %ecx,%edi
  800fbb:	89 ce                	mov    %ecx,%esi
  800fbd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	7e 28                	jle    800feb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fce:	00 
  800fcf:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  800fd6:	00 
  800fd7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fde:	00 
  800fdf:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  800fe6:	e8 55 f4 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800feb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff4:	89 ec                	mov    %ebp,%esp
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	89 1c 24             	mov    %ebx,(%esp)
  801001:	89 74 24 04          	mov    %esi,0x4(%esp)
  801005:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801009:	ba 00 00 00 00       	mov    $0x0,%edx
  80100e:	b8 02 00 00 00       	mov    $0x2,%eax
  801013:	89 d1                	mov    %edx,%ecx
  801015:	89 d3                	mov    %edx,%ebx
  801017:	89 d7                	mov    %edx,%edi
  801019:	89 d6                	mov    %edx,%esi
  80101b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80101d:	8b 1c 24             	mov    (%esp),%ebx
  801020:	8b 74 24 04          	mov    0x4(%esp),%esi
  801024:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801028:	89 ec                	mov    %ebp,%esp
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	89 1c 24             	mov    %ebx,(%esp)
  801035:	89 74 24 04          	mov    %esi,0x4(%esp)
  801039:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80103d:	ba 00 00 00 00       	mov    $0x0,%edx
  801042:	b8 04 00 00 00       	mov    $0x4,%eax
  801047:	89 d1                	mov    %edx,%ecx
  801049:	89 d3                	mov    %edx,%ebx
  80104b:	89 d7                	mov    %edx,%edi
  80104d:	89 d6                	mov    %edx,%esi
  80104f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801051:	8b 1c 24             	mov    (%esp),%ebx
  801054:	8b 74 24 04          	mov    0x4(%esp),%esi
  801058:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80105c:	89 ec                	mov    %ebp,%esp
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 38             	sub    $0x38,%esp
  801066:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801069:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80106c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80106f:	be 00 00 00 00       	mov    $0x0,%esi
  801074:	b8 08 00 00 00       	mov    $0x8,%eax
  801079:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	8b 55 08             	mov    0x8(%ebp),%edx
  801082:	89 f7                	mov    %esi,%edi
  801084:	cd 30                	int    $0x30

	if(check && ret > 0)
  801086:	85 c0                	test   %eax,%eax
  801088:	7e 28                	jle    8010b2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80108a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801095:	00 
  801096:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  80109d:	00 
  80109e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a5:	00 
  8010a6:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  8010ad:	e8 8e f3 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010bb:	89 ec                	mov    %ebp,%esp
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 38             	sub    $0x38,%esp
  8010c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010cb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8010d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010df:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e2:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7e 28                	jle    801110 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ec:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  80110b:	e8 30 f3 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801110:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801113:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801116:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801119:	89 ec                	mov    %ebp,%esp
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 38             	sub    $0x38,%esp
  801123:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801126:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801129:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80112c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801131:	b8 0a 00 00 00       	mov    $0xa,%eax
  801136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	89 df                	mov    %ebx,%edi
  80113e:	89 de                	mov    %ebx,%esi
  801140:	cd 30                	int    $0x30

	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7e 28                	jle    80116e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801146:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801151:	00 
  801152:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  801159:	00 
  80115a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801161:	00 
  801162:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  801169:	e8 d2 f2 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80116e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801171:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801174:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801177:	89 ec                	mov    %ebp,%esp
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 38             	sub    $0x38,%esp
  801181:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801184:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801187:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80118a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118f:	b8 05 00 00 00       	mov    $0x5,%eax
  801194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	89 df                	mov    %ebx,%edi
  80119c:	89 de                	mov    %ebx,%esi
  80119e:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	7e 28                	jle    8011cc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011af:	00 
  8011b0:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  8011b7:	00 
  8011b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011bf:	00 
  8011c0:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  8011c7:	e8 74 f2 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d5:	89 ec                	mov    %ebp,%esp
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 38             	sub    $0x38,%esp
  8011df:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8011f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f8:	89 df                	mov    %ebx,%edi
  8011fa:	89 de                	mov    %ebx,%esi
  8011fc:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011fe:	85 c0                	test   %eax,%eax
  801200:	7e 28                	jle    80122a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801202:	89 44 24 10          	mov    %eax,0x10(%esp)
  801206:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80120d:	00 
  80120e:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  801215:	00 
  801216:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121d:	00 
  80121e:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  801225:	e8 16 f2 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80122a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80122d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801230:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801233:	89 ec                	mov    %ebp,%esp
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 38             	sub    $0x38,%esp
  80123d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801240:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801243:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801246:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801253:	8b 55 08             	mov    0x8(%ebp),%edx
  801256:	89 df                	mov    %ebx,%edi
  801258:	89 de                	mov    %ebx,%esi
  80125a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80125c:	85 c0                	test   %eax,%eax
  80125e:	7e 28                	jle    801288 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	89 44 24 10          	mov    %eax,0x10(%esp)
  801264:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  801283:	e8 b8 f1 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801288:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80128b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80128e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801291:	89 ec                	mov    %ebp,%esp
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    

00801295 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 38             	sub    $0x38,%esp
  80129b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80129e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b4:	89 df                	mov    %ebx,%edi
  8012b6:	89 de                	mov    %ebx,%esi
  8012b8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	7e 28                	jle    8012e6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8012c9:	00 
  8012ca:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  8012d1:	00 
  8012d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d9:	00 
  8012da:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  8012e1:	e8 5a f1 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ef:	89 ec                	mov    %ebp,%esp
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	89 1c 24             	mov    %ebx,(%esp)
  8012fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801300:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801304:	be 00 00 00 00       	mov    $0x0,%esi
  801309:	b8 0d 00 00 00       	mov    $0xd,%eax
  80130e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801311:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801314:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80131c:	8b 1c 24             	mov    (%esp),%ebx
  80131f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801323:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801327:	89 ec                	mov    %ebp,%esp
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 38             	sub    $0x38,%esp
  801331:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801334:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801337:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80133a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80133f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801344:	8b 55 08             	mov    0x8(%ebp),%edx
  801347:	89 cb                	mov    %ecx,%ebx
  801349:	89 cf                	mov    %ecx,%edi
  80134b:	89 ce                	mov    %ecx,%esi
  80134d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80134f:	85 c0                	test   %eax,%eax
  801351:	7e 28                	jle    80137b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801353:	89 44 24 10          	mov    %eax,0x10(%esp)
  801357:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80135e:	00 
  80135f:	c7 44 24 08 54 48 80 	movl   $0x804854,0x8(%esp)
  801366:	00 
  801367:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80136e:	00 
  80136f:	c7 04 24 71 48 80 00 	movl   $0x804871,(%esp)
  801376:	e8 c5 f0 ff ff       	call   800440 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80137b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80137e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801381:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801384:	89 ec                	mov    %ebp,%esp
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	89 1c 24             	mov    %ebx,(%esp)
  801391:	89 74 24 04          	mov    %esi,0x4(%esp)
  801395:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801399:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139e:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	89 df                	mov    %ebx,%edi
  8013ab:	89 de                	mov    %ebx,%esi
  8013ad:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8013af:	8b 1c 24             	mov    (%esp),%ebx
  8013b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ba:	89 ec                	mov    %ebp,%esp
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	89 1c 24             	mov    %ebx,(%esp)
  8013c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d4:	b8 11 00 00 00       	mov    $0x11,%eax
  8013d9:	89 d1                	mov    %edx,%ecx
  8013db:	89 d3                	mov    %edx,%ebx
  8013dd:	89 d7                	mov    %edx,%edi
  8013df:	89 d6                	mov    %edx,%esi
  8013e1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013e3:	8b 1c 24             	mov    (%esp),%ebx
  8013e6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013ea:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ee:	89 ec                	mov    %ebp,%esp
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    

008013f2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	89 1c 24             	mov    %ebx,(%esp)
  8013fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ff:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801403:	bb 00 00 00 00       	mov    $0x0,%ebx
  801408:	b8 12 00 00 00       	mov    $0x12,%eax
  80140d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801410:	8b 55 08             	mov    0x8(%ebp),%edx
  801413:	89 df                	mov    %ebx,%edi
  801415:	89 de                	mov    %ebx,%esi
  801417:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801419:	8b 1c 24             	mov    (%esp),%ebx
  80141c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801420:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801424:	89 ec                	mov    %ebp,%esp
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 0c             	sub    $0xc,%esp
  80142e:	89 1c 24             	mov    %ebx,(%esp)
  801431:	89 74 24 04          	mov    %esi,0x4(%esp)
  801435:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801439:	b9 00 00 00 00       	mov    $0x0,%ecx
  80143e:	b8 13 00 00 00       	mov    $0x13,%eax
  801443:	8b 55 08             	mov    0x8(%ebp),%edx
  801446:	89 cb                	mov    %ecx,%ebx
  801448:	89 cf                	mov    %ecx,%edi
  80144a:	89 ce                	mov    %ecx,%esi
  80144c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80144e:	8b 1c 24             	mov    (%esp),%ebx
  801451:	8b 74 24 04          	mov    0x4(%esp),%esi
  801455:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801459:	89 ec                	mov    %ebp,%esp
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    

0080145d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	89 1c 24             	mov    %ebx,(%esp)
  801466:	89 74 24 04          	mov    %esi,0x4(%esp)
  80146a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80146e:	b8 10 00 00 00       	mov    $0x10,%eax
  801473:	8b 75 18             	mov    0x18(%ebp),%esi
  801476:	8b 7d 14             	mov    0x14(%ebp),%edi
  801479:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80147c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147f:	8b 55 08             	mov    0x8(%ebp),%edx
  801482:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801484:	8b 1c 24             	mov    (%esp),%ebx
  801487:	8b 74 24 04          	mov    0x4(%esp),%esi
  80148b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80148f:	89 ec                	mov    %ebp,%esp
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    
	...

00801494 <_Z8argstartPiPPcP8Argstate>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	8b 55 08             	mov    0x8(%ebp),%edx
  80149a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8014a0:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8014a2:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8014a5:	83 3a 01             	cmpl   $0x1,(%edx)
  8014a8:	7e 09                	jle    8014b3 <_Z8argstartPiPPcP8Argstate+0x1f>
  8014aa:	ba a8 44 80 00       	mov    $0x8044a8,%edx
  8014af:	85 c9                	test   %ecx,%ecx
  8014b1:	75 05                	jne    8014b8 <_Z8argstartPiPPcP8Argstate+0x24>
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b8:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8014bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <_Z7argnextP8Argstate>:

int
argnext(struct Argstate *args)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 28             	sub    $0x28,%esp
  8014ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8014d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8014dd:	8b 53 08             	mov    0x8(%ebx),%edx
		return -1;
  8014e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	int arg;

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8014e5:	85 d2                	test   %edx,%edx
  8014e7:	74 6f                	je     801558 <_Z7argnextP8Argstate+0x94>
		return -1;

	if (!*args->curarg) {
  8014e9:	80 3a 00             	cmpb   $0x0,(%edx)
  8014ec:	75 50                	jne    80153e <_Z7argnextP8Argstate+0x7a>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8014ee:	8b 0b                	mov    (%ebx),%ecx
  8014f0:	83 39 01             	cmpl   $0x1,(%ecx)
  8014f3:	74 57                	je     80154c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
  8014f5:	8b 43 04             	mov    0x4(%ebx),%eax
  8014f8:	8d 70 04             	lea    0x4(%eax),%esi
  8014fb:	8b 50 04             	mov    0x4(%eax),%edx
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8014fe:	80 3a 2d             	cmpb   $0x2d,(%edx)
  801501:	75 49                	jne    80154c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  801503:	8d 7a 01             	lea    0x1(%edx),%edi
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801506:	80 7a 01 00          	cmpb   $0x0,0x1(%edx)
  80150a:	74 40                	je     80154c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80150c:	89 7b 08             	mov    %edi,0x8(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80150f:	8b 11                	mov    (%ecx),%edx
  801511:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801518:	89 54 24 08          	mov    %edx,0x8(%esp)
  80151c:	83 c0 08             	add    $0x8,%eax
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	89 34 24             	mov    %esi,(%esp)
  801526:	e8 6c f8 ff ff       	call   800d97 <memcpy>
		(*args->argc)--;
  80152b:	8b 03                	mov    (%ebx),%eax
  80152d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801530:	8b 43 08             	mov    0x8(%ebx),%eax
  801533:	80 38 2d             	cmpb   $0x2d,(%eax)
  801536:	75 06                	jne    80153e <_Z7argnextP8Argstate+0x7a>
  801538:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80153c:	74 0e                	je     80154c <_Z7argnextP8Argstate+0x88>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80153e:	8b 53 08             	mov    0x8(%ebx),%edx
  801541:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801544:	83 c2 01             	add    $0x1,%edx
  801547:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  80154a:	eb 0c                	jmp    801558 <_Z7argnextP8Argstate+0x94>

    endofargs:
	args->curarg = 0;
  80154c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801558:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80155b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80155e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801561:	89 ec                	mov    %ebp,%esp
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <_Z12argnextvalueP8Argstate>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 18             	sub    $0x18,%esp
  80156b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80156e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801571:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801574:	8b 53 08             	mov    0x8(%ebx),%edx
		return 0;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
  80157c:	85 d2                	test   %edx,%edx
  80157e:	74 58                	je     8015d8 <_Z12argnextvalueP8Argstate+0x73>
		return 0;
	if (*args->curarg) {
  801580:	80 3a 00             	cmpb   $0x0,(%edx)
  801583:	74 0c                	je     801591 <_Z12argnextvalueP8Argstate+0x2c>
		args->argvalue = args->curarg;
  801585:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  801588:	c7 43 08 a8 44 80 00 	movl   $0x8044a8,0x8(%ebx)
  80158f:	eb 44                	jmp    8015d5 <_Z12argnextvalueP8Argstate+0x70>
	} else if (*args->argc > 1) {
  801591:	8b 03                	mov    (%ebx),%eax
  801593:	83 38 01             	cmpl   $0x1,(%eax)
  801596:	7e 2f                	jle    8015c7 <_Z12argnextvalueP8Argstate+0x62>
		args->argvalue = args->argv[1];
  801598:	8b 53 04             	mov    0x4(%ebx),%edx
  80159b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80159e:	8b 72 04             	mov    0x4(%edx),%esi
  8015a1:	89 73 0c             	mov    %esi,0xc(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8015a4:	8b 00                	mov    (%eax),%eax
  8015a6:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8015ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015b1:	83 c2 08             	add    $0x8,%edx
  8015b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b8:	89 0c 24             	mov    %ecx,(%esp)
  8015bb:	e8 d7 f7 ff ff       	call   800d97 <memcpy>
		(*args->argc)--;
  8015c0:	8b 03                	mov    (%ebx),%eax
  8015c2:	83 28 01             	subl   $0x1,(%eax)
  8015c5:	eb 0e                	jmp    8015d5 <_Z12argnextvalueP8Argstate+0x70>
	} else {
		args->argvalue = 0;
  8015c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8015ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8015d5:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8015d8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015db:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015de:	89 ec                	mov    %ebp,%esp
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    

008015e2 <_Z8argvalueP8Argstate>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 18             	sub    $0x18,%esp
  8015e8:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8015eb:	8b 42 0c             	mov    0xc(%edx),%eax
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	75 08                	jne    8015fa <_Z8argvalueP8Argstate+0x18>
  8015f2:	89 14 24             	mov    %edx,(%esp)
  8015f5:	e8 6b ff ff ff       	call   801565 <_Z12argnextvalueP8Argstate>
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    
  8015fc:	00 00                	add    %al,(%eax)
	...

00801600 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801603:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801608:	75 11                	jne    80161b <_ZL8fd_validPK2Fd+0x1b>
  80160a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80160f:	76 0a                	jbe    80161b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801611:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801616:	0f 96 c0             	setbe  %al
  801619:	eb 05                	jmp    801620 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 14             	sub    $0x14,%esp
  801629:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80162b:	e8 d0 ff ff ff       	call   801600 <_ZL8fd_validPK2Fd>
  801630:	84 c0                	test   %al,%al
  801632:	75 24                	jne    801658 <_ZL9fd_isopenPK2Fd+0x36>
  801634:	c7 44 24 0c 7f 48 80 	movl   $0x80487f,0xc(%esp)
  80163b:	00 
  80163c:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  801643:	00 
  801644:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80164b:	00 
  80164c:	c7 04 24 a1 48 80 00 	movl   $0x8048a1,(%esp)
  801653:	e8 e8 ed ff ff       	call   800440 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801658:	89 d8                	mov    %ebx,%eax
  80165a:	c1 e8 16             	shr    $0x16,%eax
  80165d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	f6 c2 01             	test   $0x1,%dl
  80166c:	74 0d                	je     80167b <_ZL9fd_isopenPK2Fd+0x59>
  80166e:	c1 eb 0c             	shr    $0xc,%ebx
  801671:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801678:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80167b:	83 c4 14             	add    $0x14,%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	89 1c 24             	mov    %ebx,(%esp)
  80168a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80168e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801691:	8b 75 0c             	mov    0xc(%ebp),%esi
  801694:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801698:	83 fb 1f             	cmp    $0x1f,%ebx
  80169b:	77 18                	ja     8016b5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80169d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8016a3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8016a6:	84 c0                	test   %al,%al
  8016a8:	74 21                	je     8016cb <_Z9fd_lookupiPP2Fdb+0x4a>
  8016aa:	89 d8                	mov    %ebx,%eax
  8016ac:	e8 71 ff ff ff       	call   801622 <_ZL9fd_isopenPK2Fd>
  8016b1:	84 c0                	test   %al,%al
  8016b3:	75 16                	jne    8016cb <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8016b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8016bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8016c0:	8b 1c 24             	mov    (%esp),%ebx
  8016c3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016c7:	89 ec                	mov    %ebp,%esp
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8016cb:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	eb ec                	jmp    8016c0 <_Z9fd_lookupiPP2Fdb+0x3f>

008016d4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 14             	sub    $0x14,%esp
  8016db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8016de:	89 d8                	mov    %ebx,%eax
  8016e0:	e8 1b ff ff ff       	call   801600 <_ZL8fd_validPK2Fd>
  8016e5:	84 c0                	test   %al,%al
  8016e7:	75 24                	jne    80170d <_Z6fd2numP2Fd+0x39>
  8016e9:	c7 44 24 0c 7f 48 80 	movl   $0x80487f,0xc(%esp)
  8016f0:	00 
  8016f1:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  8016f8:	00 
  8016f9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801700:	00 
  801701:	c7 04 24 a1 48 80 00 	movl   $0x8048a1,(%esp)
  801708:	e8 33 ed ff ff       	call   800440 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80170d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801713:	c1 e8 0c             	shr    $0xc,%eax
}
  801716:	83 c4 14             	add    $0x14,%esp
  801719:	5b                   	pop    %ebx
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 04 24             	mov    %eax,(%esp)
  801728:	e8 a7 ff ff ff       	call   8016d4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80172d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801732:	c1 e0 0c             	shl    $0xc,%eax
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	57                   	push   %edi
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 2c             	sub    $0x2c,%esp
  801740:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801743:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801748:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80174b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801752:	00 
  801753:	89 74 24 04          	mov    %esi,0x4(%esp)
  801757:	89 1c 24             	mov    %ebx,(%esp)
  80175a:	e8 22 ff ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80175f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801762:	e8 bb fe ff ff       	call   801622 <_ZL9fd_isopenPK2Fd>
  801767:	84 c0                	test   %al,%al
  801769:	75 0c                	jne    801777 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80176b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176e:	89 07                	mov    %eax,(%edi)
			return 0;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	eb 13                	jmp    80178a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801777:	83 c3 01             	add    $0x1,%ebx
  80177a:	83 fb 20             	cmp    $0x20,%ebx
  80177d:	75 cc                	jne    80174b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80177f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801785:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80178a:	83 c4 2c             	add    $0x2c,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5f                   	pop    %edi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	83 ec 14             	sub    $0x14,%esp
  801799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017a4:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  8017aa:	75 16                	jne    8017c2 <_Z10dev_lookupiPP3Dev+0x30>
  8017ac:	eb 06                	jmp    8017b4 <_Z10dev_lookupiPP3Dev+0x22>
  8017ae:	39 0a                	cmp    %ecx,(%edx)
  8017b0:	75 10                	jne    8017c2 <_Z10dev_lookupiPP3Dev+0x30>
  8017b2:	eb 05                	jmp    8017b9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017b4:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8017b9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	eb 35                	jmp    8017f7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017c2:	83 c0 01             	add    $0x1,%eax
  8017c5:	8b 14 85 0c 49 80 00 	mov    0x80490c(,%eax,4),%edx
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	75 de                	jne    8017ae <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017d0:	a1 00 74 80 00       	mov    0x807400,%eax
  8017d5:	8b 40 04             	mov    0x4(%eax),%eax
  8017d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e0:	c7 04 24 c8 48 80 00 	movl   $0x8048c8,(%esp)
  8017e7:	e8 72 ed ff ff       	call   80055e <_Z7cprintfPKcz>
	*dev = 0;
  8017ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8017f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017f7:	83 c4 14             	add    $0x14,%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 20             	sub    $0x20,%esp
  801805:	8b 75 08             	mov    0x8(%ebp),%esi
  801808:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80180c:	89 34 24             	mov    %esi,(%esp)
  80180f:	e8 c0 fe ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  801814:	0f b6 d3             	movzbl %bl,%edx
  801817:	89 54 24 08          	mov    %edx,0x8(%esp)
  80181b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80181e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801822:	89 04 24             	mov    %eax,(%esp)
  801825:	e8 57 fe ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  80182a:	85 c0                	test   %eax,%eax
  80182c:	78 05                	js     801833 <_Z8fd_closeP2Fdb+0x36>
  80182e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801831:	74 0c                	je     80183f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801833:	80 fb 01             	cmp    $0x1,%bl
  801836:	19 db                	sbb    %ebx,%ebx
  801838:	f7 d3                	not    %ebx
  80183a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80183d:	eb 3d                	jmp    80187c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80183f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801842:	89 44 24 04          	mov    %eax,0x4(%esp)
  801846:	8b 06                	mov    (%esi),%eax
  801848:	89 04 24             	mov    %eax,(%esp)
  80184b:	e8 42 ff ff ff       	call   801792 <_Z10dev_lookupiPP3Dev>
  801850:	89 c3                	mov    %eax,%ebx
  801852:	85 c0                	test   %eax,%eax
  801854:	78 16                	js     80186c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80185c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801861:	85 c0                	test   %eax,%eax
  801863:	74 07                	je     80186c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801865:	89 34 24             	mov    %esi,(%esp)
  801868:	ff d0                	call   *%eax
  80186a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80186c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801870:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801877:	e8 a1 f8 ff ff       	call   80111d <_Z14sys_page_unmapiPv>
	return r;
}
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	83 c4 20             	add    $0x20,%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80188b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801892:	00 
  801893:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	89 04 24             	mov    %eax,(%esp)
  8018a0:	e8 dc fd ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 13                	js     8018bc <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  8018a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018b0:	00 
  8018b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	e8 41 ff ff ff       	call   8017fd <_Z8fd_closeP2Fdb>
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <_Z9close_allv>:

void
close_all(void)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  8018c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018ca:	89 1c 24             	mov    %ebx,(%esp)
  8018cd:	e8 b3 ff ff ff       	call   801885 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  8018d2:	83 c3 01             	add    $0x1,%ebx
  8018d5:	83 fb 20             	cmp    $0x20,%ebx
  8018d8:	75 f0                	jne    8018ca <_Z9close_allv+0xc>
		close(i);
}
  8018da:	83 c4 14             	add    $0x14,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 48             	sub    $0x48,%esp
  8018e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8018ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8018f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018f9:	00 
  8018fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 75 fd ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	85 c0                	test   %eax,%eax
  801910:	0f 88 ce 00 00 00    	js     8019e4 <_Z3dupii+0x104>
  801916:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80191d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80191e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801921:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801925:	89 34 24             	mov    %esi,(%esp)
  801928:	e8 54 fd ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	85 c0                	test   %eax,%eax
  801931:	0f 89 bc 00 00 00    	jns    8019f3 <_Z3dupii+0x113>
  801937:	e9 a8 00 00 00       	jmp    8019e4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	c1 e8 0c             	shr    $0xc,%eax
  801941:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801948:	f6 c2 01             	test   $0x1,%dl
  80194b:	74 32                	je     80197f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80194d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801954:	25 07 0e 00 00       	and    $0xe07,%eax
  801959:	89 44 24 10          	mov    %eax,0x10(%esp)
  80195d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801961:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801968:	00 
  801969:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80196d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801974:	e8 46 f7 ff ff       	call   8010bf <_Z12sys_page_mapiPviS_i>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	85 c0                	test   %eax,%eax
  80197d:	78 3e                	js     8019bd <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80197f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801982:	89 c2                	mov    %eax,%edx
  801984:	c1 ea 0c             	shr    $0xc,%edx
  801987:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80198e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801994:	89 54 24 10          	mov    %edx,0x10(%esp)
  801998:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80199b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80199f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019a6:	00 
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b2:	e8 08 f7 ff ff       	call   8010bf <_Z12sys_page_mapiPviS_i>
  8019b7:	89 c3                	mov    %eax,%ebx
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	79 25                	jns    8019e2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cb:	e8 4d f7 ff ff       	call   80111d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8019d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019db:	e8 3d f7 ff ff       	call   80111d <_Z14sys_page_unmapiPv>
	return r;
  8019e0:	eb 02                	jmp    8019e4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8019e2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019e4:	89 d8                	mov    %ebx,%eax
  8019e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019ef:	89 ec                	mov    %ebp,%esp
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8019f3:	89 34 24             	mov    %esi,(%esp)
  8019f6:	e8 8a fe ff ff       	call   801885 <_Z5closei>

	ova = fd2data(oldfd);
  8019fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 16 fd ff ff       	call   80171c <_Z7fd2dataP2Fd>
  801a06:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0b:	89 04 24             	mov    %eax,(%esp)
  801a0e:	e8 09 fd ff ff       	call   80171c <_Z7fd2dataP2Fd>
  801a13:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801a15:	89 d8                	mov    %ebx,%eax
  801a17:	c1 e8 16             	shr    $0x16,%eax
  801a1a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801a21:	a8 01                	test   $0x1,%al
  801a23:	0f 85 13 ff ff ff    	jne    80193c <_Z3dupii+0x5c>
  801a29:	e9 51 ff ff ff       	jmp    80197f <_Z3dupii+0x9f>

00801a2e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	53                   	push   %ebx
  801a32:	83 ec 24             	sub    $0x24,%esp
  801a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a3f:	00 
  801a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 32 fc ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 5f                	js     801ab2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 2b fd ff ff       	call   801792 <_Z10dev_lookupiPP3Dev>
  801a67:	85 c0                	test   %eax,%eax
  801a69:	79 4d                	jns    801ab8 <_Z4readiPvj+0x8a>
  801a6b:	eb 45                	jmp    801ab2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a6d:	a1 00 74 80 00       	mov    0x807400,%eax
  801a72:	8b 40 04             	mov    0x4(%eax),%eax
  801a75:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7d:	c7 04 24 aa 48 80 00 	movl   $0x8048aa,(%esp)
  801a84:	e8 d5 ea ff ff       	call   80055e <_Z7cprintfPKcz>
		return -E_INVAL;
  801a89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a8e:	eb 22                	jmp    801ab2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801a96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a9b:	85 d2                	test   %edx,%edx
  801a9d:	74 13                	je     801ab2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aad:	89 0c 24             	mov    %ecx,(%esp)
  801ab0:	ff d2                	call   *%edx
}
  801ab2:	83 c4 24             	add    $0x24,%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ab8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801abb:	8b 41 08             	mov    0x8(%ecx),%eax
  801abe:	83 e0 03             	and    $0x3,%eax
  801ac1:	83 f8 01             	cmp    $0x1,%eax
  801ac4:	75 ca                	jne    801a90 <_Z4readiPvj+0x62>
  801ac6:	eb a5                	jmp    801a6d <_Z4readiPvj+0x3f>

00801ac8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	57                   	push   %edi
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
  801ace:	83 ec 1c             	sub    $0x1c,%esp
  801ad1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ad4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801ad7:	85 f6                	test   %esi,%esi
  801ad9:	74 2f                	je     801b0a <_Z5readniPvj+0x42>
  801adb:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ae0:	89 f0                	mov    %esi,%eax
  801ae2:	29 d8                	sub    %ebx,%eax
  801ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 34 ff ff ff       	call   801a2e <_Z4readiPvj>
		if (m < 0)
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 13                	js     801b11 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 0d                	je     801b0f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801b02:	01 c3                	add    %eax,%ebx
  801b04:	39 de                	cmp    %ebx,%esi
  801b06:	77 d8                	ja     801ae0 <_Z5readniPvj+0x18>
  801b08:	eb 05                	jmp    801b0f <_Z5readniPvj+0x47>
  801b0a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801b0f:	89 d8                	mov    %ebx,%eax
}
  801b11:	83 c4 1c             	add    $0x1c,%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5f                   	pop    %edi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801b1f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b26:	00 
  801b27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	89 04 24             	mov    %eax,(%esp)
  801b34:	e8 48 fb ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 3c                	js     801b79 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	89 04 24             	mov    %eax,(%esp)
  801b4c:	e8 41 fc ff ff       	call   801792 <_Z10dev_lookupiPP3Dev>
  801b51:	85 c0                	test   %eax,%eax
  801b53:	79 26                	jns    801b7b <_Z5writeiPKvj+0x62>
  801b55:	eb 22                	jmp    801b79 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801b5d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801b62:	85 c9                	test   %ecx,%ecx
  801b64:	74 13                	je     801b79 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b66:	8b 45 10             	mov    0x10(%ebp),%eax
  801b69:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b74:	89 14 24             	mov    %edx,(%esp)
  801b77:	ff d1                	call   *%ecx
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801b7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801b83:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801b87:	74 f0                	je     801b79 <_Z5writeiPKvj+0x60>
  801b89:	eb cc                	jmp    801b57 <_Z5writeiPKvj+0x3e>

00801b8b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801b91:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b98:	00 
  801b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 d6 fa ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 0e                	js     801bbd <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 24             	sub    $0x24,%esp
  801bc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801bc9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801bd0:	00 
  801bd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 a1 fa ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 58                	js     801c3c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801be4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801bee:	8b 00                	mov    (%eax),%eax
  801bf0:	89 04 24             	mov    %eax,(%esp)
  801bf3:	e8 9a fb ff ff       	call   801792 <_Z10dev_lookupiPP3Dev>
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	79 46                	jns    801c42 <_Z9ftruncateii+0x83>
  801bfc:	eb 3e                	jmp    801c3c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801bfe:	a1 00 74 80 00       	mov    0x807400,%eax
  801c03:	8b 40 04             	mov    0x4(%eax),%eax
  801c06:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0e:	c7 04 24 e8 48 80 00 	movl   $0x8048e8,(%esp)
  801c15:	e8 44 e9 ff ff       	call   80055e <_Z7cprintfPKcz>
		return -E_INVAL;
  801c1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c1f:	eb 1b                	jmp    801c3c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801c27:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c2c:	85 d2                	test   %edx,%edx
  801c2e:	74 0c                	je     801c3c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	89 0c 24             	mov    %ecx,(%esp)
  801c3a:	ff d2                	call   *%edx
}
  801c3c:	83 c4 24             	add    $0x24,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c45:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801c49:	75 d6                	jne    801c21 <_Z9ftruncateii+0x62>
  801c4b:	eb b1                	jmp    801bfe <_Z9ftruncateii+0x3f>

00801c4d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	83 ec 24             	sub    $0x24,%esp
  801c54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c57:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c5e:	00 
  801c5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	89 04 24             	mov    %eax,(%esp)
  801c6c:	e8 10 fa ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 3e                	js     801cb3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c7f:	8b 00                	mov    (%eax),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 09 fb ff ff       	call   801792 <_Z10dev_lookupiPP3Dev>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	79 2c                	jns    801cb9 <_Z5fstatiP4Stat+0x6c>
  801c8d:	eb 24                	jmp    801cb3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c8f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c92:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801c99:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801ca0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ca6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cad:	89 04 24             	mov    %eax,(%esp)
  801cb0:	ff 52 14             	call   *0x14(%edx)
}
  801cb3:	83 c4 24             	add    $0x24,%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801cbc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801cc1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801cc5:	75 c8                	jne    801c8f <_Z5fstatiP4Stat+0x42>
  801cc7:	eb ea                	jmp    801cb3 <_Z5fstatiP4Stat+0x66>

00801cc9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 18             	sub    $0x18,%esp
  801ccf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cd2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cdc:	00 
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	89 04 24             	mov    %eax,(%esp)
  801ce3:	e8 d6 09 00 00       	call   8026be <_Z4openPKci>
  801ce8:	89 c3                	mov    %eax,%ebx
  801cea:	85 c0                	test   %eax,%eax
  801cec:	78 1b                	js     801d09 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf5:	89 1c 24             	mov    %ebx,(%esp)
  801cf8:	e8 50 ff ff ff       	call   801c4d <_Z5fstatiP4Stat>
  801cfd:	89 c6                	mov    %eax,%esi
	close(fd);
  801cff:	89 1c 24             	mov    %ebx,(%esp)
  801d02:	e8 7e fb ff ff       	call   801885 <_Z5closei>
	return r;
  801d07:	89 f3                	mov    %esi,%ebx
}
  801d09:	89 d8                	mov    %ebx,%eax
  801d0b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d0e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d11:	89 ec                	mov    %ebp,%esp
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
	...

00801d20 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801d23:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801d28:	85 d2                	test   %edx,%edx
  801d2a:	78 33                	js     801d5f <_ZL10inode_dataP5Inodei+0x3f>
  801d2c:	3b 50 08             	cmp    0x8(%eax),%edx
  801d2f:	7d 2e                	jge    801d5f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801d31:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801d37:	85 d2                	test   %edx,%edx
  801d39:	0f 49 ca             	cmovns %edx,%ecx
  801d3c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801d3f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801d43:	c1 e1 0c             	shl    $0xc,%ecx
  801d46:	89 d0                	mov    %edx,%eax
  801d48:	c1 f8 1f             	sar    $0x1f,%eax
  801d4b:	c1 e8 14             	shr    $0x14,%eax
  801d4e:	01 c2                	add    %eax,%edx
  801d50:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801d56:	29 c2                	sub    %eax,%edx
  801d58:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801d5f:	89 c8                	mov    %ecx,%eax
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801d66:	8b 48 08             	mov    0x8(%eax),%ecx
  801d69:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801d71:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  801d78:	60 80 00 
}
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    

00801d7d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801d83:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	74 08                	je     801d95 <_ZL9get_inodei+0x18>
  801d8d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801d93:	7e 20                	jle    801db5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801d95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d99:	c7 44 24 08 20 49 80 	movl   $0x804920,0x8(%esp)
  801da0:	00 
  801da1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801da8:	00 
  801da9:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  801db0:	e8 8b e6 ff ff       	call   800440 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801db5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801dbb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801dc1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801dc7:	85 d2                	test   %edx,%edx
  801dc9:	0f 48 d1             	cmovs  %ecx,%edx
  801dcc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801dcf:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801dd6:	c1 e0 0c             	shl    $0xc,%eax
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801de3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801de9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801dec:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801df2:	76 20                	jbe    801e14 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801df4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df8:	c7 44 24 08 5c 49 80 	movl   $0x80495c,0x8(%esp)
  801dff:	00 
  801e00:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801e07:	00 
  801e08:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  801e0f:	e8 2c e6 ff ff       	call   800440 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801e14:	83 fe 01             	cmp    $0x1,%esi
  801e17:	7e 08                	jle    801e21 <_ZL10bcache_ipcPvi+0x46>
  801e19:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801e1f:	7d 12                	jge    801e33 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801e21:	89 f3                	mov    %esi,%ebx
  801e23:	c1 e3 04             	shl    $0x4,%ebx
  801e26:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801e28:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801e2e:	c1 e6 0c             	shl    $0xc,%esi
  801e31:	eb 20                	jmp    801e53 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801e33:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e37:	c7 44 24 08 8c 49 80 	movl   $0x80498c,0x8(%esp)
  801e3e:	00 
  801e3f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801e46:	00 
  801e47:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  801e4e:	e8 ed e5 ff ff       	call   800440 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801e53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e5a:	00 
  801e5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e62:	00 
  801e63:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e67:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801e6e:	e8 fc 22 00 00       	call   80416f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801e73:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e7a:	00 
  801e7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e86:	e8 55 22 00 00       	call   8040e0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801e8b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801e8e:	74 c3                	je     801e53 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 28             	sub    $0x28,%esp
  801e9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ea0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ea3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ea6:	89 c7                	mov    %eax,%edi
  801ea8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801eaa:	c7 04 24 3d 21 80 00 	movl   $0x80213d,(%esp)
  801eb1:	e8 35 21 00 00       	call   803feb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801eb6:	89 f8                	mov    %edi,%eax
  801eb8:	e8 c0 fe ff ff       	call   801d7d <_ZL9get_inodei>
  801ebd:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801ebf:	ba 02 00 00 00       	mov    $0x2,%edx
  801ec4:	e8 12 ff ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	79 08                	jns    801ed5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801ecd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801ed3:	eb 2e                	jmp    801f03 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	75 1c                	jne    801ef5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801ed9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801edf:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801ee6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801ee9:	ba 06 00 00 00       	mov    $0x6,%edx
  801eee:	89 d8                	mov    %ebx,%eax
  801ef0:	e8 e6 fe ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801ef5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801efc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f03:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f06:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f0c:	89 ec                	mov    %ebp,%esp
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	57                   	push   %edi
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
  801f16:	83 ec 2c             	sub    $0x2c,%esp
  801f19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801f1c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801f1f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801f24:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801f2a:	0f 87 3d 01 00 00    	ja     80206d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801f30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f33:	8b 42 08             	mov    0x8(%edx),%eax
  801f36:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	0f 49 f0             	cmovns %eax,%esi
  801f41:	c1 fe 0c             	sar    $0xc,%esi
  801f44:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801f46:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801f49:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801f4f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801f52:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801f55:	0f 82 a6 00 00 00    	jb     802001 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801f5b:	39 fe                	cmp    %edi,%esi
  801f5d:	0f 8d f2 00 00 00    	jge    802055 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801f63:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801f67:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801f6a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801f6d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801f70:	83 3e 00             	cmpl   $0x0,(%esi)
  801f73:	75 77                	jne    801fec <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801f75:	ba 02 00 00 00       	mov    $0x2,%edx
  801f7a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801f7f:	e8 57 fe ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801f84:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801f8a:	83 f9 02             	cmp    $0x2,%ecx
  801f8d:	7e 43                	jle    801fd2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801f8f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801f94:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801f99:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801fa0:	74 29                	je     801fcb <_ZL14inode_set_sizeP5Inodej+0xbb>
  801fa2:	e9 ce 00 00 00       	jmp    802075 <_ZL14inode_set_sizeP5Inodej+0x165>
  801fa7:	89 c7                	mov    %eax,%edi
  801fa9:	0f b6 10             	movzbl (%eax),%edx
  801fac:	83 c0 01             	add    $0x1,%eax
  801faf:	84 d2                	test   %dl,%dl
  801fb1:	74 18                	je     801fcb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801fb3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801fb6:	ba 05 00 00 00       	mov    $0x5,%edx
  801fbb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801fc0:	e8 16 fe ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801fc5:	85 db                	test   %ebx,%ebx
  801fc7:	79 1e                	jns    801fe7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801fc9:	eb 07                	jmp    801fd2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801fcb:	83 c3 01             	add    $0x1,%ebx
  801fce:	39 d9                	cmp    %ebx,%ecx
  801fd0:	7f d5                	jg     801fa7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801fd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	e8 33 ff ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801fdd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801fe2:	e9 86 00 00 00       	jmp    80206d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801fe7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fea:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801fec:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801ff0:	83 c6 04             	add    $0x4,%esi
  801ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801ff9:	0f 8f 6e ff ff ff    	jg     801f6d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801fff:	eb 54                	jmp    802055 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802001:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802004:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802009:	83 f8 01             	cmp    $0x1,%eax
  80200c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80200f:	ba 02 00 00 00       	mov    $0x2,%edx
  802014:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802019:	e8 bd fd ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80201e:	39 f7                	cmp    %esi,%edi
  802020:	7d 24                	jge    802046 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802022:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802025:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802029:	8b 10                	mov    (%eax),%edx
  80202b:	85 d2                	test   %edx,%edx
  80202d:	74 0d                	je     80203c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80202f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80203c:	83 eb 01             	sub    $0x1,%ebx
  80203f:	83 e8 04             	sub    $0x4,%eax
  802042:	39 fb                	cmp    %edi,%ebx
  802044:	75 e3                	jne    802029 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802046:	ba 05 00 00 00       	mov    $0x5,%edx
  80204b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802050:	e8 86 fd ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802055:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80205b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80205e:	ba 04 00 00 00       	mov    $0x4,%edx
  802063:	e8 73 fd ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	return 0;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206d:	83 c4 2c             	add    $0x2c,%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802075:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80207c:	ba 05 00 00 00       	mov    $0x5,%edx
  802081:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802086:	e8 50 fd ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80208b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802090:	e9 52 ff ff ff       	jmp    801fe7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802095 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	53                   	push   %ebx
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80209e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  8020a4:	83 e8 01             	sub    $0x1,%eax
  8020a7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  8020ad:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  8020b1:	75 40                	jne    8020f3 <_ZL11inode_closeP5Inode+0x5e>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 3c                	jne    8020f3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8020b7:	ba 02 00 00 00       	mov    $0x2,%edx
  8020bc:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8020c1:	e8 15 fd ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  8020c6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  8020cb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  8020cf:	85 d2                	test   %edx,%edx
  8020d1:	74 07                	je     8020da <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  8020d3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  8020da:	83 c0 01             	add    $0x1,%eax
  8020dd:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8020e2:	75 e7                	jne    8020cb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8020e4:	ba 05 00 00 00       	mov    $0x5,%edx
  8020e9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8020ee:	e8 e8 fc ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8020f3:	ba 03 00 00 00       	mov    $0x3,%edx
  8020f8:	89 d8                	mov    %ebx,%eax
  8020fa:	e8 dc fc ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
}
  8020ff:	83 c4 04             	add    $0x4,%esp
  802102:	5b                   	pop    %ebx
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    

00802105 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 40 0c             	mov    0xc(%eax),%eax
  802112:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802115:	e8 7d fd ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 15                	js     802135 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802120:	8b 55 0c             	mov    0xc(%ebp),%edx
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	e8 e5 fd ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
  80212b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	e8 60 ff ff ff       	call   802095 <_ZL11inode_closeP5Inode>
	return r;
}
  802135:	89 d8                	mov    %ebx,%eax
  802137:	83 c4 14             	add    $0x14,%esp
  80213a:	5b                   	pop    %ebx
  80213b:	5d                   	pop    %ebp
  80213c:	c3                   	ret    

0080213d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	53                   	push   %ebx
  802141:	83 ec 14             	sub    $0x14,%esp
  802144:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802147:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802149:	89 c2                	mov    %eax,%edx
  80214b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802151:	78 32                	js     802185 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802153:	ba 00 00 00 00       	mov    $0x0,%edx
  802158:	e8 7e fc ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
  80215d:	85 c0                	test   %eax,%eax
  80215f:	74 1c                	je     80217d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802161:	c7 44 24 08 41 49 80 	movl   $0x804941,0x8(%esp)
  802168:	00 
  802169:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802170:	00 
  802171:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802178:	e8 c3 e2 ff ff       	call   800440 <_Z6_panicPKciS0_z>
    resume(utf);
  80217d:	89 1c 24             	mov    %ebx,(%esp)
  802180:	e8 3b 1f 00 00       	call   8040c0 <resume>
}
  802185:	83 c4 14             	add    $0x14,%esp
  802188:	5b                   	pop    %ebx
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 28             	sub    $0x28,%esp
  802191:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802194:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80219a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80219d:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021a0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021a3:	e8 ef fc ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	78 26                	js     8021d2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  8021ac:	83 c3 10             	add    $0x10,%ebx
  8021af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b3:	89 34 24             	mov    %esi,(%esp)
  8021b6:	e8 bf e9 ff ff       	call   800b7a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	e8 9e fb ff ff       	call   801d63 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	e8 c8 fe ff ff       	call   802095 <_ZL11inode_closeP5Inode>
	return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021d5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021d8:	89 ec                	mov    %ebp,%esp
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    

008021dc <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 24             	sub    $0x24,%esp
  8021e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8021e6:	89 1c 24             	mov    %ebx,(%esp)
  8021e9:	e8 d6 16 00 00       	call   8038c4 <_Z7pagerefPv>
  8021ee:	89 c2                	mov    %eax,%edx
        return 0;
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8021f5:	83 fa 01             	cmp    $0x1,%edx
  8021f8:	7f 1e                	jg     802218 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8021fa:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021fd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802200:	e8 92 fc ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  802205:	85 c0                	test   %eax,%eax
  802207:	78 0f                	js     802218 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802213:	e8 7d fe ff ff       	call   802095 <_ZL11inode_closeP5Inode>
}
  802218:	83 c4 24             	add    $0x24,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 3c             	sub    $0x3c,%esp
  802227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80222a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80222d:	8b 43 04             	mov    0x4(%ebx),%eax
  802230:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802233:	8b 43 0c             	mov    0xc(%ebx),%eax
  802236:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802239:	e8 59 fc ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  80223e:	85 c0                	test   %eax,%eax
  802240:	0f 88 8c 00 00 00    	js     8022d2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802246:	8b 53 04             	mov    0x4(%ebx),%edx
  802249:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80224f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802255:	29 d7                	sub    %edx,%edi
  802257:	39 f7                	cmp    %esi,%edi
  802259:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80225c:	85 ff                	test   %edi,%edi
  80225e:	74 16                	je     802276 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802260:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802266:	3b 50 08             	cmp    0x8(%eax),%edx
  802269:	76 6f                	jbe    8022da <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80226b:	e8 a0 fc ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802270:	85 c0                	test   %eax,%eax
  802272:	79 66                	jns    8022da <_ZL13devfile_writeP2FdPKvj+0xbc>
  802274:	eb 4e                	jmp    8022c4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802276:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80227c:	76 24                	jbe    8022a2 <_ZL13devfile_writeP2FdPKvj+0x84>
  80227e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802280:	8b 53 04             	mov    0x4(%ebx),%edx
  802283:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80228c:	3b 50 08             	cmp    0x8(%eax),%edx
  80228f:	0f 86 83 00 00 00    	jbe    802318 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802295:	e8 76 fc ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80229a:	85 c0                	test   %eax,%eax
  80229c:	79 7a                	jns    802318 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	eb 22                	jmp    8022c4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8022a2:	85 f6                	test   %esi,%esi
  8022a4:	74 1e                	je     8022c4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8022a6:	89 f2                	mov    %esi,%edx
  8022a8:	03 53 04             	add    0x4(%ebx),%edx
  8022ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ae:	3b 50 08             	cmp    0x8(%eax),%edx
  8022b1:	0f 86 b8 00 00 00    	jbe    80236f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  8022b7:	e8 54 fc ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	0f 89 ab 00 00 00    	jns    80236f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  8022c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c7:	e8 c9 fd ff ff       	call   802095 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8022cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8022cf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8022d2:	83 c4 3c             	add    $0x3c,%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5f                   	pop    %edi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8022da:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8022dc:	8b 53 04             	mov    0x4(%ebx),%edx
  8022df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e2:	e8 39 fa ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  8022e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8022ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022f8:	89 04 24             	mov    %eax,(%esp)
  8022fb:	e8 97 ea ff ff       	call   800d97 <memcpy>
        fd->fd_offset += n2;
  802300:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802303:	ba 04 00 00 00       	mov    $0x4,%edx
  802308:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80230b:	e8 cb fa ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802310:	01 7d 0c             	add    %edi,0xc(%ebp)
  802313:	e9 5e ff ff ff       	jmp    802276 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802318:	8b 53 04             	mov    0x4(%ebx),%edx
  80231b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231e:	e8 fd f9 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  802323:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802325:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80232c:	00 
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	89 34 24             	mov    %esi,(%esp)
  802337:	e8 5b ea ff ff       	call   800d97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80233c:	ba 04 00 00 00       	mov    $0x4,%edx
  802341:	89 f0                	mov    %esi,%eax
  802343:	e8 93 fa ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802348:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80234e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802355:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80235c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802362:	0f 87 18 ff ff ff    	ja     802280 <_ZL13devfile_writeP2FdPKvj+0x62>
  802368:	89 fe                	mov    %edi,%esi
  80236a:	e9 33 ff ff ff       	jmp    8022a2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80236f:	8b 53 04             	mov    0x4(%ebx),%edx
  802372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802375:	e8 a6 f9 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  80237a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80237c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802380:	8b 45 0c             	mov    0xc(%ebp),%eax
  802383:	89 44 24 04          	mov    %eax,0x4(%esp)
  802387:	89 3c 24             	mov    %edi,(%esp)
  80238a:	e8 08 ea ff ff       	call   800d97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80238f:	ba 04 00 00 00       	mov    $0x4,%edx
  802394:	89 f8                	mov    %edi,%eax
  802396:	e8 40 fa ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80239b:	01 73 04             	add    %esi,0x4(%ebx)
  80239e:	e9 21 ff ff ff       	jmp    8022c4 <_ZL13devfile_writeP2FdPKvj+0xa6>

008023a3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	57                   	push   %edi
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 3c             	sub    $0x3c,%esp
  8023ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8023af:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8023b2:	8b 43 04             	mov    0x4(%ebx),%eax
  8023b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8023b8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8023bb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8023be:	e8 d4 fa ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	0f 88 d3 00 00 00    	js     80249e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8023cb:	8b 73 04             	mov    0x4(%ebx),%esi
  8023ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8023d4:	8b 50 08             	mov    0x8(%eax),%edx
  8023d7:	29 f2                	sub    %esi,%edx
  8023d9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8023dc:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8023df:	89 f2                	mov    %esi,%edx
  8023e1:	e8 3a f9 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	0f 84 a2 00 00 00    	je     802490 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8023ee:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8023f4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8023fa:	29 f2                	sub    %esi,%edx
  8023fc:	39 d7                	cmp    %edx,%edi
  8023fe:	0f 46 d7             	cmovbe %edi,%edx
  802401:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802404:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802406:	01 d6                	add    %edx,%esi
  802408:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80240b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802413:	8b 45 0c             	mov    0xc(%ebp),%eax
  802416:	89 04 24             	mov    %eax,(%esp)
  802419:	e8 79 e9 ff ff       	call   800d97 <memcpy>
    buf = (void *)((char *)buf + n2);
  80241e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802421:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802424:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80242a:	76 3e                	jbe    80246a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80242c:	8b 53 04             	mov    0x4(%ebx),%edx
  80242f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802432:	e8 e9 f8 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  802437:	85 c0                	test   %eax,%eax
  802439:	74 55                	je     802490 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80243b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802442:	00 
  802443:	89 44 24 04          	mov    %eax,0x4(%esp)
  802447:	89 34 24             	mov    %esi,(%esp)
  80244a:	e8 48 e9 ff ff       	call   800d97 <memcpy>
        n -= PGSIZE;
  80244f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802455:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80245b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802462:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802468:	77 c2                	ja     80242c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80246a:	85 ff                	test   %edi,%edi
  80246c:	74 22                	je     802490 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80246e:	8b 53 04             	mov    0x4(%ebx),%edx
  802471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802474:	e8 a7 f8 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 13                	je     802490 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80247d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802481:	89 44 24 04          	mov    %eax,0x4(%esp)
  802485:	89 34 24             	mov    %esi,(%esp)
  802488:	e8 0a e9 ff ff       	call   800d97 <memcpy>
        fd->fd_offset += n;
  80248d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802493:	e8 fd fb ff ff       	call   802095 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802498:	8b 43 04             	mov    0x4(%ebx),%eax
  80249b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80249e:	83 c4 3c             	add    $0x3c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    

008024a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	57                   	push   %edi
  8024aa:	56                   	push   %esi
  8024ab:	53                   	push   %ebx
  8024ac:	83 ec 4c             	sub    $0x4c,%esp
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8024b4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8024b7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8024bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8024c6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8024c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ce:	e8 c4 f9 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  8024d3:	89 c7                	mov    %eax,%edi
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	0f 88 cd 01 00 00    	js     8026aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8024dd:	89 f3                	mov    %esi,%ebx
  8024df:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8024e2:	75 08                	jne    8024ec <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8024e4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8024e7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8024ea:	74 f8                	je     8024e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8024ec:	0f b6 03             	movzbl (%ebx),%eax
  8024ef:	3c 2f                	cmp    $0x2f,%al
  8024f1:	74 16                	je     802509 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8024f3:	84 c0                	test   %al,%al
  8024f5:	74 12                	je     802509 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8024f7:	89 da                	mov    %ebx,%edx
		++path;
  8024f9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8024fc:	0f b6 02             	movzbl (%edx),%eax
  8024ff:	3c 2f                	cmp    $0x2f,%al
  802501:	74 08                	je     80250b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802503:	84 c0                	test   %al,%al
  802505:	75 f2                	jne    8024f9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802507:	eb 02                	jmp    80250b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802509:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80250b:	89 d0                	mov    %edx,%eax
  80250d:	29 d8                	sub    %ebx,%eax
  80250f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802512:	0f b6 02             	movzbl (%edx),%eax
  802515:	89 d6                	mov    %edx,%esi
  802517:	3c 2f                	cmp    $0x2f,%al
  802519:	75 0a                	jne    802525 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80251b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80251e:	0f b6 06             	movzbl (%esi),%eax
  802521:	3c 2f                	cmp    $0x2f,%al
  802523:	74 f6                	je     80251b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802525:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802529:	75 1b                	jne    802546 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802531:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802533:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802536:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80253c:	bf 00 00 00 00       	mov    $0x0,%edi
  802541:	e9 64 01 00 00       	jmp    8026aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802546:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80254a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80254e:	74 06                	je     802556 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802550:	84 c0                	test   %al,%al
  802552:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802556:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802559:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80255c:	83 3a 02             	cmpl   $0x2,(%edx)
  80255f:	0f 85 f4 00 00 00    	jne    802659 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802565:	89 d0                	mov    %edx,%eax
  802567:	8b 52 08             	mov    0x8(%edx),%edx
  80256a:	85 d2                	test   %edx,%edx
  80256c:	7e 78                	jle    8025e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80256e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802575:	bf 00 00 00 00       	mov    $0x0,%edi
  80257a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80257d:	89 fb                	mov    %edi,%ebx
  80257f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802582:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802584:	89 da                	mov    %ebx,%edx
  802586:	89 f0                	mov    %esi,%eax
  802588:	e8 93 f7 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  80258d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80258f:	83 38 00             	cmpl   $0x0,(%eax)
  802592:	74 26                	je     8025ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802594:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802597:	3b 50 04             	cmp    0x4(%eax),%edx
  80259a:	75 33                	jne    8025cf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80259c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a7:	8d 47 08             	lea    0x8(%edi),%eax
  8025aa:	89 04 24             	mov    %eax,(%esp)
  8025ad:	e8 26 e8 ff ff       	call   800dd8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 84 fa 00 00 00    	je     8026b4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8025ba:	83 3f 00             	cmpl   $0x0,(%edi)
  8025bd:	75 10                	jne    8025cf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8025bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8025c3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8025c6:	84 c0                	test   %al,%al
  8025c8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8025cc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8025cf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8025d5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8025d7:	8b 56 08             	mov    0x8(%esi),%edx
  8025da:	39 d0                	cmp    %edx,%eax
  8025dc:	7c a6                	jl     802584 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8025de:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8025e1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8025e4:	eb 07                	jmp    8025ed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8025e6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8025ed:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8025f1:	74 6d                	je     802660 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8025f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8025f7:	75 24                	jne    80261d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8025f9:	83 ea 80             	sub    $0xffffff80,%edx
  8025fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ff:	e8 0c f9 ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802604:	85 c0                	test   %eax,%eax
  802606:	0f 88 90 00 00 00    	js     80269c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80260c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80260f:	8b 50 08             	mov    0x8(%eax),%edx
  802612:	83 c2 80             	add    $0xffffff80,%edx
  802615:	e8 06 f7 ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  80261a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80261d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802624:	00 
  802625:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80262c:	00 
  80262d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802630:	89 14 24             	mov    %edx,(%esp)
  802633:	e8 89 e6 ff ff       	call   800cc1 <memset>
	empty->de_namelen = namelen;
  802638:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80263b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80263e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802641:	89 54 24 08          	mov    %edx,0x8(%esp)
  802645:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802649:	83 c0 08             	add    $0x8,%eax
  80264c:	89 04 24             	mov    %eax,(%esp)
  80264f:	e8 43 e7 ff ff       	call   800d97 <memcpy>
	*de_store = empty;
  802654:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802657:	eb 5e                	jmp    8026b7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802659:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80265e:	eb 42                	jmp    8026a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802660:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802665:	eb 3b                	jmp    8026a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80266d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80266f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802672:	89 38                	mov    %edi,(%eax)
			return 0;
  802674:	bf 00 00 00 00       	mov    $0x0,%edi
  802679:	eb 2f                	jmp    8026aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80267b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80267e:	8b 07                	mov    (%edi),%eax
  802680:	e8 12 f8 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  802685:	85 c0                	test   %eax,%eax
  802687:	78 17                	js     8026a0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	e8 04 fa ff ff       	call   802095 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802694:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802697:	e9 41 fe ff ff       	jmp    8024dd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80269c:	89 c7                	mov    %eax,%edi
  80269e:	eb 02                	jmp    8026a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8026a0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8026a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a5:	e8 eb f9 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
	return r;
}
  8026aa:	89 f8                	mov    %edi,%eax
  8026ac:	83 c4 4c             	add    $0x4c,%esp
  8026af:	5b                   	pop    %ebx
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    
  8026b4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8026b7:	80 3e 00             	cmpb   $0x0,(%esi)
  8026ba:	75 bf                	jne    80267b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8026bc:	eb a9                	jmp    802667 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008026be <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	53                   	push   %ebx
  8026c4:	83 ec 3c             	sub    $0x3c,%esp
  8026c7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8026ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8026cd:	89 04 24             	mov    %eax,(%esp)
  8026d0:	e8 62 f0 ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  8026d5:	89 c3                	mov    %eax,%ebx
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	0f 88 16 02 00 00    	js     8028f5 <_Z4openPKci+0x237>
  8026df:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026e6:	00 
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f5:	e8 66 e9 ff ff       	call   801060 <_Z14sys_page_allociPvi>
  8026fa:	89 c3                	mov    %eax,%ebx
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	85 db                	test   %ebx,%ebx
  802703:	0f 88 ec 01 00 00    	js     8028f5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802709:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80270d:	0f 84 ec 01 00 00    	je     8028ff <_Z4openPKci+0x241>
  802713:	83 c0 01             	add    $0x1,%eax
  802716:	83 f8 78             	cmp    $0x78,%eax
  802719:	75 ee                	jne    802709 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80271b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802720:	e9 b9 01 00 00       	jmp    8028de <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802725:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802728:	81 e7 00 01 00 00    	and    $0x100,%edi
  80272e:	89 3c 24             	mov    %edi,(%esp)
  802731:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802734:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802737:	89 f0                	mov    %esi,%eax
  802739:	e8 68 fd ff ff       	call   8024a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80273e:	89 c3                	mov    %eax,%ebx
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 85 96 01 00 00    	jne    8028de <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802748:	85 ff                	test   %edi,%edi
  80274a:	75 41                	jne    80278d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80274c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80274f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802754:	75 08                	jne    80275e <_Z4openPKci+0xa0>
            fileino = dirino;
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80275c:	eb 14                	jmp    802772 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80275e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802761:	8b 00                	mov    (%eax),%eax
  802763:	e8 2f f7 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  802768:	89 c3                	mov    %eax,%ebx
  80276a:	85 c0                	test   %eax,%eax
  80276c:	0f 88 5d 01 00 00    	js     8028cf <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802772:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802775:	83 38 02             	cmpl   $0x2,(%eax)
  802778:	0f 85 d2 00 00 00    	jne    802850 <_Z4openPKci+0x192>
  80277e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802782:	0f 84 c8 00 00 00    	je     802850 <_Z4openPKci+0x192>
  802788:	e9 38 01 00 00       	jmp    8028c5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80278d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802794:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80279b:	0f 8e a8 00 00 00    	jle    802849 <_Z4openPKci+0x18b>
  8027a1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8027a6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8027a9:	89 f8                	mov    %edi,%eax
  8027ab:	e8 e7 f6 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  8027b0:	89 c3                	mov    %eax,%ebx
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	0f 88 15 01 00 00    	js     8028cf <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8027ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027bd:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8027c1:	75 68                	jne    80282b <_Z4openPKci+0x16d>
  8027c3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8027ca:	75 5f                	jne    80282b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8027cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8027cf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8027d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027d8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8027df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8027e6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8027ed:	00 
  8027ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027f5:	00 
  8027f6:	83 c0 0c             	add    $0xc,%eax
  8027f9:	89 04 24             	mov    %eax,(%esp)
  8027fc:	e8 c0 e4 ff ff       	call   800cc1 <memset>
        de->de_inum = fileino->i_inum;
  802801:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802804:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80280a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80280d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80280f:	ba 04 00 00 00       	mov    $0x4,%edx
  802814:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802817:	e8 bf f5 ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80281c:	ba 04 00 00 00       	mov    $0x4,%edx
  802821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802824:	e8 b2 f5 ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
  802829:	eb 25                	jmp    802850 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80282b:	e8 65 f8 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802830:	83 c7 01             	add    $0x1,%edi
  802833:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802839:	0f 8c 67 ff ff ff    	jl     8027a6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80283f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802844:	e9 86 00 00 00       	jmp    8028cf <_Z4openPKci+0x211>
  802849:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80284e:	eb 7f                	jmp    8028cf <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802850:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802857:	74 0d                	je     802866 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802859:	ba 00 00 00 00       	mov    $0x0,%edx
  80285e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802861:	e8 aa f6 ff ff       	call   801f10 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802866:	8b 15 04 60 80 00    	mov    0x806004,%edx
  80286c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802874:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80287b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802881:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802884:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80288a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80288d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802891:	83 c0 10             	add    $0x10,%eax
  802894:	89 04 24             	mov    %eax,(%esp)
  802897:	e8 de e2 ff ff       	call   800b7a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80289c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80289f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  8028a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a9:	e8 e7 f7 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  8028ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028b1:	e8 df f7 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  8028b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b9:	89 04 24             	mov    %eax,(%esp)
  8028bc:	e8 13 ee ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  8028c1:	89 c3                	mov    %eax,%ebx
  8028c3:	eb 30                	jmp    8028f5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  8028c5:	e8 cb f7 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  8028ca:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  8028cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d2:	e8 be f7 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
  8028d7:	eb 05                	jmp    8028de <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8028d9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  8028de:	a1 00 74 80 00       	mov    0x807400,%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028ed:	89 04 24             	mov    %eax,(%esp)
  8028f0:	e8 28 e8 ff ff       	call   80111d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  8028f5:	89 d8                	mov    %ebx,%eax
  8028f7:	83 c4 3c             	add    $0x3c,%esp
  8028fa:	5b                   	pop    %ebx
  8028fb:	5e                   	pop    %esi
  8028fc:	5f                   	pop    %edi
  8028fd:	5d                   	pop    %ebp
  8028fe:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  8028ff:	83 f8 78             	cmp    $0x78,%eax
  802902:	0f 85 1d fe ff ff    	jne    802725 <_Z4openPKci+0x67>
  802908:	eb cf                	jmp    8028d9 <_Z4openPKci+0x21b>

0080290a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	53                   	push   %ebx
  80290e:	83 ec 24             	sub    $0x24,%esp
  802911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802914:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	e8 78 f5 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  80291f:	85 c0                	test   %eax,%eax
  802921:	78 27                	js     80294a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802923:	c7 44 24 04 54 49 80 	movl   $0x804954,0x4(%esp)
  80292a:	00 
  80292b:	89 1c 24             	mov    %ebx,(%esp)
  80292e:	e8 47 e2 ff ff       	call   800b7a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802933:	89 da                	mov    %ebx,%edx
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	e8 26 f4 ff ff       	call   801d63 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	e8 50 f7 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
	return 0;
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294a:	83 c4 24             	add    $0x24,%esp
  80294d:	5b                   	pop    %ebx
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    

00802950 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	53                   	push   %ebx
  802954:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802957:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80295e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802961:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	e8 3a fb ff ff       	call   8024a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80296c:	89 c3                	mov    %eax,%ebx
  80296e:	85 c0                	test   %eax,%eax
  802970:	78 5f                	js     8029d1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802972:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	e8 18 f5 ff ff       	call   801e97 <_ZL10inode_openiPP5Inode>
  80297f:	89 c3                	mov    %eax,%ebx
  802981:	85 c0                	test   %eax,%eax
  802983:	78 44                	js     8029c9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802985:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	83 38 02             	cmpl   $0x2,(%eax)
  802990:	74 2f                	je     8029c1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  8029a2:	ba 04 00 00 00       	mov    $0x4,%edx
  8029a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029aa:	e8 2c f4 ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  8029af:	ba 04 00 00 00       	mov    $0x4,%edx
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	e8 1f f4 ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
	r = 0;
  8029bc:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	e8 cc f6 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	e8 c4 f6 ff ff       	call   802095 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8029d1:	89 d8                	mov    %ebx,%eax
  8029d3:	83 c4 24             	add    $0x24,%esp
  8029d6:	5b                   	pop    %ebx
  8029d7:	5d                   	pop    %ebp
  8029d8:	c3                   	ret    

008029d9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	5d                   	pop    %ebp
  8029e2:	c3                   	ret    

008029e3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
  8029e6:	57                   	push   %edi
  8029e7:	56                   	push   %esi
  8029e8:	53                   	push   %ebx
  8029e9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  8029ef:	c7 04 24 3d 21 80 00 	movl   $0x80213d,(%esp)
  8029f6:	e8 f0 15 00 00       	call   803feb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8029fb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802a00:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802a05:	74 28                	je     802a2f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802a07:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802a0e:	4a 
  802a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a13:	c7 44 24 08 bc 49 80 	movl   $0x8049bc,0x8(%esp)
  802a1a:	00 
  802a1b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802a22:	00 
  802a23:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802a2a:	e8 11 da ff ff       	call   800440 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802a2f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802a34:	83 f8 03             	cmp    $0x3,%eax
  802a37:	7f 1c                	jg     802a55 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802a39:	c7 44 24 08 f0 49 80 	movl   $0x8049f0,0x8(%esp)
  802a40:	00 
  802a41:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802a48:	00 
  802a49:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802a50:	e8 eb d9 ff ff       	call   800440 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802a55:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802a5b:	85 d2                	test   %edx,%edx
  802a5d:	7f 1c                	jg     802a7b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802a5f:	c7 44 24 08 20 4a 80 	movl   $0x804a20,0x8(%esp)
  802a66:	00 
  802a67:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802a6e:	00 
  802a6f:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802a76:	e8 c5 d9 ff ff       	call   800440 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802a7b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802a81:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802a87:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802a8d:	85 c9                	test   %ecx,%ecx
  802a8f:	0f 48 cb             	cmovs  %ebx,%ecx
  802a92:	c1 f9 0c             	sar    $0xc,%ecx
  802a95:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802a99:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802a9f:	39 c8                	cmp    %ecx,%eax
  802aa1:	7c 13                	jl     802ab6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	7f 3d                	jg     802ae4 <_Z4fsckv+0x101>
  802aa7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802aae:	00 00 00 
  802ab1:	e9 ac 00 00 00       	jmp    802b62 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802ab6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802abc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802ac0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ac4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802ac8:	c7 44 24 08 50 4a 80 	movl   $0x804a50,0x8(%esp)
  802acf:	00 
  802ad0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802ad7:	00 
  802ad8:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802adf:	e8 5c d9 ff ff       	call   800440 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802ae4:	be 00 20 00 50       	mov    $0x50002000,%esi
  802ae9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802af0:	00 00 00 
  802af3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802af8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802afe:	39 df                	cmp    %ebx,%edi
  802b00:	7e 27                	jle    802b29 <_Z4fsckv+0x146>
  802b02:	0f b6 06             	movzbl (%esi),%eax
  802b05:	84 c0                	test   %al,%al
  802b07:	74 4b                	je     802b54 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802b09:	0f be c0             	movsbl %al,%eax
  802b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b14:	c7 04 24 94 4a 80 00 	movl   $0x804a94,(%esp)
  802b1b:	e8 3e da ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802b20:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b27:	eb 2b                	jmp    802b54 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802b29:	0f b6 06             	movzbl (%esi),%eax
  802b2c:	3c 01                	cmp    $0x1,%al
  802b2e:	76 24                	jbe    802b54 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802b30:	0f be c0             	movsbl %al,%eax
  802b33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b37:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b3b:	c7 04 24 c8 4a 80 00 	movl   $0x804ac8,(%esp)
  802b42:	e8 17 da ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802b47:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802b4e:	80 3e 00             	cmpb   $0x0,(%esi)
  802b51:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802b54:	83 c3 01             	add    $0x1,%ebx
  802b57:	83 c6 01             	add    $0x1,%esi
  802b5a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802b60:	7f 9c                	jg     802afe <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802b62:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802b69:	0f 8e e1 02 00 00    	jle    802e50 <_Z4fsckv+0x46d>
  802b6f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802b76:	00 00 00 
		struct Inode *ino = get_inode(i);
  802b79:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802b7f:	e8 f9 f1 ff ff       	call   801d7d <_ZL9get_inodei>
  802b84:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802b8a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802b8e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802b95:	75 22                	jne    802bb9 <_Z4fsckv+0x1d6>
  802b97:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802b9e:	0f 84 a9 06 00 00    	je     80324d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba9:	e8 2d f2 ff ff       	call   801ddb <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	74 3a                	je     802bec <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802bb2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802bb9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802bbf:	8b 02                	mov    (%edx),%eax
  802bc1:	83 f8 01             	cmp    $0x1,%eax
  802bc4:	74 26                	je     802bec <_Z4fsckv+0x209>
  802bc6:	83 f8 02             	cmp    $0x2,%eax
  802bc9:	74 21                	je     802bec <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802bcb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bcf:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802bd5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bd9:	c7 04 24 f4 4a 80 00 	movl   $0x804af4,(%esp)
  802be0:	e8 79 d9 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802be5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802bec:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802bf3:	75 3f                	jne    802c34 <_Z4fsckv+0x251>
  802bf5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802bfb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802bff:	75 15                	jne    802c16 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802c01:	c7 04 24 18 4b 80 00 	movl   $0x804b18,(%esp)
  802c08:	e8 51 d9 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802c0d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c14:	eb 1e                	jmp    802c34 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802c16:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c1c:	83 3a 02             	cmpl   $0x2,(%edx)
  802c1f:	74 13                	je     802c34 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802c21:	c7 04 24 4c 4b 80 00 	movl   $0x804b4c,(%esp)
  802c28:	e8 31 d9 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802c2d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802c34:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802c39:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802c40:	0f 84 93 00 00 00    	je     802cd9 <_Z4fsckv+0x2f6>
  802c46:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802c4c:	8b 41 08             	mov    0x8(%ecx),%eax
  802c4f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802c54:	7e 23                	jle    802c79 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802c56:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c5a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c64:	c7 04 24 7c 4b 80 00 	movl   $0x804b7c,(%esp)
  802c6b:	e8 ee d8 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802c70:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c77:	eb 09                	jmp    802c82 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802c79:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802c80:	74 4b                	je     802ccd <_Z4fsckv+0x2ea>
  802c82:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c88:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802c8e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802c94:	74 23                	je     802cb9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802c96:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c9a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ca4:	c7 04 24 a0 4b 80 00 	movl   $0x804ba0,(%esp)
  802cab:	e8 ae d8 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802cb0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802cb7:	eb 09                	jmp    802cc2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802cb9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802cc0:	74 12                	je     802cd4 <_Z4fsckv+0x2f1>
  802cc2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802cc8:	8b 78 08             	mov    0x8(%eax),%edi
  802ccb:	eb 0c                	jmp    802cd9 <_Z4fsckv+0x2f6>
  802ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd2:	eb 05                	jmp    802cd9 <_Z4fsckv+0x2f6>
  802cd4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802cd9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802cde:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ce4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802ce8:	89 d8                	mov    %ebx,%eax
  802cea:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802ced:	39 c7                	cmp    %eax,%edi
  802cef:	7e 2b                	jle    802d1c <_Z4fsckv+0x339>
  802cf1:	85 f6                	test   %esi,%esi
  802cf3:	75 27                	jne    802d1c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802cf5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cf9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802cfd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d07:	c7 04 24 c4 4b 80 00 	movl   $0x804bc4,(%esp)
  802d0e:	e8 4b d8 ff ff       	call   80055e <_Z7cprintfPKcz>
				++errors;
  802d13:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d1a:	eb 36                	jmp    802d52 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802d1c:	39 f8                	cmp    %edi,%eax
  802d1e:	7c 32                	jl     802d52 <_Z4fsckv+0x36f>
  802d20:	85 f6                	test   %esi,%esi
  802d22:	74 2e                	je     802d52 <_Z4fsckv+0x36f>
  802d24:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802d2b:	74 25                	je     802d52 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d35:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d3f:	c7 04 24 08 4c 80 00 	movl   $0x804c08,(%esp)
  802d46:	e8 13 d8 ff ff       	call   80055e <_Z7cprintfPKcz>
				++errors;
  802d4b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802d52:	85 f6                	test   %esi,%esi
  802d54:	0f 84 a0 00 00 00    	je     802dfa <_Z4fsckv+0x417>
  802d5a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802d61:	0f 84 93 00 00 00    	je     802dfa <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802d67:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802d6d:	7e 27                	jle    802d96 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802d6f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802d73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d77:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802d7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d81:	c7 04 24 4c 4c 80 00 	movl   $0x804c4c,(%esp)
  802d88:	e8 d1 d7 ff ff       	call   80055e <_Z7cprintfPKcz>
					++errors;
  802d8d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d94:	eb 64                	jmp    802dfa <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802d96:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802d9d:	3c 01                	cmp    $0x1,%al
  802d9f:	75 27                	jne    802dc8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802da1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802da5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802da9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802daf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802db3:	c7 04 24 90 4c 80 00 	movl   $0x804c90,(%esp)
  802dba:	e8 9f d7 ff ff       	call   80055e <_Z7cprintfPKcz>
					++errors;
  802dbf:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802dc6:	eb 32                	jmp    802dfa <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802dc8:	3c ff                	cmp    $0xff,%al
  802dca:	75 27                	jne    802df3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802dcc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802dd0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802dd4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dde:	c7 04 24 cc 4c 80 00 	movl   $0x804ccc,(%esp)
  802de5:	e8 74 d7 ff ff       	call   80055e <_Z7cprintfPKcz>
					++errors;
  802dea:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802df1:	eb 07                	jmp    802dfa <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802df3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802dfa:	83 c3 01             	add    $0x1,%ebx
  802dfd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802e03:	0f 85 d5 fe ff ff    	jne    802cde <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802e09:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802e10:	0f 94 c0             	sete   %al
  802e13:	0f b6 c0             	movzbl %al,%eax
  802e16:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e1c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802e22:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802e29:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802e30:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802e37:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802e3e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e44:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802e4a:	0f 8f 29 fd ff ff    	jg     802b79 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802e50:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802e57:	0f 8e 7f 03 00 00    	jle    8031dc <_Z4fsckv+0x7f9>
  802e5d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802e62:	89 f0                	mov    %esi,%eax
  802e64:	e8 14 ef ff ff       	call   801d7d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802e69:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e70:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802e77:	c1 e2 08             	shl    $0x8,%edx
  802e7a:	09 ca                	or     %ecx,%edx
  802e7c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802e83:	c1 e1 10             	shl    $0x10,%ecx
  802e86:	09 ca                	or     %ecx,%edx
  802e88:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802e8f:	83 e1 7f             	and    $0x7f,%ecx
  802e92:	c1 e1 18             	shl    $0x18,%ecx
  802e95:	09 d1                	or     %edx,%ecx
  802e97:	74 0e                	je     802ea7 <_Z4fsckv+0x4c4>
  802e99:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802ea0:	78 05                	js     802ea7 <_Z4fsckv+0x4c4>
  802ea2:	83 38 02             	cmpl   $0x2,(%eax)
  802ea5:	74 1f                	je     802ec6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ea7:	83 c6 01             	add    $0x1,%esi
  802eaa:	a1 08 10 00 50       	mov    0x50001008,%eax
  802eaf:	39 f0                	cmp    %esi,%eax
  802eb1:	7f af                	jg     802e62 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802eb3:	bb 01 00 00 00       	mov    $0x1,%ebx
  802eb8:	83 f8 01             	cmp    $0x1,%eax
  802ebb:	0f 8f ad 02 00 00    	jg     80316e <_Z4fsckv+0x78b>
  802ec1:	e9 16 03 00 00       	jmp    8031dc <_Z4fsckv+0x7f9>
  802ec6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802ec8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802ecf:	8b 40 08             	mov    0x8(%eax),%eax
  802ed2:	a8 7f                	test   $0x7f,%al
  802ed4:	74 23                	je     802ef9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802ed6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802edd:	00 
  802ede:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ee2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ee6:	c7 04 24 08 4d 80 00 	movl   $0x804d08,(%esp)
  802eed:	e8 6c d6 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  802ef2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ef9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802f00:	00 00 00 
  802f03:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802f09:	e9 3d 02 00 00       	jmp    80314b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802f0e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f14:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f1a:	e8 01 ee ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
  802f1f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802f21:	83 38 00             	cmpl   $0x0,(%eax)
  802f24:	0f 84 15 02 00 00    	je     80313f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f30:	83 fa 76             	cmp    $0x76,%edx
  802f33:	76 27                	jbe    802f5c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802f35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f39:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802f3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f43:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f47:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802f4e:	e8 0b d6 ff ff       	call   80055e <_Z7cprintfPKcz>
				++errors;
  802f53:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f5a:	eb 28                	jmp    802f84 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802f5c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802f61:	74 21                	je     802f84 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802f63:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f69:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f6d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f71:	c7 04 24 68 4d 80 00 	movl   $0x804d68,(%esp)
  802f78:	e8 e1 d5 ff ff       	call   80055e <_Z7cprintfPKcz>
				++errors;
  802f7d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802f84:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802f8b:	00 
  802f8c:	8d 43 08             	lea    0x8(%ebx),%eax
  802f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f93:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802f99:	89 0c 24             	mov    %ecx,(%esp)
  802f9c:	e8 f6 dd ff ff       	call   800d97 <memcpy>
  802fa1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802fa5:	bf 77 00 00 00       	mov    $0x77,%edi
  802faa:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802fae:	85 ff                	test   %edi,%edi
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802fb8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802fbf:	00 

			if (de->de_inum >= super->s_ninodes) {
  802fc0:	8b 03                	mov    (%ebx),%eax
  802fc2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802fc8:	7c 3e                	jl     803008 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802fca:	89 44 24 10          	mov    %eax,0x10(%esp)
  802fce:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802fd4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fd8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fde:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fe2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fe6:	c7 04 24 9c 4d 80 00 	movl   $0x804d9c,(%esp)
  802fed:	e8 6c d5 ff ff       	call   80055e <_Z7cprintfPKcz>
				++errors;
  802ff2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ff9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803000:	00 00 00 
  803003:	e9 0b 01 00 00       	jmp    803113 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803008:	e8 70 ed ff ff       	call   801d7d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80300d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803014:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80301b:	c1 e2 08             	shl    $0x8,%edx
  80301e:	09 d1                	or     %edx,%ecx
  803020:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803027:	c1 e2 10             	shl    $0x10,%edx
  80302a:	09 d1                	or     %edx,%ecx
  80302c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803033:	83 e2 7f             	and    $0x7f,%edx
  803036:	c1 e2 18             	shl    $0x18,%edx
  803039:	09 ca                	or     %ecx,%edx
  80303b:	83 c2 01             	add    $0x1,%edx
  80303e:	89 d1                	mov    %edx,%ecx
  803040:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803046:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80304c:	0f b6 d5             	movzbl %ch,%edx
  80304f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803055:	89 ca                	mov    %ecx,%edx
  803057:	c1 ea 10             	shr    $0x10,%edx
  80305a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803060:	c1 e9 18             	shr    $0x18,%ecx
  803063:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80306a:	83 e2 80             	and    $0xffffff80,%edx
  80306d:	09 ca                	or     %ecx,%edx
  80306f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803075:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803079:	0f 85 7a ff ff ff    	jne    802ff9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80307f:	8b 03                	mov    (%ebx),%eax
  803081:	89 44 24 10          	mov    %eax,0x10(%esp)
  803085:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80308b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80308f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803095:	89 44 24 08          	mov    %eax,0x8(%esp)
  803099:	89 74 24 04          	mov    %esi,0x4(%esp)
  80309d:	c7 04 24 cc 4d 80 00 	movl   $0x804dcc,(%esp)
  8030a4:	e8 b5 d4 ff ff       	call   80055e <_Z7cprintfPKcz>
					++errors;
  8030a9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030b0:	e9 44 ff ff ff       	jmp    802ff9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8030b5:	3b 78 04             	cmp    0x4(%eax),%edi
  8030b8:	75 52                	jne    80310c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  8030ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8030be:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8030c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8030c8:	83 c0 08             	add    $0x8,%eax
  8030cb:	89 04 24             	mov    %eax,(%esp)
  8030ce:	e8 05 dd ff ff       	call   800dd8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	75 35                	jne    80310c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  8030d7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8030dd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8030e1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8030e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030eb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030f9:	c7 04 24 fc 4d 80 00 	movl   $0x804dfc,(%esp)
  803100:	e8 59 d4 ff ff       	call   80055e <_Z7cprintfPKcz>
					++errors;
  803105:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80310c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803113:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803119:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80311f:	7e 1e                	jle    80313f <_Z4fsckv+0x75c>
  803121:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803125:	7f 18                	jg     80313f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803127:	89 ca                	mov    %ecx,%edx
  803129:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80312f:	e8 ec eb ff ff       	call   801d20 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803134:	83 38 00             	cmpl   $0x0,(%eax)
  803137:	0f 85 78 ff ff ff    	jne    8030b5 <_Z4fsckv+0x6d2>
  80313d:	eb cd                	jmp    80310c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80313f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803145:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80314b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803151:	83 ea 80             	sub    $0xffffff80,%edx
  803154:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80315a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803160:	3b 51 08             	cmp    0x8(%ecx),%edx
  803163:	0f 8f e7 fc ff ff    	jg     802e50 <_Z4fsckv+0x46d>
  803169:	e9 a0 fd ff ff       	jmp    802f0e <_Z4fsckv+0x52b>
  80316e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803174:	89 d8                	mov    %ebx,%eax
  803176:	e8 02 ec ff ff       	call   801d7d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80317b:	8b 50 04             	mov    0x4(%eax),%edx
  80317e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803185:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80318c:	c1 e7 08             	shl    $0x8,%edi
  80318f:	09 f9                	or     %edi,%ecx
  803191:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803198:	c1 e7 10             	shl    $0x10,%edi
  80319b:	09 f9                	or     %edi,%ecx
  80319d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  8031a4:	83 e7 7f             	and    $0x7f,%edi
  8031a7:	c1 e7 18             	shl    $0x18,%edi
  8031aa:	09 f9                	or     %edi,%ecx
  8031ac:	39 ca                	cmp    %ecx,%edx
  8031ae:	74 1b                	je     8031cb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  8031b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8031bc:	c7 04 24 2c 4e 80 00 	movl   $0x804e2c,(%esp)
  8031c3:	e8 96 d3 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  8031c8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8031cb:	83 c3 01             	add    $0x1,%ebx
  8031ce:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  8031d4:	7f 9e                	jg     803174 <_Z4fsckv+0x791>
  8031d6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8031dc:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8031e3:	7e 4f                	jle    803234 <_Z4fsckv+0x851>
  8031e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031ea:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8031f0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8031f7:	3c ff                	cmp    $0xff,%al
  8031f9:	75 09                	jne    803204 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8031fb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803202:	eb 1f                	jmp    803223 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803204:	84 c0                	test   %al,%al
  803206:	75 1b                	jne    803223 <_Z4fsckv+0x840>
  803208:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80320e:	7c 13                	jl     803223 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803210:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803214:	c7 04 24 58 4e 80 00 	movl   $0x804e58,(%esp)
  80321b:	e8 3e d3 ff ff       	call   80055e <_Z7cprintfPKcz>
			++errors;
  803220:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803223:	83 c3 01             	add    $0x1,%ebx
  803226:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80322c:	7f c2                	jg     8031f0 <_Z4fsckv+0x80d>
  80322e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803234:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80323b:	19 c0                	sbb    %eax,%eax
  80323d:	f7 d0                	not    %eax
  80323f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803242:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803248:	5b                   	pop    %ebx
  803249:	5e                   	pop    %esi
  80324a:	5f                   	pop    %edi
  80324b:	5d                   	pop    %ebp
  80324c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80324d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803254:	0f 84 92 f9 ff ff    	je     802bec <_Z4fsckv+0x209>
  80325a:	e9 5a f9 ff ff       	jmp    802bb9 <_Z4fsckv+0x1d6>
	...

00803260 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
  803263:	83 ec 18             	sub    $0x18,%esp
  803266:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803269:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80326c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	89 04 24             	mov    %eax,(%esp)
  803275:	e8 a2 e4 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  80327a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80327c:	c7 44 24 04 8b 4e 80 	movl   $0x804e8b,0x4(%esp)
  803283:	00 
  803284:	89 34 24             	mov    %esi,(%esp)
  803287:	e8 ee d8 ff ff       	call   800b7a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80328c:	8b 43 04             	mov    0x4(%ebx),%eax
  80328f:	2b 03                	sub    (%ebx),%eax
  803291:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803294:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80329b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  8032a2:	60 80 00 
	return 0;
}
  8032a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032aa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8032ad:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8032b0:	89 ec                	mov    %ebp,%esp
  8032b2:	5d                   	pop    %ebp
  8032b3:	c3                   	ret    

008032b4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  8032b4:	55                   	push   %ebp
  8032b5:	89 e5                	mov    %esp,%ebp
  8032b7:	53                   	push   %ebx
  8032b8:	83 ec 14             	sub    $0x14,%esp
  8032bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8032be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8032c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032c9:	e8 4f de ff ff       	call   80111d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  8032ce:	89 1c 24             	mov    %ebx,(%esp)
  8032d1:	e8 46 e4 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  8032d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032e1:	e8 37 de ff ff       	call   80111d <_Z14sys_page_unmapiPv>
}
  8032e6:	83 c4 14             	add    $0x14,%esp
  8032e9:	5b                   	pop    %ebx
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    

008032ec <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	57                   	push   %edi
  8032f0:	56                   	push   %esi
  8032f1:	53                   	push   %ebx
  8032f2:	83 ec 2c             	sub    $0x2c,%esp
  8032f5:	89 c7                	mov    %eax,%edi
  8032f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8032fa:	a1 00 74 80 00       	mov    0x807400,%eax
  8032ff:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803302:	89 3c 24             	mov    %edi,(%esp)
  803305:	e8 ba 05 00 00       	call   8038c4 <_Z7pagerefPv>
  80330a:	89 c3                	mov    %eax,%ebx
  80330c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330f:	89 04 24             	mov    %eax,(%esp)
  803312:	e8 ad 05 00 00       	call   8038c4 <_Z7pagerefPv>
  803317:	39 c3                	cmp    %eax,%ebx
  803319:	0f 94 c0             	sete   %al
  80331c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80331f:	8b 15 00 74 80 00    	mov    0x807400,%edx
  803325:	8b 52 58             	mov    0x58(%edx),%edx
  803328:	39 d6                	cmp    %edx,%esi
  80332a:	75 08                	jne    803334 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80332c:	83 c4 2c             	add    $0x2c,%esp
  80332f:	5b                   	pop    %ebx
  803330:	5e                   	pop    %esi
  803331:	5f                   	pop    %edi
  803332:	5d                   	pop    %ebp
  803333:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803334:	85 c0                	test   %eax,%eax
  803336:	74 c2                	je     8032fa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803338:	c7 04 24 92 4e 80 00 	movl   $0x804e92,(%esp)
  80333f:	e8 1a d2 ff ff       	call   80055e <_Z7cprintfPKcz>
  803344:	eb b4                	jmp    8032fa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803346 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803346:	55                   	push   %ebp
  803347:	89 e5                	mov    %esp,%ebp
  803349:	57                   	push   %edi
  80334a:	56                   	push   %esi
  80334b:	53                   	push   %ebx
  80334c:	83 ec 1c             	sub    $0x1c,%esp
  80334f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803352:	89 34 24             	mov    %esi,(%esp)
  803355:	e8 c2 e3 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  80335a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80335c:	bf 00 00 00 00       	mov    $0x0,%edi
  803361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803365:	75 46                	jne    8033ad <_ZL13devpipe_writeP2FdPKvj+0x67>
  803367:	eb 52                	jmp    8033bb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803369:	89 da                	mov    %ebx,%edx
  80336b:	89 f0                	mov    %esi,%eax
  80336d:	e8 7a ff ff ff       	call   8032ec <_ZL13_pipeisclosedP2FdP4Pipe>
  803372:	85 c0                	test   %eax,%eax
  803374:	75 49                	jne    8033bf <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803376:	e8 b1 dc ff ff       	call   80102c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80337b:	8b 43 04             	mov    0x4(%ebx),%eax
  80337e:	89 c2                	mov    %eax,%edx
  803380:	2b 13                	sub    (%ebx),%edx
  803382:	83 fa 20             	cmp    $0x20,%edx
  803385:	74 e2                	je     803369 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803387:	89 c2                	mov    %eax,%edx
  803389:	c1 fa 1f             	sar    $0x1f,%edx
  80338c:	c1 ea 1b             	shr    $0x1b,%edx
  80338f:	01 d0                	add    %edx,%eax
  803391:	83 e0 1f             	and    $0x1f,%eax
  803394:	29 d0                	sub    %edx,%eax
  803396:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803399:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80339d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8033a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8033a5:	83 c7 01             	add    $0x1,%edi
  8033a8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8033ab:	76 0e                	jbe    8033bb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8033ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8033b0:	89 c2                	mov    %eax,%edx
  8033b2:	2b 13                	sub    (%ebx),%edx
  8033b4:	83 fa 20             	cmp    $0x20,%edx
  8033b7:	74 b0                	je     803369 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8033b9:	eb cc                	jmp    803387 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8033bb:	89 f8                	mov    %edi,%eax
  8033bd:	eb 05                	jmp    8033c4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8033bf:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    

008033cc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033cc:	55                   	push   %ebp
  8033cd:	89 e5                	mov    %esp,%ebp
  8033cf:	83 ec 28             	sub    $0x28,%esp
  8033d2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8033d5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8033d8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8033db:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8033de:	89 3c 24             	mov    %edi,(%esp)
  8033e1:	e8 36 e3 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  8033e6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8033e8:	be 00 00 00 00       	mov    $0x0,%esi
  8033ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8033f1:	75 47                	jne    80343a <_ZL12devpipe_readP2FdPvj+0x6e>
  8033f3:	eb 52                	jmp    803447 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8033f5:	89 f0                	mov    %esi,%eax
  8033f7:	eb 5e                	jmp    803457 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8033f9:	89 da                	mov    %ebx,%edx
  8033fb:	89 f8                	mov    %edi,%eax
  8033fd:	8d 76 00             	lea    0x0(%esi),%esi
  803400:	e8 e7 fe ff ff       	call   8032ec <_ZL13_pipeisclosedP2FdP4Pipe>
  803405:	85 c0                	test   %eax,%eax
  803407:	75 49                	jne    803452 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803409:	e8 1e dc ff ff       	call   80102c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80340e:	8b 03                	mov    (%ebx),%eax
  803410:	3b 43 04             	cmp    0x4(%ebx),%eax
  803413:	74 e4                	je     8033f9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803415:	89 c2                	mov    %eax,%edx
  803417:	c1 fa 1f             	sar    $0x1f,%edx
  80341a:	c1 ea 1b             	shr    $0x1b,%edx
  80341d:	01 d0                	add    %edx,%eax
  80341f:	83 e0 1f             	and    $0x1f,%eax
  803422:	29 d0                	sub    %edx,%eax
  803424:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80342f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803432:	83 c6 01             	add    $0x1,%esi
  803435:	39 75 10             	cmp    %esi,0x10(%ebp)
  803438:	76 0d                	jbe    803447 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80343a:	8b 03                	mov    (%ebx),%eax
  80343c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80343f:	75 d4                	jne    803415 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803441:	85 f6                	test   %esi,%esi
  803443:	75 b0                	jne    8033f5 <_ZL12devpipe_readP2FdPvj+0x29>
  803445:	eb b2                	jmp    8033f9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803447:	89 f0                	mov    %esi,%eax
  803449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803450:	eb 05                	jmp    803457 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803452:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803457:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80345a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80345d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803460:	89 ec                	mov    %ebp,%esp
  803462:	5d                   	pop    %ebp
  803463:	c3                   	ret    

00803464 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803464:	55                   	push   %ebp
  803465:	89 e5                	mov    %esp,%ebp
  803467:	83 ec 48             	sub    $0x48,%esp
  80346a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80346d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803470:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803473:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803476:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803479:	89 04 24             	mov    %eax,(%esp)
  80347c:	e8 b6 e2 ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  803481:	89 c3                	mov    %eax,%ebx
  803483:	85 c0                	test   %eax,%eax
  803485:	0f 88 0b 01 00 00    	js     803596 <_Z4pipePi+0x132>
  80348b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803492:	00 
  803493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80349a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034a1:	e8 ba db ff ff       	call   801060 <_Z14sys_page_allociPvi>
  8034a6:	89 c3                	mov    %eax,%ebx
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	0f 89 f5 00 00 00    	jns    8035a5 <_Z4pipePi+0x141>
  8034b0:	e9 e1 00 00 00       	jmp    803596 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8034b5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8034bc:	00 
  8034bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034cb:	e8 90 db ff ff       	call   801060 <_Z14sys_page_allociPvi>
  8034d0:	89 c3                	mov    %eax,%ebx
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	0f 89 e2 00 00 00    	jns    8035bc <_Z4pipePi+0x158>
  8034da:	e9 a4 00 00 00       	jmp    803583 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e2:	89 04 24             	mov    %eax,(%esp)
  8034e5:	e8 32 e2 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  8034ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8034f1:	00 
  8034f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034fd:	00 
  8034fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  803502:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803509:	e8 b1 db ff ff       	call   8010bf <_Z12sys_page_mapiPviS_i>
  80350e:	89 c3                	mov    %eax,%ebx
  803510:	85 c0                	test   %eax,%eax
  803512:	78 4c                	js     803560 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803514:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80351a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80351f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803529:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80352f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803537:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80353e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803541:	89 04 24             	mov    %eax,(%esp)
  803544:	e8 8b e1 ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  803549:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80354b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354e:	89 04 24             	mov    %eax,(%esp)
  803551:	e8 7e e1 ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  803556:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803559:	bb 00 00 00 00       	mov    $0x0,%ebx
  80355e:	eb 36                	jmp    803596 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803560:	89 74 24 04          	mov    %esi,0x4(%esp)
  803564:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80356b:	e8 ad db ff ff       	call   80111d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803573:	89 44 24 04          	mov    %eax,0x4(%esp)
  803577:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80357e:	e8 9a db ff ff       	call   80111d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80358a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803591:	e8 87 db ff ff       	call   80111d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803596:	89 d8                	mov    %ebx,%eax
  803598:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80359b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80359e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8035a1:	89 ec                	mov    %ebp,%esp
  8035a3:	5d                   	pop    %ebp
  8035a4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8035a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035a8:	89 04 24             	mov    %eax,(%esp)
  8035ab:	e8 87 e1 ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  8035b0:	89 c3                	mov    %eax,%ebx
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	0f 89 fb fe ff ff    	jns    8034b5 <_Z4pipePi+0x51>
  8035ba:	eb c7                	jmp    803583 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bf:	89 04 24             	mov    %eax,(%esp)
  8035c2:	e8 55 e1 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  8035c7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035c9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8035d0:	00 
  8035d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035dc:	e8 7f da ff ff       	call   801060 <_Z14sys_page_allociPvi>
  8035e1:	89 c3                	mov    %eax,%ebx
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	0f 89 f4 fe ff ff    	jns    8034df <_Z4pipePi+0x7b>
  8035eb:	eb 83                	jmp    803570 <_Z4pipePi+0x10c>

008035ed <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8035ed:	55                   	push   %ebp
  8035ee:	89 e5                	mov    %esp,%ebp
  8035f0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8035f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8035fa:	00 
  8035fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	89 04 24             	mov    %eax,(%esp)
  803608:	e8 74 e0 ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  80360d:	85 c0                	test   %eax,%eax
  80360f:	78 15                	js     803626 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	89 04 24             	mov    %eax,(%esp)
  803617:	e8 00 e1 ff ff       	call   80171c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80361c:	89 c2                	mov    %eax,%edx
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	e8 c6 fc ff ff       	call   8032ec <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803626:	c9                   	leave  
  803627:	c3                   	ret    

00803628 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803628:	55                   	push   %ebp
  803629:	89 e5                	mov    %esp,%ebp
  80362b:	53                   	push   %ebx
  80362c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80362f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803632:	89 04 24             	mov    %eax,(%esp)
  803635:	e8 fd e0 ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  80363a:	89 c3                	mov    %eax,%ebx
  80363c:	85 c0                	test   %eax,%eax
  80363e:	0f 88 be 00 00 00    	js     803702 <_Z18pipe_ipc_recv_readv+0xda>
  803644:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80364b:	00 
  80364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80365a:	e8 01 da ff ff       	call   801060 <_Z14sys_page_allociPvi>
  80365f:	89 c3                	mov    %eax,%ebx
  803661:	85 c0                	test   %eax,%eax
  803663:	0f 89 a1 00 00 00    	jns    80370a <_Z18pipe_ipc_recv_readv+0xe2>
  803669:	e9 94 00 00 00       	jmp    803702 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803671:	85 c0                	test   %eax,%eax
  803673:	75 0e                	jne    803683 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803675:	c7 04 24 f0 4e 80 00 	movl   $0x804ef0,(%esp)
  80367c:	e8 dd ce ff ff       	call   80055e <_Z7cprintfPKcz>
  803681:	eb 10                	jmp    803693 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803683:	89 44 24 04          	mov    %eax,0x4(%esp)
  803687:	c7 04 24 a5 4e 80 00 	movl   $0x804ea5,(%esp)
  80368e:	e8 cb ce ff ff       	call   80055e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803693:	c7 04 24 af 4e 80 00 	movl   $0x804eaf,(%esp)
  80369a:	e8 bf ce ff ff       	call   80055e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80369f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a2:	a8 04                	test   $0x4,%al
  8036a4:	74 04                	je     8036aa <_Z18pipe_ipc_recv_readv+0x82>
  8036a6:	a8 01                	test   $0x1,%al
  8036a8:	75 24                	jne    8036ce <_Z18pipe_ipc_recv_readv+0xa6>
  8036aa:	c7 44 24 0c c2 4e 80 	movl   $0x804ec2,0xc(%esp)
  8036b1:	00 
  8036b2:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  8036b9:	00 
  8036ba:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8036c1:	00 
  8036c2:	c7 04 24 df 4e 80 00 	movl   $0x804edf,(%esp)
  8036c9:	e8 72 cd ff ff       	call   800440 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8036ce:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8036e3:	89 04 24             	mov    %eax,(%esp)
  8036e6:	e8 e9 df ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  8036eb:	89 c3                	mov    %eax,%ebx
  8036ed:	eb 13                	jmp    803702 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036fd:	e8 1b da ff ff       	call   80111d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803702:	89 d8                	mov    %ebx,%eax
  803704:	83 c4 24             	add    $0x24,%esp
  803707:	5b                   	pop    %ebx
  803708:	5d                   	pop    %ebp
  803709:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	89 04 24             	mov    %eax,(%esp)
  803710:	e8 07 e0 ff ff       	call   80171c <_Z7fd2dataP2Fd>
  803715:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803718:	89 54 24 08          	mov    %edx,0x8(%esp)
  80371c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803723:	89 04 24             	mov    %eax,(%esp)
  803726:	e8 b5 09 00 00       	call   8040e0 <_Z8ipc_recvPiPvS_>
  80372b:	89 c3                	mov    %eax,%ebx
  80372d:	85 c0                	test   %eax,%eax
  80372f:	0f 89 39 ff ff ff    	jns    80366e <_Z18pipe_ipc_recv_readv+0x46>
  803735:	eb b8                	jmp    8036ef <_Z18pipe_ipc_recv_readv+0xc7>

00803737 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
  80373a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80373d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803744:	00 
  803745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803748:	89 44 24 04          	mov    %eax,0x4(%esp)
  80374c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374f:	89 04 24             	mov    %eax,(%esp)
  803752:	e8 2a df ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  803757:	85 c0                	test   %eax,%eax
  803759:	78 2f                	js     80378a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80375b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375e:	89 04 24             	mov    %eax,(%esp)
  803761:	e8 b6 df ff ff       	call   80171c <_Z7fd2dataP2Fd>
  803766:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80376d:	00 
  80376e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803779:	00 
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	89 04 24             	mov    %eax,(%esp)
  803780:	e8 ea 09 00 00       	call   80416f <_Z8ipc_sendijPvi>
    return 0;
  803785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80378a:	c9                   	leave  
  80378b:	c3                   	ret    

0080378c <_ZL8writebufP8printbuf>:
};


static void
writebuf(struct printbuf *b)
{
  80378c:	55                   	push   %ebp
  80378d:	89 e5                	mov    %esp,%ebp
  80378f:	53                   	push   %ebx
  803790:	83 ec 14             	sub    $0x14,%esp
  803793:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  803795:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  803799:	7e 31                	jle    8037cc <_ZL8writebufP8printbuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80379b:	8b 40 04             	mov    0x4(%eax),%eax
  80379e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037a2:	8d 43 10             	lea    0x10(%ebx),%eax
  8037a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037a9:	8b 03                	mov    (%ebx),%eax
  8037ab:	89 04 24             	mov    %eax,(%esp)
  8037ae:	e8 66 e3 ff ff       	call   801b19 <_Z5writeiPKvj>
		if (result > 0)
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	7e 03                	jle    8037ba <_ZL8writebufP8printbuf+0x2e>
			b->result += result;
  8037b7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8037ba:	39 43 04             	cmp    %eax,0x4(%ebx)
  8037bd:	74 0d                	je     8037cc <_ZL8writebufP8printbuf+0x40>
			b->error = (result < 0 ? result : 0);
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8037c6:	0f 4f c2             	cmovg  %edx,%eax
  8037c9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8037cc:	83 c4 14             	add    $0x14,%esp
  8037cf:	5b                   	pop    %ebx
  8037d0:	5d                   	pop    %ebp
  8037d1:	c3                   	ret    

008037d2 <_ZL5putchiPv>:

static void
putch(int ch, void *thunk)
{
  8037d2:	55                   	push   %ebp
  8037d3:	89 e5                	mov    %esp,%ebp
  8037d5:	53                   	push   %ebx
  8037d6:	83 ec 04             	sub    $0x4,%esp
  8037d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8037dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8037df:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e2:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  8037e6:	83 c0 01             	add    $0x1,%eax
  8037e9:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  8037ec:	3d 00 01 00 00       	cmp    $0x100,%eax
  8037f1:	75 0e                	jne    803801 <_ZL5putchiPv+0x2f>
		writebuf(b);
  8037f3:	89 d8                	mov    %ebx,%eax
  8037f5:	e8 92 ff ff ff       	call   80378c <_ZL8writebufP8printbuf>
		b->idx = 0;
  8037fa:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  803801:	83 c4 04             	add    $0x4,%esp
  803804:	5b                   	pop    %ebx
  803805:	5d                   	pop    %ebp
  803806:	c3                   	ret    

00803807 <_Z8vfprintfiPKcPc>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803807:	55                   	push   %ebp
  803808:	89 e5                	mov    %esp,%ebp
  80380a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  803819:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  803820:	00 00 00 
	b.result = 0;
  803823:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80382a:	00 00 00 
	b.error = 1;
  80382d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  803834:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803837:	8b 45 10             	mov    0x10(%ebp),%eax
  80383a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	89 44 24 08          	mov    %eax,0x8(%esp)
  803845:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80384b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80384f:	c7 04 24 d2 37 80 00 	movl   $0x8037d2,(%esp)
  803856:	e8 8c ce ff ff       	call   8006e7 <_Z9vprintfmtPFviPvES_PKcPc>
	if (b.idx > 0)
  80385b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  803862:	7e 0b                	jle    80386f <_Z8vfprintfiPKcPc+0x68>
		writebuf(&b);
  803864:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80386a:	e8 1d ff ff ff       	call   80378c <_ZL8writebufP8printbuf>

	return (b.result ? b.result : b.error);
  80386f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80387e:	c9                   	leave  
  80387f:	c3                   	ret    

00803880 <_Z7fprintfiPKcz>:

int
fprintf(int fd, const char *fmt, ...)
{
  803880:	55                   	push   %ebp
  803881:	89 e5                	mov    %esp,%ebp
  803883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803886:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  803889:	89 44 24 08          	mov    %eax,0x8(%esp)
  80388d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803890:	89 44 24 04          	mov    %eax,0x4(%esp)
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	89 04 24             	mov    %eax,(%esp)
  80389a:	e8 68 ff ff ff       	call   803807 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  80389f:	c9                   	leave  
  8038a0:	c3                   	ret    

008038a1 <_Z6printfPKcz>:

int
printf(const char *fmt, ...)
{
  8038a1:	55                   	push   %ebp
  8038a2:	89 e5                	mov    %esp,%ebp
  8038a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8038a7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8038aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8038bc:	e8 46 ff ff ff       	call   803807 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  8038c1:	c9                   	leave  
  8038c2:	c3                   	ret    
	...

008038c4 <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8038c4:	55                   	push   %ebp
  8038c5:	89 e5                	mov    %esp,%ebp
  8038c7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8038ca:	89 d0                	mov    %edx,%eax
  8038cc:	c1 e8 16             	shr    $0x16,%eax
  8038cf:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8038d6:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8038db:	f6 c1 01             	test   $0x1,%cl
  8038de:	74 1d                	je     8038fd <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8038e0:	c1 ea 0c             	shr    $0xc,%edx
  8038e3:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8038ea:	f6 c2 01             	test   $0x1,%dl
  8038ed:	74 0e                	je     8038fd <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8038ef:	c1 ea 0c             	shr    $0xc,%edx
  8038f2:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8038f9:	ef 
  8038fa:	0f b7 c0             	movzwl %ax,%eax
}
  8038fd:	5d                   	pop    %ebp
  8038fe:	c3                   	ret    
	...

00803900 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803900:	55                   	push   %ebp
  803901:	89 e5                	mov    %esp,%ebp
  803903:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803906:	c7 44 24 04 13 4f 80 	movl   $0x804f13,0x4(%esp)
  80390d:	00 
  80390e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803911:	89 04 24             	mov    %eax,(%esp)
  803914:	e8 61 d2 ff ff       	call   800b7a <_Z6strcpyPcPKc>
	return 0;
}
  803919:	b8 00 00 00 00       	mov    $0x0,%eax
  80391e:	c9                   	leave  
  80391f:	c3                   	ret    

00803920 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803920:	55                   	push   %ebp
  803921:	89 e5                	mov    %esp,%ebp
  803923:	53                   	push   %ebx
  803924:	83 ec 14             	sub    $0x14,%esp
  803927:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80392a:	89 1c 24             	mov    %ebx,(%esp)
  80392d:	e8 92 ff ff ff       	call   8038c4 <_Z7pagerefPv>
  803932:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803934:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803939:	83 fa 01             	cmp    $0x1,%edx
  80393c:	75 0b                	jne    803949 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80393e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803941:	89 04 24             	mov    %eax,(%esp)
  803944:	e8 fe 02 00 00       	call   803c47 <_Z11nsipc_closei>
	else
		return 0;
}
  803949:	83 c4 14             	add    $0x14,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5d                   	pop    %ebp
  80394e:	c3                   	ret    

0080394f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803955:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80395c:	00 
  80395d:	8b 45 10             	mov    0x10(%ebp),%eax
  803960:	89 44 24 08          	mov    %eax,0x8(%esp)
  803964:	8b 45 0c             	mov    0xc(%ebp),%eax
  803967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	8b 40 0c             	mov    0xc(%eax),%eax
  803971:	89 04 24             	mov    %eax,(%esp)
  803974:	e8 c9 03 00 00       	call   803d42 <_Z10nsipc_sendiPKvij>
}
  803979:	c9                   	leave  
  80397a:	c3                   	ret    

0080397b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80397b:	55                   	push   %ebp
  80397c:	89 e5                	mov    %esp,%ebp
  80397e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803981:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803988:	00 
  803989:	8b 45 10             	mov    0x10(%ebp),%eax
  80398c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803990:	8b 45 0c             	mov    0xc(%ebp),%eax
  803993:	89 44 24 04          	mov    %eax,0x4(%esp)
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	8b 40 0c             	mov    0xc(%eax),%eax
  80399d:	89 04 24             	mov    %eax,(%esp)
  8039a0:	e8 1d 03 00 00       	call   803cc2 <_Z10nsipc_recviPvij>
}
  8039a5:	c9                   	leave  
  8039a6:	c3                   	ret    

008039a7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8039a7:	55                   	push   %ebp
  8039a8:	89 e5                	mov    %esp,%ebp
  8039aa:	83 ec 28             	sub    $0x28,%esp
  8039ad:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8039b0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8039b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8039b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039b8:	89 04 24             	mov    %eax,(%esp)
  8039bb:	e8 77 dd ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  8039c0:	89 c3                	mov    %eax,%ebx
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	78 21                	js     8039e7 <_ZL12alloc_sockfdi+0x40>
  8039c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8039cd:	00 
  8039ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039dc:	e8 7f d6 ff ff       	call   801060 <_Z14sys_page_allociPvi>
  8039e1:	89 c3                	mov    %eax,%ebx
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	79 14                	jns    8039fb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8039e7:	89 34 24             	mov    %esi,(%esp)
  8039ea:	e8 58 02 00 00       	call   803c47 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8039ef:	89 d8                	mov    %ebx,%eax
  8039f1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8039f4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8039f7:	89 ec                	mov    %ebp,%esp
  8039f9:	5d                   	pop    %ebp
  8039fa:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8039fb:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a04:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a09:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803a10:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803a13:	89 04 24             	mov    %eax,(%esp)
  803a16:	e8 b9 dc ff ff       	call   8016d4 <_Z6fd2numP2Fd>
  803a1b:	89 c3                	mov    %eax,%ebx
  803a1d:	eb d0                	jmp    8039ef <_ZL12alloc_sockfdi+0x48>

00803a1f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a1f:	55                   	push   %ebp
  803a20:	89 e5                	mov    %esp,%ebp
  803a22:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803a25:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a2c:	00 
  803a2d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803a30:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a34:	89 04 24             	mov    %eax,(%esp)
  803a37:	e8 45 dc ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  803a3c:	85 c0                	test   %eax,%eax
  803a3e:	78 15                	js     803a55 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803a43:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803a48:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803a4e:	39 0a                	cmp    %ecx,(%edx)
  803a50:	75 03                	jne    803a55 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803a52:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803a55:	c9                   	leave  
  803a56:	c3                   	ret    

00803a57 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a57:	55                   	push   %ebp
  803a58:	89 e5                	mov    %esp,%ebp
  803a5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a60:	e8 ba ff ff ff       	call   803a1f <_ZL9fd2sockidi>
  803a65:	85 c0                	test   %eax,%eax
  803a67:	78 1f                	js     803a88 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803a69:	8b 55 10             	mov    0x10(%ebp),%edx
  803a6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a73:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a77:	89 04 24             	mov    %eax,(%esp)
  803a7a:	e8 19 01 00 00       	call   803b98 <_Z12nsipc_acceptiP8sockaddrPj>
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	78 05                	js     803a88 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803a83:	e8 1f ff ff ff       	call   8039a7 <_ZL12alloc_sockfdi>
}
  803a88:	c9                   	leave  
  803a89:	c3                   	ret    

00803a8a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a8a:	55                   	push   %ebp
  803a8b:	89 e5                	mov    %esp,%ebp
  803a8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	e8 87 ff ff ff       	call   803a1f <_ZL9fd2sockidi>
  803a98:	85 c0                	test   %eax,%eax
  803a9a:	78 16                	js     803ab2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803a9c:	8b 55 10             	mov    0x10(%ebp),%edx
  803a9f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aa6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803aaa:	89 04 24             	mov    %eax,(%esp)
  803aad:	e8 34 01 00 00       	call   803be6 <_Z10nsipc_bindiP8sockaddrj>
}
  803ab2:	c9                   	leave  
  803ab3:	c3                   	ret    

00803ab4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803ab4:	55                   	push   %ebp
  803ab5:	89 e5                	mov    %esp,%ebp
  803ab7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	e8 5d ff ff ff       	call   803a1f <_ZL9fd2sockidi>
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	78 0f                	js     803ad5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
  803acd:	89 04 24             	mov    %eax,(%esp)
  803ad0:	e8 50 01 00 00       	call   803c25 <_Z14nsipc_shutdownii>
}
  803ad5:	c9                   	leave  
  803ad6:	c3                   	ret    

00803ad7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ad7:	55                   	push   %ebp
  803ad8:	89 e5                	mov    %esp,%ebp
  803ada:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803add:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae0:	e8 3a ff ff ff       	call   803a1f <_ZL9fd2sockidi>
  803ae5:	85 c0                	test   %eax,%eax
  803ae7:	78 16                	js     803aff <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803ae9:	8b 55 10             	mov    0x10(%ebp),%edx
  803aec:	89 54 24 08          	mov    %edx,0x8(%esp)
  803af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803af3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803af7:	89 04 24             	mov    %eax,(%esp)
  803afa:	e8 62 01 00 00       	call   803c61 <_Z13nsipc_connectiPK8sockaddrj>
}
  803aff:	c9                   	leave  
  803b00:	c3                   	ret    

00803b01 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803b01:	55                   	push   %ebp
  803b02:	89 e5                	mov    %esp,%ebp
  803b04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b07:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0a:	e8 10 ff ff ff       	call   803a1f <_ZL9fd2sockidi>
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	78 0f                	js     803b22 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b16:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b1a:	89 04 24             	mov    %eax,(%esp)
  803b1d:	e8 7e 01 00 00       	call   803ca0 <_Z12nsipc_listenii>
}
  803b22:	c9                   	leave  
  803b23:	c3                   	ret    

00803b24 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803b24:	55                   	push   %ebp
  803b25:	89 e5                	mov    %esp,%ebp
  803b27:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  803b2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b38:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3b:	89 04 24             	mov    %eax,(%esp)
  803b3e:	e8 72 02 00 00       	call   803db5 <_Z12nsipc_socketiii>
  803b43:	85 c0                	test   %eax,%eax
  803b45:	78 05                	js     803b4c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803b47:	e8 5b fe ff ff       	call   8039a7 <_ZL12alloc_sockfdi>
}
  803b4c:	c9                   	leave  
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	c3                   	ret    
  803b51:	00 00                	add    %al,(%eax)
	...

00803b54 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b54:	55                   	push   %ebp
  803b55:	89 e5                	mov    %esp,%ebp
  803b57:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b5a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803b61:	00 
  803b62:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803b69:	00 
  803b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b6e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803b75:	e8 f5 05 00 00       	call   80416f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803b7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803b81:	00 
  803b82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803b89:	00 
  803b8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b91:	e8 4a 05 00 00       	call   8040e0 <_Z8ipc_recvPiPvS_>
}
  803b96:	c9                   	leave  
  803b97:	c3                   	ret    

00803b98 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b98:	55                   	push   %ebp
  803b99:	89 e5                	mov    %esp,%ebp
  803b9b:	53                   	push   %ebx
  803b9c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba2:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ba7:	b8 01 00 00 00       	mov    $0x1,%eax
  803bac:	e8 a3 ff ff ff       	call   803b54 <_ZL5nsipcj>
  803bb1:	89 c3                	mov    %eax,%ebx
  803bb3:	85 c0                	test   %eax,%eax
  803bb5:	78 27                	js     803bde <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803bb7:	a1 10 80 80 00       	mov    0x808010,%eax
  803bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bc0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803bc7:	00 
  803bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bcb:	89 04 24             	mov    %eax,(%esp)
  803bce:	e8 49 d1 ff ff       	call   800d1c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803bd3:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  803bdc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803bde:	89 d8                	mov    %ebx,%eax
  803be0:	83 c4 14             	add    $0x14,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5d                   	pop    %ebp
  803be5:	c3                   	ret    

00803be6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803be6:	55                   	push   %ebp
  803be7:	89 e5                	mov    %esp,%ebp
  803be9:	53                   	push   %ebx
  803bea:	83 ec 14             	sub    $0x14,%esp
  803bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf3:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bf8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c03:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803c0a:	e8 0d d1 ff ff       	call   800d1c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803c0f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803c15:	b8 02 00 00 00       	mov    $0x2,%eax
  803c1a:	e8 35 ff ff ff       	call   803b54 <_ZL5nsipcj>
}
  803c1f:	83 c4 14             	add    $0x14,%esp
  803c22:	5b                   	pop    %ebx
  803c23:	5d                   	pop    %ebp
  803c24:	c3                   	ret    

00803c25 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803c25:	55                   	push   %ebp
  803c26:	89 e5                	mov    %esp,%ebp
  803c28:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c36:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803c3b:	b8 03 00 00 00       	mov    $0x3,%eax
  803c40:	e8 0f ff ff ff       	call   803b54 <_ZL5nsipcj>
}
  803c45:	c9                   	leave  
  803c46:	c3                   	ret    

00803c47 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803c47:	55                   	push   %ebp
  803c48:	89 e5                	mov    %esp,%ebp
  803c4a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c50:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803c55:	b8 04 00 00 00       	mov    $0x4,%eax
  803c5a:	e8 f5 fe ff ff       	call   803b54 <_ZL5nsipcj>
}
  803c5f:	c9                   	leave  
  803c60:	c3                   	ret    

00803c61 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c61:	55                   	push   %ebp
  803c62:	89 e5                	mov    %esp,%ebp
  803c64:	53                   	push   %ebx
  803c65:	83 ec 14             	sub    $0x14,%esp
  803c68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c7e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803c85:	e8 92 d0 ff ff       	call   800d1c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803c8a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803c90:	b8 05 00 00 00       	mov    $0x5,%eax
  803c95:	e8 ba fe ff ff       	call   803b54 <_ZL5nsipcj>
}
  803c9a:	83 c4 14             	add    $0x14,%esp
  803c9d:	5b                   	pop    %ebx
  803c9e:	5d                   	pop    %ebp
  803c9f:	c3                   	ret    

00803ca0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803ca0:	55                   	push   %ebp
  803ca1:	89 e5                	mov    %esp,%ebp
  803ca3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb1:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803cb6:	b8 06 00 00 00       	mov    $0x6,%eax
  803cbb:	e8 94 fe ff ff       	call   803b54 <_ZL5nsipcj>
}
  803cc0:	c9                   	leave  
  803cc1:	c3                   	ret    

00803cc2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cc2:	55                   	push   %ebp
  803cc3:	89 e5                	mov    %esp,%ebp
  803cc5:	56                   	push   %esi
  803cc6:	53                   	push   %ebx
  803cc7:	83 ec 10             	sub    $0x10,%esp
  803cca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803cd5:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803cdb:	8b 45 14             	mov    0x14(%ebp),%eax
  803cde:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ce3:	b8 07 00 00 00       	mov    $0x7,%eax
  803ce8:	e8 67 fe ff ff       	call   803b54 <_ZL5nsipcj>
  803ced:	89 c3                	mov    %eax,%ebx
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	78 46                	js     803d39 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803cf3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803cf8:	7f 04                	jg     803cfe <_Z10nsipc_recviPvij+0x3c>
  803cfa:	39 f0                	cmp    %esi,%eax
  803cfc:	7e 24                	jle    803d22 <_Z10nsipc_recviPvij+0x60>
  803cfe:	c7 44 24 0c 1f 4f 80 	movl   $0x804f1f,0xc(%esp)
  803d05:	00 
  803d06:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  803d0d:	00 
  803d0e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803d15:	00 
  803d16:	c7 04 24 34 4f 80 00 	movl   $0x804f34,(%esp)
  803d1d:	e8 1e c7 ff ff       	call   800440 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d22:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d26:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803d2d:	00 
  803d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d31:	89 04 24             	mov    %eax,(%esp)
  803d34:	e8 e3 cf ff ff       	call   800d1c <memmove>
	}

	return r;
}
  803d39:	89 d8                	mov    %ebx,%eax
  803d3b:	83 c4 10             	add    $0x10,%esp
  803d3e:	5b                   	pop    %ebx
  803d3f:	5e                   	pop    %esi
  803d40:	5d                   	pop    %ebp
  803d41:	c3                   	ret    

00803d42 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d42:	55                   	push   %ebp
  803d43:	89 e5                	mov    %esp,%ebp
  803d45:	53                   	push   %ebx
  803d46:	83 ec 14             	sub    $0x14,%esp
  803d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803d54:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803d5a:	7e 24                	jle    803d80 <_Z10nsipc_sendiPKvij+0x3e>
  803d5c:	c7 44 24 0c 40 4f 80 	movl   $0x804f40,0xc(%esp)
  803d63:	00 
  803d64:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  803d6b:	00 
  803d6c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803d73:	00 
  803d74:	c7 04 24 34 4f 80 00 	movl   $0x804f34,(%esp)
  803d7b:	e8 c0 c6 ff ff       	call   800440 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d80:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d8b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803d92:	e8 85 cf ff ff       	call   800d1c <memmove>
	nsipcbuf.send.req_size = size;
  803d97:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  803da0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803da5:	b8 08 00 00 00       	mov    $0x8,%eax
  803daa:	e8 a5 fd ff ff       	call   803b54 <_ZL5nsipcj>
}
  803daf:	83 c4 14             	add    $0x14,%esp
  803db2:	5b                   	pop    %ebx
  803db3:	5d                   	pop    %ebp
  803db4:	c3                   	ret    

00803db5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803db5:	55                   	push   %ebp
  803db6:	89 e5                	mov    %esp,%ebp
  803db8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbe:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  803dce:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803dd3:	b8 09 00 00 00       	mov    $0x9,%eax
  803dd8:	e8 77 fd ff ff       	call   803b54 <_ZL5nsipcj>
}
  803ddd:	c9                   	leave  
  803dde:	c3                   	ret    
	...

00803de0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803de0:	55                   	push   %ebp
  803de1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803de3:	b8 00 00 00 00       	mov    $0x0,%eax
  803de8:	5d                   	pop    %ebp
  803de9:	c3                   	ret    

00803dea <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803dea:	55                   	push   %ebp
  803deb:	89 e5                	mov    %esp,%ebp
  803ded:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803df0:	c7 44 24 04 4c 4f 80 	movl   $0x804f4c,0x4(%esp)
  803df7:	00 
  803df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dfb:	89 04 24             	mov    %eax,(%esp)
  803dfe:	e8 77 cd ff ff       	call   800b7a <_Z6strcpyPcPKc>
	return 0;
}
  803e03:	b8 00 00 00 00       	mov    $0x0,%eax
  803e08:	c9                   	leave  
  803e09:	c3                   	ret    

00803e0a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e0a:	55                   	push   %ebp
  803e0b:	89 e5                	mov    %esp,%ebp
  803e0d:	57                   	push   %edi
  803e0e:	56                   	push   %esi
  803e0f:	53                   	push   %ebx
  803e10:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  803e1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e1f:	74 3e                	je     803e5f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803e21:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803e27:	8b 75 10             	mov    0x10(%ebp),%esi
  803e2a:	29 de                	sub    %ebx,%esi
  803e2c:	83 fe 7f             	cmp    $0x7f,%esi
  803e2f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803e34:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803e37:	89 74 24 08          	mov    %esi,0x8(%esp)
  803e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e3e:	01 d8                	add    %ebx,%eax
  803e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e44:	89 3c 24             	mov    %edi,(%esp)
  803e47:	e8 d0 ce ff ff       	call   800d1c <memmove>
		sys_cputs(buf, m);
  803e4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803e50:	89 3c 24             	mov    %edi,(%esp)
  803e53:	e8 dc d0 ff ff       	call   800f34 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e58:	01 f3                	add    %esi,%ebx
  803e5a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803e5d:	77 c8                	ja     803e27 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803e5f:	89 d8                	mov    %ebx,%eax
  803e61:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803e67:	5b                   	pop    %ebx
  803e68:	5e                   	pop    %esi
  803e69:	5f                   	pop    %edi
  803e6a:	5d                   	pop    %ebp
  803e6b:	c3                   	ret    

00803e6c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e6c:	55                   	push   %ebp
  803e6d:	89 e5                	mov    %esp,%ebp
  803e6f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803e72:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803e77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e7b:	75 07                	jne    803e84 <_ZL12devcons_readP2FdPvj+0x18>
  803e7d:	eb 2a                	jmp    803ea9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e7f:	e8 a8 d1 ff ff       	call   80102c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e84:	e8 de d0 ff ff       	call   800f67 <_Z9sys_cgetcv>
  803e89:	85 c0                	test   %eax,%eax
  803e8b:	74 f2                	je     803e7f <_ZL12devcons_readP2FdPvj+0x13>
  803e8d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803e8f:	85 c0                	test   %eax,%eax
  803e91:	78 16                	js     803ea9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803e93:	83 f8 04             	cmp    $0x4,%eax
  803e96:	74 0c                	je     803ea4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e9b:	88 10                	mov    %dl,(%eax)
	return 1;
  803e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803ea2:	eb 05                	jmp    803ea9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803ea4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803ea9:	c9                   	leave  
  803eaa:	c3                   	ret    

00803eab <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803eab:	55                   	push   %ebp
  803eac:	89 e5                	mov    %esp,%ebp
  803eae:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803eb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803ebe:	00 
  803ebf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ec2:	89 04 24             	mov    %eax,(%esp)
  803ec5:	e8 6a d0 ff ff       	call   800f34 <_Z9sys_cputsPKcj>
}
  803eca:	c9                   	leave  
  803ecb:	c3                   	ret    

00803ecc <_Z7getcharv>:

int
getchar(void)
{
  803ecc:	55                   	push   %ebp
  803ecd:	89 e5                	mov    %esp,%ebp
  803ecf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ed2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803ed9:	00 
  803eda:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803edd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ee8:	e8 41 db ff ff       	call   801a2e <_Z4readiPvj>
	if (r < 0)
  803eed:	85 c0                	test   %eax,%eax
  803eef:	78 0f                	js     803f00 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803ef1:	85 c0                	test   %eax,%eax
  803ef3:	7e 06                	jle    803efb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803ef5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803ef9:	eb 05                	jmp    803f00 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803efb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803f00:	c9                   	leave  
  803f01:	c3                   	ret    

00803f02 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803f02:	55                   	push   %ebp
  803f03:	89 e5                	mov    %esp,%ebp
  803f05:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803f08:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803f0f:	00 
  803f10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f17:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1a:	89 04 24             	mov    %eax,(%esp)
  803f1d:	e8 5f d7 ff ff       	call   801681 <_Z9fd_lookupiPP2Fdb>
  803f22:	85 c0                	test   %eax,%eax
  803f24:	78 11                	js     803f37 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f29:	8b 15 58 60 80 00    	mov    0x806058,%edx
  803f2f:	39 10                	cmp    %edx,(%eax)
  803f31:	0f 94 c0             	sete   %al
  803f34:	0f b6 c0             	movzbl %al,%eax
}
  803f37:	c9                   	leave  
  803f38:	c3                   	ret    

00803f39 <_Z8openconsv>:

int
opencons(void)
{
  803f39:	55                   	push   %ebp
  803f3a:	89 e5                	mov    %esp,%ebp
  803f3c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803f3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f42:	89 04 24             	mov    %eax,(%esp)
  803f45:	e8 ed d7 ff ff       	call   801737 <_Z14fd_find_unusedPP2Fd>
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	78 3c                	js     803f8a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f4e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f55:	00 
  803f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f64:	e8 f7 d0 ff ff       	call   801060 <_Z14sys_page_allociPvi>
  803f69:	85 c0                	test   %eax,%eax
  803f6b:	78 1d                	js     803f8a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803f6d:	8b 15 58 60 80 00    	mov    0x806058,%edx
  803f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f76:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803f82:	89 04 24             	mov    %eax,(%esp)
  803f85:	e8 4a d7 ff ff       	call   8016d4 <_Z6fd2numP2Fd>
}
  803f8a:	c9                   	leave  
  803f8b:	c3                   	ret    
  803f8c:	00 00                	add    %al,(%eax)
	...

00803f90 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803f90:	55                   	push   %ebp
  803f91:	89 e5                	mov    %esp,%ebp
  803f93:	56                   	push   %esi
  803f94:	53                   	push   %ebx
  803f95:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803f98:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803f9d:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  803fa4:	85 c0                	test   %eax,%eax
  803fa6:	74 08                	je     803fb0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803fa8:	8d 55 08             	lea    0x8(%ebp),%edx
  803fab:	89 14 24             	mov    %edx,(%esp)
  803fae:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803fb0:	83 eb 01             	sub    $0x1,%ebx
  803fb3:	83 fb ff             	cmp    $0xffffffff,%ebx
  803fb6:	75 e5                	jne    803f9d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803fb8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803fbb:	8b 75 08             	mov    0x8(%ebp),%esi
  803fbe:	e8 35 d0 ff ff       	call   800ff8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803fc3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803fc7:	89 74 24 10          	mov    %esi,0x10(%esp)
  803fcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fcf:	c7 44 24 08 58 4f 80 	movl   $0x804f58,0x8(%esp)
  803fd6:	00 
  803fd7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803fde:	00 
  803fdf:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  803fe6:	e8 55 c4 ff ff       	call   800440 <_Z6_panicPKciS0_z>

00803feb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803feb:	55                   	push   %ebp
  803fec:	89 e5                	mov    %esp,%ebp
  803fee:	56                   	push   %esi
  803fef:	53                   	push   %ebx
  803ff0:	83 ec 10             	sub    $0x10,%esp
  803ff3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803ff6:	e8 fd cf ff ff       	call   800ff8 <_Z12sys_getenvidv>
  803ffb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803ffd:	a1 00 74 80 00       	mov    0x807400,%eax
  804002:	8b 40 5c             	mov    0x5c(%eax),%eax
  804005:	85 c0                	test   %eax,%eax
  804007:	75 4c                	jne    804055 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804009:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804010:	00 
  804011:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804018:	ee 
  804019:	89 34 24             	mov    %esi,(%esp)
  80401c:	e8 3f d0 ff ff       	call   801060 <_Z14sys_page_allociPvi>
  804021:	85 c0                	test   %eax,%eax
  804023:	74 20                	je     804045 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804025:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804029:	c7 44 24 08 90 4f 80 	movl   $0x804f90,0x8(%esp)
  804030:	00 
  804031:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804038:	00 
  804039:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  804040:	e8 fb c3 ff ff       	call   800440 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804045:	c7 44 24 04 90 3f 80 	movl   $0x803f90,0x4(%esp)
  80404c:	00 
  80404d:	89 34 24             	mov    %esi,(%esp)
  804050:	e8 40 d2 ff ff       	call   801295 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804055:	a1 00 90 80 00       	mov    0x809000,%eax
  80405a:	39 d8                	cmp    %ebx,%eax
  80405c:	74 1a                	je     804078 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80405e:	85 c0                	test   %eax,%eax
  804060:	74 20                	je     804082 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804062:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804067:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80406e:	39 da                	cmp    %ebx,%edx
  804070:	74 15                	je     804087 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804072:	85 d2                	test   %edx,%edx
  804074:	75 1f                	jne    804095 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804076:	eb 0f                	jmp    804087 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804078:	b8 00 00 00 00       	mov    $0x0,%eax
  80407d:	8d 76 00             	lea    0x0(%esi),%esi
  804080:	eb 05                	jmp    804087 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804082:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804087:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80408e:	83 c4 10             	add    $0x10,%esp
  804091:	5b                   	pop    %ebx
  804092:	5e                   	pop    %esi
  804093:	5d                   	pop    %ebp
  804094:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804095:	83 c0 01             	add    $0x1,%eax
  804098:	83 f8 08             	cmp    $0x8,%eax
  80409b:	75 ca                	jne    804067 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80409d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8040a1:	c7 44 24 08 b4 4f 80 	movl   $0x804fb4,0x8(%esp)
  8040a8:	00 
  8040a9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8040b0:	00 
  8040b1:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  8040b8:	e8 83 c3 ff ff       	call   800440 <_Z6_panicPKciS0_z>
  8040bd:	00 00                	add    %al,(%eax)
	...

008040c0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8040c0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8040c3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8040c4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8040c7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8040cb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8040cf:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8040d2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8040d4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8040d8:	61                   	popa   
    popf
  8040d9:	9d                   	popf   
    popl %esp
  8040da:	5c                   	pop    %esp
    ret
  8040db:	c3                   	ret    

008040dc <spin>:

spin:	jmp spin
  8040dc:	eb fe                	jmp    8040dc <spin>
	...

008040e0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8040e0:	55                   	push   %ebp
  8040e1:	89 e5                	mov    %esp,%ebp
  8040e3:	56                   	push   %esi
  8040e4:	53                   	push   %ebx
  8040e5:	83 ec 10             	sub    $0x10,%esp
  8040e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8040eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040ee:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  8040f1:	85 c0                	test   %eax,%eax
  8040f3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8040f8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  8040fb:	89 04 24             	mov    %eax,(%esp)
  8040fe:	e8 28 d2 ff ff       	call   80132b <_Z12sys_ipc_recvPv>
  804103:	85 c0                	test   %eax,%eax
  804105:	79 16                	jns    80411d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804107:	85 db                	test   %ebx,%ebx
  804109:	74 06                	je     804111 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80410b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804111:	85 f6                	test   %esi,%esi
  804113:	74 53                	je     804168 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804115:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80411b:	eb 4b                	jmp    804168 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80411d:	85 db                	test   %ebx,%ebx
  80411f:	74 17                	je     804138 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804121:	e8 d2 ce ff ff       	call   800ff8 <_Z12sys_getenvidv>
  804126:	25 ff 03 00 00       	and    $0x3ff,%eax
  80412b:	6b c0 78             	imul   $0x78,%eax,%eax
  80412e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804133:	8b 40 60             	mov    0x60(%eax),%eax
  804136:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804138:	85 f6                	test   %esi,%esi
  80413a:	74 17                	je     804153 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80413c:	e8 b7 ce ff ff       	call   800ff8 <_Z12sys_getenvidv>
  804141:	25 ff 03 00 00       	and    $0x3ff,%eax
  804146:	6b c0 78             	imul   $0x78,%eax,%eax
  804149:	05 00 00 00 ef       	add    $0xef000000,%eax
  80414e:	8b 40 70             	mov    0x70(%eax),%eax
  804151:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804153:	e8 a0 ce ff ff       	call   800ff8 <_Z12sys_getenvidv>
  804158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80415d:	6b c0 78             	imul   $0x78,%eax,%eax
  804160:	05 08 00 00 ef       	add    $0xef000008,%eax
  804165:	8b 40 60             	mov    0x60(%eax),%eax

}
  804168:	83 c4 10             	add    $0x10,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5d                   	pop    %ebp
  80416e:	c3                   	ret    

0080416f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80416f:	55                   	push   %ebp
  804170:	89 e5                	mov    %esp,%ebp
  804172:	57                   	push   %edi
  804173:	56                   	push   %esi
  804174:	53                   	push   %ebx
  804175:	83 ec 1c             	sub    $0x1c,%esp
  804178:	8b 75 08             	mov    0x8(%ebp),%esi
  80417b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80417e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804181:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804183:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804188:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80418b:	8b 45 14             	mov    0x14(%ebp),%eax
  80418e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804192:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804196:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80419a:	89 34 24             	mov    %esi,(%esp)
  80419d:	e8 51 d1 ff ff       	call   8012f3 <_Z16sys_ipc_try_sendijPvi>
  8041a2:	85 c0                	test   %eax,%eax
  8041a4:	79 31                	jns    8041d7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8041a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8041a9:	75 0c                	jne    8041b7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8041ab:	90                   	nop
  8041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041b0:	e8 77 ce ff ff       	call   80102c <_Z9sys_yieldv>
  8041b5:	eb d4                	jmp    80418b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8041b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041bb:	c7 44 24 08 ea 4f 80 	movl   $0x804fea,0x8(%esp)
  8041c2:	00 
  8041c3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8041ca:	00 
  8041cb:	c7 04 24 f7 4f 80 00 	movl   $0x804ff7,(%esp)
  8041d2:	e8 69 c2 ff ff       	call   800440 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  8041d7:	83 c4 1c             	add    $0x1c,%esp
  8041da:	5b                   	pop    %ebx
  8041db:	5e                   	pop    %esi
  8041dc:	5f                   	pop    %edi
  8041dd:	5d                   	pop    %ebp
  8041de:	c3                   	ret    
	...

008041e0 <__udivdi3>:
  8041e0:	55                   	push   %ebp
  8041e1:	89 e5                	mov    %esp,%ebp
  8041e3:	57                   	push   %edi
  8041e4:	56                   	push   %esi
  8041e5:	83 ec 20             	sub    $0x20,%esp
  8041e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8041eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8041ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8041f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8041f4:	85 c0                	test   %eax,%eax
  8041f6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8041f9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8041fc:	75 3a                	jne    804238 <__udivdi3+0x58>
  8041fe:	39 f9                	cmp    %edi,%ecx
  804200:	77 66                	ja     804268 <__udivdi3+0x88>
  804202:	85 c9                	test   %ecx,%ecx
  804204:	75 0b                	jne    804211 <__udivdi3+0x31>
  804206:	b8 01 00 00 00       	mov    $0x1,%eax
  80420b:	31 d2                	xor    %edx,%edx
  80420d:	f7 f1                	div    %ecx
  80420f:	89 c1                	mov    %eax,%ecx
  804211:	89 f8                	mov    %edi,%eax
  804213:	31 d2                	xor    %edx,%edx
  804215:	f7 f1                	div    %ecx
  804217:	89 c7                	mov    %eax,%edi
  804219:	89 f0                	mov    %esi,%eax
  80421b:	f7 f1                	div    %ecx
  80421d:	89 fa                	mov    %edi,%edx
  80421f:	89 c6                	mov    %eax,%esi
  804221:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804224:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80422a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80422d:	83 c4 20             	add    $0x20,%esp
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804238:	31 d2                	xor    %edx,%edx
  80423a:	31 f6                	xor    %esi,%esi
  80423c:	39 f8                	cmp    %edi,%eax
  80423e:	77 e1                	ja     804221 <__udivdi3+0x41>
  804240:	0f bd d0             	bsr    %eax,%edx
  804243:	83 f2 1f             	xor    $0x1f,%edx
  804246:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804249:	75 2d                	jne    804278 <__udivdi3+0x98>
  80424b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80424e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804251:	76 06                	jbe    804259 <__udivdi3+0x79>
  804253:	39 f8                	cmp    %edi,%eax
  804255:	89 f2                	mov    %esi,%edx
  804257:	73 c8                	jae    804221 <__udivdi3+0x41>
  804259:	31 d2                	xor    %edx,%edx
  80425b:	be 01 00 00 00       	mov    $0x1,%esi
  804260:	eb bf                	jmp    804221 <__udivdi3+0x41>
  804262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804268:	89 f0                	mov    %esi,%eax
  80426a:	89 fa                	mov    %edi,%edx
  80426c:	f7 f1                	div    %ecx
  80426e:	31 d2                	xor    %edx,%edx
  804270:	89 c6                	mov    %eax,%esi
  804272:	eb ad                	jmp    804221 <__udivdi3+0x41>
  804274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804278:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80427c:	89 c2                	mov    %eax,%edx
  80427e:	b8 20 00 00 00       	mov    $0x20,%eax
  804283:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804286:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804289:	d3 e2                	shl    %cl,%edx
  80428b:	89 c1                	mov    %eax,%ecx
  80428d:	d3 ee                	shr    %cl,%esi
  80428f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804293:	09 d6                	or     %edx,%esi
  804295:	89 fa                	mov    %edi,%edx
  804297:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80429a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80429d:	d3 e6                	shl    %cl,%esi
  80429f:	89 c1                	mov    %eax,%ecx
  8042a1:	d3 ea                	shr    %cl,%edx
  8042a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042a7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8042aa:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8042ad:	d3 e7                	shl    %cl,%edi
  8042af:	89 c1                	mov    %eax,%ecx
  8042b1:	d3 ee                	shr    %cl,%esi
  8042b3:	09 fe                	or     %edi,%esi
  8042b5:	89 f0                	mov    %esi,%eax
  8042b7:	f7 75 e4             	divl   -0x1c(%ebp)
  8042ba:	89 d7                	mov    %edx,%edi
  8042bc:	89 c6                	mov    %eax,%esi
  8042be:	f7 65 f0             	mull   -0x10(%ebp)
  8042c1:	39 d7                	cmp    %edx,%edi
  8042c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8042c6:	72 12                	jb     8042da <__udivdi3+0xfa>
  8042c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042cb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042cf:	d3 e2                	shl    %cl,%edx
  8042d1:	39 c2                	cmp    %eax,%edx
  8042d3:	73 08                	jae    8042dd <__udivdi3+0xfd>
  8042d5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8042d8:	75 03                	jne    8042dd <__udivdi3+0xfd>
  8042da:	83 ee 01             	sub    $0x1,%esi
  8042dd:	31 d2                	xor    %edx,%edx
  8042df:	e9 3d ff ff ff       	jmp    804221 <__udivdi3+0x41>
	...

008042f0 <__umoddi3>:
  8042f0:	55                   	push   %ebp
  8042f1:	89 e5                	mov    %esp,%ebp
  8042f3:	57                   	push   %edi
  8042f4:	56                   	push   %esi
  8042f5:	83 ec 20             	sub    $0x20,%esp
  8042f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8042fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804301:	8b 75 0c             	mov    0xc(%ebp),%esi
  804304:	85 ff                	test   %edi,%edi
  804306:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804309:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80430c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80430f:	89 f2                	mov    %esi,%edx
  804311:	75 15                	jne    804328 <__umoddi3+0x38>
  804313:	39 f1                	cmp    %esi,%ecx
  804315:	76 41                	jbe    804358 <__umoddi3+0x68>
  804317:	f7 f1                	div    %ecx
  804319:	89 d0                	mov    %edx,%eax
  80431b:	31 d2                	xor    %edx,%edx
  80431d:	83 c4 20             	add    $0x20,%esp
  804320:	5e                   	pop    %esi
  804321:	5f                   	pop    %edi
  804322:	5d                   	pop    %ebp
  804323:	c3                   	ret    
  804324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804328:	39 f7                	cmp    %esi,%edi
  80432a:	77 4c                	ja     804378 <__umoddi3+0x88>
  80432c:	0f bd c7             	bsr    %edi,%eax
  80432f:	83 f0 1f             	xor    $0x1f,%eax
  804332:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804335:	75 51                	jne    804388 <__umoddi3+0x98>
  804337:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80433a:	0f 87 e8 00 00 00    	ja     804428 <__umoddi3+0x138>
  804340:	89 f2                	mov    %esi,%edx
  804342:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804345:	29 ce                	sub    %ecx,%esi
  804347:	19 fa                	sbb    %edi,%edx
  804349:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80434c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80434f:	83 c4 20             	add    $0x20,%esp
  804352:	5e                   	pop    %esi
  804353:	5f                   	pop    %edi
  804354:	5d                   	pop    %ebp
  804355:	c3                   	ret    
  804356:	66 90                	xchg   %ax,%ax
  804358:	85 c9                	test   %ecx,%ecx
  80435a:	75 0b                	jne    804367 <__umoddi3+0x77>
  80435c:	b8 01 00 00 00       	mov    $0x1,%eax
  804361:	31 d2                	xor    %edx,%edx
  804363:	f7 f1                	div    %ecx
  804365:	89 c1                	mov    %eax,%ecx
  804367:	89 f0                	mov    %esi,%eax
  804369:	31 d2                	xor    %edx,%edx
  80436b:	f7 f1                	div    %ecx
  80436d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804370:	eb a5                	jmp    804317 <__umoddi3+0x27>
  804372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804378:	89 f2                	mov    %esi,%edx
  80437a:	83 c4 20             	add    $0x20,%esp
  80437d:	5e                   	pop    %esi
  80437e:	5f                   	pop    %edi
  80437f:	5d                   	pop    %ebp
  804380:	c3                   	ret    
  804381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804388:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80438c:	89 f2                	mov    %esi,%edx
  80438e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804391:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804398:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80439b:	d3 e7                	shl    %cl,%edi
  80439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043a4:	d3 e8                	shr    %cl,%eax
  8043a6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043aa:	09 f8                	or     %edi,%eax
  8043ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8043af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b2:	d3 e0                	shl    %cl,%eax
  8043b4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043be:	d3 ea                	shr    %cl,%edx
  8043c0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043c4:	d3 e6                	shl    %cl,%esi
  8043c6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043ca:	d3 e8                	shr    %cl,%eax
  8043cc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043d0:	09 f0                	or     %esi,%eax
  8043d2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8043d5:	f7 75 e4             	divl   -0x1c(%ebp)
  8043d8:	d3 e6                	shl    %cl,%esi
  8043da:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8043dd:	89 d6                	mov    %edx,%esi
  8043df:	f7 65 f4             	mull   -0xc(%ebp)
  8043e2:	89 d7                	mov    %edx,%edi
  8043e4:	89 c2                	mov    %eax,%edx
  8043e6:	39 fe                	cmp    %edi,%esi
  8043e8:	89 f9                	mov    %edi,%ecx
  8043ea:	72 30                	jb     80441c <__umoddi3+0x12c>
  8043ec:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8043ef:	72 27                	jb     804418 <__umoddi3+0x128>
  8043f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043f4:	29 d0                	sub    %edx,%eax
  8043f6:	19 ce                	sbb    %ecx,%esi
  8043f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043fc:	89 f2                	mov    %esi,%edx
  8043fe:	d3 e8                	shr    %cl,%eax
  804400:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804404:	d3 e2                	shl    %cl,%edx
  804406:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80440a:	09 d0                	or     %edx,%eax
  80440c:	89 f2                	mov    %esi,%edx
  80440e:	d3 ea                	shr    %cl,%edx
  804410:	83 c4 20             	add    $0x20,%esp
  804413:	5e                   	pop    %esi
  804414:	5f                   	pop    %edi
  804415:	5d                   	pop    %ebp
  804416:	c3                   	ret    
  804417:	90                   	nop
  804418:	39 fe                	cmp    %edi,%esi
  80441a:	75 d5                	jne    8043f1 <__umoddi3+0x101>
  80441c:	89 f9                	mov    %edi,%ecx
  80441e:	89 c2                	mov    %eax,%edx
  804420:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804423:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804426:	eb c9                	jmp    8043f1 <__umoddi3+0x101>
  804428:	39 f7                	cmp    %esi,%edi
  80442a:	0f 82 10 ff ff ff    	jb     804340 <__umoddi3+0x50>
  804430:	e9 17 ff ff ff       	jmp    80434c <__umoddi3+0x5c>
