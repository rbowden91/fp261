
obj/user/faultregs:     file format elf32-i386


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
  80002c:	e8 63 05 00 00       	call   800594 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL10check_regsP4regsPKcS0_S2_S2_>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 1c             	sub    $0x1c,%esp
  80003d:	89 c3                	mov    %eax,%ebx
  80003f:	89 ce                	mov    %ecx,%esi
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800041:	8b 45 08             	mov    0x8(%ebp),%eax
  800044:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800048:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004c:	c7 44 24 04 b1 43 80 	movl   $0x8043b1,0x4(%esp)
  800053:	00 
  800054:	c7 04 24 80 43 80 00 	movl   $0x804380,(%esp)
  80005b:	e8 d6 06 00 00       	call   800736 <_Z7cprintfPKcz>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800060:	8b 06                	mov    (%esi),%eax
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	8b 03                	mov    (%ebx),%eax
  800068:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006c:	c7 44 24 04 90 43 80 	movl   $0x804390,0x4(%esp)
  800073:	00 
  800074:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  80007b:	e8 b6 06 00 00       	call   800736 <_Z7cprintfPKcz>
  800080:	8b 06                	mov    (%esi),%eax
  800082:	39 03                	cmp    %eax,(%ebx)
  800084:	75 13                	jne    800099 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x65>
  800086:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  80008d:	e8 a4 06 00 00       	call   800736 <_Z7cprintfPKcz>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800092:	bf 00 00 00 00       	mov    $0x0,%edi
  800097:	eb 11                	jmp    8000aa <_ZL10check_regsP4regsPKcS0_S2_S2_+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800099:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  8000a0:	e8 91 06 00 00       	call   800736 <_Z7cprintfPKcz>
  8000a5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000aa:	8b 46 04             	mov    0x4(%esi),%eax
  8000ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8000b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b8:	c7 44 24 04 b2 43 80 	movl   $0x8043b2,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  8000c7:	e8 6a 06 00 00       	call   800736 <_Z7cprintfPKcz>
  8000cc:	8b 46 04             	mov    0x4(%esi),%eax
  8000cf:	39 43 04             	cmp    %eax,0x4(%ebx)
  8000d2:	75 0e                	jne    8000e2 <_ZL10check_regsP4regsPKcS0_S2_S2_+0xae>
  8000d4:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  8000db:	e8 56 06 00 00       	call   800736 <_Z7cprintfPKcz>
  8000e0:	eb 11                	jmp    8000f3 <_ZL10check_regsP4regsPKcS0_S2_S2_+0xbf>
  8000e2:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  8000e9:	e8 48 06 00 00       	call   800736 <_Z7cprintfPKcz>
  8000ee:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f3:	8b 46 08             	mov    0x8(%esi),%eax
  8000f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fa:	8b 43 08             	mov    0x8(%ebx),%eax
  8000fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800101:	c7 44 24 04 b6 43 80 	movl   $0x8043b6,0x4(%esp)
  800108:	00 
  800109:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  800110:	e8 21 06 00 00       	call   800736 <_Z7cprintfPKcz>
  800115:	8b 46 08             	mov    0x8(%esi),%eax
  800118:	39 43 08             	cmp    %eax,0x8(%ebx)
  80011b:	75 0e                	jne    80012b <_ZL10check_regsP4regsPKcS0_S2_S2_+0xf7>
  80011d:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  800124:	e8 0d 06 00 00       	call   800736 <_Z7cprintfPKcz>
  800129:	eb 11                	jmp    80013c <_ZL10check_regsP4regsPKcS0_S2_S2_+0x108>
  80012b:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  800132:	e8 ff 05 00 00       	call   800736 <_Z7cprintfPKcz>
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013c:	8b 46 10             	mov    0x10(%esi),%eax
  80013f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800143:	8b 43 10             	mov    0x10(%ebx),%eax
  800146:	89 44 24 08          	mov    %eax,0x8(%esp)
  80014a:	c7 44 24 04 ba 43 80 	movl   $0x8043ba,0x4(%esp)
  800151:	00 
  800152:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  800159:	e8 d8 05 00 00       	call   800736 <_Z7cprintfPKcz>
  80015e:	8b 46 10             	mov    0x10(%esi),%eax
  800161:	39 43 10             	cmp    %eax,0x10(%ebx)
  800164:	75 0e                	jne    800174 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x140>
  800166:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  80016d:	e8 c4 05 00 00       	call   800736 <_Z7cprintfPKcz>
  800172:	eb 11                	jmp    800185 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x151>
  800174:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  80017b:	e8 b6 05 00 00       	call   800736 <_Z7cprintfPKcz>
  800180:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800185:	8b 46 14             	mov    0x14(%esi),%eax
  800188:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018c:	8b 43 14             	mov    0x14(%ebx),%eax
  80018f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800193:	c7 44 24 04 be 43 80 	movl   $0x8043be,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  8001a2:	e8 8f 05 00 00       	call   800736 <_Z7cprintfPKcz>
  8001a7:	8b 46 14             	mov    0x14(%esi),%eax
  8001aa:	39 43 14             	cmp    %eax,0x14(%ebx)
  8001ad:	75 0e                	jne    8001bd <_ZL10check_regsP4regsPKcS0_S2_S2_+0x189>
  8001af:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  8001b6:	e8 7b 05 00 00       	call   800736 <_Z7cprintfPKcz>
  8001bb:	eb 11                	jmp    8001ce <_ZL10check_regsP4regsPKcS0_S2_S2_+0x19a>
  8001bd:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  8001c4:	e8 6d 05 00 00       	call   800736 <_Z7cprintfPKcz>
  8001c9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001ce:	8b 46 18             	mov    0x18(%esi),%eax
  8001d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d5:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001dc:	c7 44 24 04 c2 43 80 	movl   $0x8043c2,0x4(%esp)
  8001e3:	00 
  8001e4:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  8001eb:	e8 46 05 00 00       	call   800736 <_Z7cprintfPKcz>
  8001f0:	8b 46 18             	mov    0x18(%esi),%eax
  8001f3:	39 43 18             	cmp    %eax,0x18(%ebx)
  8001f6:	75 0e                	jne    800206 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x1d2>
  8001f8:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  8001ff:	e8 32 05 00 00       	call   800736 <_Z7cprintfPKcz>
  800204:	eb 11                	jmp    800217 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x1e3>
  800206:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  80020d:	e8 24 05 00 00       	call   800736 <_Z7cprintfPKcz>
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800217:	8b 46 1c             	mov    0x1c(%esi),%eax
  80021a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021e:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800221:	89 44 24 08          	mov    %eax,0x8(%esp)
  800225:	c7 44 24 04 c6 43 80 	movl   $0x8043c6,0x4(%esp)
  80022c:	00 
  80022d:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  800234:	e8 fd 04 00 00       	call   800736 <_Z7cprintfPKcz>
  800239:	8b 46 1c             	mov    0x1c(%esi),%eax
  80023c:	39 43 1c             	cmp    %eax,0x1c(%ebx)
  80023f:	75 0e                	jne    80024f <_ZL10check_regsP4regsPKcS0_S2_S2_+0x21b>
  800241:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  800248:	e8 e9 04 00 00       	call   800736 <_Z7cprintfPKcz>
  80024d:	eb 11                	jmp    800260 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x22c>
  80024f:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  800256:	e8 db 04 00 00       	call   800736 <_Z7cprintfPKcz>
  80025b:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  800260:	8b 46 20             	mov    0x20(%esi),%eax
  800263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800267:	8b 43 20             	mov    0x20(%ebx),%eax
  80026a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026e:	c7 44 24 04 ca 43 80 	movl   $0x8043ca,0x4(%esp)
  800275:	00 
  800276:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  80027d:	e8 b4 04 00 00       	call   800736 <_Z7cprintfPKcz>
  800282:	8b 46 20             	mov    0x20(%esi),%eax
  800285:	39 43 20             	cmp    %eax,0x20(%ebx)
  800288:	75 0e                	jne    800298 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x264>
  80028a:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  800291:	e8 a0 04 00 00       	call   800736 <_Z7cprintfPKcz>
  800296:	eb 11                	jmp    8002a9 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x275>
  800298:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  80029f:	e8 92 04 00 00       	call   800736 <_Z7cprintfPKcz>
  8002a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a9:	8b 46 24             	mov    0x24(%esi),%eax
  8002ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b0:	8b 43 24             	mov    0x24(%ebx),%eax
  8002b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b7:	c7 44 24 04 ce 43 80 	movl   $0x8043ce,0x4(%esp)
  8002be:	00 
  8002bf:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  8002c6:	e8 6b 04 00 00       	call   800736 <_Z7cprintfPKcz>
  8002cb:	8b 46 24             	mov    0x24(%esi),%eax
  8002ce:	39 43 24             	cmp    %eax,0x24(%ebx)
  8002d1:	75 0e                	jne    8002e1 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x2ad>
  8002d3:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  8002da:	e8 57 04 00 00       	call   800736 <_Z7cprintfPKcz>
  8002df:	eb 11                	jmp    8002f2 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x2be>
  8002e1:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  8002e8:	e8 49 04 00 00       	call   800736 <_Z7cprintfPKcz>
  8002ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f2:	8b 46 28             	mov    0x28(%esi),%eax
  8002f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f9:	8b 43 28             	mov    0x28(%ebx),%eax
  8002fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800300:	c7 44 24 04 d5 43 80 	movl   $0x8043d5,0x4(%esp)
  800307:	00 
  800308:	c7 04 24 94 43 80 00 	movl   $0x804394,(%esp)
  80030f:	e8 22 04 00 00       	call   800736 <_Z7cprintfPKcz>
  800314:	8b 46 28             	mov    0x28(%esi),%eax
  800317:	39 43 28             	cmp    %eax,0x28(%ebx)
  80031a:	75 25                	jne    800341 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x30d>
  80031c:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  800323:	e8 0e 04 00 00       	call   800736 <_Z7cprintfPKcz>

#undef CHECK

	cprintf("Registers %s ", testname);
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	c7 04 24 d9 43 80 00 	movl   $0x8043d9,(%esp)
  800336:	e8 fb 03 00 00       	call   800736 <_Z7cprintfPKcz>
	if (!mismatch)
  80033b:	85 ff                	test   %edi,%edi
  80033d:	74 23                	je     800362 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x32e>
  80033f:	eb 2f                	jmp    800370 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800341:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  800348:	e8 e9 03 00 00       	call   800736 <_Z7cprintfPKcz>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 d9 43 80 00 	movl   $0x8043d9,(%esp)
  80035b:	e8 d6 03 00 00       	call   800736 <_Z7cprintfPKcz>
  800360:	eb 0e                	jmp    800370 <_ZL10check_regsP4regsPKcS0_S2_S2_+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800362:	c7 04 24 a4 43 80 00 	movl   $0x8043a4,(%esp)
  800369:	e8 c8 03 00 00       	call   800736 <_Z7cprintfPKcz>
  80036e:	eb 0c                	jmp    80037c <_ZL10check_regsP4regsPKcS0_S2_S2_+0x348>
	else
		cprintf("MISMATCH\n");
  800370:	c7 04 24 a8 43 80 00 	movl   $0x8043a8,(%esp)
  800377:	e8 ba 03 00 00       	call   800736 <_Z7cprintfPKcz>
}
  80037c:	83 c4 1c             	add    $0x1c,%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <_ZL7pgfaultP10UTrapframe>:

static void
pgfault(struct UTrapframe *utf)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	53                   	push   %ebx
  800388:	83 ec 24             	sub    $0x24,%esp
  80038b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;


	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  80038e:	8b 43 08             	mov    0x8(%ebx),%eax
  800391:	a3 80 60 80 00       	mov    %eax,0x806080
  800396:	8b 43 0c             	mov    0xc(%ebx),%eax
  800399:	a3 84 60 80 00       	mov    %eax,0x806084
  80039e:	8b 43 10             	mov    0x10(%ebx),%eax
  8003a1:	a3 88 60 80 00       	mov    %eax,0x806088
  8003a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8003a9:	a3 8c 60 80 00       	mov    %eax,0x80608c
  8003ae:	8b 43 18             	mov    0x18(%ebx),%eax
  8003b1:	a3 90 60 80 00       	mov    %eax,0x806090
  8003b6:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8003b9:	a3 94 60 80 00       	mov    %eax,0x806094
  8003be:	8b 43 20             	mov    0x20(%ebx),%eax
  8003c1:	a3 98 60 80 00       	mov    %eax,0x806098
  8003c6:	8b 43 24             	mov    0x24(%ebx),%eax
  8003c9:	a3 9c 60 80 00       	mov    %eax,0x80609c
	during.eip = utf->utf_eip;
  8003ce:	8b 43 30             	mov    0x30(%ebx),%eax
  8003d1:	a3 a0 60 80 00       	mov    %eax,0x8060a0
	during.eflags = utf->utf_eflags;
  8003d6:	8b 43 28             	mov    0x28(%ebx),%eax
  8003d9:	a3 a4 60 80 00       	mov    %eax,0x8060a4
	during.esp = utf->utf_esp;
  8003de:	8b 43 2c             	mov    0x2c(%ebx),%eax
  8003e1:	a3 a8 60 80 00       	mov    %eax,0x8060a8
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8003e6:	c7 44 24 04 ee 43 80 	movl   $0x8043ee,0x4(%esp)
  8003ed:	00 
  8003ee:	c7 04 24 fc 43 80 00 	movl   $0x8043fc,(%esp)
  8003f5:	b9 80 60 80 00       	mov    $0x806080,%ecx
  8003fa:	ba e7 43 80 00       	mov    $0x8043e7,%edx
  8003ff:	b8 00 60 80 00       	mov    $0x806000,%eax
  800404:	e8 2b fc ff ff       	call   800034 <_ZL10check_regsP4regsPKcS0_S2_S2_>
	if (utf->utf_fault_va != (uint32_t)UTEMP)
  800409:	8b 03                	mov    (%ebx),%eax
  80040b:	3d 00 00 40 00       	cmp    $0x400000,%eax
  800410:	74 27                	je     800439 <_ZL7pgfaultP10UTrapframe+0xb5>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);
  800412:	8b 53 30             	mov    0x30(%ebx),%edx
  800415:	89 54 24 10          	mov    %edx,0x10(%esp)
  800419:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80041d:	c7 44 24 08 40 44 80 	movl   $0x804440,0x8(%esp)
  800424:	00 
  800425:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  80042c:	00 
  80042d:	c7 04 24 03 44 80 00 	movl   $0x804403,(%esp)
  800434:	e8 df 01 00 00       	call   800618 <_Z6_panicPKciS0_z>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800439:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800440:	00 
  800441:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800448:	00 
  800449:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800450:	e8 db 0d 00 00       	call   801230 <_Z14sys_page_allociPvi>
  800455:	85 c0                	test   %eax,%eax
  800457:	79 20                	jns    800479 <_ZL7pgfaultP10UTrapframe+0xf5>
		panic("sys_page_alloc: %e", r);
  800459:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045d:	c7 44 24 08 14 44 80 	movl   $0x804414,0x8(%esp)
  800464:	00 
  800465:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80046c:	00 
  80046d:	c7 04 24 03 44 80 00 	movl   $0x804403,(%esp)
  800474:	e8 9f 01 00 00       	call   800618 <_Z6_panicPKciS0_z>
	resume(utf);
  800479:	89 1c 24             	mov    %ebx,(%esp)
  80047c:	e8 1f 13 00 00       	call   8017a0 <resume>

00800481 <_Z5umainiPPc>:
}

void
umain(int argc, char **argv)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 18             	sub    $0x18,%esp
	add_pgfault_handler(pgfault);
  800487:	c7 04 24 84 03 80 00 	movl   $0x800384,(%esp)
  80048e:	e8 38 12 00 00       	call   8016cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
		"\tpushl %%eax\n"
		"\tpushfl\n"
		"\tpopl %%eax\n"
		"\tmov %%eax, %1+0x24\n"
		"\tpopl %%eax\n"
		: : "m" (before), "m" (after) : "memory", "cc");
  800493:	50                   	push   %eax
  800494:	9c                   	pushf  
  800495:	58                   	pop    %eax
  800496:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049b:	50                   	push   %eax
  80049c:	9d                   	popf   
  80049d:	a3 24 60 80 00       	mov    %eax,0x806024
  8004a2:	8d 05 dd 04 80 00    	lea    0x8004dd,%eax
  8004a8:	a3 20 60 80 00       	mov    %eax,0x806020
  8004ad:	58                   	pop    %eax
  8004ae:	89 3d 00 60 80 00    	mov    %edi,0x806000
  8004b4:	89 35 04 60 80 00    	mov    %esi,0x806004
  8004ba:	89 2d 08 60 80 00    	mov    %ebp,0x806008
  8004c0:	89 1d 10 60 80 00    	mov    %ebx,0x806010
  8004c6:	89 15 14 60 80 00    	mov    %edx,0x806014
  8004cc:	89 0d 18 60 80 00    	mov    %ecx,0x806018
  8004d2:	a3 1c 60 80 00       	mov    %eax,0x80601c
  8004d7:	89 25 28 60 80 00    	mov    %esp,0x806028
  8004dd:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e4:	00 00 00 
  8004e7:	89 3d 40 60 80 00    	mov    %edi,0x806040
  8004ed:	89 35 44 60 80 00    	mov    %esi,0x806044
  8004f3:	89 2d 48 60 80 00    	mov    %ebp,0x806048
  8004f9:	89 1d 50 60 80 00    	mov    %ebx,0x806050
  8004ff:	89 15 54 60 80 00    	mov    %edx,0x806054
  800505:	89 0d 58 60 80 00    	mov    %ecx,0x806058
  80050b:	a3 5c 60 80 00       	mov    %eax,0x80605c
  800510:	89 25 68 60 80 00    	mov    %esp,0x806068
  800516:	8b 3d 00 60 80 00    	mov    0x806000,%edi
  80051c:	8b 35 04 60 80 00    	mov    0x806004,%esi
  800522:	8b 2d 08 60 80 00    	mov    0x806008,%ebp
  800528:	8b 1d 10 60 80 00    	mov    0x806010,%ebx
  80052e:	8b 15 14 60 80 00    	mov    0x806014,%edx
  800534:	8b 0d 18 60 80 00    	mov    0x806018,%ecx
  80053a:	a1 1c 60 80 00       	mov    0x80601c,%eax
  80053f:	8b 25 28 60 80 00    	mov    0x806028,%esp
  800545:	50                   	push   %eax
  800546:	9c                   	pushf  
  800547:	58                   	pop    %eax
  800548:	a3 64 60 80 00       	mov    %eax,0x806064
  80054d:	58                   	pop    %eax

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80054e:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800555:	74 0c                	je     800563 <_Z5umainiPPc+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  800557:	c7 04 24 74 44 80 00 	movl   $0x804474,(%esp)
  80055e:	e8 d3 01 00 00       	call   800736 <_Z7cprintfPKcz>
	after.eip = before.eip;
  800563:	a1 20 60 80 00       	mov    0x806020,%eax
  800568:	a3 60 60 80 00       	mov    %eax,0x806060

	check_regs(&before, "before", &after, "after", "after page-fault");
  80056d:	c7 44 24 04 27 44 80 	movl   $0x804427,0x4(%esp)
  800574:	00 
  800575:	c7 04 24 38 44 80 00 	movl   $0x804438,(%esp)
  80057c:	b9 40 60 80 00       	mov    $0x806040,%ecx
  800581:	ba e7 43 80 00       	mov    $0x8043e7,%edx
  800586:	b8 00 60 80 00       	mov    $0x806000,%eax
  80058b:	e8 a4 fa ff ff       	call   800034 <_ZL10check_regsP4regsPKcS0_S2_S2_>
}
  800590:	c9                   	leave  
  800591:	c3                   	ret    
	...

00800594 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 1c             	sub    $0x1c,%esp
  80059d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8005a3:	e8 20 0c 00 00       	call   8011c8 <_Z12sys_getenvidv>
  8005a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005ad:	6b c0 78             	imul   $0x78,%eax,%eax
  8005b0:	05 00 00 00 ef       	add    $0xef000000,%eax
  8005b5:	a3 ac 60 80 00       	mov    %eax,0x8060ac
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7e 07                	jle    8005c5 <libmain+0x31>
		binaryname = argv[0];
  8005be:	8b 06                	mov    (%esi),%eax
  8005c0:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8005c5:	b8 c0 4f 80 00       	mov    $0x804fc0,%eax
  8005ca:	3d c0 4f 80 00       	cmp    $0x804fc0,%eax
  8005cf:	76 0f                	jbe    8005e0 <libmain+0x4c>
  8005d1:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  8005d3:	83 eb 04             	sub    $0x4,%ebx
  8005d6:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8005d8:	81 fb c0 4f 80 00    	cmp    $0x804fc0,%ebx
  8005de:	77 f3                	ja     8005d3 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  8005e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e4:	89 3c 24             	mov    %edi,(%esp)
  8005e7:	e8 95 fe ff ff       	call   800481 <_Z5umainiPPc>

	// exit gracefully
	exit();
  8005ec:	e8 0b 00 00 00       	call   8005fc <_Z4exitv>
}
  8005f1:	83 c4 1c             	add    $0x1c,%esp
  8005f4:	5b                   	pop    %ebx
  8005f5:	5e                   	pop    %esi
  8005f6:	5f                   	pop    %edi
  8005f7:	5d                   	pop    %ebp
  8005f8:	c3                   	ret    
  8005f9:	00 00                	add    %al,(%eax)
	...

008005fc <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800602:	e8 77 14 00 00       	call   801a7e <_Z9close_allv>
	sys_env_destroy(0);
  800607:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80060e:	e8 58 0b 00 00       	call   80116b <_Z15sys_env_destroyi>
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    
  800615:	00 00                	add    %al,(%eax)
	...

00800618 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	56                   	push   %esi
  80061c:	53                   	push   %ebx
  80061d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800620:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800623:	a1 b0 60 80 00       	mov    0x8060b0,%eax
  800628:	85 c0                	test   %eax,%eax
  80062a:	74 10                	je     80063c <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  80062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800630:	c7 04 24 9d 44 80 00 	movl   $0x80449d,(%esp)
  800637:	e8 fa 00 00 00       	call   800736 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  80063c:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  800642:	e8 81 0b 00 00       	call   8011c8 <_Z12sys_getenvidv>
  800647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80064e:	8b 55 08             	mov    0x8(%ebp),%edx
  800651:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800655:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065d:	c7 04 24 a4 44 80 00 	movl   $0x8044a4,(%esp)
  800664:	e8 cd 00 00 00       	call   800736 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80066d:	8b 45 10             	mov    0x10(%ebp),%eax
  800670:	89 04 24             	mov    %eax,(%esp)
  800673:	e8 5d 00 00 00       	call   8006d5 <_Z8vcprintfPKcPc>
	cprintf("\n");
  800678:	c7 04 24 b0 43 80 00 	movl   $0x8043b0,(%esp)
  80067f:	e8 b2 00 00 00       	call   800736 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800684:	cc                   	int3   
  800685:	eb fd                	jmp    800684 <_Z6_panicPKciS0_z+0x6c>
	...

00800688 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 18             	sub    $0x18,%esp
  80068e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800691:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800694:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800697:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800699:	8b 03                	mov    (%ebx),%eax
  80069b:	8b 55 08             	mov    0x8(%ebp),%edx
  80069e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006a2:	83 c0 01             	add    $0x1,%eax
  8006a5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ac:	75 19                	jne    8006c7 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8006ae:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006b5:	00 
  8006b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b9:	89 04 24             	mov    %eax,(%esp)
  8006bc:	e8 43 0a 00 00       	call   801104 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8006c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006c7:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8006cb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8006ce:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8006d1:	89 ec                	mov    %ebp,%esp
  8006d3:	5d                   	pop    %ebp
  8006d4:	c3                   	ret    

008006d5 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e5:	00 00 00 
	b.cnt = 0;
  8006e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ef:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800700:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070a:	c7 04 24 88 06 80 00 	movl   $0x800688,(%esp)
  800711:	e8 a1 01 00 00       	call   8008b7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800716:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80071c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800720:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	e8 d6 09 00 00       	call   801104 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80072e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80073c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80073f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 04 24             	mov    %eax,(%esp)
  800749:	e8 87 ff ff ff       	call   8006d5 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

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
  8007bf:	e8 5c 39 00 00       	call   804120 <__udivdi3>
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
  80081a:	e8 11 3a 00 00       	call   804230 <__umoddi3>
  80081f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800823:	0f be 80 c7 44 80 00 	movsbl 0x8044c7(%eax),%eax
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
  800964:	ff 24 85 60 46 80 00 	jmp    *0x804660(,%eax,4)
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
  800a1d:	8b 14 85 c0 47 80 00 	mov    0x8047c0(,%eax,4),%edx
  800a24:	85 d2                	test   %edx,%edx
  800a26:	0f 85 35 02 00 00    	jne    800c61 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  800a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a30:	c7 44 24 08 df 44 80 	movl   $0x8044df,0x8(%esp)
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
  800a62:	ba d8 44 80 00       	mov    $0x8044d8,%edx
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
  800c65:	c7 44 24 08 ee 48 80 	movl   $0x8048ee,0x8(%esp)
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
  80119f:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  8011a6:	00 
  8011a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ae:	00 
  8011af:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  8011b6:	e8 5d f4 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  801266:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  80126d:	00 
  80126e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801275:	00 
  801276:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  80127d:	e8 96 f3 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  8012c4:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  8012db:	e8 38 f3 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  801322:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  801329:	00 
  80132a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801331:	00 
  801332:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  801339:	e8 da f2 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  801380:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  801387:	00 
  801388:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80138f:	00 
  801390:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  801397:	e8 7c f2 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  8013de:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  8013e5:	00 
  8013e6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013ed:	00 
  8013ee:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  8013f5:	e8 1e f2 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  80143c:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  801443:	00 
  801444:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80144b:	00 
  80144c:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  801453:	e8 c0 f1 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  80149a:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  8014a1:	00 
  8014a2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a9:	00 
  8014aa:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  8014b1:	e8 62 f1 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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
  80152f:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  801536:	00 
  801537:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80153e:	00 
  80153f:	c7 04 24 31 48 80 00 	movl   $0x804831,(%esp)
  801546:	e8 cd f0 ff ff       	call   800618 <_Z6_panicPKciS0_z>

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

00801670 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  801678:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80167d:	8b 04 9d c0 60 80 00 	mov    0x8060c0(,%ebx,4),%eax
  801684:	85 c0                	test   %eax,%eax
  801686:	74 08                	je     801690 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  801688:	8d 55 08             	lea    0x8(%ebp),%edx
  80168b:	89 14 24             	mov    %edx,(%esp)
  80168e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  801690:	83 eb 01             	sub    $0x1,%ebx
  801693:	83 fb ff             	cmp    $0xffffffff,%ebx
  801696:	75 e5                	jne    80167d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  801698:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80169b:	8b 75 08             	mov    0x8(%ebp),%esi
  80169e:	e8 25 fb ff ff       	call   8011c8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8016a3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8016a7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8016ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016af:	c7 44 24 08 40 48 80 	movl   $0x804840,0x8(%esp)
  8016b6:	00 
  8016b7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8016be:	00 
  8016bf:	c7 04 24 c1 48 80 00 	movl   $0x8048c1,(%esp)
  8016c6:	e8 4d ef ff ff       	call   800618 <_Z6_panicPKciS0_z>

008016cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 10             	sub    $0x10,%esp
  8016d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  8016d6:	e8 ed fa ff ff       	call   8011c8 <_Z12sys_getenvidv>
  8016db:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  8016dd:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  8016e2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 4c                	jne    801735 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8016e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016f0:	00 
  8016f1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8016f8:	ee 
  8016f9:	89 34 24             	mov    %esi,(%esp)
  8016fc:	e8 2f fb ff ff       	call   801230 <_Z14sys_page_allociPvi>
  801701:	85 c0                	test   %eax,%eax
  801703:	74 20                	je     801725 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  801705:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801709:	c7 44 24 08 78 48 80 	movl   $0x804878,0x8(%esp)
  801710:	00 
  801711:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  801718:	00 
  801719:	c7 04 24 c1 48 80 00 	movl   $0x8048c1,(%esp)
  801720:	e8 f3 ee ff ff       	call   800618 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  801725:	c7 44 24 04 70 16 80 	movl   $0x801670,0x4(%esp)
  80172c:	00 
  80172d:	89 34 24             	mov    %esi,(%esp)
  801730:	e8 30 fd ff ff       	call   801465 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  801735:	a1 c0 60 80 00       	mov    0x8060c0,%eax
  80173a:	39 d8                	cmp    %ebx,%eax
  80173c:	74 1a                	je     801758 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 20                	je     801762 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801742:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  801747:	8b 14 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%edx
  80174e:	39 da                	cmp    %ebx,%edx
  801750:	74 15                	je     801767 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  801752:	85 d2                	test   %edx,%edx
  801754:	75 1f                	jne    801775 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  801756:	eb 0f                	jmp    801767 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
  80175d:	8d 76 00             	lea    0x0(%esi),%esi
  801760:	eb 05                	jmp    801767 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  801767:	89 1c 85 c0 60 80 00 	mov    %ebx,0x8060c0(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801775:	83 c0 01             	add    $0x1,%eax
  801778:	83 f8 08             	cmp    $0x8,%eax
  80177b:	75 ca                	jne    801747 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80177d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801781:	c7 44 24 08 9c 48 80 	movl   $0x80489c,0x8(%esp)
  801788:	00 
  801789:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801790:	00 
  801791:	c7 04 24 c1 48 80 00 	movl   $0x8048c1,(%esp)
  801798:	e8 7b ee ff ff       	call   800618 <_Z6_panicPKciS0_z>
  80179d:	00 00                	add    %al,(%eax)
	...

008017a0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8017a0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8017a3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8017a4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8017a7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8017ab:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8017af:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8017b2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8017b4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8017b8:	61                   	popa   
    popf
  8017b9:	9d                   	popf   
    popl %esp
  8017ba:	5c                   	pop    %esp
    ret
  8017bb:	c3                   	ret    

008017bc <spin>:

spin:	jmp spin
  8017bc:	eb fe                	jmp    8017bc <spin>
	...

008017c0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8017c3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8017c8:	75 11                	jne    8017db <_ZL8fd_validPK2Fd+0x1b>
  8017ca:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8017cf:	76 0a                	jbe    8017db <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8017d1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8017d6:	0f 96 c0             	setbe  %al
  8017d9:	eb 05                	jmp    8017e0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 14             	sub    $0x14,%esp
  8017e9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8017eb:	e8 d0 ff ff ff       	call   8017c0 <_ZL8fd_validPK2Fd>
  8017f0:	84 c0                	test   %al,%al
  8017f2:	75 24                	jne    801818 <_ZL9fd_isopenPK2Fd+0x36>
  8017f4:	c7 44 24 0c cf 48 80 	movl   $0x8048cf,0xc(%esp)
  8017fb:	00 
  8017fc:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  801803:	00 
  801804:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80180b:	00 
  80180c:	c7 04 24 f1 48 80 00 	movl   $0x8048f1,(%esp)
  801813:	e8 00 ee ff ff       	call   800618 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801818:	89 d8                	mov    %ebx,%eax
  80181a:	c1 e8 16             	shr    $0x16,%eax
  80181d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	f6 c2 01             	test   $0x1,%dl
  80182c:	74 0d                	je     80183b <_ZL9fd_isopenPK2Fd+0x59>
  80182e:	c1 eb 0c             	shr    $0xc,%ebx
  801831:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801838:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80183b:	83 c4 14             	add    $0x14,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	89 1c 24             	mov    %ebx,(%esp)
  80184a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80184e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801851:	8b 75 0c             	mov    0xc(%ebp),%esi
  801854:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801858:	83 fb 1f             	cmp    $0x1f,%ebx
  80185b:	77 18                	ja     801875 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80185d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801863:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801866:	84 c0                	test   %al,%al
  801868:	74 21                	je     80188b <_Z9fd_lookupiPP2Fdb+0x4a>
  80186a:	89 d8                	mov    %ebx,%eax
  80186c:	e8 71 ff ff ff       	call   8017e2 <_ZL9fd_isopenPK2Fd>
  801871:	84 c0                	test   %al,%al
  801873:	75 16                	jne    80188b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801875:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80187b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801880:	8b 1c 24             	mov    (%esp),%ebx
  801883:	8b 74 24 04          	mov    0x4(%esp),%esi
  801887:	89 ec                	mov    %ebp,%esp
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80188b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
  801892:	eb ec                	jmp    801880 <_Z9fd_lookupiPP2Fdb+0x3f>

00801894 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 14             	sub    $0x14,%esp
  80189b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	e8 1b ff ff ff       	call   8017c0 <_ZL8fd_validPK2Fd>
  8018a5:	84 c0                	test   %al,%al
  8018a7:	75 24                	jne    8018cd <_Z6fd2numP2Fd+0x39>
  8018a9:	c7 44 24 0c cf 48 80 	movl   $0x8048cf,0xc(%esp)
  8018b0:	00 
  8018b1:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  8018b8:	00 
  8018b9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8018c0:	00 
  8018c1:	c7 04 24 f1 48 80 00 	movl   $0x8048f1,(%esp)
  8018c8:	e8 4b ed ff ff       	call   800618 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018cd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8018d3:	c1 e8 0c             	shr    $0xc,%eax
}
  8018d6:	83 c4 14             	add    $0x14,%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 04 24             	mov    %eax,(%esp)
  8018e8:	e8 a7 ff ff ff       	call   801894 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8018ed:	05 20 00 0d 00       	add    $0xd0020,%eax
  8018f2:	c1 e0 0c             	shl    $0xc,%eax
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	57                   	push   %edi
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 2c             	sub    $0x2c,%esp
  801900:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801903:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801908:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80190b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801912:	00 
  801913:	89 74 24 04          	mov    %esi,0x4(%esp)
  801917:	89 1c 24             	mov    %ebx,(%esp)
  80191a:	e8 22 ff ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80191f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801922:	e8 bb fe ff ff       	call   8017e2 <_ZL9fd_isopenPK2Fd>
  801927:	84 c0                	test   %al,%al
  801929:	75 0c                	jne    801937 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80192e:	89 07                	mov    %eax,(%edi)
			return 0;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	eb 13                	jmp    80194a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801937:	83 c3 01             	add    $0x1,%ebx
  80193a:	83 fb 20             	cmp    $0x20,%ebx
  80193d:	75 cc                	jne    80190b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80193f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801945:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80194a:	83 c4 2c             	add    $0x2c,%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5f                   	pop    %edi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 14             	sub    $0x14,%esp
  801959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801964:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  80196a:	75 16                	jne    801982 <_Z10dev_lookupiPP3Dev+0x30>
  80196c:	eb 06                	jmp    801974 <_Z10dev_lookupiPP3Dev+0x22>
  80196e:	39 0a                	cmp    %ecx,(%edx)
  801970:	75 10                	jne    801982 <_Z10dev_lookupiPP3Dev+0x30>
  801972:	eb 05                	jmp    801979 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801974:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801979:	89 13                	mov    %edx,(%ebx)
			return 0;
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
  801980:	eb 35                	jmp    8019b7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801982:	83 c0 01             	add    $0x1,%eax
  801985:	8b 14 85 5c 49 80 00 	mov    0x80495c(,%eax,4),%edx
  80198c:	85 d2                	test   %edx,%edx
  80198e:	75 de                	jne    80196e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801990:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  801995:	8b 40 04             	mov    0x4(%eax),%eax
  801998:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80199c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a0:	c7 04 24 18 49 80 00 	movl   $0x804918,(%esp)
  8019a7:	e8 8a ed ff ff       	call   800736 <_Z7cprintfPKcz>
	*dev = 0;
  8019ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8019b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019b7:	83 c4 14             	add    $0x14,%esp
  8019ba:	5b                   	pop    %ebx
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 20             	sub    $0x20,%esp
  8019c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8019c8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  8019cc:	89 34 24             	mov    %esi,(%esp)
  8019cf:	e8 c0 fe ff ff       	call   801894 <_Z6fd2numP2Fd>
  8019d4:	0f b6 d3             	movzbl %bl,%edx
  8019d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019db:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019e2:	89 04 24             	mov    %eax,(%esp)
  8019e5:	e8 57 fe ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 05                	js     8019f3 <_Z8fd_closeP2Fdb+0x36>
  8019ee:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8019f1:	74 0c                	je     8019ff <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8019f3:	80 fb 01             	cmp    $0x1,%bl
  8019f6:	19 db                	sbb    %ebx,%ebx
  8019f8:	f7 d3                	not    %ebx
  8019fa:	83 e3 fd             	and    $0xfffffffd,%ebx
  8019fd:	eb 3d                	jmp    801a3c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a06:	8b 06                	mov    (%esi),%eax
  801a08:	89 04 24             	mov    %eax,(%esp)
  801a0b:	e8 42 ff ff ff       	call   801952 <_Z10dev_lookupiPP3Dev>
  801a10:	89 c3                	mov    %eax,%ebx
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 16                	js     801a2c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801a1c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801a21:	85 c0                	test   %eax,%eax
  801a23:	74 07                	je     801a2c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801a25:	89 34 24             	mov    %esi,(%esp)
  801a28:	ff d0                	call   *%eax
  801a2a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a37:	e8 b1 f8 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return r;
}
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	83 c4 20             	add    $0x20,%esp
  801a41:	5b                   	pop    %ebx
  801a42:	5e                   	pop    %esi
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    

00801a45 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801a4b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a52:	00 
  801a53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	89 04 24             	mov    %eax,(%esp)
  801a60:	e8 dc fd ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 13                	js     801a7c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801a69:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a70:	00 
  801a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 41 ff ff ff       	call   8019bd <_Z8fd_closeP2Fdb>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <_Z9close_allv>:

void
close_all(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
  801a82:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801a85:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a8a:	89 1c 24             	mov    %ebx,(%esp)
  801a8d:	e8 b3 ff ff ff       	call   801a45 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801a92:	83 c3 01             	add    $0x1,%ebx
  801a95:	83 fb 20             	cmp    $0x20,%ebx
  801a98:	75 f0                	jne    801a8a <_Z9close_allv+0xc>
		close(i);
}
  801a9a:	83 c4 14             	add    $0x14,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 48             	sub    $0x48,%esp
  801aa6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aa9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801aac:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aaf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801ab2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ab9:	00 
  801aba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 75 fd ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801acc:	89 c3                	mov    %eax,%ebx
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	0f 88 ce 00 00 00    	js     801ba4 <_Z3dupii+0x104>
  801ad6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801add:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801ade:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801ae5:	89 34 24             	mov    %esi,(%esp)
  801ae8:	e8 54 fd ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	85 c0                	test   %eax,%eax
  801af1:	0f 89 bc 00 00 00    	jns    801bb3 <_Z3dupii+0x113>
  801af7:	e9 a8 00 00 00       	jmp    801ba4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	c1 e8 0c             	shr    $0xc,%eax
  801b01:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801b08:	f6 c2 01             	test   $0x1,%dl
  801b0b:	74 32                	je     801b3f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b0d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801b14:	25 07 0e 00 00       	and    $0xe07,%eax
  801b19:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b21:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b28:	00 
  801b29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b34:	e8 56 f7 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 3e                	js     801b7d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b42:	89 c2                	mov    %eax,%edx
  801b44:	c1 ea 0c             	shr    $0xc,%edx
  801b47:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801b4e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b54:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b66:	00 
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b72:	e8 18 f7 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	79 25                	jns    801ba2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8b:	e8 5d f7 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801b90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9b:	e8 4d f7 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return r;
  801ba0:	eb 02                	jmp    801ba4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801ba2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ba9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801baf:	89 ec                	mov    %ebp,%esp
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801bb3:	89 34 24             	mov    %esi,(%esp)
  801bb6:	e8 8a fe ff ff       	call   801a45 <_Z5closei>

	ova = fd2data(oldfd);
  801bbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 16 fd ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  801bc6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bcb:	89 04 24             	mov    %eax,(%esp)
  801bce:	e8 09 fd ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  801bd3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801bd5:	89 d8                	mov    %ebx,%eax
  801bd7:	c1 e8 16             	shr    $0x16,%eax
  801bda:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801be1:	a8 01                	test   $0x1,%al
  801be3:	0f 85 13 ff ff ff    	jne    801afc <_Z3dupii+0x5c>
  801be9:	e9 51 ff ff ff       	jmp    801b3f <_Z3dupii+0x9f>

00801bee <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 24             	sub    $0x24,%esp
  801bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801bf8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801bff:	00 
  801c00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	89 1c 24             	mov    %ebx,(%esp)
  801c0a:	e8 32 fc ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 5f                	js     801c72 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	89 04 24             	mov    %eax,(%esp)
  801c22:	e8 2b fd ff ff       	call   801952 <_Z10dev_lookupiPP3Dev>
  801c27:	85 c0                	test   %eax,%eax
  801c29:	79 4d                	jns    801c78 <_Z4readiPvj+0x8a>
  801c2b:	eb 45                	jmp    801c72 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c2d:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  801c32:	8b 40 04             	mov    0x4(%eax),%eax
  801c35:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	c7 04 24 fa 48 80 00 	movl   $0x8048fa,(%esp)
  801c44:	e8 ed ea ff ff       	call   800736 <_Z7cprintfPKcz>
		return -E_INVAL;
  801c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c4e:	eb 22                	jmp    801c72 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c53:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801c56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	74 13                	je     801c72 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6d:	89 0c 24             	mov    %ecx,(%esp)
  801c70:	ff d2                	call   *%edx
}
  801c72:	83 c4 24             	add    $0x24,%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c78:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c7b:	8b 41 08             	mov    0x8(%ecx),%eax
  801c7e:	83 e0 03             	and    $0x3,%eax
  801c81:	83 f8 01             	cmp    $0x1,%eax
  801c84:	75 ca                	jne    801c50 <_Z4readiPvj+0x62>
  801c86:	eb a5                	jmp    801c2d <_Z4readiPvj+0x3f>

00801c88 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	57                   	push   %edi
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 1c             	sub    $0x1c,%esp
  801c91:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c94:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801c97:	85 f6                	test   %esi,%esi
  801c99:	74 2f                	je     801cca <_Z5readniPvj+0x42>
  801c9b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ca0:	89 f0                	mov    %esi,%eax
  801ca2:	29 d8                	sub    %ebx,%eax
  801ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	89 04 24             	mov    %eax,(%esp)
  801cb5:	e8 34 ff ff ff       	call   801bee <_Z4readiPvj>
		if (m < 0)
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 13                	js     801cd1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	74 0d                	je     801ccf <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801cc2:	01 c3                	add    %eax,%ebx
  801cc4:	39 de                	cmp    %ebx,%esi
  801cc6:	77 d8                	ja     801ca0 <_Z5readniPvj+0x18>
  801cc8:	eb 05                	jmp    801ccf <_Z5readniPvj+0x47>
  801cca:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801ccf:	89 d8                	mov    %ebx,%eax
}
  801cd1:	83 c4 1c             	add    $0x1c,%esp
  801cd4:	5b                   	pop    %ebx
  801cd5:	5e                   	pop    %esi
  801cd6:	5f                   	pop    %edi
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    

00801cd9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801cdf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ce6:	00 
  801ce7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	89 04 24             	mov    %eax,(%esp)
  801cf4:	e8 48 fb ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 3c                	js     801d39 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d07:	8b 00                	mov    (%eax),%eax
  801d09:	89 04 24             	mov    %eax,(%esp)
  801d0c:	e8 41 fc ff ff       	call   801952 <_Z10dev_lookupiPP3Dev>
  801d11:	85 c0                	test   %eax,%eax
  801d13:	79 26                	jns    801d3b <_Z5writeiPKvj+0x62>
  801d15:	eb 22                	jmp    801d39 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801d1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801d22:	85 c9                	test   %ecx,%ecx
  801d24:	74 13                	je     801d39 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d26:	8b 45 10             	mov    0x10(%ebp),%eax
  801d29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d34:	89 14 24             	mov    %edx,(%esp)
  801d37:	ff d1                	call   *%ecx
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801d3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801d43:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801d47:	74 f0                	je     801d39 <_Z5writeiPKvj+0x60>
  801d49:	eb cc                	jmp    801d17 <_Z5writeiPKvj+0x3e>

00801d4b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801d51:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d58:	00 
  801d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	89 04 24             	mov    %eax,(%esp)
  801d66:	e8 d6 fa ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 0e                	js     801d7d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	53                   	push   %ebx
  801d83:	83 ec 24             	sub    $0x24,%esp
  801d86:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d89:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d90:	00 
  801d91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d98:	89 1c 24             	mov    %ebx,(%esp)
  801d9b:	e8 a1 fa ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 58                	js     801dfc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	89 04 24             	mov    %eax,(%esp)
  801db3:	e8 9a fb ff ff       	call   801952 <_Z10dev_lookupiPP3Dev>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	79 46                	jns    801e02 <_Z9ftruncateii+0x83>
  801dbc:	eb 3e                	jmp    801dfc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801dbe:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  801dc3:	8b 40 04             	mov    0x4(%eax),%eax
  801dc6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dce:	c7 04 24 38 49 80 00 	movl   $0x804938,(%esp)
  801dd5:	e8 5c e9 ff ff       	call   800736 <_Z7cprintfPKcz>
		return -E_INVAL;
  801dda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ddf:	eb 1b                	jmp    801dfc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801de7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801dec:	85 d2                	test   %edx,%edx
  801dee:	74 0c                	je     801dfc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df7:	89 0c 24             	mov    %ecx,(%esp)
  801dfa:	ff d2                	call   *%edx
}
  801dfc:	83 c4 24             	add    $0x24,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e02:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e05:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801e09:	75 d6                	jne    801de1 <_Z9ftruncateii+0x62>
  801e0b:	eb b1                	jmp    801dbe <_Z9ftruncateii+0x3f>

00801e0d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
  801e11:	83 ec 24             	sub    $0x24,%esp
  801e14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e17:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e1e:	00 
  801e1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	89 04 24             	mov    %eax,(%esp)
  801e2c:	e8 10 fa ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 3e                	js     801e73 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e3f:	8b 00                	mov    (%eax),%eax
  801e41:	89 04 24             	mov    %eax,(%esp)
  801e44:	e8 09 fb ff ff       	call   801952 <_Z10dev_lookupiPP3Dev>
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	79 2c                	jns    801e79 <_Z5fstatiP4Stat+0x6c>
  801e4d:	eb 24                	jmp    801e73 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e4f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e52:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801e59:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801e60:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	89 04 24             	mov    %eax,(%esp)
  801e70:	ff 52 14             	call   *0x14(%edx)
}
  801e73:	83 c4 24             	add    $0x24,%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801e7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801e81:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801e85:	75 c8                	jne    801e4f <_Z5fstatiP4Stat+0x42>
  801e87:	eb ea                	jmp    801e73 <_Z5fstatiP4Stat+0x66>

00801e89 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 18             	sub    $0x18,%esp
  801e8f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e92:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e9c:	00 
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	89 04 24             	mov    %eax,(%esp)
  801ea3:	e8 d6 09 00 00       	call   80287e <_Z4openPKci>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 1b                	js     801ec9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	89 1c 24             	mov    %ebx,(%esp)
  801eb8:	e8 50 ff ff ff       	call   801e0d <_Z5fstatiP4Stat>
  801ebd:	89 c6                	mov    %eax,%esi
	close(fd);
  801ebf:	89 1c 24             	mov    %ebx,(%esp)
  801ec2:	e8 7e fb ff ff       	call   801a45 <_Z5closei>
	return r;
  801ec7:	89 f3                	mov    %esi,%ebx
}
  801ec9:	89 d8                	mov    %ebx,%eax
  801ecb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ece:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ed1:	89 ec                	mov    %ebp,%esp
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    
	...

00801ee0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801ee3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801ee8:	85 d2                	test   %edx,%edx
  801eea:	78 33                	js     801f1f <_ZL10inode_dataP5Inodei+0x3f>
  801eec:	3b 50 08             	cmp    0x8(%eax),%edx
  801eef:	7d 2e                	jge    801f1f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801ef1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801ef7:	85 d2                	test   %edx,%edx
  801ef9:	0f 49 ca             	cmovns %edx,%ecx
  801efc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801eff:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801f03:	c1 e1 0c             	shl    $0xc,%ecx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	c1 f8 1f             	sar    $0x1f,%eax
  801f0b:	c1 e8 14             	shr    $0x14,%eax
  801f0e:	01 c2                	add    %eax,%edx
  801f10:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f16:	29 c2                	sub    %eax,%edx
  801f18:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801f1f:	89 c8                	mov    %ecx,%eax
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801f26:	8b 48 08             	mov    0x8(%eax),%ecx
  801f29:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801f31:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801f38:	50 80 00 
}
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    

00801f3d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801f43:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	74 08                	je     801f55 <_ZL9get_inodei+0x18>
  801f4d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801f53:	7e 20                	jle    801f75 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801f55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f59:	c7 44 24 08 70 49 80 	movl   $0x804970,0x8(%esp)
  801f60:	00 
  801f61:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801f68:	00 
  801f69:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  801f70:	e8 a3 e6 ff ff       	call   800618 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801f75:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801f7b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f81:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801f87:	85 d2                	test   %edx,%edx
  801f89:	0f 48 d1             	cmovs  %ecx,%edx
  801f8c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801f8f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801f96:	c1 e0 0c             	shl    $0xc,%eax
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801fa3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801fa9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801fac:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801fb2:	76 20                	jbe    801fd4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801fb4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb8:	c7 44 24 08 ac 49 80 	movl   $0x8049ac,0x8(%esp)
  801fbf:	00 
  801fc0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801fc7:	00 
  801fc8:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  801fcf:	e8 44 e6 ff ff       	call   800618 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801fd4:	83 fe 01             	cmp    $0x1,%esi
  801fd7:	7e 08                	jle    801fe1 <_ZL10bcache_ipcPvi+0x46>
  801fd9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801fdf:	7d 12                	jge    801ff3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801fe1:	89 f3                	mov    %esi,%ebx
  801fe3:	c1 e3 04             	shl    $0x4,%ebx
  801fe6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801fe8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801fee:	c1 e6 0c             	shl    $0xc,%esi
  801ff1:	eb 20                	jmp    802013 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801ff3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ff7:	c7 44 24 08 dc 49 80 	movl   $0x8049dc,0x8(%esp)
  801ffe:	00 
  801fff:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802006:	00 
  802007:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  80200e:	e8 05 e6 ff ff       	call   800618 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802013:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80201a:	00 
  80201b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802022:	00 
  802023:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802027:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80202e:	e8 7c 20 00 00       	call   8040af <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802033:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80203a:	00 
  80203b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80203f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802046:	e8 d5 1f 00 00       	call   804020 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80204b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80204e:	74 c3                	je     802013 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 28             	sub    $0x28,%esp
  80205d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802060:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802063:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802066:	89 c7                	mov    %eax,%edi
  802068:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80206a:	c7 04 24 fd 22 80 00 	movl   $0x8022fd,(%esp)
  802071:	e8 55 f6 ff ff       	call   8016cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802076:	89 f8                	mov    %edi,%eax
  802078:	e8 c0 fe ff ff       	call   801f3d <_ZL9get_inodei>
  80207d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80207f:	ba 02 00 00 00       	mov    $0x2,%edx
  802084:	e8 12 ff ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802089:	85 c0                	test   %eax,%eax
  80208b:	79 08                	jns    802095 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80208d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802093:	eb 2e                	jmp    8020c3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802095:	85 c0                	test   %eax,%eax
  802097:	75 1c                	jne    8020b5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802099:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80209f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8020a6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8020a9:	ba 06 00 00 00       	mov    $0x6,%edx
  8020ae:	89 d8                	mov    %ebx,%eax
  8020b0:	e8 e6 fe ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8020b5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8020bc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020c6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020cc:	89 ec                	mov    %ebp,%esp
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	57                   	push   %edi
  8020d4:	56                   	push   %esi
  8020d5:	53                   	push   %ebx
  8020d6:	83 ec 2c             	sub    $0x2c,%esp
  8020d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8020dc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8020df:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8020e4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8020ea:	0f 87 3d 01 00 00    	ja     80222d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  8020f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8020f3:	8b 42 08             	mov    0x8(%edx),%eax
  8020f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	0f 49 f0             	cmovns %eax,%esi
  802101:	c1 fe 0c             	sar    $0xc,%esi
  802104:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802106:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802109:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80210f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802112:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802115:	0f 82 a6 00 00 00    	jb     8021c1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80211b:	39 fe                	cmp    %edi,%esi
  80211d:	0f 8d f2 00 00 00    	jge    802215 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802123:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802127:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80212a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80212d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802130:	83 3e 00             	cmpl   $0x0,(%esi)
  802133:	75 77                	jne    8021ac <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802135:	ba 02 00 00 00       	mov    $0x2,%edx
  80213a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80213f:	e8 57 fe ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802144:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80214a:	83 f9 02             	cmp    $0x2,%ecx
  80214d:	7e 43                	jle    802192 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80214f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802154:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802159:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802160:	74 29                	je     80218b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802162:	e9 ce 00 00 00       	jmp    802235 <_ZL14inode_set_sizeP5Inodej+0x165>
  802167:	89 c7                	mov    %eax,%edi
  802169:	0f b6 10             	movzbl (%eax),%edx
  80216c:	83 c0 01             	add    $0x1,%eax
  80216f:	84 d2                	test   %dl,%dl
  802171:	74 18                	je     80218b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802173:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802176:	ba 05 00 00 00       	mov    $0x5,%edx
  80217b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802180:	e8 16 fe ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802185:	85 db                	test   %ebx,%ebx
  802187:	79 1e                	jns    8021a7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802189:	eb 07                	jmp    802192 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80218b:	83 c3 01             	add    $0x1,%ebx
  80218e:	39 d9                	cmp    %ebx,%ecx
  802190:	7f d5                	jg     802167 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802192:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802195:	8b 50 08             	mov    0x8(%eax),%edx
  802198:	e8 33 ff ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80219d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8021a2:	e9 86 00 00 00       	jmp    80222d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8021a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021aa:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8021ac:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8021b0:	83 c6 04             	add    $0x4,%esi
  8021b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8021b9:	0f 8f 6e ff ff ff    	jg     80212d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8021bf:	eb 54                	jmp    802215 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8021c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021c4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8021c9:	83 f8 01             	cmp    $0x1,%eax
  8021cc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8021cf:	ba 02 00 00 00       	mov    $0x2,%edx
  8021d4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8021d9:	e8 bd fd ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8021de:	39 f7                	cmp    %esi,%edi
  8021e0:	7d 24                	jge    802206 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8021e2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021e5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8021e9:	8b 10                	mov    (%eax),%edx
  8021eb:	85 d2                	test   %edx,%edx
  8021ed:	74 0d                	je     8021fc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8021ef:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  8021f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  8021fc:	83 eb 01             	sub    $0x1,%ebx
  8021ff:	83 e8 04             	sub    $0x4,%eax
  802202:	39 fb                	cmp    %edi,%ebx
  802204:	75 e3                	jne    8021e9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802206:	ba 05 00 00 00       	mov    $0x5,%edx
  80220b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802210:	e8 86 fd ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802215:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80221e:	ba 04 00 00 00       	mov    $0x4,%edx
  802223:	e8 73 fd ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	return 0;
  802228:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222d:	83 c4 2c             	add    $0x2c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802235:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80223c:	ba 05 00 00 00       	mov    $0x5,%edx
  802241:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802246:	e8 50 fd ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80224b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802250:	e9 52 ff ff ff       	jmp    8021a7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802255 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	53                   	push   %ebx
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80225e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802264:	83 e8 01             	sub    $0x1,%eax
  802267:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80226d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802271:	75 40                	jne    8022b3 <_ZL11inode_closeP5Inode+0x5e>
  802273:	85 c0                	test   %eax,%eax
  802275:	75 3c                	jne    8022b3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802277:	ba 02 00 00 00       	mov    $0x2,%edx
  80227c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802281:	e8 15 fd ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80228b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80228f:	85 d2                	test   %edx,%edx
  802291:	74 07                	je     80229a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802293:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80229a:	83 c0 01             	add    $0x1,%eax
  80229d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8022a2:	75 e7                	jne    80228b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8022a4:	ba 05 00 00 00       	mov    $0x5,%edx
  8022a9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022ae:	e8 e8 fc ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8022b3:	ba 03 00 00 00       	mov    $0x3,%edx
  8022b8:	89 d8                	mov    %ebx,%eax
  8022ba:	e8 dc fc ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
}
  8022bf:	83 c4 04             	add    $0x4,%esp
  8022c2:	5b                   	pop    %ebx
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	53                   	push   %ebx
  8022c9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8022d5:	e8 7d fd ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  8022da:	89 c3                	mov    %eax,%ebx
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	78 15                	js     8022f5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8022e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	e8 e5 fd ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
  8022eb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	e8 60 ff ff ff       	call   802255 <_ZL11inode_closeP5Inode>
	return r;
}
  8022f5:	89 d8                	mov    %ebx,%eax
  8022f7:	83 c4 14             	add    $0x14,%esp
  8022fa:	5b                   	pop    %ebx
  8022fb:	5d                   	pop    %ebp
  8022fc:	c3                   	ret    

008022fd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	53                   	push   %ebx
  802301:	83 ec 14             	sub    $0x14,%esp
  802304:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802307:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802309:	89 c2                	mov    %eax,%edx
  80230b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802311:	78 32                	js     802345 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802313:	ba 00 00 00 00       	mov    $0x0,%edx
  802318:	e8 7e fc ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 1c                	je     80233d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802321:	c7 44 24 08 91 49 80 	movl   $0x804991,0x8(%esp)
  802328:	00 
  802329:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802330:	00 
  802331:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  802338:	e8 db e2 ff ff       	call   800618 <_Z6_panicPKciS0_z>
    resume(utf);
  80233d:	89 1c 24             	mov    %ebx,(%esp)
  802340:	e8 5b f4 ff ff       	call   8017a0 <resume>
}
  802345:	83 c4 14             	add    $0x14,%esp
  802348:	5b                   	pop    %ebx
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 28             	sub    $0x28,%esp
  802351:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802354:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80235a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80235d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802360:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802363:	e8 ef fc ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802368:	85 c0                	test   %eax,%eax
  80236a:	78 26                	js     802392 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80236c:	83 c3 10             	add    $0x10,%ebx
  80236f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802373:	89 34 24             	mov    %esi,(%esp)
  802376:	e8 cf e9 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	e8 9e fb ff ff       	call   801f23 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	e8 c8 fe ff ff       	call   802255 <_ZL11inode_closeP5Inode>
	return 0;
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802392:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802395:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802398:	89 ec                	mov    %ebp,%esp
  80239a:	5d                   	pop    %ebp
  80239b:	c3                   	ret    

0080239c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	53                   	push   %ebx
  8023a0:	83 ec 24             	sub    $0x24,%esp
  8023a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8023a6:	89 1c 24             	mov    %ebx,(%esp)
  8023a9:	e8 9e 15 00 00       	call   80394c <_Z7pagerefPv>
  8023ae:	89 c2                	mov    %eax,%edx
        return 0;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8023b5:	83 fa 01             	cmp    $0x1,%edx
  8023b8:	7f 1e                	jg     8023d8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8023ba:	8b 43 0c             	mov    0xc(%ebx),%eax
  8023bd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023c0:	e8 92 fc ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	78 0f                	js     8023d8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  8023d3:	e8 7d fe ff ff       	call   802255 <_ZL11inode_closeP5Inode>
}
  8023d8:	83 c4 24             	add    $0x24,%esp
  8023db:	5b                   	pop    %ebx
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    

008023de <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 3c             	sub    $0x3c,%esp
  8023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8023ea:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8023ed:	8b 43 04             	mov    0x4(%ebx),%eax
  8023f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8023f3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8023f6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8023f9:	e8 59 fc ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  8023fe:	85 c0                	test   %eax,%eax
  802400:	0f 88 8c 00 00 00    	js     802492 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802406:	8b 53 04             	mov    0x4(%ebx),%edx
  802409:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80240f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802415:	29 d7                	sub    %edx,%edi
  802417:	39 f7                	cmp    %esi,%edi
  802419:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80241c:	85 ff                	test   %edi,%edi
  80241e:	74 16                	je     802436 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802420:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802426:	3b 50 08             	cmp    0x8(%eax),%edx
  802429:	76 6f                	jbe    80249a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80242b:	e8 a0 fc ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802430:	85 c0                	test   %eax,%eax
  802432:	79 66                	jns    80249a <_ZL13devfile_writeP2FdPKvj+0xbc>
  802434:	eb 4e                	jmp    802484 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802436:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80243c:	76 24                	jbe    802462 <_ZL13devfile_writeP2FdPKvj+0x84>
  80243e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802440:	8b 53 04             	mov    0x4(%ebx),%edx
  802443:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244c:	3b 50 08             	cmp    0x8(%eax),%edx
  80244f:	0f 86 83 00 00 00    	jbe    8024d8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802455:	e8 76 fc ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80245a:	85 c0                	test   %eax,%eax
  80245c:	79 7a                	jns    8024d8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80245e:	66 90                	xchg   %ax,%ax
  802460:	eb 22                	jmp    802484 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802462:	85 f6                	test   %esi,%esi
  802464:	74 1e                	je     802484 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802466:	89 f2                	mov    %esi,%edx
  802468:	03 53 04             	add    0x4(%ebx),%edx
  80246b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246e:	3b 50 08             	cmp    0x8(%eax),%edx
  802471:	0f 86 b8 00 00 00    	jbe    80252f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802477:	e8 54 fc ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80247c:	85 c0                	test   %eax,%eax
  80247e:	0f 89 ab 00 00 00    	jns    80252f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802487:	e8 c9 fd ff ff       	call   802255 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80248c:	8b 43 04             	mov    0x4(%ebx),%eax
  80248f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802492:	83 c4 3c             	add    $0x3c,%esp
  802495:	5b                   	pop    %ebx
  802496:	5e                   	pop    %esi
  802497:	5f                   	pop    %edi
  802498:	5d                   	pop    %ebp
  802499:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80249a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80249c:	8b 53 04             	mov    0x4(%ebx),%edx
  80249f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a2:	e8 39 fa ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8024a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8024aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b8:	89 04 24             	mov    %eax,(%esp)
  8024bb:	e8 a7 ea ff ff       	call   800f67 <memcpy>
        fd->fd_offset += n2;
  8024c0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8024c3:	ba 04 00 00 00       	mov    $0x4,%edx
  8024c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024cb:	e8 cb fa ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8024d0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8024d3:	e9 5e ff ff ff       	jmp    802436 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8024d8:	8b 53 04             	mov    0x4(%ebx),%edx
  8024db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024de:	e8 fd f9 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8024e3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8024e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8024ec:	00 
  8024ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f4:	89 34 24             	mov    %esi,(%esp)
  8024f7:	e8 6b ea ff ff       	call   800f67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8024fc:	ba 04 00 00 00       	mov    $0x4,%edx
  802501:	89 f0                	mov    %esi,%eax
  802503:	e8 93 fa ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802508:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80250e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802515:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80251c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802522:	0f 87 18 ff ff ff    	ja     802440 <_ZL13devfile_writeP2FdPKvj+0x62>
  802528:	89 fe                	mov    %edi,%esi
  80252a:	e9 33 ff ff ff       	jmp    802462 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80252f:	8b 53 04             	mov    0x4(%ebx),%edx
  802532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802535:	e8 a6 f9 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  80253a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80253c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802540:	8b 45 0c             	mov    0xc(%ebp),%eax
  802543:	89 44 24 04          	mov    %eax,0x4(%esp)
  802547:	89 3c 24             	mov    %edi,(%esp)
  80254a:	e8 18 ea ff ff       	call   800f67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80254f:	ba 04 00 00 00       	mov    $0x4,%edx
  802554:	89 f8                	mov    %edi,%eax
  802556:	e8 40 fa ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80255b:	01 73 04             	add    %esi,0x4(%ebx)
  80255e:	e9 21 ff ff ff       	jmp    802484 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802563 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	57                   	push   %edi
  802567:	56                   	push   %esi
  802568:	53                   	push   %ebx
  802569:	83 ec 3c             	sub    $0x3c,%esp
  80256c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80256f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802572:	8b 43 04             	mov    0x4(%ebx),%eax
  802575:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802578:	8b 43 0c             	mov    0xc(%ebx),%eax
  80257b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80257e:	e8 d4 fa ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802583:	85 c0                	test   %eax,%eax
  802585:	0f 88 d3 00 00 00    	js     80265e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80258b:	8b 73 04             	mov    0x4(%ebx),%esi
  80258e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802591:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802594:	8b 50 08             	mov    0x8(%eax),%edx
  802597:	29 f2                	sub    %esi,%edx
  802599:	3b 48 08             	cmp    0x8(%eax),%ecx
  80259c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80259f:	89 f2                	mov    %esi,%edx
  8025a1:	e8 3a f9 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	0f 84 a2 00 00 00    	je     802650 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8025ae:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8025b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8025ba:	29 f2                	sub    %esi,%edx
  8025bc:	39 d7                	cmp    %edx,%edi
  8025be:	0f 46 d7             	cmovbe %edi,%edx
  8025c1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8025c4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8025c6:	01 d6                	add    %edx,%esi
  8025c8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8025cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 89 e9 ff ff       	call   800f67 <memcpy>
    buf = (void *)((char *)buf + n2);
  8025de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025e1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8025e4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8025ea:	76 3e                	jbe    80262a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8025ec:	8b 53 04             	mov    0x4(%ebx),%edx
  8025ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f2:	e8 e9 f8 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 55                	je     802650 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8025fb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802602:	00 
  802603:	89 44 24 04          	mov    %eax,0x4(%esp)
  802607:	89 34 24             	mov    %esi,(%esp)
  80260a:	e8 58 e9 ff ff       	call   800f67 <memcpy>
        n -= PGSIZE;
  80260f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802615:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80261b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802622:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802628:	77 c2                	ja     8025ec <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80262a:	85 ff                	test   %edi,%edi
  80262c:	74 22                	je     802650 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80262e:	8b 53 04             	mov    0x4(%ebx),%edx
  802631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802634:	e8 a7 f8 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  802639:	85 c0                	test   %eax,%eax
  80263b:	74 13                	je     802650 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80263d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802641:	89 44 24 04          	mov    %eax,0x4(%esp)
  802645:	89 34 24             	mov    %esi,(%esp)
  802648:	e8 1a e9 ff ff       	call   800f67 <memcpy>
        fd->fd_offset += n;
  80264d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802653:	e8 fd fb ff ff       	call   802255 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802658:	8b 43 04             	mov    0x4(%ebx),%eax
  80265b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80265e:	83 c4 3c             	add    $0x3c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    

00802666 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	57                   	push   %edi
  80266a:	56                   	push   %esi
  80266b:	53                   	push   %ebx
  80266c:	83 ec 4c             	sub    $0x4c,%esp
  80266f:	89 c6                	mov    %eax,%esi
  802671:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802674:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802677:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80267d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802686:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802689:	b8 01 00 00 00       	mov    $0x1,%eax
  80268e:	e8 c4 f9 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802693:	89 c7                	mov    %eax,%edi
  802695:	85 c0                	test   %eax,%eax
  802697:	0f 88 cd 01 00 00    	js     80286a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80269d:	89 f3                	mov    %esi,%ebx
  80269f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8026a2:	75 08                	jne    8026ac <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8026a4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8026a7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8026aa:	74 f8                	je     8026a4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8026ac:	0f b6 03             	movzbl (%ebx),%eax
  8026af:	3c 2f                	cmp    $0x2f,%al
  8026b1:	74 16                	je     8026c9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8026b3:	84 c0                	test   %al,%al
  8026b5:	74 12                	je     8026c9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8026b7:	89 da                	mov    %ebx,%edx
		++path;
  8026b9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8026bc:	0f b6 02             	movzbl (%edx),%eax
  8026bf:	3c 2f                	cmp    $0x2f,%al
  8026c1:	74 08                	je     8026cb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8026c3:	84 c0                	test   %al,%al
  8026c5:	75 f2                	jne    8026b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8026c7:	eb 02                	jmp    8026cb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8026c9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	29 d8                	sub    %ebx,%eax
  8026cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8026d2:	0f b6 02             	movzbl (%edx),%eax
  8026d5:	89 d6                	mov    %edx,%esi
  8026d7:	3c 2f                	cmp    $0x2f,%al
  8026d9:	75 0a                	jne    8026e5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8026db:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8026de:	0f b6 06             	movzbl (%esi),%eax
  8026e1:	3c 2f                	cmp    $0x2f,%al
  8026e3:	74 f6                	je     8026db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8026e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026e9:	75 1b                	jne    802706 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8026eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ee:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8026f1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8026f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026f6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8026fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802701:	e9 64 01 00 00       	jmp    80286a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802706:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80270a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270e:	74 06                	je     802716 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802710:	84 c0                	test   %al,%al
  802712:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802719:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80271c:	83 3a 02             	cmpl   $0x2,(%edx)
  80271f:	0f 85 f4 00 00 00    	jne    802819 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802725:	89 d0                	mov    %edx,%eax
  802727:	8b 52 08             	mov    0x8(%edx),%edx
  80272a:	85 d2                	test   %edx,%edx
  80272c:	7e 78                	jle    8027a6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80272e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802735:	bf 00 00 00 00       	mov    $0x0,%edi
  80273a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80273d:	89 fb                	mov    %edi,%ebx
  80273f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802742:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802744:	89 da                	mov    %ebx,%edx
  802746:	89 f0                	mov    %esi,%eax
  802748:	e8 93 f7 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  80274d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80274f:	83 38 00             	cmpl   $0x0,(%eax)
  802752:	74 26                	je     80277a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802754:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802757:	3b 50 04             	cmp    0x4(%eax),%edx
  80275a:	75 33                	jne    80278f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80275c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802760:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802763:	89 44 24 04          	mov    %eax,0x4(%esp)
  802767:	8d 47 08             	lea    0x8(%edi),%eax
  80276a:	89 04 24             	mov    %eax,(%esp)
  80276d:	e8 36 e8 ff ff       	call   800fa8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802772:	85 c0                	test   %eax,%eax
  802774:	0f 84 fa 00 00 00    	je     802874 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80277a:	83 3f 00             	cmpl   $0x0,(%edi)
  80277d:	75 10                	jne    80278f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80277f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802783:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802786:	84 c0                	test   %al,%al
  802788:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80278c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80278f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802795:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802797:	8b 56 08             	mov    0x8(%esi),%edx
  80279a:	39 d0                	cmp    %edx,%eax
  80279c:	7c a6                	jl     802744 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80279e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8027a1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8027a4:	eb 07                	jmp    8027ad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8027a6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8027ad:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8027b1:	74 6d                	je     802820 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8027b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027b7:	75 24                	jne    8027dd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8027b9:	83 ea 80             	sub    $0xffffff80,%edx
  8027bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027bf:	e8 0c f9 ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	0f 88 90 00 00 00    	js     80285c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8027cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027cf:	8b 50 08             	mov    0x8(%eax),%edx
  8027d2:	83 c2 80             	add    $0xffffff80,%edx
  8027d5:	e8 06 f7 ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8027da:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8027dd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8027e4:	00 
  8027e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027ec:	00 
  8027ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f0:	89 14 24             	mov    %edx,(%esp)
  8027f3:	e8 99 e6 ff ff       	call   800e91 <memset>
	empty->de_namelen = namelen;
  8027f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fe:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802801:	89 54 24 08          	mov    %edx,0x8(%esp)
  802805:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802809:	83 c0 08             	add    $0x8,%eax
  80280c:	89 04 24             	mov    %eax,(%esp)
  80280f:	e8 53 e7 ff ff       	call   800f67 <memcpy>
	*de_store = empty;
  802814:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802817:	eb 5e                	jmp    802877 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802819:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80281e:	eb 42                	jmp    802862 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802820:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802825:	eb 3b                	jmp    802862 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80282d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80282f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802832:	89 38                	mov    %edi,(%eax)
			return 0;
  802834:	bf 00 00 00 00       	mov    $0x0,%edi
  802839:	eb 2f                	jmp    80286a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80283b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80283e:	8b 07                	mov    (%edi),%eax
  802840:	e8 12 f8 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802845:	85 c0                	test   %eax,%eax
  802847:	78 17                	js     802860 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284c:	e8 04 fa ff ff       	call   802255 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802851:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802857:	e9 41 fe ff ff       	jmp    80269d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	eb 02                	jmp    802862 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802860:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802865:	e8 eb f9 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
	return r;
}
  80286a:	89 f8                	mov    %edi,%eax
  80286c:	83 c4 4c             	add    $0x4c,%esp
  80286f:	5b                   	pop    %ebx
  802870:	5e                   	pop    %esi
  802871:	5f                   	pop    %edi
  802872:	5d                   	pop    %ebp
  802873:	c3                   	ret    
  802874:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802877:	80 3e 00             	cmpb   $0x0,(%esi)
  80287a:	75 bf                	jne    80283b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80287c:	eb a9                	jmp    802827 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080287e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
  802881:	57                   	push   %edi
  802882:	56                   	push   %esi
  802883:	53                   	push   %ebx
  802884:	83 ec 3c             	sub    $0x3c,%esp
  802887:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80288a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80288d:	89 04 24             	mov    %eax,(%esp)
  802890:	e8 62 f0 ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  802895:	89 c3                	mov    %eax,%ebx
  802897:	85 c0                	test   %eax,%eax
  802899:	0f 88 16 02 00 00    	js     802ab5 <_Z4openPKci+0x237>
  80289f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028a6:	00 
  8028a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b5:	e8 76 e9 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  8028ba:	89 c3                	mov    %eax,%ebx
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	85 db                	test   %ebx,%ebx
  8028c3:	0f 88 ec 01 00 00    	js     802ab5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8028c9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8028cd:	0f 84 ec 01 00 00    	je     802abf <_Z4openPKci+0x241>
  8028d3:	83 c0 01             	add    $0x1,%eax
  8028d6:	83 f8 78             	cmp    $0x78,%eax
  8028d9:	75 ee                	jne    8028c9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8028db:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8028e0:	e9 b9 01 00 00       	jmp    802a9e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8028e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028e8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8028ee:	89 3c 24             	mov    %edi,(%esp)
  8028f1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8028f4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8028f7:	89 f0                	mov    %esi,%eax
  8028f9:	e8 68 fd ff ff       	call   802666 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8028fe:	89 c3                	mov    %eax,%ebx
  802900:	85 c0                	test   %eax,%eax
  802902:	0f 85 96 01 00 00    	jne    802a9e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802908:	85 ff                	test   %edi,%edi
  80290a:	75 41                	jne    80294d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80290c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80290f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802914:	75 08                	jne    80291e <_Z4openPKci+0xa0>
            fileino = dirino;
  802916:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80291c:	eb 14                	jmp    802932 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80291e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802921:	8b 00                	mov    (%eax),%eax
  802923:	e8 2f f7 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802928:	89 c3                	mov    %eax,%ebx
  80292a:	85 c0                	test   %eax,%eax
  80292c:	0f 88 5d 01 00 00    	js     802a8f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802932:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802935:	83 38 02             	cmpl   $0x2,(%eax)
  802938:	0f 85 d2 00 00 00    	jne    802a10 <_Z4openPKci+0x192>
  80293e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802942:	0f 84 c8 00 00 00    	je     802a10 <_Z4openPKci+0x192>
  802948:	e9 38 01 00 00       	jmp    802a85 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80294d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802954:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80295b:	0f 8e a8 00 00 00    	jle    802a09 <_Z4openPKci+0x18b>
  802961:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802966:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802969:	89 f8                	mov    %edi,%eax
  80296b:	e8 e7 f6 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802970:	89 c3                	mov    %eax,%ebx
  802972:	85 c0                	test   %eax,%eax
  802974:	0f 88 15 01 00 00    	js     802a8f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80297a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802981:	75 68                	jne    8029eb <_Z4openPKci+0x16d>
  802983:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80298a:	75 5f                	jne    8029eb <_Z4openPKci+0x16d>
			*ino_store = ino;
  80298c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80298f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802995:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802998:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80299f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8029a6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8029ad:	00 
  8029ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8029b5:	00 
  8029b6:	83 c0 0c             	add    $0xc,%eax
  8029b9:	89 04 24             	mov    %eax,(%esp)
  8029bc:	e8 d0 e4 ff ff       	call   800e91 <memset>
        de->de_inum = fileino->i_inum;
  8029c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  8029ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029cd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  8029cf:	ba 04 00 00 00       	mov    $0x4,%edx
  8029d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d7:	e8 bf f5 ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8029dc:	ba 04 00 00 00       	mov    $0x4,%edx
  8029e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e4:	e8 b2 f5 ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
  8029e9:	eb 25                	jmp    802a10 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8029eb:	e8 65 f8 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8029f0:	83 c7 01             	add    $0x1,%edi
  8029f3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8029f9:	0f 8c 67 ff ff ff    	jl     802966 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8029ff:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802a04:	e9 86 00 00 00       	jmp    802a8f <_Z4openPKci+0x211>
  802a09:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802a0e:	eb 7f                	jmp    802a8f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802a10:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802a17:	74 0d                	je     802a26 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802a19:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a21:	e8 aa f6 ff ff       	call   8020d0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802a26:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802a41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a44:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802a4a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802a4d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a51:	83 c0 10             	add    $0x10,%eax
  802a54:	89 04 24             	mov    %eax,(%esp)
  802a57:	e8 ee e2 ff ff       	call   800d4a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802a5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a5f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a69:	e8 e7 f7 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802a6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a71:	e8 df f7 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a79:	89 04 24             	mov    %eax,(%esp)
  802a7c:	e8 13 ee ff ff       	call   801894 <_Z6fd2numP2Fd>
  802a81:	89 c3                	mov    %eax,%ebx
  802a83:	eb 30                	jmp    802ab5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802a85:	e8 cb f7 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802a8a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a92:	e8 be f7 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
  802a97:	eb 05                	jmp    802a9e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802a99:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802a9e:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aad:	89 04 24             	mov    %eax,(%esp)
  802ab0:	e8 38 e8 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802ab5:	89 d8                	mov    %ebx,%eax
  802ab7:	83 c4 3c             	add    $0x3c,%esp
  802aba:	5b                   	pop    %ebx
  802abb:	5e                   	pop    %esi
  802abc:	5f                   	pop    %edi
  802abd:	5d                   	pop    %ebp
  802abe:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802abf:	83 f8 78             	cmp    $0x78,%eax
  802ac2:	0f 85 1d fe ff ff    	jne    8028e5 <_Z4openPKci+0x67>
  802ac8:	eb cf                	jmp    802a99 <_Z4openPKci+0x21b>

00802aca <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802aca:	55                   	push   %ebp
  802acb:	89 e5                	mov    %esp,%ebp
  802acd:	53                   	push   %ebx
  802ace:	83 ec 24             	sub    $0x24,%esp
  802ad1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802ad4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	e8 78 f5 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	78 27                	js     802b0a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802ae3:	c7 44 24 04 a4 49 80 	movl   $0x8049a4,0x4(%esp)
  802aea:	00 
  802aeb:	89 1c 24             	mov    %ebx,(%esp)
  802aee:	e8 57 e2 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802af3:	89 da                	mov    %ebx,%edx
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	e8 26 f4 ff ff       	call   801f23 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	e8 50 f7 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
	return 0;
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b0a:	83 c4 24             	add    $0x24,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    

00802b10 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
  802b13:	53                   	push   %ebx
  802b14:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802b17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b1e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802b21:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	e8 3a fb ff ff       	call   802666 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802b2c:	89 c3                	mov    %eax,%ebx
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	78 5f                	js     802b91 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802b32:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	e8 18 f5 ff ff       	call   802057 <_ZL10inode_openiPP5Inode>
  802b3f:	89 c3                	mov    %eax,%ebx
  802b41:	85 c0                	test   %eax,%eax
  802b43:	78 44                	js     802b89 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802b45:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	83 38 02             	cmpl   $0x2,(%eax)
  802b50:	74 2f                	je     802b81 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802b62:	ba 04 00 00 00       	mov    $0x4,%edx
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	e8 2c f4 ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802b6f:	ba 04 00 00 00       	mov    $0x4,%edx
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	e8 1f f4 ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
	r = 0;
  802b7c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	e8 cc f6 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	e8 c4 f6 ff ff       	call   802255 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802b91:	89 d8                	mov    %ebx,%eax
  802b93:	83 c4 24             	add    $0x24,%esp
  802b96:	5b                   	pop    %ebx
  802b97:	5d                   	pop    %ebp
  802b98:	c3                   	ret    

00802b99 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba1:	5d                   	pop    %ebp
  802ba2:	c3                   	ret    

00802ba3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
  802ba6:	57                   	push   %edi
  802ba7:	56                   	push   %esi
  802ba8:	53                   	push   %ebx
  802ba9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802baf:	c7 04 24 fd 22 80 00 	movl   $0x8022fd,(%esp)
  802bb6:	e8 10 eb ff ff       	call   8016cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802bbb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802bc0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802bc5:	74 28                	je     802bef <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802bc7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802bce:	4a 
  802bcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bd3:	c7 44 24 08 0c 4a 80 	movl   $0x804a0c,0x8(%esp)
  802bda:	00 
  802bdb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802be2:	00 
  802be3:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  802bea:	e8 29 da ff ff       	call   800618 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802bef:	a1 04 10 00 50       	mov    0x50001004,%eax
  802bf4:	83 f8 03             	cmp    $0x3,%eax
  802bf7:	7f 1c                	jg     802c15 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802bf9:	c7 44 24 08 40 4a 80 	movl   $0x804a40,0x8(%esp)
  802c00:	00 
  802c01:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802c08:	00 
  802c09:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  802c10:	e8 03 da ff ff       	call   800618 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802c15:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802c1b:	85 d2                	test   %edx,%edx
  802c1d:	7f 1c                	jg     802c3b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802c1f:	c7 44 24 08 70 4a 80 	movl   $0x804a70,0x8(%esp)
  802c26:	00 
  802c27:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802c2e:	00 
  802c2f:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  802c36:	e8 dd d9 ff ff       	call   800618 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802c3b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802c41:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802c47:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802c4d:	85 c9                	test   %ecx,%ecx
  802c4f:	0f 48 cb             	cmovs  %ebx,%ecx
  802c52:	c1 f9 0c             	sar    $0xc,%ecx
  802c55:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802c59:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802c5f:	39 c8                	cmp    %ecx,%eax
  802c61:	7c 13                	jl     802c76 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802c63:	85 c0                	test   %eax,%eax
  802c65:	7f 3d                	jg     802ca4 <_Z4fsckv+0x101>
  802c67:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802c6e:	00 00 00 
  802c71:	e9 ac 00 00 00       	jmp    802d22 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802c76:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802c7c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802c80:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c84:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802c88:	c7 44 24 08 a0 4a 80 	movl   $0x804aa0,0x8(%esp)
  802c8f:	00 
  802c90:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802c97:	00 
  802c98:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  802c9f:	e8 74 d9 ff ff       	call   800618 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802ca4:	be 00 20 00 50       	mov    $0x50002000,%esi
  802ca9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802cb0:	00 00 00 
  802cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802cb8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802cbe:	39 df                	cmp    %ebx,%edi
  802cc0:	7e 27                	jle    802ce9 <_Z4fsckv+0x146>
  802cc2:	0f b6 06             	movzbl (%esi),%eax
  802cc5:	84 c0                	test   %al,%al
  802cc7:	74 4b                	je     802d14 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802cc9:	0f be c0             	movsbl %al,%eax
  802ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802cd4:	c7 04 24 e4 4a 80 00 	movl   $0x804ae4,(%esp)
  802cdb:	e8 56 da ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802ce0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ce7:	eb 2b                	jmp    802d14 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802ce9:	0f b6 06             	movzbl (%esi),%eax
  802cec:	3c 01                	cmp    $0x1,%al
  802cee:	76 24                	jbe    802d14 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802cf0:	0f be c0             	movsbl %al,%eax
  802cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cf7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802cfb:	c7 04 24 18 4b 80 00 	movl   $0x804b18,(%esp)
  802d02:	e8 2f da ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802d07:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802d0e:	80 3e 00             	cmpb   $0x0,(%esi)
  802d11:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802d14:	83 c3 01             	add    $0x1,%ebx
  802d17:	83 c6 01             	add    $0x1,%esi
  802d1a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802d20:	7f 9c                	jg     802cbe <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802d22:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802d29:	0f 8e e1 02 00 00    	jle    803010 <_Z4fsckv+0x46d>
  802d2f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802d36:	00 00 00 
		struct Inode *ino = get_inode(i);
  802d39:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d3f:	e8 f9 f1 ff ff       	call   801f3d <_ZL9get_inodei>
  802d44:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802d4a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802d4e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802d55:	75 22                	jne    802d79 <_Z4fsckv+0x1d6>
  802d57:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802d5e:	0f 84 a9 06 00 00    	je     80340d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802d64:	ba 00 00 00 00       	mov    $0x0,%edx
  802d69:	e8 2d f2 ff ff       	call   801f9b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 3a                	je     802dac <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802d72:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802d79:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d7f:	8b 02                	mov    (%edx),%eax
  802d81:	83 f8 01             	cmp    $0x1,%eax
  802d84:	74 26                	je     802dac <_Z4fsckv+0x209>
  802d86:	83 f8 02             	cmp    $0x2,%eax
  802d89:	74 21                	je     802dac <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802d8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d8f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d95:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d99:	c7 04 24 44 4b 80 00 	movl   $0x804b44,(%esp)
  802da0:	e8 91 d9 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802da5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802dac:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802db3:	75 3f                	jne    802df4 <_Z4fsckv+0x251>
  802db5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802dbb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802dbf:	75 15                	jne    802dd6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802dc1:	c7 04 24 68 4b 80 00 	movl   $0x804b68,(%esp)
  802dc8:	e8 69 d9 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802dcd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802dd4:	eb 1e                	jmp    802df4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802dd6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ddc:	83 3a 02             	cmpl   $0x2,(%edx)
  802ddf:	74 13                	je     802df4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802de1:	c7 04 24 9c 4b 80 00 	movl   $0x804b9c,(%esp)
  802de8:	e8 49 d9 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802ded:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802df4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802df9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e00:	0f 84 93 00 00 00    	je     802e99 <_Z4fsckv+0x2f6>
  802e06:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802e0c:	8b 41 08             	mov    0x8(%ecx),%eax
  802e0f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802e14:	7e 23                	jle    802e39 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802e16:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e1a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e24:	c7 04 24 cc 4b 80 00 	movl   $0x804bcc,(%esp)
  802e2b:	e8 06 d9 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802e30:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e37:	eb 09                	jmp    802e42 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802e39:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e40:	74 4b                	je     802e8d <_Z4fsckv+0x2ea>
  802e42:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e48:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802e4e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802e54:	74 23                	je     802e79 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802e56:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e5a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e64:	c7 04 24 f0 4b 80 00 	movl   $0x804bf0,(%esp)
  802e6b:	e8 c6 d8 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  802e70:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e77:	eb 09                	jmp    802e82 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802e79:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e80:	74 12                	je     802e94 <_Z4fsckv+0x2f1>
  802e82:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802e88:	8b 78 08             	mov    0x8(%eax),%edi
  802e8b:	eb 0c                	jmp    802e99 <_Z4fsckv+0x2f6>
  802e8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e92:	eb 05                	jmp    802e99 <_Z4fsckv+0x2f6>
  802e94:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802e99:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802e9e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ea4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802ea8:	89 d8                	mov    %ebx,%eax
  802eaa:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802ead:	39 c7                	cmp    %eax,%edi
  802eaf:	7e 2b                	jle    802edc <_Z4fsckv+0x339>
  802eb1:	85 f6                	test   %esi,%esi
  802eb3:	75 27                	jne    802edc <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ebd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ec3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ec7:	c7 04 24 14 4c 80 00 	movl   $0x804c14,(%esp)
  802ece:	e8 63 d8 ff ff       	call   800736 <_Z7cprintfPKcz>
				++errors;
  802ed3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802eda:	eb 36                	jmp    802f12 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802edc:	39 f8                	cmp    %edi,%eax
  802ede:	7c 32                	jl     802f12 <_Z4fsckv+0x36f>
  802ee0:	85 f6                	test   %esi,%esi
  802ee2:	74 2e                	je     802f12 <_Z4fsckv+0x36f>
  802ee4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802eeb:	74 25                	je     802f12 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802eed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ef1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ef5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eff:	c7 04 24 58 4c 80 00 	movl   $0x804c58,(%esp)
  802f06:	e8 2b d8 ff ff       	call   800736 <_Z7cprintfPKcz>
				++errors;
  802f0b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802f12:	85 f6                	test   %esi,%esi
  802f14:	0f 84 a0 00 00 00    	je     802fba <_Z4fsckv+0x417>
  802f1a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f21:	0f 84 93 00 00 00    	je     802fba <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802f27:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802f2d:	7e 27                	jle    802f56 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802f2f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f37:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f41:	c7 04 24 9c 4c 80 00 	movl   $0x804c9c,(%esp)
  802f48:	e8 e9 d7 ff ff       	call   800736 <_Z7cprintfPKcz>
					++errors;
  802f4d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f54:	eb 64                	jmp    802fba <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802f56:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802f5d:	3c 01                	cmp    $0x1,%al
  802f5f:	75 27                	jne    802f88 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802f61:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f65:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f69:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f73:	c7 04 24 e0 4c 80 00 	movl   $0x804ce0,(%esp)
  802f7a:	e8 b7 d7 ff ff       	call   800736 <_Z7cprintfPKcz>
					++errors;
  802f7f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f86:	eb 32                	jmp    802fba <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802f88:	3c ff                	cmp    $0xff,%al
  802f8a:	75 27                	jne    802fb3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802f8c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f90:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f94:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f9e:	c7 04 24 1c 4d 80 00 	movl   $0x804d1c,(%esp)
  802fa5:	e8 8c d7 ff ff       	call   800736 <_Z7cprintfPKcz>
					++errors;
  802faa:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fb1:	eb 07                	jmp    802fba <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802fb3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802fba:	83 c3 01             	add    $0x1,%ebx
  802fbd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802fc3:	0f 85 d5 fe ff ff    	jne    802e9e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802fc9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802fd0:	0f 94 c0             	sete   %al
  802fd3:	0f b6 c0             	movzbl %al,%eax
  802fd6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fdc:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802fe2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802fe9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802ff0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802ff7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802ffe:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803004:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80300a:	0f 8f 29 fd ff ff    	jg     802d39 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803010:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803017:	0f 8e 7f 03 00 00    	jle    80339c <_Z4fsckv+0x7f9>
  80301d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803022:	89 f0                	mov    %esi,%eax
  803024:	e8 14 ef ff ff       	call   801f3d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803029:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803030:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803037:	c1 e2 08             	shl    $0x8,%edx
  80303a:	09 ca                	or     %ecx,%edx
  80303c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803043:	c1 e1 10             	shl    $0x10,%ecx
  803046:	09 ca                	or     %ecx,%edx
  803048:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80304f:	83 e1 7f             	and    $0x7f,%ecx
  803052:	c1 e1 18             	shl    $0x18,%ecx
  803055:	09 d1                	or     %edx,%ecx
  803057:	74 0e                	je     803067 <_Z4fsckv+0x4c4>
  803059:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803060:	78 05                	js     803067 <_Z4fsckv+0x4c4>
  803062:	83 38 02             	cmpl   $0x2,(%eax)
  803065:	74 1f                	je     803086 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803067:	83 c6 01             	add    $0x1,%esi
  80306a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80306f:	39 f0                	cmp    %esi,%eax
  803071:	7f af                	jg     803022 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803073:	bb 01 00 00 00       	mov    $0x1,%ebx
  803078:	83 f8 01             	cmp    $0x1,%eax
  80307b:	0f 8f ad 02 00 00    	jg     80332e <_Z4fsckv+0x78b>
  803081:	e9 16 03 00 00       	jmp    80339c <_Z4fsckv+0x7f9>
  803086:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803088:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80308f:	8b 40 08             	mov    0x8(%eax),%eax
  803092:	a8 7f                	test   $0x7f,%al
  803094:	74 23                	je     8030b9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803096:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80309d:	00 
  80309e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030a6:	c7 04 24 58 4d 80 00 	movl   $0x804d58,(%esp)
  8030ad:	e8 84 d6 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  8030b2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8030b9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8030c0:	00 00 00 
  8030c3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8030c9:	e9 3d 02 00 00       	jmp    80330b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8030ce:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030d4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8030da:	e8 01 ee ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
  8030df:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8030e1:	83 38 00             	cmpl   $0x0,(%eax)
  8030e4:	0f 84 15 02 00 00    	je     8032ff <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030f0:	83 fa 76             	cmp    $0x76,%edx
  8030f3:	76 27                	jbe    80311c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  8030f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030f9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8030ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  803103:	89 74 24 04          	mov    %esi,0x4(%esp)
  803107:	c7 04 24 8c 4d 80 00 	movl   $0x804d8c,(%esp)
  80310e:	e8 23 d6 ff ff       	call   800736 <_Z7cprintfPKcz>
				++errors;
  803113:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80311a:	eb 28                	jmp    803144 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80311c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803121:	74 21                	je     803144 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803123:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803129:	89 54 24 08          	mov    %edx,0x8(%esp)
  80312d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803131:	c7 04 24 b8 4d 80 00 	movl   $0x804db8,(%esp)
  803138:	e8 f9 d5 ff ff       	call   800736 <_Z7cprintfPKcz>
				++errors;
  80313d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803144:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80314b:	00 
  80314c:	8d 43 08             	lea    0x8(%ebx),%eax
  80314f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803153:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803159:	89 0c 24             	mov    %ecx,(%esp)
  80315c:	e8 06 de ff ff       	call   800f67 <memcpy>
  803161:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803165:	bf 77 00 00 00       	mov    $0x77,%edi
  80316a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80316e:	85 ff                	test   %edi,%edi
  803170:	b8 00 00 00 00       	mov    $0x0,%eax
  803175:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803178:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80317f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803180:	8b 03                	mov    (%ebx),%eax
  803182:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803188:	7c 3e                	jl     8031c8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80318a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80318e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803194:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803198:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80319e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031a6:	c7 04 24 ec 4d 80 00 	movl   $0x804dec,(%esp)
  8031ad:	e8 84 d5 ff ff       	call   800736 <_Z7cprintfPKcz>
				++errors;
  8031b2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8031b9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8031c0:	00 00 00 
  8031c3:	e9 0b 01 00 00       	jmp    8032d3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8031c8:	e8 70 ed ff ff       	call   801f3d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8031cd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8031d4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8031db:	c1 e2 08             	shl    $0x8,%edx
  8031de:	09 d1                	or     %edx,%ecx
  8031e0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8031e7:	c1 e2 10             	shl    $0x10,%edx
  8031ea:	09 d1                	or     %edx,%ecx
  8031ec:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8031f3:	83 e2 7f             	and    $0x7f,%edx
  8031f6:	c1 e2 18             	shl    $0x18,%edx
  8031f9:	09 ca                	or     %ecx,%edx
  8031fb:	83 c2 01             	add    $0x1,%edx
  8031fe:	89 d1                	mov    %edx,%ecx
  803200:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803206:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80320c:	0f b6 d5             	movzbl %ch,%edx
  80320f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803215:	89 ca                	mov    %ecx,%edx
  803217:	c1 ea 10             	shr    $0x10,%edx
  80321a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803220:	c1 e9 18             	shr    $0x18,%ecx
  803223:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80322a:	83 e2 80             	and    $0xffffff80,%edx
  80322d:	09 ca                	or     %ecx,%edx
  80322f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803235:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803239:	0f 85 7a ff ff ff    	jne    8031b9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80323f:	8b 03                	mov    (%ebx),%eax
  803241:	89 44 24 10          	mov    %eax,0x10(%esp)
  803245:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80324b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80324f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803255:	89 44 24 08          	mov    %eax,0x8(%esp)
  803259:	89 74 24 04          	mov    %esi,0x4(%esp)
  80325d:	c7 04 24 1c 4e 80 00 	movl   $0x804e1c,(%esp)
  803264:	e8 cd d4 ff ff       	call   800736 <_Z7cprintfPKcz>
					++errors;
  803269:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803270:	e9 44 ff ff ff       	jmp    8031b9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803275:	3b 78 04             	cmp    0x4(%eax),%edi
  803278:	75 52                	jne    8032cc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80327a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80327e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803284:	89 54 24 04          	mov    %edx,0x4(%esp)
  803288:	83 c0 08             	add    $0x8,%eax
  80328b:	89 04 24             	mov    %eax,(%esp)
  80328e:	e8 15 dd ff ff       	call   800fa8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803293:	85 c0                	test   %eax,%eax
  803295:	75 35                	jne    8032cc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803297:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80329d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8032a1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8032a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032ab:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032b9:	c7 04 24 4c 4e 80 00 	movl   $0x804e4c,(%esp)
  8032c0:	e8 71 d4 ff ff       	call   800736 <_Z7cprintfPKcz>
					++errors;
  8032c5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8032cc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  8032d3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8032d9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  8032df:	7e 1e                	jle    8032ff <_Z4fsckv+0x75c>
  8032e1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8032e5:	7f 18                	jg     8032ff <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8032e7:	89 ca                	mov    %ecx,%edx
  8032e9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8032ef:	e8 ec eb ff ff       	call   801ee0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  8032f4:	83 38 00             	cmpl   $0x0,(%eax)
  8032f7:	0f 85 78 ff ff ff    	jne    803275 <_Z4fsckv+0x6d2>
  8032fd:	eb cd                	jmp    8032cc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8032ff:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803305:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80330b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803311:	83 ea 80             	sub    $0xffffff80,%edx
  803314:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80331a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803320:	3b 51 08             	cmp    0x8(%ecx),%edx
  803323:	0f 8f e7 fc ff ff    	jg     803010 <_Z4fsckv+0x46d>
  803329:	e9 a0 fd ff ff       	jmp    8030ce <_Z4fsckv+0x52b>
  80332e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803334:	89 d8                	mov    %ebx,%eax
  803336:	e8 02 ec ff ff       	call   801f3d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80333b:	8b 50 04             	mov    0x4(%eax),%edx
  80333e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803345:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80334c:	c1 e7 08             	shl    $0x8,%edi
  80334f:	09 f9                	or     %edi,%ecx
  803351:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803358:	c1 e7 10             	shl    $0x10,%edi
  80335b:	09 f9                	or     %edi,%ecx
  80335d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803364:	83 e7 7f             	and    $0x7f,%edi
  803367:	c1 e7 18             	shl    $0x18,%edi
  80336a:	09 f9                	or     %edi,%ecx
  80336c:	39 ca                	cmp    %ecx,%edx
  80336e:	74 1b                	je     80338b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803370:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803374:	89 54 24 08          	mov    %edx,0x8(%esp)
  803378:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80337c:	c7 04 24 7c 4e 80 00 	movl   $0x804e7c,(%esp)
  803383:	e8 ae d3 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  803388:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80338b:	83 c3 01             	add    $0x1,%ebx
  80338e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803394:	7f 9e                	jg     803334 <_Z4fsckv+0x791>
  803396:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80339c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8033a3:	7e 4f                	jle    8033f4 <_Z4fsckv+0x851>
  8033a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8033aa:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8033b0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8033b7:	3c ff                	cmp    $0xff,%al
  8033b9:	75 09                	jne    8033c4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8033bb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  8033c2:	eb 1f                	jmp    8033e3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  8033c4:	84 c0                	test   %al,%al
  8033c6:	75 1b                	jne    8033e3 <_Z4fsckv+0x840>
  8033c8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  8033ce:	7c 13                	jl     8033e3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  8033d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033d4:	c7 04 24 a8 4e 80 00 	movl   $0x804ea8,(%esp)
  8033db:	e8 56 d3 ff ff       	call   800736 <_Z7cprintfPKcz>
			++errors;
  8033e0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8033e3:	83 c3 01             	add    $0x1,%ebx
  8033e6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8033ec:	7f c2                	jg     8033b0 <_Z4fsckv+0x80d>
  8033ee:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  8033f4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  8033fb:	19 c0                	sbb    %eax,%eax
  8033fd:	f7 d0                	not    %eax
  8033ff:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803402:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803408:	5b                   	pop    %ebx
  803409:	5e                   	pop    %esi
  80340a:	5f                   	pop    %edi
  80340b:	5d                   	pop    %ebp
  80340c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80340d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803414:	0f 84 92 f9 ff ff    	je     802dac <_Z4fsckv+0x209>
  80341a:	e9 5a f9 ff ff       	jmp    802d79 <_Z4fsckv+0x1d6>
	...

00803420 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803420:	55                   	push   %ebp
  803421:	89 e5                	mov    %esp,%ebp
  803423:	83 ec 18             	sub    $0x18,%esp
  803426:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803429:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80342c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	89 04 24             	mov    %eax,(%esp)
  803435:	e8 a2 e4 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  80343a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80343c:	c7 44 24 04 db 4e 80 	movl   $0x804edb,0x4(%esp)
  803443:	00 
  803444:	89 34 24             	mov    %esi,(%esp)
  803447:	e8 fe d8 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80344c:	8b 43 04             	mov    0x4(%ebx),%eax
  80344f:	2b 03                	sub    (%ebx),%eax
  803451:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803454:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80345b:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  803462:	50 80 00 
	return 0;
}
  803465:	b8 00 00 00 00       	mov    $0x0,%eax
  80346a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80346d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803470:	89 ec                	mov    %ebp,%esp
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    

00803474 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803474:	55                   	push   %ebp
  803475:	89 e5                	mov    %esp,%ebp
  803477:	53                   	push   %ebx
  803478:	83 ec 14             	sub    $0x14,%esp
  80347b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80347e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803482:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803489:	e8 5f de ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80348e:	89 1c 24             	mov    %ebx,(%esp)
  803491:	e8 46 e4 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  803496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80349a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034a1:	e8 47 de ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
}
  8034a6:	83 c4 14             	add    $0x14,%esp
  8034a9:	5b                   	pop    %ebx
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    

008034ac <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	57                   	push   %edi
  8034b0:	56                   	push   %esi
  8034b1:	53                   	push   %ebx
  8034b2:	83 ec 2c             	sub    $0x2c,%esp
  8034b5:	89 c7                	mov    %eax,%edi
  8034b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8034ba:	a1 ac 60 80 00       	mov    0x8060ac,%eax
  8034bf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8034c2:	89 3c 24             	mov    %edi,(%esp)
  8034c5:	e8 82 04 00 00       	call   80394c <_Z7pagerefPv>
  8034ca:	89 c3                	mov    %eax,%ebx
  8034cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cf:	89 04 24             	mov    %eax,(%esp)
  8034d2:	e8 75 04 00 00       	call   80394c <_Z7pagerefPv>
  8034d7:	39 c3                	cmp    %eax,%ebx
  8034d9:	0f 94 c0             	sete   %al
  8034dc:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8034df:	8b 15 ac 60 80 00    	mov    0x8060ac,%edx
  8034e5:	8b 52 58             	mov    0x58(%edx),%edx
  8034e8:	39 d6                	cmp    %edx,%esi
  8034ea:	75 08                	jne    8034f4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8034ec:	83 c4 2c             	add    $0x2c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 c2                	je     8034ba <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8034f8:	c7 04 24 e2 4e 80 00 	movl   $0x804ee2,(%esp)
  8034ff:	e8 32 d2 ff ff       	call   800736 <_Z7cprintfPKcz>
  803504:	eb b4                	jmp    8034ba <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803506 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
  803509:	57                   	push   %edi
  80350a:	56                   	push   %esi
  80350b:	53                   	push   %ebx
  80350c:	83 ec 1c             	sub    $0x1c,%esp
  80350f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803512:	89 34 24             	mov    %esi,(%esp)
  803515:	e8 c2 e3 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  80351a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80351c:	bf 00 00 00 00       	mov    $0x0,%edi
  803521:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803525:	75 46                	jne    80356d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803527:	eb 52                	jmp    80357b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803529:	89 da                	mov    %ebx,%edx
  80352b:	89 f0                	mov    %esi,%eax
  80352d:	e8 7a ff ff ff       	call   8034ac <_ZL13_pipeisclosedP2FdP4Pipe>
  803532:	85 c0                	test   %eax,%eax
  803534:	75 49                	jne    80357f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803536:	e8 c1 dc ff ff       	call   8011fc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80353b:	8b 43 04             	mov    0x4(%ebx),%eax
  80353e:	89 c2                	mov    %eax,%edx
  803540:	2b 13                	sub    (%ebx),%edx
  803542:	83 fa 20             	cmp    $0x20,%edx
  803545:	74 e2                	je     803529 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803547:	89 c2                	mov    %eax,%edx
  803549:	c1 fa 1f             	sar    $0x1f,%edx
  80354c:	c1 ea 1b             	shr    $0x1b,%edx
  80354f:	01 d0                	add    %edx,%eax
  803551:	83 e0 1f             	and    $0x1f,%eax
  803554:	29 d0                	sub    %edx,%eax
  803556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803559:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80355d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803561:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803565:	83 c7 01             	add    $0x1,%edi
  803568:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80356b:	76 0e                	jbe    80357b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80356d:	8b 43 04             	mov    0x4(%ebx),%eax
  803570:	89 c2                	mov    %eax,%edx
  803572:	2b 13                	sub    (%ebx),%edx
  803574:	83 fa 20             	cmp    $0x20,%edx
  803577:	74 b0                	je     803529 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803579:	eb cc                	jmp    803547 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80357b:	89 f8                	mov    %edi,%eax
  80357d:	eb 05                	jmp    803584 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80357f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803584:	83 c4 1c             	add    $0x1c,%esp
  803587:	5b                   	pop    %ebx
  803588:	5e                   	pop    %esi
  803589:	5f                   	pop    %edi
  80358a:	5d                   	pop    %ebp
  80358b:	c3                   	ret    

0080358c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80358c:	55                   	push   %ebp
  80358d:	89 e5                	mov    %esp,%ebp
  80358f:	83 ec 28             	sub    $0x28,%esp
  803592:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803595:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803598:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80359b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80359e:	89 3c 24             	mov    %edi,(%esp)
  8035a1:	e8 36 e3 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  8035a6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8035a8:	be 00 00 00 00       	mov    $0x0,%esi
  8035ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8035b1:	75 47                	jne    8035fa <_ZL12devpipe_readP2FdPvj+0x6e>
  8035b3:	eb 52                	jmp    803607 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8035b5:	89 f0                	mov    %esi,%eax
  8035b7:	eb 5e                	jmp    803617 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8035b9:	89 da                	mov    %ebx,%edx
  8035bb:	89 f8                	mov    %edi,%eax
  8035bd:	8d 76 00             	lea    0x0(%esi),%esi
  8035c0:	e8 e7 fe ff ff       	call   8034ac <_ZL13_pipeisclosedP2FdP4Pipe>
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	75 49                	jne    803612 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8035c9:	e8 2e dc ff ff       	call   8011fc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035ce:	8b 03                	mov    (%ebx),%eax
  8035d0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8035d3:	74 e4                	je     8035b9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035d5:	89 c2                	mov    %eax,%edx
  8035d7:	c1 fa 1f             	sar    $0x1f,%edx
  8035da:	c1 ea 1b             	shr    $0x1b,%edx
  8035dd:	01 d0                	add    %edx,%eax
  8035df:	83 e0 1f             	and    $0x1f,%eax
  8035e2:	29 d0                	sub    %edx,%eax
  8035e4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8035e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ec:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8035ef:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8035f2:	83 c6 01             	add    $0x1,%esi
  8035f5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8035f8:	76 0d                	jbe    803607 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8035fa:	8b 03                	mov    (%ebx),%eax
  8035fc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8035ff:	75 d4                	jne    8035d5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803601:	85 f6                	test   %esi,%esi
  803603:	75 b0                	jne    8035b5 <_ZL12devpipe_readP2FdPvj+0x29>
  803605:	eb b2                	jmp    8035b9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803607:	89 f0                	mov    %esi,%eax
  803609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803610:	eb 05                	jmp    803617 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803612:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803617:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80361a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80361d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803620:	89 ec                	mov    %ebp,%esp
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    

00803624 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803624:	55                   	push   %ebp
  803625:	89 e5                	mov    %esp,%ebp
  803627:	83 ec 48             	sub    $0x48,%esp
  80362a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80362d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803630:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803633:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803636:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803639:	89 04 24             	mov    %eax,(%esp)
  80363c:	e8 b6 e2 ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  803641:	89 c3                	mov    %eax,%ebx
  803643:	85 c0                	test   %eax,%eax
  803645:	0f 88 0b 01 00 00    	js     803756 <_Z4pipePi+0x132>
  80364b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803652:	00 
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80365a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803661:	e8 ca db ff ff       	call   801230 <_Z14sys_page_allociPvi>
  803666:	89 c3                	mov    %eax,%ebx
  803668:	85 c0                	test   %eax,%eax
  80366a:	0f 89 f5 00 00 00    	jns    803765 <_Z4pipePi+0x141>
  803670:	e9 e1 00 00 00       	jmp    803756 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803675:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80367c:	00 
  80367d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803680:	89 44 24 04          	mov    %eax,0x4(%esp)
  803684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80368b:	e8 a0 db ff ff       	call   801230 <_Z14sys_page_allociPvi>
  803690:	89 c3                	mov    %eax,%ebx
  803692:	85 c0                	test   %eax,%eax
  803694:	0f 89 e2 00 00 00    	jns    80377c <_Z4pipePi+0x158>
  80369a:	e9 a4 00 00 00       	jmp    803743 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80369f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a2:	89 04 24             	mov    %eax,(%esp)
  8036a5:	e8 32 e2 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  8036aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8036b1:	00 
  8036b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036bd:	00 
  8036be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8036c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036c9:	e8 c1 db ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  8036ce:	89 c3                	mov    %eax,%ebx
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	78 4c                	js     803720 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036d4:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8036df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036e9:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8036ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8036f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803701:	89 04 24             	mov    %eax,(%esp)
  803704:	e8 8b e1 ff ff       	call   801894 <_Z6fd2numP2Fd>
  803709:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80370b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80370e:	89 04 24             	mov    %eax,(%esp)
  803711:	e8 7e e1 ff ff       	call   801894 <_Z6fd2numP2Fd>
  803716:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803719:	bb 00 00 00 00       	mov    $0x0,%ebx
  80371e:	eb 36                	jmp    803756 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803720:	89 74 24 04          	mov    %esi,0x4(%esp)
  803724:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80372b:	e8 bd db ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803733:	89 44 24 04          	mov    %eax,0x4(%esp)
  803737:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80373e:	e8 aa db ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80374a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803751:	e8 97 db ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803756:	89 d8                	mov    %ebx,%eax
  803758:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80375b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80375e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803761:	89 ec                	mov    %ebp,%esp
  803763:	5d                   	pop    %ebp
  803764:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803765:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803768:	89 04 24             	mov    %eax,(%esp)
  80376b:	e8 87 e1 ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  803770:	89 c3                	mov    %eax,%ebx
  803772:	85 c0                	test   %eax,%eax
  803774:	0f 89 fb fe ff ff    	jns    803675 <_Z4pipePi+0x51>
  80377a:	eb c7                	jmp    803743 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80377c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377f:	89 04 24             	mov    %eax,(%esp)
  803782:	e8 55 e1 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  803787:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803789:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803790:	00 
  803791:	89 44 24 04          	mov    %eax,0x4(%esp)
  803795:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80379c:	e8 8f da ff ff       	call   801230 <_Z14sys_page_allociPvi>
  8037a1:	89 c3                	mov    %eax,%ebx
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	0f 89 f4 fe ff ff    	jns    80369f <_Z4pipePi+0x7b>
  8037ab:	eb 83                	jmp    803730 <_Z4pipePi+0x10c>

008037ad <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8037ad:	55                   	push   %ebp
  8037ae:	89 e5                	mov    %esp,%ebp
  8037b0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8037b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8037ba:	00 
  8037bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	89 04 24             	mov    %eax,(%esp)
  8037c8:	e8 74 e0 ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  8037cd:	85 c0                	test   %eax,%eax
  8037cf:	78 15                	js     8037e6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	89 04 24             	mov    %eax,(%esp)
  8037d7:	e8 00 e1 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8037dc:	89 c2                	mov    %eax,%edx
  8037de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e1:	e8 c6 fc ff ff       	call   8034ac <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8037e6:	c9                   	leave  
  8037e7:	c3                   	ret    

008037e8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8037e8:	55                   	push   %ebp
  8037e9:	89 e5                	mov    %esp,%ebp
  8037eb:	53                   	push   %ebx
  8037ec:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8037ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037f2:	89 04 24             	mov    %eax,(%esp)
  8037f5:	e8 fd e0 ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  8037fa:	89 c3                	mov    %eax,%ebx
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	0f 88 be 00 00 00    	js     8038c2 <_Z18pipe_ipc_recv_readv+0xda>
  803804:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80380b:	00 
  80380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803813:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80381a:	e8 11 da ff ff       	call   801230 <_Z14sys_page_allociPvi>
  80381f:	89 c3                	mov    %eax,%ebx
  803821:	85 c0                	test   %eax,%eax
  803823:	0f 89 a1 00 00 00    	jns    8038ca <_Z18pipe_ipc_recv_readv+0xe2>
  803829:	e9 94 00 00 00       	jmp    8038c2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80382e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	75 0e                	jne    803843 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803835:	c7 04 24 40 4f 80 00 	movl   $0x804f40,(%esp)
  80383c:	e8 f5 ce ff ff       	call   800736 <_Z7cprintfPKcz>
  803841:	eb 10                	jmp    803853 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803843:	89 44 24 04          	mov    %eax,0x4(%esp)
  803847:	c7 04 24 f5 4e 80 00 	movl   $0x804ef5,(%esp)
  80384e:	e8 e3 ce ff ff       	call   800736 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803853:	c7 04 24 ff 4e 80 00 	movl   $0x804eff,(%esp)
  80385a:	e8 d7 ce ff ff       	call   800736 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80385f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803862:	a8 04                	test   $0x4,%al
  803864:	74 04                	je     80386a <_Z18pipe_ipc_recv_readv+0x82>
  803866:	a8 01                	test   $0x1,%al
  803868:	75 24                	jne    80388e <_Z18pipe_ipc_recv_readv+0xa6>
  80386a:	c7 44 24 0c 12 4f 80 	movl   $0x804f12,0xc(%esp)
  803871:	00 
  803872:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  803879:	00 
  80387a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803881:	00 
  803882:	c7 04 24 2f 4f 80 00 	movl   $0x804f2f,(%esp)
  803889:	e8 8a cd ff ff       	call   800618 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80388e:	8b 15 20 50 80 00    	mov    0x805020,%edx
  803894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803897:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8038a3:	89 04 24             	mov    %eax,(%esp)
  8038a6:	e8 e9 df ff ff       	call   801894 <_Z6fd2numP2Fd>
  8038ab:	89 c3                	mov    %eax,%ebx
  8038ad:	eb 13                	jmp    8038c2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038bd:	e8 2b da ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8038c2:	89 d8                	mov    %ebx,%eax
  8038c4:	83 c4 24             	add    $0x24,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5d                   	pop    %ebp
  8038c9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8038ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cd:	89 04 24             	mov    %eax,(%esp)
  8038d0:	e8 07 e0 ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  8038d5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8038d8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8038dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8038e3:	89 04 24             	mov    %eax,(%esp)
  8038e6:	e8 35 07 00 00       	call   804020 <_Z8ipc_recvPiPvS_>
  8038eb:	89 c3                	mov    %eax,%ebx
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	0f 89 39 ff ff ff    	jns    80382e <_Z18pipe_ipc_recv_readv+0x46>
  8038f5:	eb b8                	jmp    8038af <_Z18pipe_ipc_recv_readv+0xc7>

008038f7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8038f7:	55                   	push   %ebp
  8038f8:	89 e5                	mov    %esp,%ebp
  8038fa:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8038fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803904:	00 
  803905:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80390c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390f:	89 04 24             	mov    %eax,(%esp)
  803912:	e8 2a df ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  803917:	85 c0                	test   %eax,%eax
  803919:	78 2f                	js     80394a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391e:	89 04 24             	mov    %eax,(%esp)
  803921:	e8 b6 df ff ff       	call   8018dc <_Z7fd2dataP2Fd>
  803926:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80392d:	00 
  80392e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803932:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803939:	00 
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	89 04 24             	mov    %eax,(%esp)
  803940:	e8 6a 07 00 00       	call   8040af <_Z8ipc_sendijPvi>
    return 0;
  803945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80394a:	c9                   	leave  
  80394b:	c3                   	ret    

0080394c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80394c:	55                   	push   %ebp
  80394d:	89 e5                	mov    %esp,%ebp
  80394f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803952:	89 d0                	mov    %edx,%eax
  803954:	c1 e8 16             	shr    $0x16,%eax
  803957:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80395e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803963:	f6 c1 01             	test   $0x1,%cl
  803966:	74 1d                	je     803985 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803968:	c1 ea 0c             	shr    $0xc,%edx
  80396b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803972:	f6 c2 01             	test   $0x1,%dl
  803975:	74 0e                	je     803985 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803977:	c1 ea 0c             	shr    $0xc,%edx
  80397a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803981:	ef 
  803982:	0f b7 c0             	movzwl %ax,%eax
}
  803985:	5d                   	pop    %ebp
  803986:	c3                   	ret    
	...

00803990 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803990:	55                   	push   %ebp
  803991:	89 e5                	mov    %esp,%ebp
  803993:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803996:	c7 44 24 04 64 4f 80 	movl   $0x804f64,0x4(%esp)
  80399d:	00 
  80399e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039a1:	89 04 24             	mov    %eax,(%esp)
  8039a4:	e8 a1 d3 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	return 0;
}
  8039a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ae:	c9                   	leave  
  8039af:	c3                   	ret    

008039b0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8039b0:	55                   	push   %ebp
  8039b1:	89 e5                	mov    %esp,%ebp
  8039b3:	53                   	push   %ebx
  8039b4:	83 ec 14             	sub    $0x14,%esp
  8039b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8039ba:	89 1c 24             	mov    %ebx,(%esp)
  8039bd:	e8 8a ff ff ff       	call   80394c <_Z7pagerefPv>
  8039c2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8039c4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8039c9:	83 fa 01             	cmp    $0x1,%edx
  8039cc:	75 0b                	jne    8039d9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8039ce:	8b 43 0c             	mov    0xc(%ebx),%eax
  8039d1:	89 04 24             	mov    %eax,(%esp)
  8039d4:	e8 fe 02 00 00       	call   803cd7 <_Z11nsipc_closei>
	else
		return 0;
}
  8039d9:	83 c4 14             	add    $0x14,%esp
  8039dc:	5b                   	pop    %ebx
  8039dd:	5d                   	pop    %ebp
  8039de:	c3                   	ret    

008039df <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039df:	55                   	push   %ebp
  8039e0:	89 e5                	mov    %esp,%ebp
  8039e2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8039e5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8039ec:	00 
  8039ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8039f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803a01:	89 04 24             	mov    %eax,(%esp)
  803a04:	e8 c9 03 00 00       	call   803dd2 <_Z10nsipc_sendiPKvij>
}
  803a09:	c9                   	leave  
  803a0a:	c3                   	ret    

00803a0b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a0b:	55                   	push   %ebp
  803a0c:	89 e5                	mov    %esp,%ebp
  803a0e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a11:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803a18:	00 
  803a19:	8b 45 10             	mov    0x10(%ebp),%eax
  803a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a27:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a2d:	89 04 24             	mov    %eax,(%esp)
  803a30:	e8 1d 03 00 00       	call   803d52 <_Z10nsipc_recviPvij>
}
  803a35:	c9                   	leave  
  803a36:	c3                   	ret    

00803a37 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803a37:	55                   	push   %ebp
  803a38:	89 e5                	mov    %esp,%ebp
  803a3a:	83 ec 28             	sub    $0x28,%esp
  803a3d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803a40:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803a43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a48:	89 04 24             	mov    %eax,(%esp)
  803a4b:	e8 a7 de ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  803a50:	89 c3                	mov    %eax,%ebx
  803a52:	85 c0                	test   %eax,%eax
  803a54:	78 21                	js     803a77 <_ZL12alloc_sockfdi+0x40>
  803a56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a5d:	00 
  803a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a6c:	e8 bf d7 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  803a71:	89 c3                	mov    %eax,%ebx
  803a73:	85 c0                	test   %eax,%eax
  803a75:	79 14                	jns    803a8b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803a77:	89 34 24             	mov    %esi,(%esp)
  803a7a:	e8 58 02 00 00       	call   803cd7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803a7f:	89 d8                	mov    %ebx,%eax
  803a81:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803a84:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803a87:	89 ec                	mov    %ebp,%esp
  803a89:	5d                   	pop    %ebp
  803a8a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803a8b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a99:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803aa0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803aa3:	89 04 24             	mov    %eax,(%esp)
  803aa6:	e8 e9 dd ff ff       	call   801894 <_Z6fd2numP2Fd>
  803aab:	89 c3                	mov    %eax,%ebx
  803aad:	eb d0                	jmp    803a7f <_ZL12alloc_sockfdi+0x48>

00803aaf <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803aaf:	55                   	push   %ebp
  803ab0:	89 e5                	mov    %esp,%ebp
  803ab2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803ab5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803abc:	00 
  803abd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803ac0:	89 54 24 04          	mov    %edx,0x4(%esp)
  803ac4:	89 04 24             	mov    %eax,(%esp)
  803ac7:	e8 75 dd ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  803acc:	85 c0                	test   %eax,%eax
  803ace:	78 15                	js     803ae5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803ad3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ad8:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  803ade:	39 0a                	cmp    %ecx,(%edx)
  803ae0:	75 03                	jne    803ae5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803ae2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803ae5:	c9                   	leave  
  803ae6:	c3                   	ret    

00803ae7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ae7:	55                   	push   %ebp
  803ae8:	89 e5                	mov    %esp,%ebp
  803aea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803aed:	8b 45 08             	mov    0x8(%ebp),%eax
  803af0:	e8 ba ff ff ff       	call   803aaf <_ZL9fd2sockidi>
  803af5:	85 c0                	test   %eax,%eax
  803af7:	78 1f                	js     803b18 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803af9:	8b 55 10             	mov    0x10(%ebp),%edx
  803afc:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b03:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b07:	89 04 24             	mov    %eax,(%esp)
  803b0a:	e8 19 01 00 00       	call   803c28 <_Z12nsipc_acceptiP8sockaddrPj>
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	78 05                	js     803b18 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803b13:	e8 1f ff ff ff       	call   803a37 <_ZL12alloc_sockfdi>
}
  803b18:	c9                   	leave  
  803b19:	c3                   	ret    

00803b1a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b1a:	55                   	push   %ebp
  803b1b:	89 e5                	mov    %esp,%ebp
  803b1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b20:	8b 45 08             	mov    0x8(%ebp),%eax
  803b23:	e8 87 ff ff ff       	call   803aaf <_ZL9fd2sockidi>
  803b28:	85 c0                	test   %eax,%eax
  803b2a:	78 16                	js     803b42 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803b2c:	8b 55 10             	mov    0x10(%ebp),%edx
  803b2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b36:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b3a:	89 04 24             	mov    %eax,(%esp)
  803b3d:	e8 34 01 00 00       	call   803c76 <_Z10nsipc_bindiP8sockaddrj>
}
  803b42:	c9                   	leave  
  803b43:	c3                   	ret    

00803b44 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803b44:	55                   	push   %ebp
  803b45:	89 e5                	mov    %esp,%ebp
  803b47:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4d:	e8 5d ff ff ff       	call   803aaf <_ZL9fd2sockidi>
  803b52:	85 c0                	test   %eax,%eax
  803b54:	78 0f                	js     803b65 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b59:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b5d:	89 04 24             	mov    %eax,(%esp)
  803b60:	e8 50 01 00 00       	call   803cb5 <_Z14nsipc_shutdownii>
}
  803b65:	c9                   	leave  
  803b66:	c3                   	ret    

00803b67 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b67:	55                   	push   %ebp
  803b68:	89 e5                	mov    %esp,%ebp
  803b6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	e8 3a ff ff ff       	call   803aaf <_ZL9fd2sockidi>
  803b75:	85 c0                	test   %eax,%eax
  803b77:	78 16                	js     803b8f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803b79:	8b 55 10             	mov    0x10(%ebp),%edx
  803b7c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b83:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b87:	89 04 24             	mov    %eax,(%esp)
  803b8a:	e8 62 01 00 00       	call   803cf1 <_Z13nsipc_connectiPK8sockaddrj>
}
  803b8f:	c9                   	leave  
  803b90:	c3                   	ret    

00803b91 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803b91:	55                   	push   %ebp
  803b92:	89 e5                	mov    %esp,%ebp
  803b94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	e8 10 ff ff ff       	call   803aaf <_ZL9fd2sockidi>
  803b9f:	85 c0                	test   %eax,%eax
  803ba1:	78 0f                	js     803bb2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ba6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803baa:	89 04 24             	mov    %eax,(%esp)
  803bad:	e8 7e 01 00 00       	call   803d30 <_Z12nsipc_listenii>
}
  803bb2:	c9                   	leave  
  803bb3:	c3                   	ret    

00803bb4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803bb4:	55                   	push   %ebp
  803bb5:	89 e5                	mov    %esp,%ebp
  803bb7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803bba:	8b 45 10             	mov    0x10(%ebp),%eax
  803bbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcb:	89 04 24             	mov    %eax,(%esp)
  803bce:	e8 72 02 00 00       	call   803e45 <_Z12nsipc_socketiii>
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	78 05                	js     803bdc <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803bd7:	e8 5b fe ff ff       	call   803a37 <_ZL12alloc_sockfdi>
}
  803bdc:	c9                   	leave  
  803bdd:	8d 76 00             	lea    0x0(%esi),%esi
  803be0:	c3                   	ret    
  803be1:	00 00                	add    %al,(%eax)
	...

00803be4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803be4:	55                   	push   %ebp
  803be5:	89 e5                	mov    %esp,%ebp
  803be7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803bea:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803bf1:	00 
  803bf2:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803bf9:	00 
  803bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bfe:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803c05:	e8 a5 04 00 00       	call   8040af <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803c0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803c11:	00 
  803c12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803c19:	00 
  803c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c21:	e8 fa 03 00 00       	call   804020 <_Z8ipc_recvPiPvS_>
}
  803c26:	c9                   	leave  
  803c27:	c3                   	ret    

00803c28 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c28:	55                   	push   %ebp
  803c29:	89 e5                	mov    %esp,%ebp
  803c2b:	53                   	push   %ebx
  803c2c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c37:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3c:	e8 a3 ff ff ff       	call   803be4 <_ZL5nsipcj>
  803c41:	89 c3                	mov    %eax,%ebx
  803c43:	85 c0                	test   %eax,%eax
  803c45:	78 27                	js     803c6e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803c47:	a1 10 70 80 00       	mov    0x807010,%eax
  803c4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c50:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803c57:	00 
  803c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c5b:	89 04 24             	mov    %eax,(%esp)
  803c5e:	e8 89 d2 ff ff       	call   800eec <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803c63:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803c69:	8b 45 10             	mov    0x10(%ebp),%eax
  803c6c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803c6e:	89 d8                	mov    %ebx,%eax
  803c70:	83 c4 14             	add    $0x14,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5d                   	pop    %ebp
  803c75:	c3                   	ret    

00803c76 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c76:	55                   	push   %ebp
  803c77:	89 e5                	mov    %esp,%ebp
  803c79:	53                   	push   %ebx
  803c7a:	83 ec 14             	sub    $0x14,%esp
  803c7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c93:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803c9a:	e8 4d d2 ff ff       	call   800eec <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803c9f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803ca5:	b8 02 00 00 00       	mov    $0x2,%eax
  803caa:	e8 35 ff ff ff       	call   803be4 <_ZL5nsipcj>
}
  803caf:	83 c4 14             	add    $0x14,%esp
  803cb2:	5b                   	pop    %ebx
  803cb3:	5d                   	pop    %ebp
  803cb4:	c3                   	ret    

00803cb5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803cb5:	55                   	push   %ebp
  803cb6:	89 e5                	mov    %esp,%ebp
  803cb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803ccb:	b8 03 00 00 00       	mov    $0x3,%eax
  803cd0:	e8 0f ff ff ff       	call   803be4 <_ZL5nsipcj>
}
  803cd5:	c9                   	leave  
  803cd6:	c3                   	ret    

00803cd7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803cd7:	55                   	push   %ebp
  803cd8:	89 e5                	mov    %esp,%ebp
  803cda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803ce5:	b8 04 00 00 00       	mov    $0x4,%eax
  803cea:	e8 f5 fe ff ff       	call   803be4 <_ZL5nsipcj>
}
  803cef:	c9                   	leave  
  803cf0:	c3                   	ret    

00803cf1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803cf1:	55                   	push   %ebp
  803cf2:	89 e5                	mov    %esp,%ebp
  803cf4:	53                   	push   %ebx
  803cf5:	83 ec 14             	sub    $0x14,%esp
  803cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d0e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803d15:	e8 d2 d1 ff ff       	call   800eec <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803d1a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803d20:	b8 05 00 00 00       	mov    $0x5,%eax
  803d25:	e8 ba fe ff ff       	call   803be4 <_ZL5nsipcj>
}
  803d2a:	83 c4 14             	add    $0x14,%esp
  803d2d:	5b                   	pop    %ebx
  803d2e:	5d                   	pop    %ebp
  803d2f:	c3                   	ret    

00803d30 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803d30:	55                   	push   %ebp
  803d31:	89 e5                	mov    %esp,%ebp
  803d33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803d36:	8b 45 08             	mov    0x8(%ebp),%eax
  803d39:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d41:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803d46:	b8 06 00 00 00       	mov    $0x6,%eax
  803d4b:	e8 94 fe ff ff       	call   803be4 <_ZL5nsipcj>
}
  803d50:	c9                   	leave  
  803d51:	c3                   	ret    

00803d52 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d52:	55                   	push   %ebp
  803d53:	89 e5                	mov    %esp,%ebp
  803d55:	56                   	push   %esi
  803d56:	53                   	push   %ebx
  803d57:	83 ec 10             	sub    $0x10,%esp
  803d5a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d60:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803d65:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  803d6e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d73:	b8 07 00 00 00       	mov    $0x7,%eax
  803d78:	e8 67 fe ff ff       	call   803be4 <_ZL5nsipcj>
  803d7d:	89 c3                	mov    %eax,%ebx
  803d7f:	85 c0                	test   %eax,%eax
  803d81:	78 46                	js     803dc9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803d83:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803d88:	7f 04                	jg     803d8e <_Z10nsipc_recviPvij+0x3c>
  803d8a:	39 f0                	cmp    %esi,%eax
  803d8c:	7e 24                	jle    803db2 <_Z10nsipc_recviPvij+0x60>
  803d8e:	c7 44 24 0c 70 4f 80 	movl   $0x804f70,0xc(%esp)
  803d95:	00 
  803d96:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  803d9d:	00 
  803d9e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803da5:	00 
  803da6:	c7 04 24 85 4f 80 00 	movl   $0x804f85,(%esp)
  803dad:	e8 66 c8 ff ff       	call   800618 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803db2:	89 44 24 08          	mov    %eax,0x8(%esp)
  803db6:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803dbd:	00 
  803dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc1:	89 04 24             	mov    %eax,(%esp)
  803dc4:	e8 23 d1 ff ff       	call   800eec <memmove>
	}

	return r;
}
  803dc9:	89 d8                	mov    %ebx,%eax
  803dcb:	83 c4 10             	add    $0x10,%esp
  803dce:	5b                   	pop    %ebx
  803dcf:	5e                   	pop    %esi
  803dd0:	5d                   	pop    %ebp
  803dd1:	c3                   	ret    

00803dd2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803dd2:	55                   	push   %ebp
  803dd3:	89 e5                	mov    %esp,%ebp
  803dd5:	53                   	push   %ebx
  803dd6:	83 ec 14             	sub    $0x14,%esp
  803dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ddf:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803de4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803dea:	7e 24                	jle    803e10 <_Z10nsipc_sendiPKvij+0x3e>
  803dec:	c7 44 24 0c 91 4f 80 	movl   $0x804f91,0xc(%esp)
  803df3:	00 
  803df4:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  803dfb:	00 
  803dfc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803e03:	00 
  803e04:	c7 04 24 85 4f 80 00 	movl   $0x804f85,(%esp)
  803e0b:	e8 08 c8 ff ff       	call   800618 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e10:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e1b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803e22:	e8 c5 d0 ff ff       	call   800eec <memmove>
	nsipcbuf.send.req_size = size;
  803e27:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  803e30:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803e35:	b8 08 00 00 00       	mov    $0x8,%eax
  803e3a:	e8 a5 fd ff ff       	call   803be4 <_ZL5nsipcj>
}
  803e3f:	83 c4 14             	add    $0x14,%esp
  803e42:	5b                   	pop    %ebx
  803e43:	5d                   	pop    %ebp
  803e44:	c3                   	ret    

00803e45 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e45:	55                   	push   %ebp
  803e46:	89 e5                	mov    %esp,%ebp
  803e48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e56:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  803e5e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803e63:	b8 09 00 00 00       	mov    $0x9,%eax
  803e68:	e8 77 fd ff ff       	call   803be4 <_ZL5nsipcj>
}
  803e6d:	c9                   	leave  
  803e6e:	c3                   	ret    
	...

00803e70 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803e70:	55                   	push   %ebp
  803e71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803e73:	b8 00 00 00 00       	mov    $0x0,%eax
  803e78:	5d                   	pop    %ebp
  803e79:	c3                   	ret    

00803e7a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e7a:	55                   	push   %ebp
  803e7b:	89 e5                	mov    %esp,%ebp
  803e7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803e80:	c7 44 24 04 9d 4f 80 	movl   $0x804f9d,0x4(%esp)
  803e87:	00 
  803e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e8b:	89 04 24             	mov    %eax,(%esp)
  803e8e:	e8 b7 ce ff ff       	call   800d4a <_Z6strcpyPcPKc>
	return 0;
}
  803e93:	b8 00 00 00 00       	mov    $0x0,%eax
  803e98:	c9                   	leave  
  803e99:	c3                   	ret    

00803e9a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e9a:	55                   	push   %ebp
  803e9b:	89 e5                	mov    %esp,%ebp
  803e9d:	57                   	push   %edi
  803e9e:	56                   	push   %esi
  803e9f:	53                   	push   %ebx
  803ea0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  803eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803eaf:	74 3e                	je     803eef <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803eb1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803eb7:	8b 75 10             	mov    0x10(%ebp),%esi
  803eba:	29 de                	sub    %ebx,%esi
  803ebc:	83 fe 7f             	cmp    $0x7f,%esi
  803ebf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803ec4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803ec7:	89 74 24 08          	mov    %esi,0x8(%esp)
  803ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ece:	01 d8                	add    %ebx,%eax
  803ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed4:	89 3c 24             	mov    %edi,(%esp)
  803ed7:	e8 10 d0 ff ff       	call   800eec <memmove>
		sys_cputs(buf, m);
  803edc:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ee0:	89 3c 24             	mov    %edi,(%esp)
  803ee3:	e8 1c d2 ff ff       	call   801104 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ee8:	01 f3                	add    %esi,%ebx
  803eea:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803eed:	77 c8                	ja     803eb7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803eef:	89 d8                	mov    %ebx,%eax
  803ef1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803ef7:	5b                   	pop    %ebx
  803ef8:	5e                   	pop    %esi
  803ef9:	5f                   	pop    %edi
  803efa:	5d                   	pop    %ebp
  803efb:	c3                   	ret    

00803efc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803efc:	55                   	push   %ebp
  803efd:	89 e5                	mov    %esp,%ebp
  803eff:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803f02:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803f0b:	75 07                	jne    803f14 <_ZL12devcons_readP2FdPvj+0x18>
  803f0d:	eb 2a                	jmp    803f39 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803f0f:	e8 e8 d2 ff ff       	call   8011fc <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f14:	e8 1e d2 ff ff       	call   801137 <_Z9sys_cgetcv>
  803f19:	85 c0                	test   %eax,%eax
  803f1b:	74 f2                	je     803f0f <_ZL12devcons_readP2FdPvj+0x13>
  803f1d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803f1f:	85 c0                	test   %eax,%eax
  803f21:	78 16                	js     803f39 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803f23:	83 f8 04             	cmp    $0x4,%eax
  803f26:	74 0c                	je     803f34 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f2b:	88 10                	mov    %dl,(%eax)
	return 1;
  803f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803f32:	eb 05                	jmp    803f39 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803f34:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803f39:	c9                   	leave  
  803f3a:	c3                   	ret    

00803f3b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f3b:	55                   	push   %ebp
  803f3c:	89 e5                	mov    %esp,%ebp
  803f3e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803f41:	8b 45 08             	mov    0x8(%ebp),%eax
  803f44:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803f4e:	00 
  803f4f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803f52:	89 04 24             	mov    %eax,(%esp)
  803f55:	e8 aa d1 ff ff       	call   801104 <_Z9sys_cputsPKcj>
}
  803f5a:	c9                   	leave  
  803f5b:	c3                   	ret    

00803f5c <_Z7getcharv>:

int
getchar(void)
{
  803f5c:	55                   	push   %ebp
  803f5d:	89 e5                	mov    %esp,%ebp
  803f5f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f62:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803f69:	00 
  803f6a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f78:	e8 71 dc ff ff       	call   801bee <_Z4readiPvj>
	if (r < 0)
  803f7d:	85 c0                	test   %eax,%eax
  803f7f:	78 0f                	js     803f90 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803f81:	85 c0                	test   %eax,%eax
  803f83:	7e 06                	jle    803f8b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803f85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803f89:	eb 05                	jmp    803f90 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803f8b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803f90:	c9                   	leave  
  803f91:	c3                   	ret    

00803f92 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803f92:	55                   	push   %ebp
  803f93:	89 e5                	mov    %esp,%ebp
  803f95:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803f98:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803f9f:	00 
  803fa0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803faa:	89 04 24             	mov    %eax,(%esp)
  803fad:	e8 8f d8 ff ff       	call   801841 <_Z9fd_lookupiPP2Fdb>
  803fb2:	85 c0                	test   %eax,%eax
  803fb4:	78 11                	js     803fc7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb9:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803fbf:	39 10                	cmp    %edx,(%eax)
  803fc1:	0f 94 c0             	sete   %al
  803fc4:	0f b6 c0             	movzbl %al,%eax
}
  803fc7:	c9                   	leave  
  803fc8:	c3                   	ret    

00803fc9 <_Z8openconsv>:

int
opencons(void)
{
  803fc9:	55                   	push   %ebp
  803fca:	89 e5                	mov    %esp,%ebp
  803fcc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803fcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803fd2:	89 04 24             	mov    %eax,(%esp)
  803fd5:	e8 1d d9 ff ff       	call   8018f7 <_Z14fd_find_unusedPP2Fd>
  803fda:	85 c0                	test   %eax,%eax
  803fdc:	78 3c                	js     80401a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fde:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803fe5:	00 
  803fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ff4:	e8 37 d2 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  803ff9:	85 c0                	test   %eax,%eax
  803ffb:	78 1d                	js     80401a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803ffd:	8b 15 58 50 80 00    	mov    0x805058,%edx
  804003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804006:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804012:	89 04 24             	mov    %eax,(%esp)
  804015:	e8 7a d8 ff ff       	call   801894 <_Z6fd2numP2Fd>
}
  80401a:	c9                   	leave  
  80401b:	c3                   	ret    
  80401c:	00 00                	add    %al,(%eax)
	...

00804020 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804020:	55                   	push   %ebp
  804021:	89 e5                	mov    %esp,%ebp
  804023:	56                   	push   %esi
  804024:	53                   	push   %ebx
  804025:	83 ec 10             	sub    $0x10,%esp
  804028:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80402b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804031:	85 c0                	test   %eax,%eax
  804033:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804038:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80403b:	89 04 24             	mov    %eax,(%esp)
  80403e:	e8 b8 d4 ff ff       	call   8014fb <_Z12sys_ipc_recvPv>
  804043:	85 c0                	test   %eax,%eax
  804045:	79 16                	jns    80405d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804047:	85 db                	test   %ebx,%ebx
  804049:	74 06                	je     804051 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80404b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804051:	85 f6                	test   %esi,%esi
  804053:	74 53                	je     8040a8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804055:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80405b:	eb 4b                	jmp    8040a8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80405d:	85 db                	test   %ebx,%ebx
  80405f:	74 17                	je     804078 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804061:	e8 62 d1 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80406b:	6b c0 78             	imul   $0x78,%eax,%eax
  80406e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804073:	8b 40 60             	mov    0x60(%eax),%eax
  804076:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804078:	85 f6                	test   %esi,%esi
  80407a:	74 17                	je     804093 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80407c:	e8 47 d1 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804081:	25 ff 03 00 00       	and    $0x3ff,%eax
  804086:	6b c0 78             	imul   $0x78,%eax,%eax
  804089:	05 00 00 00 ef       	add    $0xef000000,%eax
  80408e:	8b 40 70             	mov    0x70(%eax),%eax
  804091:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804093:	e8 30 d1 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80409d:	6b c0 78             	imul   $0x78,%eax,%eax
  8040a0:	05 08 00 00 ef       	add    $0xef000008,%eax
  8040a5:	8b 40 60             	mov    0x60(%eax),%eax

}
  8040a8:	83 c4 10             	add    $0x10,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5d                   	pop    %ebp
  8040ae:	c3                   	ret    

008040af <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040af:	55                   	push   %ebp
  8040b0:	89 e5                	mov    %esp,%ebp
  8040b2:	57                   	push   %edi
  8040b3:	56                   	push   %esi
  8040b4:	53                   	push   %ebx
  8040b5:	83 ec 1c             	sub    $0x1c,%esp
  8040b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8040bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8040be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8040c1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8040c3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8040c8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8040cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8040ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8040da:	89 34 24             	mov    %esi,(%esp)
  8040dd:	e8 e1 d3 ff ff       	call   8014c3 <_Z16sys_ipc_try_sendijPvi>
  8040e2:	85 c0                	test   %eax,%eax
  8040e4:	79 31                	jns    804117 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8040e6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8040e9:	75 0c                	jne    8040f7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8040eb:	90                   	nop
  8040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8040f0:	e8 07 d1 ff ff       	call   8011fc <_Z9sys_yieldv>
  8040f5:	eb d4                	jmp    8040cb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8040f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040fb:	c7 44 24 08 a9 4f 80 	movl   $0x804fa9,0x8(%esp)
  804102:	00 
  804103:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80410a:	00 
  80410b:	c7 04 24 b6 4f 80 00 	movl   $0x804fb6,(%esp)
  804112:	e8 01 c5 ff ff       	call   800618 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804117:	83 c4 1c             	add    $0x1c,%esp
  80411a:	5b                   	pop    %ebx
  80411b:	5e                   	pop    %esi
  80411c:	5f                   	pop    %edi
  80411d:	5d                   	pop    %ebp
  80411e:	c3                   	ret    
	...

00804120 <__udivdi3>:
  804120:	55                   	push   %ebp
  804121:	89 e5                	mov    %esp,%ebp
  804123:	57                   	push   %edi
  804124:	56                   	push   %esi
  804125:	83 ec 20             	sub    $0x20,%esp
  804128:	8b 45 14             	mov    0x14(%ebp),%eax
  80412b:	8b 75 08             	mov    0x8(%ebp),%esi
  80412e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804131:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804134:	85 c0                	test   %eax,%eax
  804136:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804139:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80413c:	75 3a                	jne    804178 <__udivdi3+0x58>
  80413e:	39 f9                	cmp    %edi,%ecx
  804140:	77 66                	ja     8041a8 <__udivdi3+0x88>
  804142:	85 c9                	test   %ecx,%ecx
  804144:	75 0b                	jne    804151 <__udivdi3+0x31>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	31 d2                	xor    %edx,%edx
  80414d:	f7 f1                	div    %ecx
  80414f:	89 c1                	mov    %eax,%ecx
  804151:	89 f8                	mov    %edi,%eax
  804153:	31 d2                	xor    %edx,%edx
  804155:	f7 f1                	div    %ecx
  804157:	89 c7                	mov    %eax,%edi
  804159:	89 f0                	mov    %esi,%eax
  80415b:	f7 f1                	div    %ecx
  80415d:	89 fa                	mov    %edi,%edx
  80415f:	89 c6                	mov    %eax,%esi
  804161:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804164:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80416a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80416d:	83 c4 20             	add    $0x20,%esp
  804170:	5e                   	pop    %esi
  804171:	5f                   	pop    %edi
  804172:	5d                   	pop    %ebp
  804173:	c3                   	ret    
  804174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804178:	31 d2                	xor    %edx,%edx
  80417a:	31 f6                	xor    %esi,%esi
  80417c:	39 f8                	cmp    %edi,%eax
  80417e:	77 e1                	ja     804161 <__udivdi3+0x41>
  804180:	0f bd d0             	bsr    %eax,%edx
  804183:	83 f2 1f             	xor    $0x1f,%edx
  804186:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804189:	75 2d                	jne    8041b8 <__udivdi3+0x98>
  80418b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80418e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804191:	76 06                	jbe    804199 <__udivdi3+0x79>
  804193:	39 f8                	cmp    %edi,%eax
  804195:	89 f2                	mov    %esi,%edx
  804197:	73 c8                	jae    804161 <__udivdi3+0x41>
  804199:	31 d2                	xor    %edx,%edx
  80419b:	be 01 00 00 00       	mov    $0x1,%esi
  8041a0:	eb bf                	jmp    804161 <__udivdi3+0x41>
  8041a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8041a8:	89 f0                	mov    %esi,%eax
  8041aa:	89 fa                	mov    %edi,%edx
  8041ac:	f7 f1                	div    %ecx
  8041ae:	31 d2                	xor    %edx,%edx
  8041b0:	89 c6                	mov    %eax,%esi
  8041b2:	eb ad                	jmp    804161 <__udivdi3+0x41>
  8041b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041b8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041bc:	89 c2                	mov    %eax,%edx
  8041be:	b8 20 00 00 00       	mov    $0x20,%eax
  8041c3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8041c6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8041c9:	d3 e2                	shl    %cl,%edx
  8041cb:	89 c1                	mov    %eax,%ecx
  8041cd:	d3 ee                	shr    %cl,%esi
  8041cf:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041d3:	09 d6                	or     %edx,%esi
  8041d5:	89 fa                	mov    %edi,%edx
  8041d7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8041da:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8041dd:	d3 e6                	shl    %cl,%esi
  8041df:	89 c1                	mov    %eax,%ecx
  8041e1:	d3 ea                	shr    %cl,%edx
  8041e3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8041e7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8041ea:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8041ed:	d3 e7                	shl    %cl,%edi
  8041ef:	89 c1                	mov    %eax,%ecx
  8041f1:	d3 ee                	shr    %cl,%esi
  8041f3:	09 fe                	or     %edi,%esi
  8041f5:	89 f0                	mov    %esi,%eax
  8041f7:	f7 75 e4             	divl   -0x1c(%ebp)
  8041fa:	89 d7                	mov    %edx,%edi
  8041fc:	89 c6                	mov    %eax,%esi
  8041fe:	f7 65 f0             	mull   -0x10(%ebp)
  804201:	39 d7                	cmp    %edx,%edi
  804203:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804206:	72 12                	jb     80421a <__udivdi3+0xfa>
  804208:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80420b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80420f:	d3 e2                	shl    %cl,%edx
  804211:	39 c2                	cmp    %eax,%edx
  804213:	73 08                	jae    80421d <__udivdi3+0xfd>
  804215:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804218:	75 03                	jne    80421d <__udivdi3+0xfd>
  80421a:	83 ee 01             	sub    $0x1,%esi
  80421d:	31 d2                	xor    %edx,%edx
  80421f:	e9 3d ff ff ff       	jmp    804161 <__udivdi3+0x41>
	...

00804230 <__umoddi3>:
  804230:	55                   	push   %ebp
  804231:	89 e5                	mov    %esp,%ebp
  804233:	57                   	push   %edi
  804234:	56                   	push   %esi
  804235:	83 ec 20             	sub    $0x20,%esp
  804238:	8b 7d 14             	mov    0x14(%ebp),%edi
  80423b:	8b 45 08             	mov    0x8(%ebp),%eax
  80423e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804241:	8b 75 0c             	mov    0xc(%ebp),%esi
  804244:	85 ff                	test   %edi,%edi
  804246:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804249:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80424c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80424f:	89 f2                	mov    %esi,%edx
  804251:	75 15                	jne    804268 <__umoddi3+0x38>
  804253:	39 f1                	cmp    %esi,%ecx
  804255:	76 41                	jbe    804298 <__umoddi3+0x68>
  804257:	f7 f1                	div    %ecx
  804259:	89 d0                	mov    %edx,%eax
  80425b:	31 d2                	xor    %edx,%edx
  80425d:	83 c4 20             	add    $0x20,%esp
  804260:	5e                   	pop    %esi
  804261:	5f                   	pop    %edi
  804262:	5d                   	pop    %ebp
  804263:	c3                   	ret    
  804264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804268:	39 f7                	cmp    %esi,%edi
  80426a:	77 4c                	ja     8042b8 <__umoddi3+0x88>
  80426c:	0f bd c7             	bsr    %edi,%eax
  80426f:	83 f0 1f             	xor    $0x1f,%eax
  804272:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804275:	75 51                	jne    8042c8 <__umoddi3+0x98>
  804277:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80427a:	0f 87 e8 00 00 00    	ja     804368 <__umoddi3+0x138>
  804280:	89 f2                	mov    %esi,%edx
  804282:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804285:	29 ce                	sub    %ecx,%esi
  804287:	19 fa                	sbb    %edi,%edx
  804289:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80428c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80428f:	83 c4 20             	add    $0x20,%esp
  804292:	5e                   	pop    %esi
  804293:	5f                   	pop    %edi
  804294:	5d                   	pop    %ebp
  804295:	c3                   	ret    
  804296:	66 90                	xchg   %ax,%ax
  804298:	85 c9                	test   %ecx,%ecx
  80429a:	75 0b                	jne    8042a7 <__umoddi3+0x77>
  80429c:	b8 01 00 00 00       	mov    $0x1,%eax
  8042a1:	31 d2                	xor    %edx,%edx
  8042a3:	f7 f1                	div    %ecx
  8042a5:	89 c1                	mov    %eax,%ecx
  8042a7:	89 f0                	mov    %esi,%eax
  8042a9:	31 d2                	xor    %edx,%edx
  8042ab:	f7 f1                	div    %ecx
  8042ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b0:	eb a5                	jmp    804257 <__umoddi3+0x27>
  8042b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8042b8:	89 f2                	mov    %esi,%edx
  8042ba:	83 c4 20             	add    $0x20,%esp
  8042bd:	5e                   	pop    %esi
  8042be:	5f                   	pop    %edi
  8042bf:	5d                   	pop    %ebp
  8042c0:	c3                   	ret    
  8042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8042c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042cc:	89 f2                	mov    %esi,%edx
  8042ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042d1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8042d8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8042db:	d3 e7                	shl    %cl,%edi
  8042dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042e4:	d3 e8                	shr    %cl,%eax
  8042e6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042ea:	09 f8                	or     %edi,%eax
  8042ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f2:	d3 e0                	shl    %cl,%eax
  8042f4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8042f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042fe:	d3 ea                	shr    %cl,%edx
  804300:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804304:	d3 e6                	shl    %cl,%esi
  804306:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80430a:	d3 e8                	shr    %cl,%eax
  80430c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804310:	09 f0                	or     %esi,%eax
  804312:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804315:	f7 75 e4             	divl   -0x1c(%ebp)
  804318:	d3 e6                	shl    %cl,%esi
  80431a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80431d:	89 d6                	mov    %edx,%esi
  80431f:	f7 65 f4             	mull   -0xc(%ebp)
  804322:	89 d7                	mov    %edx,%edi
  804324:	89 c2                	mov    %eax,%edx
  804326:	39 fe                	cmp    %edi,%esi
  804328:	89 f9                	mov    %edi,%ecx
  80432a:	72 30                	jb     80435c <__umoddi3+0x12c>
  80432c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80432f:	72 27                	jb     804358 <__umoddi3+0x128>
  804331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804334:	29 d0                	sub    %edx,%eax
  804336:	19 ce                	sbb    %ecx,%esi
  804338:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80433c:	89 f2                	mov    %esi,%edx
  80433e:	d3 e8                	shr    %cl,%eax
  804340:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804344:	d3 e2                	shl    %cl,%edx
  804346:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80434a:	09 d0                	or     %edx,%eax
  80434c:	89 f2                	mov    %esi,%edx
  80434e:	d3 ea                	shr    %cl,%edx
  804350:	83 c4 20             	add    $0x20,%esp
  804353:	5e                   	pop    %esi
  804354:	5f                   	pop    %edi
  804355:	5d                   	pop    %ebp
  804356:	c3                   	ret    
  804357:	90                   	nop
  804358:	39 fe                	cmp    %edi,%esi
  80435a:	75 d5                	jne    804331 <__umoddi3+0x101>
  80435c:	89 f9                	mov    %edi,%ecx
  80435e:	89 c2                	mov    %eax,%edx
  804360:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804363:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804366:	eb c9                	jmp    804331 <__umoddi3+0x101>
  804368:	39 f7                	cmp    %esi,%edi
  80436a:	0f 82 10 ff ff ff    	jb     804280 <__umoddi3+0x50>
  804370:	e9 17 ff ff ff       	jmp    80428c <__umoddi3+0x5c>
