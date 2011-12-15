
obj/user/idle:     file format elf32-i386


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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003a:	c7 05 00 50 80 00 40 	movl   $0x803e40,0x805000
  800041:	3e 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800044:	e8 7f 01 00 00       	call   8001c8 <_Z9sys_yieldv>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800049:	cc                   	int3   
  80004a:	eb f8                	jmp    800044 <_Z5umainiPPc+0x10>

0080004c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	83 ec 1c             	sub    $0x1c,%esp
  800055:	8b 7d 08             	mov    0x8(%ebp),%edi
  800058:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80005b:	e8 34 01 00 00       	call   800194 <_Z12sys_getenvidv>
  800060:	25 ff 03 00 00       	and    $0x3ff,%eax
  800065:	6b c0 78             	imul   $0x78,%eax,%eax
  800068:	05 00 00 00 ef       	add    $0xef000000,%eax
  80006d:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800072:	85 ff                	test   %edi,%edi
  800074:	7e 07                	jle    80007d <libmain+0x31>
		binaryname = argv[0];
  800076:	8b 06                	mov    (%esi),%eax
  800078:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80007d:	b8 7d 49 80 00       	mov    $0x80497d,%eax
  800082:	3d 7d 49 80 00       	cmp    $0x80497d,%eax
  800087:	76 0f                	jbe    800098 <libmain+0x4c>
  800089:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80008b:	83 eb 04             	sub    $0x4,%ebx
  80008e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800090:	81 fb 7d 49 80 00    	cmp    $0x80497d,%ebx
  800096:	77 f3                	ja     80008b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800098:	89 74 24 04          	mov    %esi,0x4(%esp)
  80009c:	89 3c 24             	mov    %edi,(%esp)
  80009f:	e8 90 ff ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  8000a4:	e8 0b 00 00 00       	call   8000b4 <_Z4exitv>
}
  8000a9:	83 c4 1c             	add    $0x1c,%esp
  8000ac:	5b                   	pop    %ebx
  8000ad:	5e                   	pop    %esi
  8000ae:	5f                   	pop    %edi
  8000af:	5d                   	pop    %ebp
  8000b0:	c3                   	ret    
  8000b1:	00 00                	add    %al,(%eax)
	...

008000b4 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ba:	e8 2f 08 00 00       	call   8008ee <_Z9close_allv>
	sys_env_destroy(0);
  8000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c6:	e8 6c 00 00 00       	call   800137 <_Z15sys_env_destroyi>
}
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    
  8000cd:	00 00                	add    %al,(%eax)
	...

008000d0 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	89 1c 24             	mov    %ebx,(%esp)
  8000d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8000e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ec:	89 c3                	mov    %eax,%ebx
  8000ee:	89 c7                	mov    %eax,%edi
  8000f0:	89 c6                	mov    %eax,%esi
  8000f2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f4:	8b 1c 24             	mov    (%esp),%ebx
  8000f7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000fb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000ff:	89 ec                	mov    %ebp,%esp
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    

00800103 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	89 1c 24             	mov    %ebx,(%esp)
  80010c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800110:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
  800119:	b8 01 00 00 00       	mov    $0x1,%eax
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	89 d3                	mov    %edx,%ebx
  800122:	89 d7                	mov    %edx,%edi
  800124:	89 d6                	mov    %edx,%esi
  800126:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800128:	8b 1c 24             	mov    (%esp),%ebx
  80012b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80012f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800133:	89 ec                	mov    %ebp,%esp
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	83 ec 38             	sub    $0x38,%esp
  80013d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800140:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800143:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800146:	b9 00 00 00 00       	mov    $0x0,%ecx
  80014b:	b8 03 00 00 00       	mov    $0x3,%eax
  800150:	8b 55 08             	mov    0x8(%ebp),%edx
  800153:	89 cb                	mov    %ecx,%ebx
  800155:	89 cf                	mov    %ecx,%edi
  800157:	89 ce                	mov    %ecx,%esi
  800159:	cd 30                	int    $0x30

	if(check && ret > 0)
  80015b:	85 c0                	test   %eax,%eax
  80015d:	7e 28                	jle    800187 <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800163:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80016a:	00 
  80016b:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  800172:	00 
  800173:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80017a:	00 
  80017b:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  800182:	e8 05 2d 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800187:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80018a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80018d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800190:	89 ec                	mov    %ebp,%esp
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    

00800194 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	89 1c 24             	mov    %ebx,(%esp)
  80019d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8001a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8001af:	89 d1                	mov    %edx,%ecx
  8001b1:	89 d3                	mov    %edx,%ebx
  8001b3:	89 d7                	mov    %edx,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001b9:	8b 1c 24             	mov    (%esp),%ebx
  8001bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001c0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001c4:	89 ec                	mov    %ebp,%esp
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    

008001c8 <_Z9sys_yieldv>:

void
sys_yield(void)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8001d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8001de:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e3:	89 d1                	mov    %edx,%ecx
  8001e5:	89 d3                	mov    %edx,%ebx
  8001e7:	89 d7                	mov    %edx,%edi
  8001e9:	89 d6                	mov    %edx,%esi
  8001eb:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001ed:	8b 1c 24             	mov    (%esp),%ebx
  8001f0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001f8:	89 ec                	mov    %ebp,%esp
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    

008001fc <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 38             	sub    $0x38,%esp
  800202:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800205:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800208:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80020b:	be 00 00 00 00       	mov    $0x0,%esi
  800210:	b8 08 00 00 00       	mov    $0x8,%eax
  800215:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021b:	8b 55 08             	mov    0x8(%ebp),%edx
  80021e:	89 f7                	mov    %esi,%edi
  800220:	cd 30                	int    $0x30

	if(check && ret > 0)
  800222:	85 c0                	test   %eax,%eax
  800224:	7e 28                	jle    80024e <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800226:	89 44 24 10          	mov    %eax,0x10(%esp)
  80022a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800231:	00 
  800232:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  800239:	00 
  80023a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800241:	00 
  800242:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  800249:	e8 3e 2c 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80024e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800251:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800254:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800257:	89 ec                	mov    %ebp,%esp
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    

0080025b <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 38             	sub    $0x38,%esp
  800261:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800264:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800267:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80026a:	b8 09 00 00 00       	mov    $0x9,%eax
  80026f:	8b 75 18             	mov    0x18(%ebp),%esi
  800272:	8b 7d 14             	mov    0x14(%ebp),%edi
  800275:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	8b 55 08             	mov    0x8(%ebp),%edx
  80027e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800280:	85 c0                	test   %eax,%eax
  800282:	7e 28                	jle    8002ac <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800284:	89 44 24 10          	mov    %eax,0x10(%esp)
  800288:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80028f:	00 
  800290:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  800297:	00 
  800298:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80029f:	00 
  8002a0:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  8002a7:	e8 e0 2b 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8002ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002b5:	89 ec                	mov    %ebp,%esp
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 38             	sub    $0x38,%esp
  8002bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8002c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d8:	89 df                	mov    %ebx,%edi
  8002da:	89 de                	mov    %ebx,%esi
  8002dc:	cd 30                	int    $0x30

	if(check && ret > 0)
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	7e 28                	jle    80030a <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002e6:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002ed:	00 
  8002ee:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  8002f5:	00 
  8002f6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002fd:	00 
  8002fe:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  800305:	e8 82 2b 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80030a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80030d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800310:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800313:	89 ec                	mov    %ebp,%esp
  800315:	5d                   	pop    %ebp
  800316:	c3                   	ret    

00800317 <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 38             	sub    $0x38,%esp
  80031d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800320:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800323:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800326:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032b:	b8 05 00 00 00       	mov    $0x5,%eax
  800330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800333:	8b 55 08             	mov    0x8(%ebp),%edx
  800336:	89 df                	mov    %ebx,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80033c:	85 c0                	test   %eax,%eax
  80033e:	7e 28                	jle    800368 <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800340:	89 44 24 10          	mov    %eax,0x10(%esp)
  800344:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80034b:	00 
  80034c:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  800353:	00 
  800354:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80035b:	00 
  80035c:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  800363:	e8 24 2b 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800368:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80036b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80036e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800371:	89 ec                	mov    %ebp,%esp
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 38             	sub    $0x38,%esp
  80037b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80037e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800381:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800384:	bb 00 00 00 00       	mov    $0x0,%ebx
  800389:	b8 06 00 00 00       	mov    $0x6,%eax
  80038e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800391:	8b 55 08             	mov    0x8(%ebp),%edx
  800394:	89 df                	mov    %ebx,%edi
  800396:	89 de                	mov    %ebx,%esi
  800398:	cd 30                	int    $0x30

	if(check && ret > 0)
  80039a:	85 c0                	test   %eax,%eax
  80039c:	7e 28                	jle    8003c6 <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80039e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003a9:	00 
  8003aa:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  8003b1:	00 
  8003b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003b9:	00 
  8003ba:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  8003c1:	e8 c6 2a 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8003c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003cf:	89 ec                	mov    %ebp,%esp
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    

008003d3 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 38             	sub    $0x38,%esp
  8003d9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003df:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8003e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8003ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f2:	89 df                	mov    %ebx,%edi
  8003f4:	89 de                	mov    %ebx,%esi
  8003f6:	cd 30                	int    $0x30

	if(check && ret > 0)
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	7e 28                	jle    800424 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800400:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800407:	00 
  800408:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  80040f:	00 
  800410:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800417:	00 
  800418:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  80041f:	e8 68 2a 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800424:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800427:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80042a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80042d:	89 ec                	mov    %ebp,%esp
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    

00800431 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 38             	sub    $0x38,%esp
  800437:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80043a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80043d:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800440:	bb 00 00 00 00       	mov    $0x0,%ebx
  800445:	b8 0c 00 00 00       	mov    $0xc,%eax
  80044a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044d:	8b 55 08             	mov    0x8(%ebp),%edx
  800450:	89 df                	mov    %ebx,%edi
  800452:	89 de                	mov    %ebx,%esi
  800454:	cd 30                	int    $0x30

	if(check && ret > 0)
  800456:	85 c0                	test   %eax,%eax
  800458:	7e 28                	jle    800482 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80045a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80045e:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800465:	00 
  800466:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  80046d:	00 
  80046e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800475:	00 
  800476:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  80047d:	e8 0a 2a 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800482:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800485:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800488:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80048b:	89 ec                	mov    %ebp,%esp
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 0c             	sub    $0xc,%esp
  800495:	89 1c 24             	mov    %ebx,(%esp)
  800498:	89 74 24 04          	mov    %esi,0x4(%esp)
  80049c:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8004a0:	be 00 00 00 00       	mov    $0x0,%esi
  8004a5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8004aa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8004ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8004b8:	8b 1c 24             	mov    (%esp),%ebx
  8004bb:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004bf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8004c3:	89 ec                	mov    %ebp,%esp
  8004c5:	5d                   	pop    %ebp
  8004c6:	c3                   	ret    

008004c7 <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	83 ec 38             	sub    $0x38,%esp
  8004cd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8004d0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8004d3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8004d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004db:	b8 0e 00 00 00       	mov    $0xe,%eax
  8004e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e3:	89 cb                	mov    %ecx,%ebx
  8004e5:	89 cf                	mov    %ecx,%edi
  8004e7:	89 ce                	mov    %ecx,%esi
  8004e9:	cd 30                	int    $0x30

	if(check && ret > 0)
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	7e 28                	jle    800517 <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004f3:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8004fa:	00 
  8004fb:	c7 44 24 08 4f 3e 80 	movl   $0x803e4f,0x8(%esp)
  800502:	00 
  800503:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80050a:	00 
  80050b:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  800512:	e8 75 29 00 00       	call   802e8c <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800517:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80051a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80051d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800520:	89 ec                	mov    %ebp,%esp
  800522:	5d                   	pop    %ebp
  800523:	c3                   	ret    

00800524 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	89 1c 24             	mov    %ebx,(%esp)
  80052d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800531:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80053f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800542:	8b 55 08             	mov    0x8(%ebp),%edx
  800545:	89 df                	mov    %ebx,%edi
  800547:	89 de                	mov    %ebx,%esi
  800549:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80054b:	8b 1c 24             	mov    (%esp),%ebx
  80054e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800552:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800556:	89 ec                	mov    %ebp,%esp
  800558:	5d                   	pop    %ebp
  800559:	c3                   	ret    

0080055a <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 0c             	sub    $0xc,%esp
  800560:	89 1c 24             	mov    %ebx,(%esp)
  800563:	89 74 24 04          	mov    %esi,0x4(%esp)
  800567:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80056b:	ba 00 00 00 00       	mov    $0x0,%edx
  800570:	b8 11 00 00 00       	mov    $0x11,%eax
  800575:	89 d1                	mov    %edx,%ecx
  800577:	89 d3                	mov    %edx,%ebx
  800579:	89 d7                	mov    %edx,%edi
  80057b:	89 d6                	mov    %edx,%esi
  80057d:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80057f:	8b 1c 24             	mov    (%esp),%ebx
  800582:	8b 74 24 04          	mov    0x4(%esp),%esi
  800586:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80058a:	89 ec                	mov    %ebp,%esp
  80058c:	5d                   	pop    %ebp
  80058d:	c3                   	ret    

0080058e <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	89 1c 24             	mov    %ebx,(%esp)
  800597:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80059f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005a4:	b8 12 00 00 00       	mov    $0x12,%eax
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8005af:	89 df                	mov    %ebx,%edi
  8005b1:	89 de                	mov    %ebx,%esi
  8005b3:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8005b5:	8b 1c 24             	mov    (%esp),%ebx
  8005b8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005bc:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005c0:	89 ec                	mov    %ebp,%esp
  8005c2:	5d                   	pop    %ebp
  8005c3:	c3                   	ret    

008005c4 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	89 1c 24             	mov    %ebx,(%esp)
  8005cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8005d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005da:	b8 13 00 00 00       	mov    $0x13,%eax
  8005df:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e2:	89 cb                	mov    %ecx,%ebx
  8005e4:	89 cf                	mov    %ecx,%edi
  8005e6:	89 ce                	mov    %ecx,%esi
  8005e8:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8005ea:	8b 1c 24             	mov    (%esp),%ebx
  8005ed:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005f1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005f5:	89 ec                	mov    %ebp,%esp
  8005f7:	5d                   	pop    %ebp
  8005f8:	c3                   	ret    

008005f9 <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	83 ec 0c             	sub    $0xc,%esp
  8005ff:	89 1c 24             	mov    %ebx,(%esp)
  800602:	89 74 24 04          	mov    %esi,0x4(%esp)
  800606:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80060a:	b8 10 00 00 00       	mov    $0x10,%eax
  80060f:	8b 75 18             	mov    0x18(%ebp),%esi
  800612:	8b 7d 14             	mov    0x14(%ebp),%edi
  800615:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800618:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80061b:	8b 55 08             	mov    0x8(%ebp),%edx
  80061e:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  800620:	8b 1c 24             	mov    (%esp),%ebx
  800623:	8b 74 24 04          	mov    0x4(%esp),%esi
  800627:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80062b:	89 ec                	mov    %ebp,%esp
  80062d:	5d                   	pop    %ebp
  80062e:	c3                   	ret    
	...

00800630 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  800633:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800638:	75 11                	jne    80064b <_ZL8fd_validPK2Fd+0x1b>
  80063a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80063f:	76 0a                	jbe    80064b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  800641:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  800646:	0f 96 c0             	setbe  %al
  800649:	eb 05                	jmp    800650 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80064b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800650:	5d                   	pop    %ebp
  800651:	c3                   	ret    

00800652 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	53                   	push   %ebx
  800656:	83 ec 14             	sub    $0x14,%esp
  800659:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80065b:	e8 d0 ff ff ff       	call   800630 <_ZL8fd_validPK2Fd>
  800660:	84 c0                	test   %al,%al
  800662:	75 24                	jne    800688 <_ZL9fd_isopenPK2Fd+0x36>
  800664:	c7 44 24 0c 7a 3e 80 	movl   $0x803e7a,0xc(%esp)
  80066b:	00 
  80066c:	c7 44 24 08 87 3e 80 	movl   $0x803e87,0x8(%esp)
  800673:	00 
  800674:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80067b:	00 
  80067c:	c7 04 24 9c 3e 80 00 	movl   $0x803e9c,(%esp)
  800683:	e8 04 28 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  800688:	89 d8                	mov    %ebx,%eax
  80068a:	c1 e8 16             	shr    $0x16,%eax
  80068d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	f6 c2 01             	test   $0x1,%dl
  80069c:	74 0d                	je     8006ab <_ZL9fd_isopenPK2Fd+0x59>
  80069e:	c1 eb 0c             	shr    $0xc,%ebx
  8006a1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8006a8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8006ab:	83 c4 14             	add    $0x14,%esp
  8006ae:	5b                   	pop    %ebx
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	89 1c 24             	mov    %ebx,(%esp)
  8006ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8006c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006c4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8006c8:	83 fb 1f             	cmp    $0x1f,%ebx
  8006cb:	77 18                	ja     8006e5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8006cd:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8006d3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8006d6:	84 c0                	test   %al,%al
  8006d8:	74 21                	je     8006fb <_Z9fd_lookupiPP2Fdb+0x4a>
  8006da:	89 d8                	mov    %ebx,%eax
  8006dc:	e8 71 ff ff ff       	call   800652 <_ZL9fd_isopenPK2Fd>
  8006e1:	84 c0                	test   %al,%al
  8006e3:	75 16                	jne    8006fb <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8006e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8006eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8006f0:	8b 1c 24             	mov    (%esp),%ebx
  8006f3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006f7:	89 ec                	mov    %ebp,%esp
  8006f9:	5d                   	pop    %ebp
  8006fa:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8006fb:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8006fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800702:	eb ec                	jmp    8006f0 <_Z9fd_lookupiPP2Fdb+0x3f>

00800704 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	53                   	push   %ebx
  800708:	83 ec 14             	sub    $0x14,%esp
  80070b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80070e:	89 d8                	mov    %ebx,%eax
  800710:	e8 1b ff ff ff       	call   800630 <_ZL8fd_validPK2Fd>
  800715:	84 c0                	test   %al,%al
  800717:	75 24                	jne    80073d <_Z6fd2numP2Fd+0x39>
  800719:	c7 44 24 0c 7a 3e 80 	movl   $0x803e7a,0xc(%esp)
  800720:	00 
  800721:	c7 44 24 08 87 3e 80 	movl   $0x803e87,0x8(%esp)
  800728:	00 
  800729:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  800730:	00 
  800731:	c7 04 24 9c 3e 80 00 	movl   $0x803e9c,(%esp)
  800738:	e8 4f 27 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80073d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  800743:	c1 e8 0c             	shr    $0xc,%eax
}
  800746:	83 c4 14             	add    $0x14,%esp
  800749:	5b                   	pop    %ebx
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	e8 a7 ff ff ff       	call   800704 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80075d:	05 20 00 0d 00       	add    $0xd0020,%eax
  800762:	c1 e0 0c             	shl    $0xc,%eax
}
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	57                   	push   %edi
  80076b:	56                   	push   %esi
  80076c:	53                   	push   %ebx
  80076d:	83 ec 2c             	sub    $0x2c,%esp
  800770:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  800773:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  800778:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80077b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800782:	00 
  800783:	89 74 24 04          	mov    %esi,0x4(%esp)
  800787:	89 1c 24             	mov    %ebx,(%esp)
  80078a:	e8 22 ff ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80078f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800792:	e8 bb fe ff ff       	call   800652 <_ZL9fd_isopenPK2Fd>
  800797:	84 c0                	test   %al,%al
  800799:	75 0c                	jne    8007a7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80079b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079e:	89 07                	mov    %eax,(%edi)
			return 0;
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	eb 13                	jmp    8007ba <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8007a7:	83 c3 01             	add    $0x1,%ebx
  8007aa:	83 fb 20             	cmp    $0x20,%ebx
  8007ad:	75 cc                	jne    80077b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007af:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8007b5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8007ba:	83 c4 2c             	add    $0x2c,%esp
  8007bd:	5b                   	pop    %ebx
  8007be:	5e                   	pop    %esi
  8007bf:	5f                   	pop    %edi
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 14             	sub    $0x14,%esp
  8007c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8007d4:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  8007da:	75 16                	jne    8007f2 <_Z10dev_lookupiPP3Dev+0x30>
  8007dc:	eb 06                	jmp    8007e4 <_Z10dev_lookupiPP3Dev+0x22>
  8007de:	39 0a                	cmp    %ecx,(%edx)
  8007e0:	75 10                	jne    8007f2 <_Z10dev_lookupiPP3Dev+0x30>
  8007e2:	eb 05                	jmp    8007e9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007e4:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8007e9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	eb 35                	jmp    800827 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007f2:	83 c0 01             	add    $0x1,%eax
  8007f5:	8b 14 85 08 3f 80 00 	mov    0x803f08(,%eax,4),%edx
  8007fc:	85 d2                	test   %edx,%edx
  8007fe:	75 de                	jne    8007de <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800800:	a1 00 60 80 00       	mov    0x806000,%eax
  800805:	8b 40 04             	mov    0x4(%eax),%eax
  800808:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80080c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800810:	c7 04 24 c4 3e 80 00 	movl   $0x803ec4,(%esp)
  800817:	e8 8e 27 00 00       	call   802faa <_Z7cprintfPKcz>
	*dev = 0;
  80081c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800822:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800827:	83 c4 14             	add    $0x14,%esp
  80082a:	5b                   	pop    %ebx
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	56                   	push   %esi
  800831:	53                   	push   %ebx
  800832:	83 ec 20             	sub    $0x20,%esp
  800835:	8b 75 08             	mov    0x8(%ebp),%esi
  800838:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80083c:	89 34 24             	mov    %esi,(%esp)
  80083f:	e8 c0 fe ff ff       	call   800704 <_Z6fd2numP2Fd>
  800844:	0f b6 d3             	movzbl %bl,%edx
  800847:	89 54 24 08          	mov    %edx,0x8(%esp)
  80084b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80084e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800852:	89 04 24             	mov    %eax,(%esp)
  800855:	e8 57 fe ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  80085a:	85 c0                	test   %eax,%eax
  80085c:	78 05                	js     800863 <_Z8fd_closeP2Fdb+0x36>
  80085e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800861:	74 0c                	je     80086f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  800863:	80 fb 01             	cmp    $0x1,%bl
  800866:	19 db                	sbb    %ebx,%ebx
  800868:	f7 d3                	not    %ebx
  80086a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80086d:	eb 3d                	jmp    8008ac <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80086f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800872:	89 44 24 04          	mov    %eax,0x4(%esp)
  800876:	8b 06                	mov    (%esi),%eax
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	e8 42 ff ff ff       	call   8007c2 <_Z10dev_lookupiPP3Dev>
  800880:	89 c3                	mov    %eax,%ebx
  800882:	85 c0                	test   %eax,%eax
  800884:	78 16                	js     80089c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  800886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800889:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80088c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800891:	85 c0                	test   %eax,%eax
  800893:	74 07                	je     80089c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  800895:	89 34 24             	mov    %esi,(%esp)
  800898:	ff d0                	call   *%eax
  80089a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80089c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008a7:	e8 0d fa ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
	return r;
}
  8008ac:	89 d8                	mov    %ebx,%eax
  8008ae:	83 c4 20             	add    $0x20,%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8008bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8008c2:	00 
  8008c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 04 24             	mov    %eax,(%esp)
  8008d0:	e8 dc fd ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  8008d5:	85 c0                	test   %eax,%eax
  8008d7:	78 13                	js     8008ec <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  8008d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8008e0:	00 
  8008e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e4:	89 04 24             	mov    %eax,(%esp)
  8008e7:	e8 41 ff ff ff       	call   80082d <_Z8fd_closeP2Fdb>
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <_Z9close_allv>:

void
close_all(void)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	53                   	push   %ebx
  8008f2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  8008f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8008fa:	89 1c 24             	mov    %ebx,(%esp)
  8008fd:	e8 b3 ff ff ff       	call   8008b5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  800902:	83 c3 01             	add    $0x1,%ebx
  800905:	83 fb 20             	cmp    $0x20,%ebx
  800908:	75 f0                	jne    8008fa <_Z9close_allv+0xc>
		close(i);
}
  80090a:	83 c4 14             	add    $0x14,%esp
  80090d:	5b                   	pop    %ebx
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 48             	sub    $0x48,%esp
  800916:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800919:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80091c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80091f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  800922:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800929:	00 
  80092a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80092d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	89 04 24             	mov    %eax,(%esp)
  800937:	e8 75 fd ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  80093c:	89 c3                	mov    %eax,%ebx
  80093e:	85 c0                	test   %eax,%eax
  800940:	0f 88 ce 00 00 00    	js     800a14 <_Z3dupii+0x104>
  800946:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80094d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80094e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  800955:	89 34 24             	mov    %esi,(%esp)
  800958:	e8 54 fd ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  80095d:	89 c3                	mov    %eax,%ebx
  80095f:	85 c0                	test   %eax,%eax
  800961:	0f 89 bc 00 00 00    	jns    800a23 <_Z3dupii+0x113>
  800967:	e9 a8 00 00 00       	jmp    800a14 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80096c:	89 d8                	mov    %ebx,%eax
  80096e:	c1 e8 0c             	shr    $0xc,%eax
  800971:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  800978:	f6 c2 01             	test   $0x1,%dl
  80097b:	74 32                	je     8009af <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80097d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  800984:	25 07 0e 00 00       	and    $0xe07,%eax
  800989:	89 44 24 10          	mov    %eax,0x10(%esp)
  80098d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800991:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800998:	00 
  800999:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80099d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009a4:	e8 b2 f8 ff ff       	call   80025b <_Z12sys_page_mapiPviS_i>
  8009a9:	89 c3                	mov    %eax,%ebx
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	78 3e                	js     8009ed <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	c1 ea 0c             	shr    $0xc,%edx
  8009b7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  8009be:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8009c4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8009d6:	00 
  8009d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009e2:	e8 74 f8 ff ff       	call   80025b <_Z12sys_page_mapiPviS_i>
  8009e7:	89 c3                	mov    %eax,%ebx
  8009e9:	85 c0                	test   %eax,%eax
  8009eb:	79 25                	jns    800a12 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8009ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009fb:	e8 b9 f8 ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  800a00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a0b:	e8 a9 f8 ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
	return r;
  800a10:	eb 02                	jmp    800a14 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  800a12:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a14:	89 d8                	mov    %ebx,%eax
  800a16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a19:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a1f:	89 ec                	mov    %ebp,%esp
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  800a23:	89 34 24             	mov    %esi,(%esp)
  800a26:	e8 8a fe ff ff       	call   8008b5 <_Z5closei>

	ova = fd2data(oldfd);
  800a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a2e:	89 04 24             	mov    %eax,(%esp)
  800a31:	e8 16 fd ff ff       	call   80074c <_Z7fd2dataP2Fd>
  800a36:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3b:	89 04 24             	mov    %eax,(%esp)
  800a3e:	e8 09 fd ff ff       	call   80074c <_Z7fd2dataP2Fd>
  800a43:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  800a45:	89 d8                	mov    %ebx,%eax
  800a47:	c1 e8 16             	shr    $0x16,%eax
  800a4a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  800a51:	a8 01                	test   $0x1,%al
  800a53:	0f 85 13 ff ff ff    	jne    80096c <_Z3dupii+0x5c>
  800a59:	e9 51 ff ff ff       	jmp    8009af <_Z3dupii+0x9f>

00800a5e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	53                   	push   %ebx
  800a62:	83 ec 24             	sub    $0x24,%esp
  800a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800a68:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a6f:	00 
  800a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a77:	89 1c 24             	mov    %ebx,(%esp)
  800a7a:	e8 32 fc ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	78 5f                	js     800ae2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800a8d:	8b 00                	mov    (%eax),%eax
  800a8f:	89 04 24             	mov    %eax,(%esp)
  800a92:	e8 2b fd ff ff       	call   8007c2 <_Z10dev_lookupiPP3Dev>
  800a97:	85 c0                	test   %eax,%eax
  800a99:	79 4d                	jns    800ae8 <_Z4readiPvj+0x8a>
  800a9b:	eb 45                	jmp    800ae2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a9d:	a1 00 60 80 00       	mov    0x806000,%eax
  800aa2:	8b 40 04             	mov    0x4(%eax),%eax
  800aa5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aad:	c7 04 24 a5 3e 80 00 	movl   $0x803ea5,(%esp)
  800ab4:	e8 f1 24 00 00       	call   802faa <_Z7cprintfPKcz>
		return -E_INVAL;
  800ab9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800abe:	eb 22                	jmp    800ae2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  800ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  800ac6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800acb:	85 d2                	test   %edx,%edx
  800acd:	74 13                	je     800ae2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800add:	89 0c 24             	mov    %ecx,(%esp)
  800ae0:	ff d2                	call   *%edx
}
  800ae2:	83 c4 24             	add    $0x24,%esp
  800ae5:	5b                   	pop    %ebx
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ae8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800aeb:	8b 41 08             	mov    0x8(%ecx),%eax
  800aee:	83 e0 03             	and    $0x3,%eax
  800af1:	83 f8 01             	cmp    $0x1,%eax
  800af4:	75 ca                	jne    800ac0 <_Z4readiPvj+0x62>
  800af6:	eb a5                	jmp    800a9d <_Z4readiPvj+0x3f>

00800af8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
  800afe:	83 ec 1c             	sub    $0x1c,%esp
  800b01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b04:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  800b07:	85 f6                	test   %esi,%esi
  800b09:	74 2f                	je     800b3a <_Z5readniPvj+0x42>
  800b0b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b10:	89 f0                	mov    %esi,%eax
  800b12:	29 d8                	sub    %ebx,%eax
  800b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b18:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	e8 34 ff ff ff       	call   800a5e <_Z4readiPvj>
		if (m < 0)
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	78 13                	js     800b41 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  800b2e:	85 c0                	test   %eax,%eax
  800b30:	74 0d                	je     800b3f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  800b32:	01 c3                	add    %eax,%ebx
  800b34:	39 de                	cmp    %ebx,%esi
  800b36:	77 d8                	ja     800b10 <_Z5readniPvj+0x18>
  800b38:	eb 05                	jmp    800b3f <_Z5readniPvj+0x47>
  800b3a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800b3f:	89 d8                	mov    %ebx,%eax
}
  800b41:	83 c4 1c             	add    $0x1c,%esp
  800b44:	5b                   	pop    %ebx
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800b4f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800b56:	00 
  800b57:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 04 24             	mov    %eax,(%esp)
  800b64:	e8 48 fb ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  800b69:	85 c0                	test   %eax,%eax
  800b6b:	78 3c                	js     800ba9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	89 04 24             	mov    %eax,(%esp)
  800b7c:	e8 41 fc ff ff       	call   8007c2 <_Z10dev_lookupiPP3Dev>
  800b81:	85 c0                	test   %eax,%eax
  800b83:	79 26                	jns    800bab <_Z5writeiPKvj+0x62>
  800b85:	eb 22                	jmp    800ba9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b8a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  800b8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  800b92:	85 c9                	test   %ecx,%ecx
  800b94:	74 13                	je     800ba9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b96:	8b 45 10             	mov    0x10(%ebp),%eax
  800b99:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba4:	89 14 24             	mov    %edx,(%esp)
  800ba7:	ff d1                	call   *%ecx
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  800bab:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  800bae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  800bb3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800bb7:	74 f0                	je     800ba9 <_Z5writeiPKvj+0x60>
  800bb9:	eb cc                	jmp    800b87 <_Z5writeiPKvj+0x3e>

00800bbb <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  800bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800bc8:	00 
  800bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 04 24             	mov    %eax,(%esp)
  800bd6:	e8 d6 fa ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	78 0e                	js     800bed <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  800bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	53                   	push   %ebx
  800bf3:	83 ec 24             	sub    $0x24,%esp
  800bf6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800bf9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800c00:	00 
  800c01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c08:	89 1c 24             	mov    %ebx,(%esp)
  800c0b:	e8 a1 fa ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  800c10:	85 c0                	test   %eax,%eax
  800c12:	78 58                	js     800c6c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	89 04 24             	mov    %eax,(%esp)
  800c23:	e8 9a fb ff ff       	call   8007c2 <_Z10dev_lookupiPP3Dev>
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	79 46                	jns    800c72 <_Z9ftruncateii+0x83>
  800c2c:	eb 3e                	jmp    800c6c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  800c2e:	a1 00 60 80 00       	mov    0x806000,%eax
  800c33:	8b 40 04             	mov    0x4(%eax),%eax
  800c36:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3e:	c7 04 24 e4 3e 80 00 	movl   $0x803ee4,(%esp)
  800c45:	e8 60 23 00 00       	call   802faa <_Z7cprintfPKcz>
		return -E_INVAL;
  800c4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c4f:	eb 1b                	jmp    800c6c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  800c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c54:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  800c57:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c5c:	85 d2                	test   %edx,%edx
  800c5e:	74 0c                	je     800c6c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c67:	89 0c 24             	mov    %ecx,(%esp)
  800c6a:	ff d2                	call   *%edx
}
  800c6c:	83 c4 24             	add    $0x24,%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c72:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800c75:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  800c79:	75 d6                	jne    800c51 <_Z9ftruncateii+0x62>
  800c7b:	eb b1                	jmp    800c2e <_Z9ftruncateii+0x3f>

00800c7d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	53                   	push   %ebx
  800c81:	83 ec 24             	sub    $0x24,%esp
  800c84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800c87:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800c8e:	00 
  800c8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	89 04 24             	mov    %eax,(%esp)
  800c9c:	e8 10 fa ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	78 3e                	js     800ce3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	89 04 24             	mov    %eax,(%esp)
  800cb4:	e8 09 fb ff ff       	call   8007c2 <_Z10dev_lookupiPP3Dev>
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	79 2c                	jns    800ce9 <_Z5fstatiP4Stat+0x6c>
  800cbd:	eb 24                	jmp    800ce3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800cbf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800cc2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  800cc9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  800cd0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cdd:	89 04 24             	mov    %eax,(%esp)
  800ce0:	ff 52 14             	call   *0x14(%edx)
}
  800ce3:	83 c4 24             	add    $0x24,%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  800cec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800cf1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800cf5:	75 c8                	jne    800cbf <_Z5fstatiP4Stat+0x42>
  800cf7:	eb ea                	jmp    800ce3 <_Z5fstatiP4Stat+0x66>

00800cf9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 18             	sub    $0x18,%esp
  800cff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d02:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800d05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d0c:	00 
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	89 04 24             	mov    %eax,(%esp)
  800d13:	e8 d6 09 00 00       	call   8016ee <_Z4openPKci>
  800d18:	89 c3                	mov    %eax,%ebx
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	78 1b                	js     800d39 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d25:	89 1c 24             	mov    %ebx,(%esp)
  800d28:	e8 50 ff ff ff       	call   800c7d <_Z5fstatiP4Stat>
  800d2d:	89 c6                	mov    %eax,%esi
	close(fd);
  800d2f:	89 1c 24             	mov    %ebx,(%esp)
  800d32:	e8 7e fb ff ff       	call   8008b5 <_Z5closei>
	return r;
  800d37:	89 f3                	mov    %esi,%ebx
}
  800d39:	89 d8                	mov    %ebx,%eax
  800d3b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d3e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d41:	89 ec                	mov    %ebp,%esp
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
	...

00800d50 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  800d53:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  800d58:	85 d2                	test   %edx,%edx
  800d5a:	78 33                	js     800d8f <_ZL10inode_dataP5Inodei+0x3f>
  800d5c:	3b 50 08             	cmp    0x8(%eax),%edx
  800d5f:	7d 2e                	jge    800d8f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  800d61:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800d67:	85 d2                	test   %edx,%edx
  800d69:	0f 49 ca             	cmovns %edx,%ecx
  800d6c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  800d6f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  800d73:	c1 e1 0c             	shl    $0xc,%ecx
  800d76:	89 d0                	mov    %edx,%eax
  800d78:	c1 f8 1f             	sar    $0x1f,%eax
  800d7b:	c1 e8 14             	shr    $0x14,%eax
  800d7e:	01 c2                	add    %eax,%edx
  800d80:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  800d86:	29 c2                	sub    %eax,%edx
  800d88:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  800d8f:	89 c8                	mov    %ecx,%eax
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  800d96:	8b 48 08             	mov    0x8(%eax),%ecx
  800d99:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  800da1:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  800da8:	50 80 00 
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  800db3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	74 08                	je     800dc5 <_ZL9get_inodei+0x18>
  800dbd:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  800dc3:	7e 20                	jle    800de5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  800dc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dc9:	c7 44 24 08 1c 3f 80 	movl   $0x803f1c,0x8(%esp)
  800dd0:	00 
  800dd1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  800dd8:	00 
  800dd9:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  800de0:	e8 a7 20 00 00       	call   802e8c <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  800de5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800deb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  800df1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800df7:	85 d2                	test   %edx,%edx
  800df9:	0f 48 d1             	cmovs  %ecx,%edx
  800dfc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  800dff:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  800e06:	c1 e0 0c             	shl    $0xc,%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  800e13:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  800e19:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  800e1c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  800e22:	76 20                	jbe    800e44 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  800e24:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e28:	c7 44 24 08 58 3f 80 	movl   $0x803f58,0x8(%esp)
  800e2f:	00 
  800e30:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  800e37:	00 
  800e38:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  800e3f:	e8 48 20 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  800e44:	83 fe 01             	cmp    $0x1,%esi
  800e47:	7e 08                	jle    800e51 <_ZL10bcache_ipcPvi+0x46>
  800e49:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  800e4f:	7d 12                	jge    800e63 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  800e51:	89 f3                	mov    %esi,%ebx
  800e53:	c1 e3 04             	shl    $0x4,%ebx
  800e56:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  800e58:	81 c6 00 00 05 00    	add    $0x50000,%esi
  800e5e:	c1 e6 0c             	shl    $0xc,%esi
  800e61:	eb 20                	jmp    800e83 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  800e63:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800e67:	c7 44 24 08 88 3f 80 	movl   $0x803f88,0x8(%esp)
  800e6e:	00 
  800e6f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e76:	00 
  800e77:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  800e7e:	e8 09 20 00 00       	call   802e8c <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  800e83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e8a:	00 
  800e8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800e92:	00 
  800e93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e97:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  800e9e:	e8 cc 2c 00 00       	call   803b6f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  800ea3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800eaa:	00 
  800eab:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eaf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800eb6:	e8 25 2c 00 00       	call   803ae0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  800ebb:	83 f8 f0             	cmp    $0xfffffff0,%eax
  800ebe:	74 c3                	je     800e83 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 28             	sub    $0x28,%esp
  800ecd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ed6:	89 c7                	mov    %eax,%edi
  800ed8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  800eda:	c7 04 24 6d 11 80 00 	movl   $0x80116d,(%esp)
  800ee1:	e8 05 2b 00 00       	call   8039eb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  800ee6:	89 f8                	mov    %edi,%eax
  800ee8:	e8 c0 fe ff ff       	call   800dad <_ZL9get_inodei>
  800eed:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  800eef:	ba 02 00 00 00       	mov    $0x2,%edx
  800ef4:	e8 12 ff ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	79 08                	jns    800f05 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  800efd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  800f03:	eb 2e                	jmp    800f33 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 1c                	jne    800f25 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  800f09:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  800f0f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  800f16:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  800f19:	ba 06 00 00 00       	mov    $0x6,%edx
  800f1e:	89 d8                	mov    %ebx,%eax
  800f20:	e8 e6 fe ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  800f25:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  800f2c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f33:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f36:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f39:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3c:	89 ec                	mov    %ebp,%esp
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 2c             	sub    $0x2c,%esp
  800f49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f4c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  800f4f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  800f54:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  800f5a:	0f 87 3d 01 00 00    	ja     80109d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  800f60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f63:	8b 42 08             	mov    0x8(%edx),%eax
  800f66:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	0f 49 f0             	cmovns %eax,%esi
  800f71:	c1 fe 0c             	sar    $0xc,%esi
  800f74:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  800f76:	8b 7d d8             	mov    -0x28(%ebp),%edi
  800f79:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  800f7f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  800f82:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800f85:	0f 82 a6 00 00 00    	jb     801031 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  800f8b:	39 fe                	cmp    %edi,%esi
  800f8d:	0f 8d f2 00 00 00    	jge    801085 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  800f93:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  800f97:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800f9a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800f9d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  800fa0:	83 3e 00             	cmpl   $0x0,(%esi)
  800fa3:	75 77                	jne    80101c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  800fa5:	ba 02 00 00 00       	mov    $0x2,%edx
  800faa:	b8 00 20 00 50       	mov    $0x50002000,%eax
  800faf:	e8 57 fe ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  800fb4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  800fba:	83 f9 02             	cmp    $0x2,%ecx
  800fbd:	7e 43                	jle    801002 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  800fbf:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  800fc4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  800fc9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  800fd0:	74 29                	je     800ffb <_ZL14inode_set_sizeP5Inodej+0xbb>
  800fd2:	e9 ce 00 00 00       	jmp    8010a5 <_ZL14inode_set_sizeP5Inodej+0x165>
  800fd7:	89 c7                	mov    %eax,%edi
  800fd9:	0f b6 10             	movzbl (%eax),%edx
  800fdc:	83 c0 01             	add    $0x1,%eax
  800fdf:	84 d2                	test   %dl,%dl
  800fe1:	74 18                	je     800ffb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  800fe3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  800fe6:	ba 05 00 00 00       	mov    $0x5,%edx
  800feb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  800ff0:	e8 16 fe ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  800ff5:	85 db                	test   %ebx,%ebx
  800ff7:	79 1e                	jns    801017 <_ZL14inode_set_sizeP5Inodej+0xd7>
  800ff9:	eb 07                	jmp    801002 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  800ffb:	83 c3 01             	add    $0x1,%ebx
  800ffe:	39 d9                	cmp    %ebx,%ecx
  801000:	7f d5                	jg     800fd7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801002:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801005:	8b 50 08             	mov    0x8(%eax),%edx
  801008:	e8 33 ff ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80100d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801012:	e9 86 00 00 00       	jmp    80109d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801017:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80101a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80101c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801020:	83 c6 04             	add    $0x4,%esi
  801023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801026:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801029:	0f 8f 6e ff ff ff    	jg     800f9d <_ZL14inode_set_sizeP5Inodej+0x5d>
  80102f:	eb 54                	jmp    801085 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801031:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801034:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801039:	83 f8 01             	cmp    $0x1,%eax
  80103c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80103f:	ba 02 00 00 00       	mov    $0x2,%edx
  801044:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801049:	e8 bd fd ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80104e:	39 f7                	cmp    %esi,%edi
  801050:	7d 24                	jge    801076 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801052:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801055:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801059:	8b 10                	mov    (%eax),%edx
  80105b:	85 d2                	test   %edx,%edx
  80105d:	74 0d                	je     80106c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80105f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801066:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80106c:	83 eb 01             	sub    $0x1,%ebx
  80106f:	83 e8 04             	sub    $0x4,%eax
  801072:	39 fb                	cmp    %edi,%ebx
  801074:	75 e3                	jne    801059 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801076:	ba 05 00 00 00       	mov    $0x5,%edx
  80107b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801080:	e8 86 fd ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801085:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801088:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80108b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80108e:	ba 04 00 00 00       	mov    $0x4,%edx
  801093:	e8 73 fd ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	return 0;
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109d:	83 c4 2c             	add    $0x2c,%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  8010a5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8010ac:	ba 05 00 00 00       	mov    $0x5,%edx
  8010b1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8010b6:	e8 50 fd ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8010bb:	bb 02 00 00 00       	mov    $0x2,%ebx
  8010c0:	e9 52 ff ff ff       	jmp    801017 <_ZL14inode_set_sizeP5Inodej+0xd7>

008010c5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  8010ce:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  8010d4:	83 e8 01             	sub    $0x1,%eax
  8010d7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  8010dd:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  8010e1:	75 40                	jne    801123 <_ZL11inode_closeP5Inode+0x5e>
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	75 3c                	jne    801123 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8010e7:	ba 02 00 00 00       	mov    $0x2,%edx
  8010ec:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8010f1:	e8 15 fd ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  8010fb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  8010ff:	85 d2                	test   %edx,%edx
  801101:	74 07                	je     80110a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801103:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80110a:	83 c0 01             	add    $0x1,%eax
  80110d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801112:	75 e7                	jne    8010fb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801114:	ba 05 00 00 00       	mov    $0x5,%edx
  801119:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80111e:	e8 e8 fc ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801123:	ba 03 00 00 00       	mov    $0x3,%edx
  801128:	89 d8                	mov    %ebx,%eax
  80112a:	e8 dc fc ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
}
  80112f:	83 c4 04             	add    $0x4,%esp
  801132:	5b                   	pop    %ebx
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	53                   	push   %ebx
  801139:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8b 40 0c             	mov    0xc(%eax),%eax
  801142:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801145:	e8 7d fd ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  80114a:	89 c3                	mov    %eax,%ebx
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 15                	js     801165 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801150:	8b 55 0c             	mov    0xc(%ebp),%edx
  801153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801156:	e8 e5 fd ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
  80115b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80115d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801160:	e8 60 ff ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
	return r;
}
  801165:	89 d8                	mov    %ebx,%eax
  801167:	83 c4 14             	add    $0x14,%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	53                   	push   %ebx
  801171:	83 ec 14             	sub    $0x14,%esp
  801174:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801177:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801179:	89 c2                	mov    %eax,%edx
  80117b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801181:	78 32                	js     8011b5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801183:	ba 00 00 00 00       	mov    $0x0,%edx
  801188:	e8 7e fc ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
  80118d:	85 c0                	test   %eax,%eax
  80118f:	74 1c                	je     8011ad <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801191:	c7 44 24 08 3d 3f 80 	movl   $0x803f3d,0x8(%esp)
  801198:	00 
  801199:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8011a0:	00 
  8011a1:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  8011a8:	e8 df 1c 00 00       	call   802e8c <_Z6_panicPKciS0_z>
    resume(utf);
  8011ad:	89 1c 24             	mov    %ebx,(%esp)
  8011b0:	e8 0b 29 00 00       	call   803ac0 <resume>
}
  8011b5:	83 c4 14             	add    $0x14,%esp
  8011b8:	5b                   	pop    %ebx
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 28             	sub    $0x28,%esp
  8011c1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8011c4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8011c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8011ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8011cd:	8b 43 0c             	mov    0xc(%ebx),%eax
  8011d0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8011d3:	e8 ef fc ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 26                	js     801202 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  8011dc:	83 c3 10             	add    $0x10,%ebx
  8011df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011e3:	89 34 24             	mov    %esi,(%esp)
  8011e6:	e8 df 23 00 00       	call   8035ca <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8011eb:	89 f2                	mov    %esi,%edx
  8011ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f0:	e8 9e fb ff ff       	call   800d93 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8011f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f8:	e8 c8 fe ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
	return 0;
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801202:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801205:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801208:	89 ec                	mov    %ebp,%esp
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	53                   	push   %ebx
  801210:	83 ec 24             	sub    $0x24,%esp
  801213:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801216:	89 1c 24             	mov    %ebx,(%esp)
  801219:	e8 9e 15 00 00       	call   8027bc <_Z7pagerefPv>
  80121e:	89 c2                	mov    %eax,%edx
        return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801225:	83 fa 01             	cmp    $0x1,%edx
  801228:	7f 1e                	jg     801248 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80122a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80122d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801230:	e8 92 fc ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  801235:	85 c0                	test   %eax,%eax
  801237:	78 0f                	js     801248 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801243:	e8 7d fe ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
}
  801248:	83 c4 24             	add    $0x24,%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 3c             	sub    $0x3c,%esp
  801257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80125a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80125d:	8b 43 04             	mov    0x4(%ebx),%eax
  801260:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801263:	8b 43 0c             	mov    0xc(%ebx),%eax
  801266:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801269:	e8 59 fc ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  80126e:	85 c0                	test   %eax,%eax
  801270:	0f 88 8c 00 00 00    	js     801302 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801276:	8b 53 04             	mov    0x4(%ebx),%edx
  801279:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80127f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801285:	29 d7                	sub    %edx,%edi
  801287:	39 f7                	cmp    %esi,%edi
  801289:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80128c:	85 ff                	test   %edi,%edi
  80128e:	74 16                	je     8012a6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801290:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801296:	3b 50 08             	cmp    0x8(%eax),%edx
  801299:	76 6f                	jbe    80130a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80129b:	e8 a0 fc ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	79 66                	jns    80130a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8012a4:	eb 4e                	jmp    8012f4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8012a6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8012ac:	76 24                	jbe    8012d2 <_ZL13devfile_writeP2FdPKvj+0x84>
  8012ae:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8012b0:	8b 53 04             	mov    0x4(%ebx),%edx
  8012b3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8012b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012bc:	3b 50 08             	cmp    0x8(%eax),%edx
  8012bf:	0f 86 83 00 00 00    	jbe    801348 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8012c5:	e8 76 fc ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	79 7a                	jns    801348 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8012ce:	66 90                	xchg   %ax,%ax
  8012d0:	eb 22                	jmp    8012f4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8012d2:	85 f6                	test   %esi,%esi
  8012d4:	74 1e                	je     8012f4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8012d6:	89 f2                	mov    %esi,%edx
  8012d8:	03 53 04             	add    0x4(%ebx),%edx
  8012db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012de:	3b 50 08             	cmp    0x8(%eax),%edx
  8012e1:	0f 86 b8 00 00 00    	jbe    80139f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  8012e7:	e8 54 fc ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	0f 89 ab 00 00 00    	jns    80139f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  8012f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f7:	e8 c9 fd ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8012fc:	8b 43 04             	mov    0x4(%ebx),%eax
  8012ff:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801302:	83 c4 3c             	add    $0x3c,%esp
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80130a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80130c:	8b 53 04             	mov    0x4(%ebx),%edx
  80130f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801312:	e8 39 fa ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  801317:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80131a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	89 44 24 04          	mov    %eax,0x4(%esp)
  801325:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801328:	89 04 24             	mov    %eax,(%esp)
  80132b:	e8 b7 24 00 00       	call   8037e7 <memcpy>
        fd->fd_offset += n2;
  801330:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801333:	ba 04 00 00 00       	mov    $0x4,%edx
  801338:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80133b:	e8 cb fa ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801340:	01 7d 0c             	add    %edi,0xc(%ebp)
  801343:	e9 5e ff ff ff       	jmp    8012a6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801348:	8b 53 04             	mov    0x4(%ebx),%edx
  80134b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134e:	e8 fd f9 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  801353:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801355:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80135c:	00 
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	89 44 24 04          	mov    %eax,0x4(%esp)
  801364:	89 34 24             	mov    %esi,(%esp)
  801367:	e8 7b 24 00 00       	call   8037e7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80136c:	ba 04 00 00 00       	mov    $0x4,%edx
  801371:	89 f0                	mov    %esi,%eax
  801373:	e8 93 fa ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801378:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80137e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801385:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80138c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801392:	0f 87 18 ff ff ff    	ja     8012b0 <_ZL13devfile_writeP2FdPKvj+0x62>
  801398:	89 fe                	mov    %edi,%esi
  80139a:	e9 33 ff ff ff       	jmp    8012d2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80139f:	8b 53 04             	mov    0x4(%ebx),%edx
  8013a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a5:	e8 a6 f9 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  8013aa:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8013ac:	89 74 24 08          	mov    %esi,0x8(%esp)
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b7:	89 3c 24             	mov    %edi,(%esp)
  8013ba:	e8 28 24 00 00       	call   8037e7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8013bf:	ba 04 00 00 00       	mov    $0x4,%edx
  8013c4:	89 f8                	mov    %edi,%eax
  8013c6:	e8 40 fa ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8013cb:	01 73 04             	add    %esi,0x4(%ebx)
  8013ce:	e9 21 ff ff ff       	jmp    8012f4 <_ZL13devfile_writeP2FdPKvj+0xa6>

008013d3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	57                   	push   %edi
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 3c             	sub    $0x3c,%esp
  8013dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8013df:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8013e2:	8b 43 04             	mov    0x4(%ebx),%eax
  8013e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8013e8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8013eb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8013ee:	e8 d4 fa ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	0f 88 d3 00 00 00    	js     8014ce <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8013fb:	8b 73 04             	mov    0x4(%ebx),%esi
  8013fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801401:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  801404:	8b 50 08             	mov    0x8(%eax),%edx
  801407:	29 f2                	sub    %esi,%edx
  801409:	3b 48 08             	cmp    0x8(%eax),%ecx
  80140c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80140f:	89 f2                	mov    %esi,%edx
  801411:	e8 3a f9 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  801416:	85 c0                	test   %eax,%eax
  801418:	0f 84 a2 00 00 00    	je     8014c0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80141e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  801424:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80142a:	29 f2                	sub    %esi,%edx
  80142c:	39 d7                	cmp    %edx,%edi
  80142e:	0f 46 d7             	cmovbe %edi,%edx
  801431:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  801434:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  801436:	01 d6                	add    %edx,%esi
  801438:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80143b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80143f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	89 04 24             	mov    %eax,(%esp)
  801449:	e8 99 23 00 00       	call   8037e7 <memcpy>
    buf = (void *)((char *)buf + n2);
  80144e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801451:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  801454:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80145a:	76 3e                	jbe    80149a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80145c:	8b 53 04             	mov    0x4(%ebx),%edx
  80145f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801462:	e8 e9 f8 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  801467:	85 c0                	test   %eax,%eax
  801469:	74 55                	je     8014c0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80146b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801472:	00 
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	89 34 24             	mov    %esi,(%esp)
  80147a:	e8 68 23 00 00       	call   8037e7 <memcpy>
        n -= PGSIZE;
  80147f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  801485:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80148b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  801492:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801498:	77 c2                	ja     80145c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80149a:	85 ff                	test   %edi,%edi
  80149c:	74 22                	je     8014c0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80149e:	8b 53 04             	mov    0x4(%ebx),%edx
  8014a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a4:	e8 a7 f8 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	74 13                	je     8014c0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8014ad:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b5:	89 34 24             	mov    %esi,(%esp)
  8014b8:	e8 2a 23 00 00       	call   8037e7 <memcpy>
        fd->fd_offset += n;
  8014bd:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8014c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c3:	e8 fd fb ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8014c8:	8b 43 04             	mov    0x4(%ebx),%eax
  8014cb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8014ce:	83 c4 3c             	add    $0x3c,%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	57                   	push   %edi
  8014da:	56                   	push   %esi
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 4c             	sub    $0x4c,%esp
  8014df:	89 c6                	mov    %eax,%esi
  8014e1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8014e4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8014e7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8014ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8014f6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8014f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014fe:	e8 c4 f9 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  801503:	89 c7                	mov    %eax,%edi
  801505:	85 c0                	test   %eax,%eax
  801507:	0f 88 cd 01 00 00    	js     8016da <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80150d:	89 f3                	mov    %esi,%ebx
  80150f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  801512:	75 08                	jne    80151c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  801514:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  801517:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80151a:	74 f8                	je     801514 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80151c:	0f b6 03             	movzbl (%ebx),%eax
  80151f:	3c 2f                	cmp    $0x2f,%al
  801521:	74 16                	je     801539 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  801523:	84 c0                	test   %al,%al
  801525:	74 12                	je     801539 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  801527:	89 da                	mov    %ebx,%edx
		++path;
  801529:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80152c:	0f b6 02             	movzbl (%edx),%eax
  80152f:	3c 2f                	cmp    $0x2f,%al
  801531:	74 08                	je     80153b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  801533:	84 c0                	test   %al,%al
  801535:	75 f2                	jne    801529 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  801537:	eb 02                	jmp    80153b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  801539:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	29 d8                	sub    %ebx,%eax
  80153f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  801542:	0f b6 02             	movzbl (%edx),%eax
  801545:	89 d6                	mov    %edx,%esi
  801547:	3c 2f                	cmp    $0x2f,%al
  801549:	75 0a                	jne    801555 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80154b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80154e:	0f b6 06             	movzbl (%esi),%eax
  801551:	3c 2f                	cmp    $0x2f,%al
  801553:	74 f6                	je     80154b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  801555:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801559:	75 1b                	jne    801576 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80155b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801561:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  801563:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801566:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80156c:	bf 00 00 00 00       	mov    $0x0,%edi
  801571:	e9 64 01 00 00       	jmp    8016da <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  801576:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80157a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157e:	74 06                	je     801586 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  801580:	84 c0                	test   %al,%al
  801582:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  801586:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801589:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80158c:	83 3a 02             	cmpl   $0x2,(%edx)
  80158f:	0f 85 f4 00 00 00    	jne    801689 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  801595:	89 d0                	mov    %edx,%eax
  801597:	8b 52 08             	mov    0x8(%edx),%edx
  80159a:	85 d2                	test   %edx,%edx
  80159c:	7e 78                	jle    801616 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80159e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8015aa:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8015ad:	89 fb                	mov    %edi,%ebx
  8015af:	89 75 c0             	mov    %esi,-0x40(%ebp)
  8015b2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8015b4:	89 da                	mov    %ebx,%edx
  8015b6:	89 f0                	mov    %esi,%eax
  8015b8:	e8 93 f7 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  8015bd:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  8015bf:	83 38 00             	cmpl   $0x0,(%eax)
  8015c2:	74 26                	je     8015ea <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8015c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8015c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8015ca:	75 33                	jne    8015ff <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8015cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	8d 47 08             	lea    0x8(%edi),%eax
  8015da:	89 04 24             	mov    %eax,(%esp)
  8015dd:	e8 46 22 00 00       	call   803828 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	0f 84 fa 00 00 00    	je     8016e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8015ea:	83 3f 00             	cmpl   $0x0,(%edi)
  8015ed:	75 10                	jne    8015ff <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8015ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8015f3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8015f6:	84 c0                	test   %al,%al
  8015f8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8015fc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8015ff:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  801605:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  801607:	8b 56 08             	mov    0x8(%esi),%edx
  80160a:	39 d0                	cmp    %edx,%eax
  80160c:	7c a6                	jl     8015b4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80160e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  801611:	8b 75 c0             	mov    -0x40(%ebp),%esi
  801614:	eb 07                	jmp    80161d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  801616:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80161d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  801621:	74 6d                	je     801690 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  801623:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  801627:	75 24                	jne    80164d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  801629:	83 ea 80             	sub    $0xffffff80,%edx
  80162c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80162f:	e8 0c f9 ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  801634:	85 c0                	test   %eax,%eax
  801636:	0f 88 90 00 00 00    	js     8016cc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80163c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80163f:	8b 50 08             	mov    0x8(%eax),%edx
  801642:	83 c2 80             	add    $0xffffff80,%edx
  801645:	e8 06 f7 ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  80164a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80164d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  801654:	00 
  801655:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80165c:	00 
  80165d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801660:	89 14 24             	mov    %edx,(%esp)
  801663:	e8 a9 20 00 00       	call   803711 <memset>
	empty->de_namelen = namelen;
  801668:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80166b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80166e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  801671:	89 54 24 08          	mov    %edx,0x8(%esp)
  801675:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801679:	83 c0 08             	add    $0x8,%eax
  80167c:	89 04 24             	mov    %eax,(%esp)
  80167f:	e8 63 21 00 00       	call   8037e7 <memcpy>
	*de_store = empty;
  801684:	8b 7d cc             	mov    -0x34(%ebp),%edi
  801687:	eb 5e                	jmp    8016e7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  801689:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80168e:	eb 42                	jmp    8016d2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  801690:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  801695:	eb 3b                	jmp    8016d2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  801697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80169d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80169f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016a2:	89 38                	mov    %edi,(%eax)
			return 0;
  8016a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a9:	eb 2f                	jmp    8016da <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8016ab:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8016ae:	8b 07                	mov    (%edi),%eax
  8016b0:	e8 12 f8 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 17                	js     8016d0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  8016b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bc:	e8 04 fa ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8016c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8016c7:	e9 41 fe ff ff       	jmp    80150d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8016cc:	89 c7                	mov    %eax,%edi
  8016ce:	eb 02                	jmp    8016d2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8016d0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8016d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d5:	e8 eb f9 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
	return r;
}
  8016da:	89 f8                	mov    %edi,%eax
  8016dc:	83 c4 4c             	add    $0x4c,%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5f                   	pop    %edi
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    
  8016e4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8016e7:	80 3e 00             	cmpb   $0x0,(%esi)
  8016ea:	75 bf                	jne    8016ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8016ec:	eb a9                	jmp    801697 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008016ee <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	57                   	push   %edi
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 3c             	sub    $0x3c,%esp
  8016f7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8016fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016fd:	89 04 24             	mov    %eax,(%esp)
  801700:	e8 62 f0 ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  801705:	89 c3                	mov    %eax,%ebx
  801707:	85 c0                	test   %eax,%eax
  801709:	0f 88 16 02 00 00    	js     801925 <_Z4openPKci+0x237>
  80170f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801716:	00 
  801717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80171a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801725:	e8 d2 ea ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	85 db                	test   %ebx,%ebx
  801733:	0f 88 ec 01 00 00    	js     801925 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  801739:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80173d:	0f 84 ec 01 00 00    	je     80192f <_Z4openPKci+0x241>
  801743:	83 c0 01             	add    $0x1,%eax
  801746:	83 f8 78             	cmp    $0x78,%eax
  801749:	75 ee                	jne    801739 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80174b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  801750:	e9 b9 01 00 00       	jmp    80190e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  801755:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801758:	81 e7 00 01 00 00    	and    $0x100,%edi
  80175e:	89 3c 24             	mov    %edi,(%esp)
  801761:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  801764:	8d 55 e0             	lea    -0x20(%ebp),%edx
  801767:	89 f0                	mov    %esi,%eax
  801769:	e8 68 fd ff ff       	call   8014d6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80176e:	89 c3                	mov    %eax,%ebx
  801770:	85 c0                	test   %eax,%eax
  801772:	0f 85 96 01 00 00    	jne    80190e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  801778:	85 ff                	test   %edi,%edi
  80177a:	75 41                	jne    8017bd <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80177c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80177f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  801784:	75 08                	jne    80178e <_Z4openPKci+0xa0>
            fileino = dirino;
  801786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80178c:	eb 14                	jmp    8017a2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80178e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  801791:	8b 00                	mov    (%eax),%eax
  801793:	e8 2f f7 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	85 c0                	test   %eax,%eax
  80179c:	0f 88 5d 01 00 00    	js     8018ff <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8017a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a5:	83 38 02             	cmpl   $0x2,(%eax)
  8017a8:	0f 85 d2 00 00 00    	jne    801880 <_Z4openPKci+0x192>
  8017ae:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  8017b2:	0f 84 c8 00 00 00    	je     801880 <_Z4openPKci+0x192>
  8017b8:	e9 38 01 00 00       	jmp    8018f5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  8017bd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8017c4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8017cb:	0f 8e a8 00 00 00    	jle    801879 <_Z4openPKci+0x18b>
  8017d1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8017d6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8017d9:	89 f8                	mov    %edi,%eax
  8017db:	e8 e7 f6 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  8017e0:	89 c3                	mov    %eax,%ebx
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	0f 88 15 01 00 00    	js     8018ff <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8017ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017ed:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8017f1:	75 68                	jne    80185b <_Z4openPKci+0x16d>
  8017f3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8017fa:	75 5f                	jne    80185b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8017fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8017ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  801805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801808:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80180f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  801816:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80181d:	00 
  80181e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801825:	00 
  801826:	83 c0 0c             	add    $0xc,%eax
  801829:	89 04 24             	mov    %eax,(%esp)
  80182c:	e8 e0 1e 00 00       	call   803711 <memset>
        de->de_inum = fileino->i_inum;
  801831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801834:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80183a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80183d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80183f:	ba 04 00 00 00       	mov    $0x4,%edx
  801844:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801847:	e8 bf f5 ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80184c:	ba 04 00 00 00       	mov    $0x4,%edx
  801851:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801854:	e8 b2 f5 ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
  801859:	eb 25                	jmp    801880 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80185b:	e8 65 f8 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  801860:	83 c7 01             	add    $0x1,%edi
  801863:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  801869:	0f 8c 67 ff ff ff    	jl     8017d6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80186f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  801874:	e9 86 00 00 00       	jmp    8018ff <_Z4openPKci+0x211>
  801879:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80187e:	eb 7f                	jmp    8018ff <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  801880:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  801887:	74 0d                	je     801896 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801891:	e8 aa f6 ff ff       	call   800f40 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  801896:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80189c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8018a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  8018b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018b4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  8018ba:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  8018bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018c1:	83 c0 10             	add    $0x10,%eax
  8018c4:	89 04 24             	mov    %eax,(%esp)
  8018c7:	e8 fe 1c 00 00       	call   8035ca <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8018cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018cf:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	e8 e7 f7 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  8018de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e1:	e8 df f7 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  8018e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e9:	89 04 24             	mov    %eax,(%esp)
  8018ec:	e8 13 ee ff ff       	call   800704 <_Z6fd2numP2Fd>
  8018f1:	89 c3                	mov    %eax,%ebx
  8018f3:	eb 30                	jmp    801925 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  8018f5:	e8 cb f7 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  8018fa:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  8018ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801902:	e8 be f7 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
  801907:	eb 05                	jmp    80190e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  801909:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80190e:	a1 00 60 80 00       	mov    0x806000,%eax
  801913:	8b 40 04             	mov    0x4(%eax),%eax
  801916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801919:	89 54 24 04          	mov    %edx,0x4(%esp)
  80191d:	89 04 24             	mov    %eax,(%esp)
  801920:	e8 94 e9 ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  801925:	89 d8                	mov    %ebx,%eax
  801927:	83 c4 3c             	add    $0x3c,%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5e                   	pop    %esi
  80192c:	5f                   	pop    %edi
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80192f:	83 f8 78             	cmp    $0x78,%eax
  801932:	0f 85 1d fe ff ff    	jne    801755 <_Z4openPKci+0x67>
  801938:	eb cf                	jmp    801909 <_Z4openPKci+0x21b>

0080193a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
  80193e:	83 ec 24             	sub    $0x24,%esp
  801941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  801944:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	e8 78 f5 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 27                	js     80197a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  801953:	c7 44 24 04 50 3f 80 	movl   $0x803f50,0x4(%esp)
  80195a:	00 
  80195b:	89 1c 24             	mov    %ebx,(%esp)
  80195e:	e8 67 1c 00 00       	call   8035ca <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801963:	89 da                	mov    %ebx,%edx
  801965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801968:	e8 26 f4 ff ff       	call   800d93 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801970:	e8 50 f7 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
	return 0;
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197a:	83 c4 24             	add    $0x24,%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  801987:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  801991:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	e8 3a fb ff ff       	call   8014d6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 5f                	js     801a01 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  8019a2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a8:	8b 00                	mov    (%eax),%eax
  8019aa:	e8 18 f5 ff ff       	call   800ec7 <_ZL10inode_openiPP5Inode>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 44                	js     8019f9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  8019b5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	83 38 02             	cmpl   $0x2,(%eax)
  8019c0:	74 2f                	je     8019f1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  8019c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  8019d2:	ba 04 00 00 00       	mov    $0x4,%edx
  8019d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019da:	e8 2c f4 ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  8019df:	ba 04 00 00 00       	mov    $0x4,%edx
  8019e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e7:	e8 1f f4 ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
	r = 0;
  8019ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	e8 cc f6 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  8019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fc:	e8 c4 f6 ff ff       	call   8010c5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	83 c4 24             	add    $0x24,%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    

00801a09 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	57                   	push   %edi
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  801a1f:	c7 04 24 6d 11 80 00 	movl   $0x80116d,(%esp)
  801a26:	e8 c0 1f 00 00       	call   8039eb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  801a2b:	a1 00 10 00 50       	mov    0x50001000,%eax
  801a30:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  801a35:	74 28                	je     801a5f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  801a37:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  801a3e:	4a 
  801a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a43:	c7 44 24 08 b8 3f 80 	movl   $0x803fb8,0x8(%esp)
  801a4a:	00 
  801a4b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  801a52:	00 
  801a53:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  801a5a:	e8 2d 14 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  801a5f:	a1 04 10 00 50       	mov    0x50001004,%eax
  801a64:	83 f8 03             	cmp    $0x3,%eax
  801a67:	7f 1c                	jg     801a85 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  801a69:	c7 44 24 08 ec 3f 80 	movl   $0x803fec,0x8(%esp)
  801a70:	00 
  801a71:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  801a78:	00 
  801a79:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  801a80:	e8 07 14 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  801a85:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  801a8b:	85 d2                	test   %edx,%edx
  801a8d:	7f 1c                	jg     801aab <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  801a8f:	c7 44 24 08 1c 40 80 	movl   $0x80401c,0x8(%esp)
  801a96:	00 
  801a97:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  801a9e:	00 
  801a9f:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  801aa6:	e8 e1 13 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  801aab:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  801ab1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  801ab7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  801abd:	85 c9                	test   %ecx,%ecx
  801abf:	0f 48 cb             	cmovs  %ebx,%ecx
  801ac2:	c1 f9 0c             	sar    $0xc,%ecx
  801ac5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  801ac9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  801acf:	39 c8                	cmp    %ecx,%eax
  801ad1:	7c 13                	jl     801ae6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	7f 3d                	jg     801b14 <_Z4fsckv+0x101>
  801ad7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  801ade:	00 00 00 
  801ae1:	e9 ac 00 00 00       	jmp    801b92 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  801ae6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  801aec:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  801af0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801af4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801af8:	c7 44 24 08 4c 40 80 	movl   $0x80404c,0x8(%esp)
  801aff:	00 
  801b00:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  801b07:	00 
  801b08:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  801b0f:	e8 78 13 00 00       	call   802e8c <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  801b14:	be 00 20 00 50       	mov    $0x50002000,%esi
  801b19:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  801b20:	00 00 00 
  801b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b28:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  801b2e:	39 df                	cmp    %ebx,%edi
  801b30:	7e 27                	jle    801b59 <_Z4fsckv+0x146>
  801b32:	0f b6 06             	movzbl (%esi),%eax
  801b35:	84 c0                	test   %al,%al
  801b37:	74 4b                	je     801b84 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  801b39:	0f be c0             	movsbl %al,%eax
  801b3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b44:	c7 04 24 90 40 80 00 	movl   $0x804090,(%esp)
  801b4b:	e8 5a 14 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801b50:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801b57:	eb 2b                	jmp    801b84 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  801b59:	0f b6 06             	movzbl (%esi),%eax
  801b5c:	3c 01                	cmp    $0x1,%al
  801b5e:	76 24                	jbe    801b84 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  801b60:	0f be c0             	movsbl %al,%eax
  801b63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b6b:	c7 04 24 c4 40 80 00 	movl   $0x8040c4,(%esp)
  801b72:	e8 33 14 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801b77:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  801b7e:	80 3e 00             	cmpb   $0x0,(%esi)
  801b81:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  801b84:	83 c3 01             	add    $0x1,%ebx
  801b87:	83 c6 01             	add    $0x1,%esi
  801b8a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  801b90:	7f 9c                	jg     801b2e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  801b92:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  801b99:	0f 8e e1 02 00 00    	jle    801e80 <_Z4fsckv+0x46d>
  801b9f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  801ba6:	00 00 00 
		struct Inode *ino = get_inode(i);
  801ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801baf:	e8 f9 f1 ff ff       	call   800dad <_ZL9get_inodei>
  801bb4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  801bba:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  801bbe:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  801bc5:	75 22                	jne    801be9 <_Z4fsckv+0x1d6>
  801bc7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  801bce:	0f 84 a9 06 00 00    	je     80227d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	e8 2d f2 ff ff       	call   800e0b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  801bde:	85 c0                	test   %eax,%eax
  801be0:	74 3a                	je     801c1c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  801be2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  801be9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801bef:	8b 02                	mov    (%edx),%eax
  801bf1:	83 f8 01             	cmp    $0x1,%eax
  801bf4:	74 26                	je     801c1c <_Z4fsckv+0x209>
  801bf6:	83 f8 02             	cmp    $0x2,%eax
  801bf9:	74 21                	je     801c1c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  801bfb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bff:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  801c05:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c09:	c7 04 24 f0 40 80 00 	movl   $0x8040f0,(%esp)
  801c10:	e8 95 13 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801c15:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  801c1c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  801c23:	75 3f                	jne    801c64 <_Z4fsckv+0x251>
  801c25:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801c2b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  801c2f:	75 15                	jne    801c46 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  801c31:	c7 04 24 14 41 80 00 	movl   $0x804114,(%esp)
  801c38:	e8 6d 13 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801c3d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801c44:	eb 1e                	jmp    801c64 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  801c46:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801c4c:	83 3a 02             	cmpl   $0x2,(%edx)
  801c4f:	74 13                	je     801c64 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  801c51:	c7 04 24 48 41 80 00 	movl   $0x804148,(%esp)
  801c58:	e8 4d 13 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801c5d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  801c64:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  801c69:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  801c70:	0f 84 93 00 00 00    	je     801d09 <_Z4fsckv+0x2f6>
  801c76:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  801c7c:	8b 41 08             	mov    0x8(%ecx),%eax
  801c7f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  801c84:	7e 23                	jle    801ca9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  801c86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c8a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	c7 04 24 78 41 80 00 	movl   $0x804178,(%esp)
  801c9b:	e8 0a 13 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801ca0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801ca7:	eb 09                	jmp    801cb2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  801ca9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  801cb0:	74 4b                	je     801cfd <_Z4fsckv+0x2ea>
  801cb2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801cb8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  801cbe:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  801cc4:	74 23                	je     801ce9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  801cc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cca:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  801cd0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd4:	c7 04 24 9c 41 80 00 	movl   $0x80419c,(%esp)
  801cdb:	e8 ca 12 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801ce0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801ce7:	eb 09                	jmp    801cf2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  801ce9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  801cf0:	74 12                	je     801d04 <_Z4fsckv+0x2f1>
  801cf2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801cf8:	8b 78 08             	mov    0x8(%eax),%edi
  801cfb:	eb 0c                	jmp    801d09 <_Z4fsckv+0x2f6>
  801cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801d02:	eb 05                	jmp    801d09 <_Z4fsckv+0x2f6>
  801d04:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  801d09:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  801d0e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801d14:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  801d18:	89 d8                	mov    %ebx,%eax
  801d1a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  801d1d:	39 c7                	cmp    %eax,%edi
  801d1f:	7e 2b                	jle    801d4c <_Z4fsckv+0x339>
  801d21:	85 f6                	test   %esi,%esi
  801d23:	75 27                	jne    801d4c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  801d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d2d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  801d33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d37:	c7 04 24 c0 41 80 00 	movl   $0x8041c0,(%esp)
  801d3e:	e8 67 12 00 00       	call   802faa <_Z7cprintfPKcz>
				++errors;
  801d43:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801d4a:	eb 36                	jmp    801d82 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  801d4c:	39 f8                	cmp    %edi,%eax
  801d4e:	7c 32                	jl     801d82 <_Z4fsckv+0x36f>
  801d50:	85 f6                	test   %esi,%esi
  801d52:	74 2e                	je     801d82 <_Z4fsckv+0x36f>
  801d54:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  801d5b:	74 25                	je     801d82 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  801d5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d61:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d65:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6f:	c7 04 24 04 42 80 00 	movl   $0x804204,(%esp)
  801d76:	e8 2f 12 00 00       	call   802faa <_Z7cprintfPKcz>
				++errors;
  801d7b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  801d82:	85 f6                	test   %esi,%esi
  801d84:	0f 84 a0 00 00 00    	je     801e2a <_Z4fsckv+0x417>
  801d8a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  801d91:	0f 84 93 00 00 00    	je     801e2a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  801d97:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  801d9d:	7e 27                	jle    801dc6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  801d9f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  801dad:	89 54 24 04          	mov    %edx,0x4(%esp)
  801db1:	c7 04 24 48 42 80 00 	movl   $0x804248,(%esp)
  801db8:	e8 ed 11 00 00       	call   802faa <_Z7cprintfPKcz>
					++errors;
  801dbd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801dc4:	eb 64                	jmp    801e2a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  801dc6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  801dcd:	3c 01                	cmp    $0x1,%al
  801dcf:	75 27                	jne    801df8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  801dd1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dd5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dd9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  801ddf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de3:	c7 04 24 8c 42 80 00 	movl   $0x80428c,(%esp)
  801dea:	e8 bb 11 00 00       	call   802faa <_Z7cprintfPKcz>
					++errors;
  801def:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801df6:	eb 32                	jmp    801e2a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  801df8:	3c ff                	cmp    $0xff,%al
  801dfa:	75 27                	jne    801e23 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  801dfc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e04:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0e:	c7 04 24 c8 42 80 00 	movl   $0x8042c8,(%esp)
  801e15:	e8 90 11 00 00       	call   802faa <_Z7cprintfPKcz>
					++errors;
  801e1a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801e21:	eb 07                	jmp    801e2a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  801e23:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  801e2a:	83 c3 01             	add    $0x1,%ebx
  801e2d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  801e33:	0f 85 d5 fe ff ff    	jne    801d0e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  801e39:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  801e40:	0f 94 c0             	sete   %al
  801e43:	0f b6 c0             	movzbl %al,%eax
  801e46:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801e4c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  801e52:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  801e59:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  801e60:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  801e67:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  801e6e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  801e74:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  801e7a:	0f 8f 29 fd ff ff    	jg     801ba9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  801e80:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  801e87:	0f 8e 7f 03 00 00    	jle    80220c <_Z4fsckv+0x7f9>
  801e8d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  801e92:	89 f0                	mov    %esi,%eax
  801e94:	e8 14 ef ff ff       	call   800dad <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  801e99:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  801ea0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  801ea7:	c1 e2 08             	shl    $0x8,%edx
  801eaa:	09 ca                	or     %ecx,%edx
  801eac:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  801eb3:	c1 e1 10             	shl    $0x10,%ecx
  801eb6:	09 ca                	or     %ecx,%edx
  801eb8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  801ebf:	83 e1 7f             	and    $0x7f,%ecx
  801ec2:	c1 e1 18             	shl    $0x18,%ecx
  801ec5:	09 d1                	or     %edx,%ecx
  801ec7:	74 0e                	je     801ed7 <_Z4fsckv+0x4c4>
  801ec9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  801ed0:	78 05                	js     801ed7 <_Z4fsckv+0x4c4>
  801ed2:	83 38 02             	cmpl   $0x2,(%eax)
  801ed5:	74 1f                	je     801ef6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  801ed7:	83 c6 01             	add    $0x1,%esi
  801eda:	a1 08 10 00 50       	mov    0x50001008,%eax
  801edf:	39 f0                	cmp    %esi,%eax
  801ee1:	7f af                	jg     801e92 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  801ee3:	bb 01 00 00 00       	mov    $0x1,%ebx
  801ee8:	83 f8 01             	cmp    $0x1,%eax
  801eeb:	0f 8f ad 02 00 00    	jg     80219e <_Z4fsckv+0x78b>
  801ef1:	e9 16 03 00 00       	jmp    80220c <_Z4fsckv+0x7f9>
  801ef6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  801ef8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  801eff:	8b 40 08             	mov    0x8(%eax),%eax
  801f02:	a8 7f                	test   $0x7f,%al
  801f04:	74 23                	je     801f29 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  801f06:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  801f0d:	00 
  801f0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f12:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f16:	c7 04 24 04 43 80 00 	movl   $0x804304,(%esp)
  801f1d:	e8 88 10 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  801f22:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  801f29:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  801f30:	00 00 00 
  801f33:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  801f39:	e9 3d 02 00 00       	jmp    80217b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  801f3e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801f44:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f4a:	e8 01 ee ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
  801f4f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  801f51:	83 38 00             	cmpl   $0x0,(%eax)
  801f54:	0f 84 15 02 00 00    	je     80216f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  801f5a:	8b 40 04             	mov    0x4(%eax),%eax
  801f5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f60:	83 fa 76             	cmp    $0x76,%edx
  801f63:	76 27                	jbe    801f8c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  801f65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f69:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801f6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f77:	c7 04 24 38 43 80 00 	movl   $0x804338,(%esp)
  801f7e:	e8 27 10 00 00       	call   802faa <_Z7cprintfPKcz>
				++errors;
  801f83:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  801f8a:	eb 28                	jmp    801fb4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  801f8c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  801f91:	74 21                	je     801fb4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  801f93:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  801f99:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f9d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fa1:	c7 04 24 64 43 80 00 	movl   $0x804364,(%esp)
  801fa8:	e8 fd 0f 00 00       	call   802faa <_Z7cprintfPKcz>
				++errors;
  801fad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  801fb4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  801fbb:	00 
  801fbc:	8d 43 08             	lea    0x8(%ebx),%eax
  801fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  801fc9:	89 0c 24             	mov    %ecx,(%esp)
  801fcc:	e8 16 18 00 00       	call   8037e7 <memcpy>
  801fd1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  801fd5:	bf 77 00 00 00       	mov    $0x77,%edi
  801fda:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  801fde:	85 ff                	test   %edi,%edi
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  801fe8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  801fef:	00 

			if (de->de_inum >= super->s_ninodes) {
  801ff0:	8b 03                	mov    (%ebx),%eax
  801ff2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801ff8:	7c 3e                	jl     802038 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  801ffa:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ffe:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802004:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802008:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80200e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802012:	89 74 24 04          	mov    %esi,0x4(%esp)
  802016:	c7 04 24 98 43 80 00 	movl   $0x804398,(%esp)
  80201d:	e8 88 0f 00 00       	call   802faa <_Z7cprintfPKcz>
				++errors;
  802022:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802029:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802030:	00 00 00 
  802033:	e9 0b 01 00 00       	jmp    802143 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802038:	e8 70 ed ff ff       	call   800dad <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80203d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802044:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80204b:	c1 e2 08             	shl    $0x8,%edx
  80204e:	09 d1                	or     %edx,%ecx
  802050:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802057:	c1 e2 10             	shl    $0x10,%edx
  80205a:	09 d1                	or     %edx,%ecx
  80205c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802063:	83 e2 7f             	and    $0x7f,%edx
  802066:	c1 e2 18             	shl    $0x18,%edx
  802069:	09 ca                	or     %ecx,%edx
  80206b:	83 c2 01             	add    $0x1,%edx
  80206e:	89 d1                	mov    %edx,%ecx
  802070:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802076:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80207c:	0f b6 d5             	movzbl %ch,%edx
  80207f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802085:	89 ca                	mov    %ecx,%edx
  802087:	c1 ea 10             	shr    $0x10,%edx
  80208a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802090:	c1 e9 18             	shr    $0x18,%ecx
  802093:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80209a:	83 e2 80             	and    $0xffffff80,%edx
  80209d:	09 ca                	or     %ecx,%edx
  80209f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  8020a5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8020a9:	0f 85 7a ff ff ff    	jne    802029 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  8020af:	8b 03                	mov    (%ebx),%eax
  8020b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8020b5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8020bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020bf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8020c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020cd:	c7 04 24 c8 43 80 00 	movl   $0x8043c8,(%esp)
  8020d4:	e8 d1 0e 00 00       	call   802faa <_Z7cprintfPKcz>
					++errors;
  8020d9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8020e0:	e9 44 ff ff ff       	jmp    802029 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8020e5:	3b 78 04             	cmp    0x4(%eax),%edi
  8020e8:	75 52                	jne    80213c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  8020ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020ee:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8020f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020f8:	83 c0 08             	add    $0x8,%eax
  8020fb:	89 04 24             	mov    %eax,(%esp)
  8020fe:	e8 25 17 00 00       	call   803828 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802103:	85 c0                	test   %eax,%eax
  802105:	75 35                	jne    80213c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802107:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80210d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802111:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802117:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80211b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802121:	89 54 24 08          	mov    %edx,0x8(%esp)
  802125:	89 74 24 04          	mov    %esi,0x4(%esp)
  802129:	c7 04 24 f8 43 80 00 	movl   $0x8043f8,(%esp)
  802130:	e8 75 0e 00 00       	call   802faa <_Z7cprintfPKcz>
					++errors;
  802135:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80213c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802143:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802149:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80214f:	7e 1e                	jle    80216f <_Z4fsckv+0x75c>
  802151:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802155:	7f 18                	jg     80216f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802157:	89 ca                	mov    %ecx,%edx
  802159:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80215f:	e8 ec eb ff ff       	call   800d50 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802164:	83 38 00             	cmpl   $0x0,(%eax)
  802167:	0f 85 78 ff ff ff    	jne    8020e5 <_Z4fsckv+0x6d2>
  80216d:	eb cd                	jmp    80213c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80216f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802175:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80217b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802181:	83 ea 80             	sub    $0xffffff80,%edx
  802184:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80218a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802190:	3b 51 08             	cmp    0x8(%ecx),%edx
  802193:	0f 8f e7 fc ff ff    	jg     801e80 <_Z4fsckv+0x46d>
  802199:	e9 a0 fd ff ff       	jmp    801f3e <_Z4fsckv+0x52b>
  80219e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	e8 02 ec ff ff       	call   800dad <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  8021ab:	8b 50 04             	mov    0x4(%eax),%edx
  8021ae:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8021b5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  8021bc:	c1 e7 08             	shl    $0x8,%edi
  8021bf:	09 f9                	or     %edi,%ecx
  8021c1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  8021c8:	c1 e7 10             	shl    $0x10,%edi
  8021cb:	09 f9                	or     %edi,%ecx
  8021cd:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  8021d4:	83 e7 7f             	and    $0x7f,%edi
  8021d7:	c1 e7 18             	shl    $0x18,%edi
  8021da:	09 f9                	or     %edi,%ecx
  8021dc:	39 ca                	cmp    %ecx,%edx
  8021de:	74 1b                	je     8021fb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  8021e0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021e4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ec:	c7 04 24 28 44 80 00 	movl   $0x804428,(%esp)
  8021f3:	e8 b2 0d 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  8021f8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8021fb:	83 c3 01             	add    $0x1,%ebx
  8021fe:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802204:	7f 9e                	jg     8021a4 <_Z4fsckv+0x791>
  802206:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80220c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802213:	7e 4f                	jle    802264 <_Z4fsckv+0x851>
  802215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80221a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802220:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802227:	3c ff                	cmp    $0xff,%al
  802229:	75 09                	jne    802234 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80222b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802232:	eb 1f                	jmp    802253 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802234:	84 c0                	test   %al,%al
  802236:	75 1b                	jne    802253 <_Z4fsckv+0x840>
  802238:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80223e:	7c 13                	jl     802253 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802240:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802244:	c7 04 24 54 44 80 00 	movl   $0x804454,(%esp)
  80224b:	e8 5a 0d 00 00       	call   802faa <_Z7cprintfPKcz>
			++errors;
  802250:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802253:	83 c3 01             	add    $0x1,%ebx
  802256:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80225c:	7f c2                	jg     802220 <_Z4fsckv+0x80d>
  80225e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802264:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80226b:	19 c0                	sbb    %eax,%eax
  80226d:	f7 d0                	not    %eax
  80226f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802272:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802278:	5b                   	pop    %ebx
  802279:	5e                   	pop    %esi
  80227a:	5f                   	pop    %edi
  80227b:	5d                   	pop    %ebp
  80227c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80227d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802284:	0f 84 92 f9 ff ff    	je     801c1c <_Z4fsckv+0x209>
  80228a:	e9 5a f9 ff ff       	jmp    801be9 <_Z4fsckv+0x1d6>
	...

00802290 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 18             	sub    $0x18,%esp
  802296:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802299:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80229c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	89 04 24             	mov    %eax,(%esp)
  8022a5:	e8 a2 e4 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  8022aa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8022ac:	c7 44 24 04 87 44 80 	movl   $0x804487,0x4(%esp)
  8022b3:	00 
  8022b4:	89 34 24             	mov    %esi,(%esp)
  8022b7:	e8 0e 13 00 00       	call   8035ca <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8022bf:	2b 03                	sub    (%ebx),%eax
  8022c1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8022c4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8022cb:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  8022d2:	50 80 00 
	return 0;
}
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8022dd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8022e0:	89 ec                	mov    %ebp,%esp
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 14             	sub    $0x14,%esp
  8022eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f9:	e8 bb df ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  8022fe:	89 1c 24             	mov    %ebx,(%esp)
  802301:	e8 46 e4 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  802306:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802311:	e8 a3 df ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
}
  802316:	83 c4 14             	add    $0x14,%esp
  802319:	5b                   	pop    %ebx
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	57                   	push   %edi
  802320:	56                   	push   %esi
  802321:	53                   	push   %ebx
  802322:	83 ec 2c             	sub    $0x2c,%esp
  802325:	89 c7                	mov    %eax,%edi
  802327:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80232a:	a1 00 60 80 00       	mov    0x806000,%eax
  80232f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802332:	89 3c 24             	mov    %edi,(%esp)
  802335:	e8 82 04 00 00       	call   8027bc <_Z7pagerefPv>
  80233a:	89 c3                	mov    %eax,%ebx
  80233c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 75 04 00 00       	call   8027bc <_Z7pagerefPv>
  802347:	39 c3                	cmp    %eax,%ebx
  802349:	0f 94 c0             	sete   %al
  80234c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80234f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802355:	8b 52 58             	mov    0x58(%edx),%edx
  802358:	39 d6                	cmp    %edx,%esi
  80235a:	75 08                	jne    802364 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80235c:	83 c4 2c             	add    $0x2c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802364:	85 c0                	test   %eax,%eax
  802366:	74 c2                	je     80232a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802368:	c7 04 24 8e 44 80 00 	movl   $0x80448e,(%esp)
  80236f:	e8 36 0c 00 00       	call   802faa <_Z7cprintfPKcz>
  802374:	eb b4                	jmp    80232a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802376 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	57                   	push   %edi
  80237a:	56                   	push   %esi
  80237b:	53                   	push   %ebx
  80237c:	83 ec 1c             	sub    $0x1c,%esp
  80237f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802382:	89 34 24             	mov    %esi,(%esp)
  802385:	e8 c2 e3 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  80238a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80238c:	bf 00 00 00 00       	mov    $0x0,%edi
  802391:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802395:	75 46                	jne    8023dd <_ZL13devpipe_writeP2FdPKvj+0x67>
  802397:	eb 52                	jmp    8023eb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802399:	89 da                	mov    %ebx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	e8 7a ff ff ff       	call   80231c <_ZL13_pipeisclosedP2FdP4Pipe>
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	75 49                	jne    8023ef <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8023a6:	e8 1d de ff ff       	call   8001c8 <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8023ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8023ae:	89 c2                	mov    %eax,%edx
  8023b0:	2b 13                	sub    (%ebx),%edx
  8023b2:	83 fa 20             	cmp    $0x20,%edx
  8023b5:	74 e2                	je     802399 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023b7:	89 c2                	mov    %eax,%edx
  8023b9:	c1 fa 1f             	sar    $0x1f,%edx
  8023bc:	c1 ea 1b             	shr    $0x1b,%edx
  8023bf:	01 d0                	add    %edx,%eax
  8023c1:	83 e0 1f             	and    $0x1f,%eax
  8023c4:	29 d0                	sub    %edx,%eax
  8023c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8023cd:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8023d1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8023d5:	83 c7 01             	add    $0x1,%edi
  8023d8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8023db:	76 0e                	jbe    8023eb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8023dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8023e0:	89 c2                	mov    %eax,%edx
  8023e2:	2b 13                	sub    (%ebx),%edx
  8023e4:	83 fa 20             	cmp    $0x20,%edx
  8023e7:	74 b0                	je     802399 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8023e9:	eb cc                	jmp    8023b7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8023eb:	89 f8                	mov    %edi,%eax
  8023ed:	eb 05                	jmp    8023f4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8023f4:	83 c4 1c             	add    $0x1c,%esp
  8023f7:	5b                   	pop    %ebx
  8023f8:	5e                   	pop    %esi
  8023f9:	5f                   	pop    %edi
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    

008023fc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 28             	sub    $0x28,%esp
  802402:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802405:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802408:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80240b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80240e:	89 3c 24             	mov    %edi,(%esp)
  802411:	e8 36 e3 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  802416:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802418:	be 00 00 00 00       	mov    $0x0,%esi
  80241d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802421:	75 47                	jne    80246a <_ZL12devpipe_readP2FdPvj+0x6e>
  802423:	eb 52                	jmp    802477 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  802425:	89 f0                	mov    %esi,%eax
  802427:	eb 5e                	jmp    802487 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  802429:	89 da                	mov    %ebx,%edx
  80242b:	89 f8                	mov    %edi,%eax
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	e8 e7 fe ff ff       	call   80231c <_ZL13_pipeisclosedP2FdP4Pipe>
  802435:	85 c0                	test   %eax,%eax
  802437:	75 49                	jne    802482 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  802439:	e8 8a dd ff ff       	call   8001c8 <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80243e:	8b 03                	mov    (%ebx),%eax
  802440:	3b 43 04             	cmp    0x4(%ebx),%eax
  802443:	74 e4                	je     802429 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802445:	89 c2                	mov    %eax,%edx
  802447:	c1 fa 1f             	sar    $0x1f,%edx
  80244a:	c1 ea 1b             	shr    $0x1b,%edx
  80244d:	01 d0                	add    %edx,%eax
  80244f:	83 e0 1f             	and    $0x1f,%eax
  802452:	29 d0                	sub    %edx,%eax
  802454:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80245f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802462:	83 c6 01             	add    $0x1,%esi
  802465:	39 75 10             	cmp    %esi,0x10(%ebp)
  802468:	76 0d                	jbe    802477 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80246a:	8b 03                	mov    (%ebx),%eax
  80246c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80246f:	75 d4                	jne    802445 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  802471:	85 f6                	test   %esi,%esi
  802473:	75 b0                	jne    802425 <_ZL12devpipe_readP2FdPvj+0x29>
  802475:	eb b2                	jmp    802429 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  802477:	89 f0                	mov    %esi,%eax
  802479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802480:	eb 05                	jmp    802487 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  802487:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80248a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80248d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802490:	89 ec                	mov    %ebp,%esp
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    

00802494 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 48             	sub    $0x48,%esp
  80249a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80249d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024a3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8024a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8024a9:	89 04 24             	mov    %eax,(%esp)
  8024ac:	e8 b6 e2 ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	0f 88 0b 01 00 00    	js     8025c6 <_Z4pipePi+0x132>
  8024bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c2:	00 
  8024c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d1:	e8 26 dd ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	0f 89 f5 00 00 00    	jns    8025d5 <_Z4pipePi+0x141>
  8024e0:	e9 e1 00 00 00       	jmp    8025c6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8024e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024ec:	00 
  8024ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fb:	e8 fc dc ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  802500:	89 c3                	mov    %eax,%ebx
  802502:	85 c0                	test   %eax,%eax
  802504:	0f 89 e2 00 00 00    	jns    8025ec <_Z4pipePi+0x158>
  80250a:	e9 a4 00 00 00       	jmp    8025b3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 32 e2 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  80251a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802521:	00 
  802522:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802526:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80252d:	00 
  80252e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802539:	e8 1d dd ff ff       	call   80025b <_Z12sys_page_mapiPviS_i>
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	85 c0                	test   %eax,%eax
  802542:	78 4c                	js     802590 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802544:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80254a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802559:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80255f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802562:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802567:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80256e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802571:	89 04 24             	mov    %eax,(%esp)
  802574:	e8 8b e1 ff ff       	call   800704 <_Z6fd2numP2Fd>
  802579:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80257b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257e:	89 04 24             	mov    %eax,(%esp)
  802581:	e8 7e e1 ff ff       	call   800704 <_Z6fd2numP2Fd>
  802586:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802589:	bb 00 00 00 00       	mov    $0x0,%ebx
  80258e:	eb 36                	jmp    8025c6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  802590:	89 74 24 04          	mov    %esi,0x4(%esp)
  802594:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80259b:	e8 19 dd ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8025a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ae:	e8 06 dd ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c1:	e8 f3 dc ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8025c6:	89 d8                	mov    %ebx,%eax
  8025c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025d1:	89 ec                	mov    %ebp,%esp
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8025d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8025d8:	89 04 24             	mov    %eax,(%esp)
  8025db:	e8 87 e1 ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  8025e0:	89 c3                	mov    %eax,%ebx
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	0f 89 fb fe ff ff    	jns    8024e5 <_Z4pipePi+0x51>
  8025ea:	eb c7                	jmp    8025b3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ef:	89 04 24             	mov    %eax,(%esp)
  8025f2:	e8 55 e1 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  8025f7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802600:	00 
  802601:	89 44 24 04          	mov    %eax,0x4(%esp)
  802605:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80260c:	e8 eb db ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  802611:	89 c3                	mov    %eax,%ebx
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 89 f4 fe ff ff    	jns    80250f <_Z4pipePi+0x7b>
  80261b:	eb 83                	jmp    8025a0 <_Z4pipePi+0x10c>

0080261d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802623:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80262a:	00 
  80262b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80262e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	89 04 24             	mov    %eax,(%esp)
  802638:	e8 74 e0 ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  80263d:	85 c0                	test   %eax,%eax
  80263f:	78 15                	js     802656 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	89 04 24             	mov    %eax,(%esp)
  802647:	e8 00 e1 ff ff       	call   80074c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80264c:	89 c2                	mov    %eax,%edx
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	e8 c6 fc ff ff       	call   80231c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	53                   	push   %ebx
  80265c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80265f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802662:	89 04 24             	mov    %eax,(%esp)
  802665:	e8 fd e0 ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  80266a:	89 c3                	mov    %eax,%ebx
  80266c:	85 c0                	test   %eax,%eax
  80266e:	0f 88 be 00 00 00    	js     802732 <_Z18pipe_ipc_recv_readv+0xda>
  802674:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80267b:	00 
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802683:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80268a:	e8 6d db ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	85 c0                	test   %eax,%eax
  802693:	0f 89 a1 00 00 00    	jns    80273a <_Z18pipe_ipc_recv_readv+0xe2>
  802699:	e9 94 00 00 00       	jmp    802732 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	75 0e                	jne    8026b3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8026a5:	c7 04 24 ec 44 80 00 	movl   $0x8044ec,(%esp)
  8026ac:	e8 f9 08 00 00       	call   802faa <_Z7cprintfPKcz>
  8026b1:	eb 10                	jmp    8026c3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8026b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b7:	c7 04 24 a1 44 80 00 	movl   $0x8044a1,(%esp)
  8026be:	e8 e7 08 00 00       	call   802faa <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8026c3:	c7 04 24 ab 44 80 00 	movl   $0x8044ab,(%esp)
  8026ca:	e8 db 08 00 00       	call   802faa <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	a8 04                	test   $0x4,%al
  8026d4:	74 04                	je     8026da <_Z18pipe_ipc_recv_readv+0x82>
  8026d6:	a8 01                	test   $0x1,%al
  8026d8:	75 24                	jne    8026fe <_Z18pipe_ipc_recv_readv+0xa6>
  8026da:	c7 44 24 0c be 44 80 	movl   $0x8044be,0xc(%esp)
  8026e1:	00 
  8026e2:	c7 44 24 08 87 3e 80 	movl   $0x803e87,0x8(%esp)
  8026e9:	00 
  8026ea:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8026f1:	00 
  8026f2:	c7 04 24 db 44 80 00 	movl   $0x8044db,(%esp)
  8026f9:	e8 8e 07 00 00       	call   802e8c <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8026fe:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  802713:	89 04 24             	mov    %eax,(%esp)
  802716:	e8 e9 df ff ff       	call   800704 <_Z6fd2numP2Fd>
  80271b:	89 c3                	mov    %eax,%ebx
  80271d:	eb 13                	jmp    802732 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	89 44 24 04          	mov    %eax,0x4(%esp)
  802726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80272d:	e8 87 db ff ff       	call   8002b9 <_Z14sys_page_unmapiPv>
err:
    return r;
}
  802732:	89 d8                	mov    %ebx,%eax
  802734:	83 c4 24             	add    $0x24,%esp
  802737:	5b                   	pop    %ebx
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	89 04 24             	mov    %eax,(%esp)
  802740:	e8 07 e0 ff ff       	call   80074c <_Z7fd2dataP2Fd>
  802745:	8d 55 ec             	lea    -0x14(%ebp),%edx
  802748:	89 54 24 08          	mov    %edx,0x8(%esp)
  80274c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802753:	89 04 24             	mov    %eax,(%esp)
  802756:	e8 85 13 00 00       	call   803ae0 <_Z8ipc_recvPiPvS_>
  80275b:	89 c3                	mov    %eax,%ebx
  80275d:	85 c0                	test   %eax,%eax
  80275f:	0f 89 39 ff ff ff    	jns    80269e <_Z18pipe_ipc_recv_readv+0x46>
  802765:	eb b8                	jmp    80271f <_Z18pipe_ipc_recv_readv+0xc7>

00802767 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80276d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802774:	00 
  802775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277f:	89 04 24             	mov    %eax,(%esp)
  802782:	e8 2a df ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  802787:	85 c0                	test   %eax,%eax
  802789:	78 2f                	js     8027ba <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	89 04 24             	mov    %eax,(%esp)
  802791:	e8 b6 df ff ff       	call   80074c <_Z7fd2dataP2Fd>
  802796:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80279d:	00 
  80279e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027a9:	00 
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	89 04 24             	mov    %eax,(%esp)
  8027b0:	e8 ba 13 00 00       	call   803b6f <_Z8ipc_sendijPvi>
    return 0;
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	c1 e8 16             	shr    $0x16,%eax
  8027c7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027d3:	f6 c1 01             	test   $0x1,%cl
  8027d6:	74 1d                	je     8027f5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8027d8:	c1 ea 0c             	shr    $0xc,%edx
  8027db:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027e2:	f6 c2 01             	test   $0x1,%dl
  8027e5:	74 0e                	je     8027f5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027e7:	c1 ea 0c             	shr    $0xc,%edx
  8027ea:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8027f1:	ef 
  8027f2:	0f b7 c0             	movzwl %ax,%eax
}
  8027f5:	5d                   	pop    %ebp
  8027f6:	c3                   	ret    
	...

00802800 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802806:	c7 44 24 04 0f 45 80 	movl   $0x80450f,0x4(%esp)
  80280d:	00 
  80280e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802811:	89 04 24             	mov    %eax,(%esp)
  802814:	e8 b1 0d 00 00       	call   8035ca <_Z6strcpyPcPKc>
	return 0;
}
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	53                   	push   %ebx
  802824:	83 ec 14             	sub    $0x14,%esp
  802827:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80282a:	89 1c 24             	mov    %ebx,(%esp)
  80282d:	e8 8a ff ff ff       	call   8027bc <_Z7pagerefPv>
  802832:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802839:	83 fa 01             	cmp    $0x1,%edx
  80283c:	75 0b                	jne    802849 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80283e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802841:	89 04 24             	mov    %eax,(%esp)
  802844:	e8 fe 02 00 00       	call   802b47 <_Z11nsipc_closei>
	else
		return 0;
}
  802849:	83 c4 14             	add    $0x14,%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5d                   	pop    %ebp
  80284e:	c3                   	ret    

0080284f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
  802852:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802855:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80285c:	00 
  80285d:	8b 45 10             	mov    0x10(%ebp),%eax
  802860:	89 44 24 08          	mov    %eax,0x8(%esp)
  802864:	8b 45 0c             	mov    0xc(%ebp),%eax
  802867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 c9 03 00 00       	call   802c42 <_Z10nsipc_sendiPKvij>
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802881:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802888:	00 
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802890:	8b 45 0c             	mov    0xc(%ebp),%eax
  802893:	89 44 24 04          	mov    %eax,0x4(%esp)
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	89 04 24             	mov    %eax,(%esp)
  8028a0:	e8 1d 03 00 00       	call   802bc2 <_Z10nsipc_recviPvij>
}
  8028a5:	c9                   	leave  
  8028a6:	c3                   	ret    

008028a7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 28             	sub    $0x28,%esp
  8028ad:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8028b0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8028b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8028b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b8:	89 04 24             	mov    %eax,(%esp)
  8028bb:	e8 a7 de ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  8028c0:	89 c3                	mov    %eax,%ebx
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	78 21                	js     8028e7 <_ZL12alloc_sockfdi+0x40>
  8028c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028cd:	00 
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028dc:	e8 1b d9 ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  8028e1:	89 c3                	mov    %eax,%ebx
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	79 14                	jns    8028fb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8028e7:	89 34 24             	mov    %esi,(%esp)
  8028ea:	e8 58 02 00 00       	call   802b47 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8028ef:	89 d8                	mov    %ebx,%eax
  8028f1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028f4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028f7:	89 ec                	mov    %ebp,%esp
  8028f9:	5d                   	pop    %ebp
  8028fa:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8028fb:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802910:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802913:	89 04 24             	mov    %eax,(%esp)
  802916:	e8 e9 dd ff ff       	call   800704 <_Z6fd2numP2Fd>
  80291b:	89 c3                	mov    %eax,%ebx
  80291d:	eb d0                	jmp    8028ef <_ZL12alloc_sockfdi+0x48>

0080291f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
  802922:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  802925:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292c:	00 
  80292d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802930:	89 54 24 04          	mov    %edx,0x4(%esp)
  802934:	89 04 24             	mov    %eax,(%esp)
  802937:	e8 75 dd ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  80293c:	85 c0                	test   %eax,%eax
  80293e:	78 15                	js     802955 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802940:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  802943:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802948:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80294e:	39 0a                	cmp    %ecx,(%edx)
  802950:	75 03                	jne    802955 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802952:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
  80295a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	e8 ba ff ff ff       	call   80291f <_ZL9fd2sockidi>
  802965:	85 c0                	test   %eax,%eax
  802967:	78 1f                	js     802988 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802969:	8b 55 10             	mov    0x10(%ebp),%edx
  80296c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802970:	8b 55 0c             	mov    0xc(%ebp),%edx
  802973:	89 54 24 04          	mov    %edx,0x4(%esp)
  802977:	89 04 24             	mov    %eax,(%esp)
  80297a:	e8 19 01 00 00       	call   802a98 <_Z12nsipc_acceptiP8sockaddrPj>
  80297f:	85 c0                	test   %eax,%eax
  802981:	78 05                	js     802988 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  802983:	e8 1f ff ff ff       	call   8028a7 <_ZL12alloc_sockfdi>
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	e8 87 ff ff ff       	call   80291f <_ZL9fd2sockidi>
  802998:	85 c0                	test   %eax,%eax
  80299a:	78 16                	js     8029b2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80299c:	8b 55 10             	mov    0x10(%ebp),%edx
  80299f:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029aa:	89 04 24             	mov    %eax,(%esp)
  8029ad:	e8 34 01 00 00       	call   802ae6 <_Z10nsipc_bindiP8sockaddrj>
}
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
  8029b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	e8 5d ff ff ff       	call   80291f <_ZL9fd2sockidi>
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	78 0f                	js     8029d5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8029c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029cd:	89 04 24             	mov    %eax,(%esp)
  8029d0:	e8 50 01 00 00       	call   802b25 <_Z14nsipc_shutdownii>
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	e8 3a ff ff ff       	call   80291f <_ZL9fd2sockidi>
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	78 16                	js     8029ff <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8029e9:	8b 55 10             	mov    0x10(%ebp),%edx
  8029ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029f7:	89 04 24             	mov    %eax,(%esp)
  8029fa:	e8 62 01 00 00       	call   802b61 <_Z13nsipc_connectiPK8sockaddrj>
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <_Z6listenii>:

int
listen(int s, int backlog)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	e8 10 ff ff ff       	call   80291f <_ZL9fd2sockidi>
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	78 0f                	js     802a22 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a16:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a1a:	89 04 24             	mov    %eax,(%esp)
  802a1d:	e8 7e 01 00 00       	call   802ba0 <_Z12nsipc_listenii>
}
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
  802a27:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	89 04 24             	mov    %eax,(%esp)
  802a3e:	e8 72 02 00 00       	call   802cb5 <_Z12nsipc_socketiii>
  802a43:	85 c0                	test   %eax,%eax
  802a45:	78 05                	js     802a4c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  802a47:	e8 5b fe ff ff       	call   8028a7 <_ZL12alloc_sockfdi>
}
  802a4c:	c9                   	leave  
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	c3                   	ret    
  802a51:	00 00                	add    %al,(%eax)
	...

00802a54 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802a5a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802a61:	00 
  802a62:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802a69:	00 
  802a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  802a75:	e8 f5 10 00 00       	call   803b6f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  802a7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a81:	00 
  802a82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a89:	00 
  802a8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a91:	e8 4a 10 00 00       	call   803ae0 <_Z8ipc_recvPiPvS_>
}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    

00802a98 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
  802a9b:	53                   	push   %ebx
  802a9c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802aa7:	b8 01 00 00 00       	mov    $0x1,%eax
  802aac:	e8 a3 ff ff ff       	call   802a54 <_ZL5nsipcj>
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	78 27                	js     802ade <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  802ab7:	a1 10 70 80 00       	mov    0x807010,%eax
  802abc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ac0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ac7:	00 
  802ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802acb:	89 04 24             	mov    %eax,(%esp)
  802ace:	e8 99 0c 00 00       	call   80376c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  802ad3:	8b 15 10 70 80 00    	mov    0x807010,%edx
  802ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  802adc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802ade:	89 d8                	mov    %ebx,%eax
  802ae0:	83 c4 14             	add    $0x14,%esp
  802ae3:	5b                   	pop    %ebx
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    

00802ae6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ae6:	55                   	push   %ebp
  802ae7:	89 e5                	mov    %esp,%ebp
  802ae9:	53                   	push   %ebx
  802aea:	83 ec 14             	sub    $0x14,%esp
  802aed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802af8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b03:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802b0a:	e8 5d 0c 00 00       	call   80376c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802b0f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802b15:	b8 02 00 00 00       	mov    $0x2,%eax
  802b1a:	e8 35 ff ff ff       	call   802a54 <_ZL5nsipcj>
}
  802b1f:	83 c4 14             	add    $0x14,%esp
  802b22:	5b                   	pop    %ebx
  802b23:	5d                   	pop    %ebp
  802b24:	c3                   	ret    

00802b25 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  802b25:	55                   	push   %ebp
  802b26:	89 e5                	mov    %esp,%ebp
  802b28:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b36:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802b3b:	b8 03 00 00 00       	mov    $0x3,%eax
  802b40:	e8 0f ff ff ff       	call   802a54 <_ZL5nsipcj>
}
  802b45:	c9                   	leave  
  802b46:	c3                   	ret    

00802b47 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
  802b4a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802b55:	b8 04 00 00 00       	mov    $0x4,%eax
  802b5a:	e8 f5 fe ff ff       	call   802a54 <_ZL5nsipcj>
}
  802b5f:	c9                   	leave  
  802b60:	c3                   	ret    

00802b61 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b61:	55                   	push   %ebp
  802b62:	89 e5                	mov    %esp,%ebp
  802b64:	53                   	push   %ebx
  802b65:	83 ec 14             	sub    $0x14,%esp
  802b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b7e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802b85:	e8 e2 0b 00 00       	call   80376c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802b8a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802b90:	b8 05 00 00 00       	mov    $0x5,%eax
  802b95:	e8 ba fe ff ff       	call   802a54 <_ZL5nsipcj>
}
  802b9a:	83 c4 14             	add    $0x14,%esp
  802b9d:	5b                   	pop    %ebx
  802b9e:	5d                   	pop    %ebp
  802b9f:	c3                   	ret    

00802ba0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802bb6:	b8 06 00 00 00       	mov    $0x6,%eax
  802bbb:	e8 94 fe ff ff       	call   802a54 <_ZL5nsipcj>
}
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
  802bc5:	56                   	push   %esi
  802bc6:	53                   	push   %ebx
  802bc7:	83 ec 10             	sub    $0x10,%esp
  802bca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802bd5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  802bde:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802be3:	b8 07 00 00 00       	mov    $0x7,%eax
  802be8:	e8 67 fe ff ff       	call   802a54 <_ZL5nsipcj>
  802bed:	89 c3                	mov    %eax,%ebx
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	78 46                	js     802c39 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  802bf3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802bf8:	7f 04                	jg     802bfe <_Z10nsipc_recviPvij+0x3c>
  802bfa:	39 f0                	cmp    %esi,%eax
  802bfc:	7e 24                	jle    802c22 <_Z10nsipc_recviPvij+0x60>
  802bfe:	c7 44 24 0c 1b 45 80 	movl   $0x80451b,0xc(%esp)
  802c05:	00 
  802c06:	c7 44 24 08 87 3e 80 	movl   $0x803e87,0x8(%esp)
  802c0d:	00 
  802c0e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  802c15:	00 
  802c16:	c7 04 24 30 45 80 00 	movl   $0x804530,(%esp)
  802c1d:	e8 6a 02 00 00       	call   802e8c <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802c22:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c26:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802c2d:	00 
  802c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c31:	89 04 24             	mov    %eax,(%esp)
  802c34:	e8 33 0b 00 00       	call   80376c <memmove>
	}

	return r;
}
  802c39:	89 d8                	mov    %ebx,%eax
  802c3b:	83 c4 10             	add    $0x10,%esp
  802c3e:	5b                   	pop    %ebx
  802c3f:	5e                   	pop    %esi
  802c40:	5d                   	pop    %ebp
  802c41:	c3                   	ret    

00802c42 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	53                   	push   %ebx
  802c46:	83 ec 14             	sub    $0x14,%esp
  802c49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802c54:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c5a:	7e 24                	jle    802c80 <_Z10nsipc_sendiPKvij+0x3e>
  802c5c:	c7 44 24 0c 3c 45 80 	movl   $0x80453c,0xc(%esp)
  802c63:	00 
  802c64:	c7 44 24 08 87 3e 80 	movl   $0x803e87,0x8(%esp)
  802c6b:	00 
  802c6c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  802c73:	00 
  802c74:	c7 04 24 30 45 80 00 	movl   $0x804530,(%esp)
  802c7b:	e8 0c 02 00 00       	call   802e8c <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c80:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c8b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802c92:	e8 d5 0a 00 00       	call   80376c <memmove>
	nsipcbuf.send.req_size = size;
  802c97:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  802ca0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802ca5:	b8 08 00 00 00       	mov    $0x8,%eax
  802caa:	e8 a5 fd ff ff       	call   802a54 <_ZL5nsipcj>
}
  802caf:	83 c4 14             	add    $0x14,%esp
  802cb2:	5b                   	pop    %ebx
  802cb3:	5d                   	pop    %ebp
  802cb4:	c3                   	ret    

00802cb5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802cb5:	55                   	push   %ebp
  802cb6:	89 e5                	mov    %esp,%ebp
  802cb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  802cce:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802cd3:	b8 09 00 00 00       	mov    $0x9,%eax
  802cd8:	e8 77 fd ff ff       	call   802a54 <_ZL5nsipcj>
}
  802cdd:	c9                   	leave  
  802cde:	c3                   	ret    
	...

00802ce0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce8:	5d                   	pop    %ebp
  802ce9:	c3                   	ret    

00802cea <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802cf0:	c7 44 24 04 48 45 80 	movl   $0x804548,0x4(%esp)
  802cf7:	00 
  802cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfb:	89 04 24             	mov    %eax,(%esp)
  802cfe:	e8 c7 08 00 00       	call   8035ca <_Z6strcpyPcPKc>
	return 0;
}
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	c9                   	leave  
  802d09:	c3                   	ret    

00802d0a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
  802d0d:	57                   	push   %edi
  802d0e:	56                   	push   %esi
  802d0f:	53                   	push   %ebx
  802d10:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d1f:	74 3e                	je     802d5f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d21:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802d27:	8b 75 10             	mov    0x10(%ebp),%esi
  802d2a:	29 de                	sub    %ebx,%esi
  802d2c:	83 fe 7f             	cmp    $0x7f,%esi
  802d2f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d34:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d37:	89 74 24 08          	mov    %esi,0x8(%esp)
  802d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3e:	01 d8                	add    %ebx,%eax
  802d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d44:	89 3c 24             	mov    %edi,(%esp)
  802d47:	e8 20 0a 00 00       	call   80376c <memmove>
		sys_cputs(buf, m);
  802d4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d50:	89 3c 24             	mov    %edi,(%esp)
  802d53:	e8 78 d3 ff ff       	call   8000d0 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d58:	01 f3                	add    %esi,%ebx
  802d5a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  802d5d:	77 c8                	ja     802d27 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802d5f:	89 d8                	mov    %ebx,%eax
  802d61:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802d67:	5b                   	pop    %ebx
  802d68:	5e                   	pop    %esi
  802d69:	5f                   	pop    %edi
  802d6a:	5d                   	pop    %ebp
  802d6b:	c3                   	ret    

00802d6c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d6c:	55                   	push   %ebp
  802d6d:	89 e5                	mov    %esp,%ebp
  802d6f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d7b:	75 07                	jne    802d84 <_ZL12devcons_readP2FdPvj+0x18>
  802d7d:	eb 2a                	jmp    802da9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802d7f:	e8 44 d4 ff ff       	call   8001c8 <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802d84:	e8 7a d3 ff ff       	call   800103 <_Z9sys_cgetcv>
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 f2                	je     802d7f <_ZL12devcons_readP2FdPvj+0x13>
  802d8d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	78 16                	js     802da9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802d93:	83 f8 04             	cmp    $0x4,%eax
  802d96:	74 0c                	je     802da4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  802d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9b:	88 10                	mov    %dl,(%eax)
	return 1;
  802d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802da2:	eb 05                	jmp    802da9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802da4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802da9:	c9                   	leave  
  802daa:	c3                   	ret    

00802dab <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802dab:	55                   	push   %ebp
  802dac:	89 e5                	mov    %esp,%ebp
  802dae:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802db7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802dbe:	00 
  802dbf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802dc2:	89 04 24             	mov    %eax,(%esp)
  802dc5:	e8 06 d3 ff ff       	call   8000d0 <_Z9sys_cputsPKcj>
}
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <_Z7getcharv>:

int
getchar(void)
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
  802dcf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802dd2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802dd9:	00 
  802dda:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de8:	e8 71 dc ff ff       	call   800a5e <_Z4readiPvj>
	if (r < 0)
  802ded:	85 c0                	test   %eax,%eax
  802def:	78 0f                	js     802e00 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  802df1:	85 c0                	test   %eax,%eax
  802df3:	7e 06                	jle    802dfb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  802df5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802df9:	eb 05                	jmp    802e00 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802dfb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802e00:	c9                   	leave  
  802e01:	c3                   	ret    

00802e02 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  802e02:	55                   	push   %ebp
  802e03:	89 e5                	mov    %esp,%ebp
  802e05:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802e08:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e0f:	00 
  802e10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	89 04 24             	mov    %eax,(%esp)
  802e1d:	e8 8f d8 ff ff       	call   8006b1 <_Z9fd_lookupiPP2Fdb>
  802e22:	85 c0                	test   %eax,%eax
  802e24:	78 11                	js     802e37 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 15 58 50 80 00    	mov    0x805058,%edx
  802e2f:	39 10                	cmp    %edx,(%eax)
  802e31:	0f 94 c0             	sete   %al
  802e34:	0f b6 c0             	movzbl %al,%eax
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <_Z8openconsv>:

int
opencons(void)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  802e3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e42:	89 04 24             	mov    %eax,(%esp)
  802e45:	e8 1d d9 ff ff       	call   800767 <_Z14fd_find_unusedPP2Fd>
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	78 3c                	js     802e8a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e4e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e55:	00 
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e64:	e8 93 d3 ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	78 1d                	js     802e8a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802e6d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e82:	89 04 24             	mov    %eax,(%esp)
  802e85:	e8 7a d8 ff ff       	call   800704 <_Z6fd2numP2Fd>
}
  802e8a:	c9                   	leave  
  802e8b:	c3                   	ret    

00802e8c <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802e8c:	55                   	push   %ebp
  802e8d:	89 e5                	mov    %esp,%ebp
  802e8f:	56                   	push   %esi
  802e90:	53                   	push   %ebx
  802e91:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802e94:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  802e97:	a1 00 80 80 00       	mov    0x808000,%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 10                	je     802eb0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  802ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ea4:	c7 04 24 54 45 80 00 	movl   $0x804554,(%esp)
  802eab:	e8 fa 00 00 00       	call   802faa <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  802eb0:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  802eb6:	e8 d9 d2 ff ff       	call   800194 <_Z12sys_getenvidv>
  802ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebe:	89 54 24 10          	mov    %edx,0x10(%esp)
  802ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802ec9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed1:	c7 04 24 5c 45 80 00 	movl   $0x80455c,(%esp)
  802ed8:	e8 cd 00 00 00       	call   802faa <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  802edd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee4:	89 04 24             	mov    %eax,(%esp)
  802ee7:	e8 5d 00 00 00       	call   802f49 <_Z8vcprintfPKcPc>
	cprintf("\n");
  802eec:	c7 04 24 9f 44 80 00 	movl   $0x80449f,(%esp)
  802ef3:	e8 b2 00 00 00       	call   802faa <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802ef8:	cc                   	int3   
  802ef9:	eb fd                	jmp    802ef8 <_Z6_panicPKciS0_z+0x6c>
	...

00802efc <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
  802eff:	83 ec 18             	sub    $0x18,%esp
  802f02:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802f05:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802f08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  802f0b:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  802f0d:	8b 03                	mov    (%ebx),%eax
  802f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f12:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  802f16:	83 c0 01             	add    $0x1,%eax
  802f19:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  802f1b:	3d ff 00 00 00       	cmp    $0xff,%eax
  802f20:	75 19                	jne    802f3b <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  802f22:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  802f29:	00 
  802f2a:	8d 43 08             	lea    0x8(%ebx),%eax
  802f2d:	89 04 24             	mov    %eax,(%esp)
  802f30:	e8 9b d1 ff ff       	call   8000d0 <_Z9sys_cputsPKcj>
		b->idx = 0;
  802f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  802f3b:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  802f3f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f42:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f45:	89 ec                	mov    %ebp,%esp
  802f47:	5d                   	pop    %ebp
  802f48:	c3                   	ret    

00802f49 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
  802f4c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  802f52:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802f59:	00 00 00 
	b.cnt = 0;
  802f5c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  802f63:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f74:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f7e:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  802f85:	e8 ad 01 00 00       	call   803137 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  802f8a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802f90:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f94:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  802f9a:	89 04 24             	mov    %eax,(%esp)
  802f9d:	e8 2e d1 ff ff       	call   8000d0 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  802fa2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    

00802faa <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
  802fad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fb0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  802fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	89 04 24             	mov    %eax,(%esp)
  802fbd:	e8 87 ff ff ff       	call   802f49 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  802fc2:	c9                   	leave  
  802fc3:	c3                   	ret    
	...

00802fd0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	57                   	push   %edi
  802fd4:	56                   	push   %esi
  802fd5:	53                   	push   %ebx
  802fd6:	83 ec 4c             	sub    $0x4c,%esp
  802fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802fdc:	89 d6                	mov    %edx,%esi
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  802fea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fed:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff5:	39 d0                	cmp    %edx,%eax
  802ff7:	72 11                	jb     80300a <_ZL8printnumPFviPvES_yjii+0x3a>
  802ff9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802ffc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  802fff:	76 09                	jbe    80300a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803001:	83 eb 01             	sub    $0x1,%ebx
  803004:	85 db                	test   %ebx,%ebx
  803006:	7f 5d                	jg     803065 <_ZL8printnumPFviPvES_yjii+0x95>
  803008:	eb 6c                	jmp    803076 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80300a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80300e:	83 eb 01             	sub    $0x1,%ebx
  803011:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803015:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803018:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80301c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803020:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803024:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803027:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80302a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803031:	00 
  803032:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803035:	89 14 24             	mov    %edx,(%esp)
  803038:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80303b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80303f:	e8 9c 0b 00 00       	call   803be0 <__udivdi3>
  803044:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  803047:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80304a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80304e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803052:	89 04 24             	mov    %eax,(%esp)
  803055:	89 54 24 04          	mov    %edx,0x4(%esp)
  803059:	89 f2                	mov    %esi,%edx
  80305b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305e:	e8 6d ff ff ff       	call   802fd0 <_ZL8printnumPFviPvES_yjii>
  803063:	eb 11                	jmp    803076 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  803065:	89 74 24 04          	mov    %esi,0x4(%esp)
  803069:	89 3c 24             	mov    %edi,(%esp)
  80306c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80306f:	83 eb 01             	sub    $0x1,%ebx
  803072:	85 db                	test   %ebx,%ebx
  803074:	7f ef                	jg     803065 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803076:	89 74 24 04          	mov    %esi,0x4(%esp)
  80307a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80307e:	8b 45 10             	mov    0x10(%ebp),%eax
  803081:	89 44 24 08          	mov    %eax,0x8(%esp)
  803085:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80308c:	00 
  80308d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803090:	89 14 24             	mov    %edx,(%esp)
  803093:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803096:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80309a:	e8 51 0c 00 00       	call   803cf0 <__umoddi3>
  80309f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030a3:	0f be 80 7f 45 80 00 	movsbl 0x80457f(%eax),%eax
  8030aa:	89 04 24             	mov    %eax,(%esp)
  8030ad:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8030b0:	83 c4 4c             	add    $0x4c,%esp
  8030b3:	5b                   	pop    %ebx
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    

008030b8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8030bb:	83 fa 01             	cmp    $0x1,%edx
  8030be:	7e 0e                	jle    8030ce <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8030c0:	8b 10                	mov    (%eax),%edx
  8030c2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8030c5:	89 08                	mov    %ecx,(%eax)
  8030c7:	8b 02                	mov    (%edx),%eax
  8030c9:	8b 52 04             	mov    0x4(%edx),%edx
  8030cc:	eb 22                	jmp    8030f0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8030ce:	85 d2                	test   %edx,%edx
  8030d0:	74 10                	je     8030e2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8030d2:	8b 10                	mov    (%eax),%edx
  8030d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8030d7:	89 08                	mov    %ecx,(%eax)
  8030d9:	8b 02                	mov    (%edx),%eax
  8030db:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e0:	eb 0e                	jmp    8030f0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8030e2:	8b 10                	mov    (%eax),%edx
  8030e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8030e7:	89 08                	mov    %ecx,(%eax)
  8030e9:	8b 02                	mov    (%edx),%eax
  8030eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8030f0:	5d                   	pop    %ebp
  8030f1:	c3                   	ret    

008030f2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
  8030f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8030f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8030fc:	8b 10                	mov    (%eax),%edx
  8030fe:	3b 50 04             	cmp    0x4(%eax),%edx
  803101:	73 0a                	jae    80310d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  803103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803106:	88 0a                	mov    %cl,(%edx)
  803108:	83 c2 01             	add    $0x1,%edx
  80310b:	89 10                	mov    %edx,(%eax)
}
  80310d:	5d                   	pop    %ebp
  80310e:	c3                   	ret    

0080310f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
  803112:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  803115:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  803118:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80311c:	8b 45 10             	mov    0x10(%ebp),%eax
  80311f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803123:	8b 45 0c             	mov    0xc(%ebp),%eax
  803126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	89 04 24             	mov    %eax,(%esp)
  803130:	e8 02 00 00 00       	call   803137 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  803135:	c9                   	leave  
  803136:	c3                   	ret    

00803137 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803137:	55                   	push   %ebp
  803138:	89 e5                	mov    %esp,%ebp
  80313a:	57                   	push   %edi
  80313b:	56                   	push   %esi
  80313c:	53                   	push   %ebx
  80313d:	83 ec 3c             	sub    $0x3c,%esp
  803140:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803143:	8b 55 10             	mov    0x10(%ebp),%edx
  803146:	0f b6 02             	movzbl (%edx),%eax
  803149:	89 d3                	mov    %edx,%ebx
  80314b:	83 c3 01             	add    $0x1,%ebx
  80314e:	83 f8 25             	cmp    $0x25,%eax
  803151:	74 2b                	je     80317e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  803153:	85 c0                	test   %eax,%eax
  803155:	75 10                	jne    803167 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  803157:	e9 a5 03 00 00       	jmp    803501 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80315c:	85 c0                	test   %eax,%eax
  80315e:	66 90                	xchg   %ax,%ax
  803160:	75 08                	jne    80316a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  803162:	e9 9a 03 00 00       	jmp    803501 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  803167:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80316a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80316e:	89 04 24             	mov    %eax,(%esp)
  803171:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803173:	0f b6 03             	movzbl (%ebx),%eax
  803176:	83 c3 01             	add    $0x1,%ebx
  803179:	83 f8 25             	cmp    $0x25,%eax
  80317c:	75 de                	jne    80315c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80317e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  803182:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  803189:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80318e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  803195:	b9 00 00 00 00       	mov    $0x0,%ecx
  80319a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80319d:	eb 2b                	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80319f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8031a2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8031a6:	eb 22                	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8031a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8031ab:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8031af:	eb 19                	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8031b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8031b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8031bb:	eb 0d                	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8031bd:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8031c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8031c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8031ca:	0f b6 03             	movzbl (%ebx),%eax
  8031cd:	0f b6 d0             	movzbl %al,%edx
  8031d0:	8d 73 01             	lea    0x1(%ebx),%esi
  8031d3:	89 75 10             	mov    %esi,0x10(%ebp)
  8031d6:	83 e8 23             	sub    $0x23,%eax
  8031d9:	3c 55                	cmp    $0x55,%al
  8031db:	0f 87 d8 02 00 00    	ja     8034b9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8031e1:	0f b6 c0             	movzbl %al,%eax
  8031e4:	ff 24 85 20 47 80 00 	jmp    *0x804720(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8031eb:	83 ea 30             	sub    $0x30,%edx
  8031ee:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8031f1:	8b 55 10             	mov    0x10(%ebp),%edx
  8031f4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8031f7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8031fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8031fd:	83 fa 09             	cmp    $0x9,%edx
  803200:	77 4e                	ja     803250 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803202:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803205:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  803208:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80320b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80320f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  803212:	8d 50 d0             	lea    -0x30(%eax),%edx
  803215:	83 fa 09             	cmp    $0x9,%edx
  803218:	76 eb                	jbe    803205 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80321a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80321d:	eb 31                	jmp    803250 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80321f:	8b 45 14             	mov    0x14(%ebp),%eax
  803222:	8d 50 04             	lea    0x4(%eax),%edx
  803225:	89 55 14             	mov    %edx,0x14(%ebp)
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80322d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  803230:	eb 1e                	jmp    803250 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  803232:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803236:	0f 88 75 ff ff ff    	js     8031b1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80323c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80323f:	eb 89                	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  803241:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  803244:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80324b:	e9 7a ff ff ff       	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  803250:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803254:	0f 89 70 ff ff ff    	jns    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80325a:	e9 5e ff ff ff       	jmp    8031bd <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80325f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803262:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803265:	e9 60 ff ff ff       	jmp    8031ca <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80326a:	8b 45 14             	mov    0x14(%ebp),%eax
  80326d:	8d 50 04             	lea    0x4(%eax),%edx
  803270:	89 55 14             	mov    %edx,0x14(%ebp)
  803273:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803277:	8b 00                	mov    (%eax),%eax
  803279:	89 04 24             	mov    %eax,(%esp)
  80327c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80327f:	e9 bf fe ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  803284:	8b 45 14             	mov    0x14(%ebp),%eax
  803287:	8d 50 04             	lea    0x4(%eax),%edx
  80328a:	89 55 14             	mov    %edx,0x14(%ebp)
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	89 c2                	mov    %eax,%edx
  803291:	c1 fa 1f             	sar    $0x1f,%edx
  803294:	31 d0                	xor    %edx,%eax
  803296:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  803298:	83 f8 14             	cmp    $0x14,%eax
  80329b:	7f 0f                	jg     8032ac <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80329d:	8b 14 85 80 48 80 00 	mov    0x804880(,%eax,4),%edx
  8032a4:	85 d2                	test   %edx,%edx
  8032a6:	0f 85 35 02 00 00    	jne    8034e1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8032ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032b0:	c7 44 24 08 97 45 80 	movl   $0x804597,0x8(%esp)
  8032b7:	00 
  8032b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8032bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8032bf:	89 34 24             	mov    %esi,(%esp)
  8032c2:	e8 48 fe ff ff       	call   80310f <_Z8printfmtPFviPvES_PKcz>
  8032c7:	e9 77 fe ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8032cc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8032d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8032d8:	8d 50 04             	lea    0x4(%eax),%edx
  8032db:	89 55 14             	mov    %edx,0x14(%ebp)
  8032de:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8032e0:	85 db                	test   %ebx,%ebx
  8032e2:	ba 90 45 80 00       	mov    $0x804590,%edx
  8032e7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8032ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032ee:	7e 72                	jle    803362 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8032f0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8032f4:	74 6c                	je     803362 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8032f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032fa:	89 1c 24             	mov    %ebx,(%esp)
  8032fd:	e8 a9 02 00 00       	call   8035ab <_Z7strnlenPKcj>
  803302:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803305:	29 c2                	sub    %eax,%edx
  803307:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80330a:	85 d2                	test   %edx,%edx
  80330c:	7e 54                	jle    803362 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80330e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  803312:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  803315:	89 d3                	mov    %edx,%ebx
  803317:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80331a:	89 c6                	mov    %eax,%esi
  80331c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803320:	89 34 24             	mov    %esi,(%esp)
  803323:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803326:	83 eb 01             	sub    $0x1,%ebx
  803329:	85 db                	test   %ebx,%ebx
  80332b:	7f ef                	jg     80331c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80332d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  803330:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803333:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80333a:	eb 26                	jmp    803362 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80333c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80333f:	83 fa 5e             	cmp    $0x5e,%edx
  803342:	76 10                	jbe    803354 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  803344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803348:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80334f:	ff 55 08             	call   *0x8(%ebp)
  803352:	eb 0a                	jmp    80335e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  803354:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803358:	89 04 24             	mov    %eax,(%esp)
  80335b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80335e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  803362:	0f be 03             	movsbl (%ebx),%eax
  803365:	83 c3 01             	add    $0x1,%ebx
  803368:	85 c0                	test   %eax,%eax
  80336a:	74 11                	je     80337d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80336c:	85 f6                	test   %esi,%esi
  80336e:	78 05                	js     803375 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  803370:	83 ee 01             	sub    $0x1,%esi
  803373:	78 0d                	js     803382 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  803375:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803379:	75 c1                	jne    80333c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80337b:	eb d7                	jmp    803354 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80337d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803380:	eb 03                	jmp    803385 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  803382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803385:	85 c0                	test   %eax,%eax
  803387:	0f 8e b6 fd ff ff    	jle    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80338d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  803390:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  803393:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803397:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80339e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8033a0:	83 eb 01             	sub    $0x1,%ebx
  8033a3:	85 db                	test   %ebx,%ebx
  8033a5:	7f ec                	jg     803393 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8033a7:	e9 97 fd ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8033ac:	83 f9 01             	cmp    $0x1,%ecx
  8033af:	90                   	nop
  8033b0:	7e 10                	jle    8033c2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8033b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8033b5:	8d 50 08             	lea    0x8(%eax),%edx
  8033b8:	89 55 14             	mov    %edx,0x14(%ebp)
  8033bb:	8b 18                	mov    (%eax),%ebx
  8033bd:	8b 70 04             	mov    0x4(%eax),%esi
  8033c0:	eb 26                	jmp    8033e8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8033c2:	85 c9                	test   %ecx,%ecx
  8033c4:	74 12                	je     8033d8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8033c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8033c9:	8d 50 04             	lea    0x4(%eax),%edx
  8033cc:	89 55 14             	mov    %edx,0x14(%ebp)
  8033cf:	8b 18                	mov    (%eax),%ebx
  8033d1:	89 de                	mov    %ebx,%esi
  8033d3:	c1 fe 1f             	sar    $0x1f,%esi
  8033d6:	eb 10                	jmp    8033e8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8033d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8033db:	8d 50 04             	lea    0x4(%eax),%edx
  8033de:	89 55 14             	mov    %edx,0x14(%ebp)
  8033e1:	8b 18                	mov    (%eax),%ebx
  8033e3:	89 de                	mov    %ebx,%esi
  8033e5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8033e8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8033ed:	85 f6                	test   %esi,%esi
  8033ef:	0f 89 8c 00 00 00    	jns    803481 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8033f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8033f9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  803400:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  803403:	f7 db                	neg    %ebx
  803405:	83 d6 00             	adc    $0x0,%esi
  803408:	f7 de                	neg    %esi
			}
			base = 10;
  80340a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80340f:	eb 70                	jmp    803481 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  803411:	89 ca                	mov    %ecx,%edx
  803413:	8d 45 14             	lea    0x14(%ebp),%eax
  803416:	e8 9d fc ff ff       	call   8030b8 <_ZL7getuintPPci>
  80341b:	89 c3                	mov    %eax,%ebx
  80341d:	89 d6                	mov    %edx,%esi
			base = 10;
  80341f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  803424:	eb 5b                	jmp    803481 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  803426:	89 ca                	mov    %ecx,%edx
  803428:	8d 45 14             	lea    0x14(%ebp),%eax
  80342b:	e8 88 fc ff ff       	call   8030b8 <_ZL7getuintPPci>
  803430:	89 c3                	mov    %eax,%ebx
  803432:	89 d6                	mov    %edx,%esi
			base = 8;
  803434:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  803439:	eb 46                	jmp    803481 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80343b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80343f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  803446:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  803449:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80344d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  803454:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  803457:	8b 45 14             	mov    0x14(%ebp),%eax
  80345a:	8d 50 04             	lea    0x4(%eax),%edx
  80345d:	89 55 14             	mov    %edx,0x14(%ebp)
  803460:	8b 18                	mov    (%eax),%ebx
  803462:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  803467:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80346c:	eb 13                	jmp    803481 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80346e:	89 ca                	mov    %ecx,%edx
  803470:	8d 45 14             	lea    0x14(%ebp),%eax
  803473:	e8 40 fc ff ff       	call   8030b8 <_ZL7getuintPPci>
  803478:	89 c3                	mov    %eax,%ebx
  80347a:	89 d6                	mov    %edx,%esi
			base = 16;
  80347c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  803481:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  803485:	89 54 24 10          	mov    %edx,0x10(%esp)
  803489:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803490:	89 44 24 08          	mov    %eax,0x8(%esp)
  803494:	89 1c 24             	mov    %ebx,(%esp)
  803497:	89 74 24 04          	mov    %esi,0x4(%esp)
  80349b:	89 fa                	mov    %edi,%edx
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	e8 2b fb ff ff       	call   802fd0 <_ZL8printnumPFviPvES_yjii>
			break;
  8034a5:	e9 99 fc ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8034aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8034ae:	89 14 24             	mov    %edx,(%esp)
  8034b1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8034b4:	e9 8a fc ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8034b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8034bd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8034c4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8034c7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8034ca:	89 d8                	mov    %ebx,%eax
  8034cc:	eb 02                	jmp    8034d0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8034ce:	89 d0                	mov    %edx,%eax
  8034d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034d3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8034d7:	75 f5                	jne    8034ce <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8034d9:	89 45 10             	mov    %eax,0x10(%ebp)
  8034dc:	e9 62 fc ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8034e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8034e5:	c7 44 24 08 99 3e 80 	movl   $0x803e99,0x8(%esp)
  8034ec:	00 
  8034ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8034f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8034f4:	89 34 24             	mov    %esi,(%esp)
  8034f7:	e8 13 fc ff ff       	call   80310f <_Z8printfmtPFviPvES_PKcz>
  8034fc:	e9 42 fc ff ff       	jmp    803143 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  803501:	83 c4 3c             	add    $0x3c,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5f                   	pop    %edi
  803507:	5d                   	pop    %ebp
  803508:	c3                   	ret    

00803509 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803509:	55                   	push   %ebp
  80350a:	89 e5                	mov    %esp,%ebp
  80350c:	83 ec 28             	sub    $0x28,%esp
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  803515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80351c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80351f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  803523:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  803526:	85 c0                	test   %eax,%eax
  803528:	74 30                	je     80355a <_Z9vsnprintfPciPKcS_+0x51>
  80352a:	85 d2                	test   %edx,%edx
  80352c:	7e 2c                	jle    80355a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80352e:	8b 45 14             	mov    0x14(%ebp),%eax
  803531:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803535:	8b 45 10             	mov    0x10(%ebp),%eax
  803538:	89 44 24 08          	mov    %eax,0x8(%esp)
  80353c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80353f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803543:	c7 04 24 f2 30 80 00 	movl   $0x8030f2,(%esp)
  80354a:	e8 e8 fb ff ff       	call   803137 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803552:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	eb 05                	jmp    80355f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80355a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
  803564:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  803567:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80356a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356e:	8b 45 10             	mov    0x10(%ebp),%eax
  803571:	89 44 24 08          	mov    %eax,0x8(%esp)
  803575:	8b 45 0c             	mov    0xc(%ebp),%eax
  803578:	89 44 24 04          	mov    %eax,0x4(%esp)
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	89 04 24             	mov    %eax,(%esp)
  803582:	e8 82 ff ff ff       	call   803509 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  803587:	c9                   	leave  
  803588:	c3                   	ret    
  803589:	00 00                	add    %al,(%eax)
  80358b:	00 00                	add    %al,(%eax)
  80358d:	00 00                	add    %al,(%eax)
	...

00803590 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803590:	55                   	push   %ebp
  803591:	89 e5                	mov    %esp,%ebp
  803593:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  803596:	b8 00 00 00 00       	mov    $0x0,%eax
  80359b:	80 3a 00             	cmpb   $0x0,(%edx)
  80359e:	74 09                	je     8035a9 <_Z6strlenPKc+0x19>
		n++;
  8035a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8035a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8035a7:	75 f7                	jne    8035a0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  8035a9:	5d                   	pop    %ebp
  8035aa:	c3                   	ret    

008035ab <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  8035ab:	55                   	push   %ebp
  8035ac:	89 e5                	mov    %esp,%ebp
  8035ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8035b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b9:	39 c2                	cmp    %eax,%edx
  8035bb:	74 0b                	je     8035c8 <_Z7strnlenPKcj+0x1d>
  8035bd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8035c1:	74 05                	je     8035c8 <_Z7strnlenPKcj+0x1d>
		n++;
  8035c3:	83 c0 01             	add    $0x1,%eax
  8035c6:	eb f1                	jmp    8035b9 <_Z7strnlenPKcj+0xe>
	return n;
}
  8035c8:	5d                   	pop    %ebp
  8035c9:	c3                   	ret    

008035ca <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  8035ca:	55                   	push   %ebp
  8035cb:	89 e5                	mov    %esp,%ebp
  8035cd:	53                   	push   %ebx
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  8035d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8035dd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8035e0:	83 c2 01             	add    $0x1,%edx
  8035e3:	84 c9                	test   %cl,%cl
  8035e5:	75 f2                	jne    8035d9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8035e7:	5b                   	pop    %ebx
  8035e8:	5d                   	pop    %ebp
  8035e9:	c3                   	ret    

008035ea <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
  8035ed:	56                   	push   %esi
  8035ee:	53                   	push   %ebx
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8035f8:	85 f6                	test   %esi,%esi
  8035fa:	74 18                	je     803614 <_Z7strncpyPcPKcj+0x2a>
  8035fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  803601:	0f b6 1a             	movzbl (%edx),%ebx
  803604:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  803607:	80 3a 01             	cmpb   $0x1,(%edx)
  80360a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80360d:	83 c1 01             	add    $0x1,%ecx
  803610:	39 ce                	cmp    %ecx,%esi
  803612:	77 ed                	ja     803601 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    

00803618 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
  80361b:	56                   	push   %esi
  80361c:	53                   	push   %ebx
  80361d:	8b 75 08             	mov    0x8(%ebp),%esi
  803620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803623:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  803626:	89 f0                	mov    %esi,%eax
  803628:	85 d2                	test   %edx,%edx
  80362a:	74 17                	je     803643 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80362c:	83 ea 01             	sub    $0x1,%edx
  80362f:	74 18                	je     803649 <_Z7strlcpyPcPKcj+0x31>
  803631:	80 39 00             	cmpb   $0x0,(%ecx)
  803634:	74 17                	je     80364d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  803636:	0f b6 19             	movzbl (%ecx),%ebx
  803639:	88 18                	mov    %bl,(%eax)
  80363b:	83 c0 01             	add    $0x1,%eax
  80363e:	83 c1 01             	add    $0x1,%ecx
  803641:	eb e9                	jmp    80362c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  803643:	29 f0                	sub    %esi,%eax
}
  803645:	5b                   	pop    %ebx
  803646:	5e                   	pop    %esi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803649:	89 c2                	mov    %eax,%edx
  80364b:	eb 02                	jmp    80364f <_Z7strlcpyPcPKcj+0x37>
  80364d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80364f:	c6 02 00             	movb   $0x0,(%edx)
  803652:	eb ef                	jmp    803643 <_Z7strlcpyPcPKcj+0x2b>

00803654 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  803654:	55                   	push   %ebp
  803655:	89 e5                	mov    %esp,%ebp
  803657:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80365a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80365d:	0f b6 01             	movzbl (%ecx),%eax
  803660:	84 c0                	test   %al,%al
  803662:	74 0c                	je     803670 <_Z6strcmpPKcS0_+0x1c>
  803664:	3a 02                	cmp    (%edx),%al
  803666:	75 08                	jne    803670 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  803668:	83 c1 01             	add    $0x1,%ecx
  80366b:	83 c2 01             	add    $0x1,%edx
  80366e:	eb ed                	jmp    80365d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  803670:	0f b6 c0             	movzbl %al,%eax
  803673:	0f b6 12             	movzbl (%edx),%edx
  803676:	29 d0                	sub    %edx,%eax
}
  803678:	5d                   	pop    %ebp
  803679:	c3                   	ret    

0080367a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80367a:	55                   	push   %ebp
  80367b:	89 e5                	mov    %esp,%ebp
  80367d:	53                   	push   %ebx
  80367e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803681:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  803684:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  803687:	85 d2                	test   %edx,%edx
  803689:	74 16                	je     8036a1 <_Z7strncmpPKcS0_j+0x27>
  80368b:	0f b6 01             	movzbl (%ecx),%eax
  80368e:	84 c0                	test   %al,%al
  803690:	74 17                	je     8036a9 <_Z7strncmpPKcS0_j+0x2f>
  803692:	3a 03                	cmp    (%ebx),%al
  803694:	75 13                	jne    8036a9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  803696:	83 ea 01             	sub    $0x1,%edx
  803699:	83 c1 01             	add    $0x1,%ecx
  80369c:	83 c3 01             	add    $0x1,%ebx
  80369f:	eb e6                	jmp    803687 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  8036a6:	5b                   	pop    %ebx
  8036a7:	5d                   	pop    %ebp
  8036a8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  8036a9:	0f b6 01             	movzbl (%ecx),%eax
  8036ac:	0f b6 13             	movzbl (%ebx),%edx
  8036af:	29 d0                	sub    %edx,%eax
  8036b1:	eb f3                	jmp    8036a6 <_Z7strncmpPKcS0_j+0x2c>

008036b3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8036b3:	55                   	push   %ebp
  8036b4:	89 e5                	mov    %esp,%ebp
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8036bd:	0f b6 10             	movzbl (%eax),%edx
  8036c0:	84 d2                	test   %dl,%dl
  8036c2:	74 1f                	je     8036e3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  8036c4:	38 ca                	cmp    %cl,%dl
  8036c6:	75 0a                	jne    8036d2 <_Z6strchrPKcc+0x1f>
  8036c8:	eb 1e                	jmp    8036e8 <_Z6strchrPKcc+0x35>
  8036ca:	38 ca                	cmp    %cl,%dl
  8036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8036d0:	74 16                	je     8036e8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8036d2:	83 c0 01             	add    $0x1,%eax
  8036d5:	0f b6 10             	movzbl (%eax),%edx
  8036d8:	84 d2                	test   %dl,%dl
  8036da:	75 ee                	jne    8036ca <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8036dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e1:	eb 05                	jmp    8036e8 <_Z6strchrPKcc+0x35>
  8036e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e8:	5d                   	pop    %ebp
  8036e9:	c3                   	ret    

008036ea <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8036ea:	55                   	push   %ebp
  8036eb:	89 e5                	mov    %esp,%ebp
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8036f4:	0f b6 10             	movzbl (%eax),%edx
  8036f7:	84 d2                	test   %dl,%dl
  8036f9:	74 14                	je     80370f <_Z7strfindPKcc+0x25>
		if (*s == c)
  8036fb:	38 ca                	cmp    %cl,%dl
  8036fd:	75 06                	jne    803705 <_Z7strfindPKcc+0x1b>
  8036ff:	eb 0e                	jmp    80370f <_Z7strfindPKcc+0x25>
  803701:	38 ca                	cmp    %cl,%dl
  803703:	74 0a                	je     80370f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803705:	83 c0 01             	add    $0x1,%eax
  803708:	0f b6 10             	movzbl (%eax),%edx
  80370b:	84 d2                	test   %dl,%dl
  80370d:	75 f2                	jne    803701 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80370f:	5d                   	pop    %ebp
  803710:	c3                   	ret    

00803711 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  803711:	55                   	push   %ebp
  803712:	89 e5                	mov    %esp,%ebp
  803714:	83 ec 0c             	sub    $0xc,%esp
  803717:	89 1c 24             	mov    %ebx,(%esp)
  80371a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80371e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803722:	8b 7d 08             	mov    0x8(%ebp),%edi
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  80372b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  803731:	75 25                	jne    803758 <memset+0x47>
  803733:	f6 c1 03             	test   $0x3,%cl
  803736:	75 20                	jne    803758 <memset+0x47>
		c &= 0xFF;
  803738:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80373b:	89 d3                	mov    %edx,%ebx
  80373d:	c1 e3 08             	shl    $0x8,%ebx
  803740:	89 d6                	mov    %edx,%esi
  803742:	c1 e6 18             	shl    $0x18,%esi
  803745:	89 d0                	mov    %edx,%eax
  803747:	c1 e0 10             	shl    $0x10,%eax
  80374a:	09 f0                	or     %esi,%eax
  80374c:	09 d0                	or     %edx,%eax
  80374e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  803750:	c1 e9 02             	shr    $0x2,%ecx
  803753:	fc                   	cld    
  803754:	f3 ab                	rep stos %eax,%es:(%edi)
  803756:	eb 03                	jmp    80375b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  803758:	fc                   	cld    
  803759:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  80375b:	89 f8                	mov    %edi,%eax
  80375d:	8b 1c 24             	mov    (%esp),%ebx
  803760:	8b 74 24 04          	mov    0x4(%esp),%esi
  803764:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803768:	89 ec                	mov    %ebp,%esp
  80376a:	5d                   	pop    %ebp
  80376b:	c3                   	ret    

0080376c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  80376c:	55                   	push   %ebp
  80376d:	89 e5                	mov    %esp,%ebp
  80376f:	83 ec 08             	sub    $0x8,%esp
  803772:	89 34 24             	mov    %esi,(%esp)
  803775:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80377f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  803782:	39 c6                	cmp    %eax,%esi
  803784:	73 36                	jae    8037bc <memmove+0x50>
  803786:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  803789:	39 d0                	cmp    %edx,%eax
  80378b:	73 2f                	jae    8037bc <memmove+0x50>
		s += n;
		d += n;
  80378d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  803790:	f6 c2 03             	test   $0x3,%dl
  803793:	75 1b                	jne    8037b0 <memmove+0x44>
  803795:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80379b:	75 13                	jne    8037b0 <memmove+0x44>
  80379d:	f6 c1 03             	test   $0x3,%cl
  8037a0:	75 0e                	jne    8037b0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8037a2:	83 ef 04             	sub    $0x4,%edi
  8037a5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8037a8:	c1 e9 02             	shr    $0x2,%ecx
  8037ab:	fd                   	std    
  8037ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8037ae:	eb 09                	jmp    8037b9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8037b0:	83 ef 01             	sub    $0x1,%edi
  8037b3:	8d 72 ff             	lea    -0x1(%edx),%esi
  8037b6:	fd                   	std    
  8037b7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8037b9:	fc                   	cld    
  8037ba:	eb 20                	jmp    8037dc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  8037bc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8037c2:	75 13                	jne    8037d7 <memmove+0x6b>
  8037c4:	a8 03                	test   $0x3,%al
  8037c6:	75 0f                	jne    8037d7 <memmove+0x6b>
  8037c8:	f6 c1 03             	test   $0x3,%cl
  8037cb:	75 0a                	jne    8037d7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8037cd:	c1 e9 02             	shr    $0x2,%ecx
  8037d0:	89 c7                	mov    %eax,%edi
  8037d2:	fc                   	cld    
  8037d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8037d5:	eb 05                	jmp    8037dc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  8037d7:	89 c7                	mov    %eax,%edi
  8037d9:	fc                   	cld    
  8037da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  8037dc:	8b 34 24             	mov    (%esp),%esi
  8037df:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8037e3:	89 ec                	mov    %ebp,%esp
  8037e5:	5d                   	pop    %ebp
  8037e6:	c3                   	ret    

008037e7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  8037e7:	55                   	push   %ebp
  8037e8:	89 e5                	mov    %esp,%ebp
  8037ea:	83 ec 08             	sub    $0x8,%esp
  8037ed:	89 34 24             	mov    %esi,(%esp)
  8037f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8037fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  8037fd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  803803:	75 13                	jne    803818 <memcpy+0x31>
  803805:	a8 03                	test   $0x3,%al
  803807:	75 0f                	jne    803818 <memcpy+0x31>
  803809:	f6 c1 03             	test   $0x3,%cl
  80380c:	75 0a                	jne    803818 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80380e:	c1 e9 02             	shr    $0x2,%ecx
  803811:	89 c7                	mov    %eax,%edi
  803813:	fc                   	cld    
  803814:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  803816:	eb 05                	jmp    80381d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  803818:	89 c7                	mov    %eax,%edi
  80381a:	fc                   	cld    
  80381b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  80381d:	8b 34 24             	mov    (%esp),%esi
  803820:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803824:	89 ec                	mov    %ebp,%esp
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    

00803828 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  803828:	55                   	push   %ebp
  803829:	89 e5                	mov    %esp,%ebp
  80382b:	57                   	push   %edi
  80382c:	56                   	push   %esi
  80382d:	53                   	push   %ebx
  80382e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803831:	8b 75 0c             	mov    0xc(%ebp),%esi
  803834:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  803837:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80383c:	85 ff                	test   %edi,%edi
  80383e:	74 38                	je     803878 <memcmp+0x50>
		if (*s1 != *s2)
  803840:	0f b6 03             	movzbl (%ebx),%eax
  803843:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  803846:	83 ef 01             	sub    $0x1,%edi
  803849:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80384e:	38 c8                	cmp    %cl,%al
  803850:	74 1d                	je     80386f <memcmp+0x47>
  803852:	eb 11                	jmp    803865 <memcmp+0x3d>
  803854:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  803859:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  80385e:	83 c2 01             	add    $0x1,%edx
  803861:	38 c8                	cmp    %cl,%al
  803863:	74 0a                	je     80386f <memcmp+0x47>
			return *s1 - *s2;
  803865:	0f b6 c0             	movzbl %al,%eax
  803868:	0f b6 c9             	movzbl %cl,%ecx
  80386b:	29 c8                	sub    %ecx,%eax
  80386d:	eb 09                	jmp    803878 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80386f:	39 fa                	cmp    %edi,%edx
  803871:	75 e1                	jne    803854 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  803873:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803878:	5b                   	pop    %ebx
  803879:	5e                   	pop    %esi
  80387a:	5f                   	pop    %edi
  80387b:	5d                   	pop    %ebp
  80387c:	c3                   	ret    

0080387d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  80387d:	55                   	push   %ebp
  80387e:	89 e5                	mov    %esp,%ebp
  803880:	53                   	push   %ebx
  803881:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  803884:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  803886:	89 da                	mov    %ebx,%edx
  803888:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  80388b:	39 d3                	cmp    %edx,%ebx
  80388d:	73 15                	jae    8038a4 <memfind+0x27>
		if (*s == (unsigned char) c)
  80388f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  803893:	38 0b                	cmp    %cl,(%ebx)
  803895:	75 06                	jne    80389d <memfind+0x20>
  803897:	eb 0b                	jmp    8038a4 <memfind+0x27>
  803899:	38 08                	cmp    %cl,(%eax)
  80389b:	74 07                	je     8038a4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  80389d:	83 c0 01             	add    $0x1,%eax
  8038a0:	39 c2                	cmp    %eax,%edx
  8038a2:	77 f5                	ja     803899 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  8038a4:	5b                   	pop    %ebx
  8038a5:	5d                   	pop    %ebp
  8038a6:	c3                   	ret    

008038a7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	57                   	push   %edi
  8038ab:	56                   	push   %esi
  8038ac:	53                   	push   %ebx
  8038ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8038b3:	0f b6 02             	movzbl (%edx),%eax
  8038b6:	3c 20                	cmp    $0x20,%al
  8038b8:	74 04                	je     8038be <_Z6strtolPKcPPci+0x17>
  8038ba:	3c 09                	cmp    $0x9,%al
  8038bc:	75 0e                	jne    8038cc <_Z6strtolPKcPPci+0x25>
		s++;
  8038be:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8038c1:	0f b6 02             	movzbl (%edx),%eax
  8038c4:	3c 20                	cmp    $0x20,%al
  8038c6:	74 f6                	je     8038be <_Z6strtolPKcPPci+0x17>
  8038c8:	3c 09                	cmp    $0x9,%al
  8038ca:	74 f2                	je     8038be <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  8038cc:	3c 2b                	cmp    $0x2b,%al
  8038ce:	75 0a                	jne    8038da <_Z6strtolPKcPPci+0x33>
		s++;
  8038d0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8038d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d8:	eb 10                	jmp    8038ea <_Z6strtolPKcPPci+0x43>
  8038da:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8038df:	3c 2d                	cmp    $0x2d,%al
  8038e1:	75 07                	jne    8038ea <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  8038e3:	83 c2 01             	add    $0x1,%edx
  8038e6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8038ea:	85 db                	test   %ebx,%ebx
  8038ec:	0f 94 c0             	sete   %al
  8038ef:	74 05                	je     8038f6 <_Z6strtolPKcPPci+0x4f>
  8038f1:	83 fb 10             	cmp    $0x10,%ebx
  8038f4:	75 15                	jne    80390b <_Z6strtolPKcPPci+0x64>
  8038f6:	80 3a 30             	cmpb   $0x30,(%edx)
  8038f9:	75 10                	jne    80390b <_Z6strtolPKcPPci+0x64>
  8038fb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8038ff:	75 0a                	jne    80390b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  803901:	83 c2 02             	add    $0x2,%edx
  803904:	bb 10 00 00 00       	mov    $0x10,%ebx
  803909:	eb 13                	jmp    80391e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  80390b:	84 c0                	test   %al,%al
  80390d:	74 0f                	je     80391e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80390f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  803914:	80 3a 30             	cmpb   $0x30,(%edx)
  803917:	75 05                	jne    80391e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  803919:	83 c2 01             	add    $0x1,%edx
  80391c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80391e:	b8 00 00 00 00       	mov    $0x0,%eax
  803923:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803925:	0f b6 0a             	movzbl (%edx),%ecx
  803928:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  80392b:	80 fb 09             	cmp    $0x9,%bl
  80392e:	77 08                	ja     803938 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  803930:	0f be c9             	movsbl %cl,%ecx
  803933:	83 e9 30             	sub    $0x30,%ecx
  803936:	eb 1e                	jmp    803956 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  803938:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  80393b:	80 fb 19             	cmp    $0x19,%bl
  80393e:	77 08                	ja     803948 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  803940:	0f be c9             	movsbl %cl,%ecx
  803943:	83 e9 57             	sub    $0x57,%ecx
  803946:	eb 0e                	jmp    803956 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  803948:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  80394b:	80 fb 19             	cmp    $0x19,%bl
  80394e:	77 15                	ja     803965 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  803950:	0f be c9             	movsbl %cl,%ecx
  803953:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  803956:	39 f1                	cmp    %esi,%ecx
  803958:	7d 0f                	jge    803969 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  80395a:	83 c2 01             	add    $0x1,%edx
  80395d:	0f af c6             	imul   %esi,%eax
  803960:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  803963:	eb c0                	jmp    803925 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  803965:	89 c1                	mov    %eax,%ecx
  803967:	eb 02                	jmp    80396b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  803969:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80396b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80396f:	74 05                	je     803976 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  803971:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  803974:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  803976:	89 ca                	mov    %ecx,%edx
  803978:	f7 da                	neg    %edx
  80397a:	85 ff                	test   %edi,%edi
  80397c:	0f 45 c2             	cmovne %edx,%eax
}
  80397f:	5b                   	pop    %ebx
  803980:	5e                   	pop    %esi
  803981:	5f                   	pop    %edi
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    
	...

00803990 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803990:	55                   	push   %ebp
  803991:	89 e5                	mov    %esp,%ebp
  803993:	56                   	push   %esi
  803994:	53                   	push   %ebx
  803995:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803998:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80399d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  8039a4:	85 c0                	test   %eax,%eax
  8039a6:	74 08                	je     8039b0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8039a8:	8d 55 08             	lea    0x8(%ebp),%edx
  8039ab:	89 14 24             	mov    %edx,(%esp)
  8039ae:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8039b0:	83 eb 01             	sub    $0x1,%ebx
  8039b3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8039b6:	75 e5                	jne    80399d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8039b8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8039bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8039be:	e8 d1 c7 ff ff       	call   800194 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8039c3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8039c7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8039cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039cf:	c7 44 24 08 d4 48 80 	movl   $0x8048d4,0x8(%esp)
  8039d6:	00 
  8039d7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8039de:	00 
  8039df:	c7 04 24 58 49 80 00 	movl   $0x804958,(%esp)
  8039e6:	e8 a1 f4 ff ff       	call   802e8c <_Z6_panicPKciS0_z>

008039eb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
  8039ee:	56                   	push   %esi
  8039ef:	53                   	push   %ebx
  8039f0:	83 ec 10             	sub    $0x10,%esp
  8039f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  8039f6:	e8 99 c7 ff ff       	call   800194 <_Z12sys_getenvidv>
  8039fb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  8039fd:	a1 00 60 80 00       	mov    0x806000,%eax
  803a02:	8b 40 5c             	mov    0x5c(%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	75 4c                	jne    803a55 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803a09:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803a10:	00 
  803a11:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803a18:	ee 
  803a19:	89 34 24             	mov    %esi,(%esp)
  803a1c:	e8 db c7 ff ff       	call   8001fc <_Z14sys_page_allociPvi>
  803a21:	85 c0                	test   %eax,%eax
  803a23:	74 20                	je     803a45 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803a25:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803a29:	c7 44 24 08 0c 49 80 	movl   $0x80490c,0x8(%esp)
  803a30:	00 
  803a31:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803a38:	00 
  803a39:	c7 04 24 58 49 80 00 	movl   $0x804958,(%esp)
  803a40:	e8 47 f4 ff ff       	call   802e8c <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803a45:	c7 44 24 04 90 39 80 	movl   $0x803990,0x4(%esp)
  803a4c:	00 
  803a4d:	89 34 24             	mov    %esi,(%esp)
  803a50:	e8 dc c9 ff ff       	call   800431 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803a55:	a1 20 80 80 00       	mov    0x808020,%eax
  803a5a:	39 d8                	cmp    %ebx,%eax
  803a5c:	74 1a                	je     803a78 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	74 20                	je     803a82 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803a62:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803a67:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  803a6e:	39 da                	cmp    %ebx,%edx
  803a70:	74 15                	je     803a87 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803a72:	85 d2                	test   %edx,%edx
  803a74:	75 1f                	jne    803a95 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803a76:	eb 0f                	jmp    803a87 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803a78:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7d:	8d 76 00             	lea    0x0(%esi),%esi
  803a80:	eb 05                	jmp    803a87 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803a82:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803a87:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803a8e:	83 c4 10             	add    $0x10,%esp
  803a91:	5b                   	pop    %ebx
  803a92:	5e                   	pop    %esi
  803a93:	5d                   	pop    %ebp
  803a94:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803a95:	83 c0 01             	add    $0x1,%eax
  803a98:	83 f8 08             	cmp    $0x8,%eax
  803a9b:	75 ca                	jne    803a67 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803a9d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803aa1:	c7 44 24 08 30 49 80 	movl   $0x804930,0x8(%esp)
  803aa8:	00 
  803aa9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803ab0:	00 
  803ab1:	c7 04 24 58 49 80 00 	movl   $0x804958,(%esp)
  803ab8:	e8 cf f3 ff ff       	call   802e8c <_Z6_panicPKciS0_z>
  803abd:	00 00                	add    %al,(%eax)
	...

00803ac0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803ac0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803ac3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803ac4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803ac7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803acb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803acf:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803ad2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803ad4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803ad8:	61                   	popa   
    popf
  803ad9:	9d                   	popf   
    popl %esp
  803ada:	5c                   	pop    %esp
    ret
  803adb:	c3                   	ret    

00803adc <spin>:

spin:	jmp spin
  803adc:	eb fe                	jmp    803adc <spin>
	...

00803ae0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ae0:	55                   	push   %ebp
  803ae1:	89 e5                	mov    %esp,%ebp
  803ae3:	56                   	push   %esi
  803ae4:	53                   	push   %ebx
  803ae5:	83 ec 10             	sub    $0x10,%esp
  803ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aee:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803af1:	85 c0                	test   %eax,%eax
  803af3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803af8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803afb:	89 04 24             	mov    %eax,(%esp)
  803afe:	e8 c4 c9 ff ff       	call   8004c7 <_Z12sys_ipc_recvPv>
  803b03:	85 c0                	test   %eax,%eax
  803b05:	79 16                	jns    803b1d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803b07:	85 db                	test   %ebx,%ebx
  803b09:	74 06                	je     803b11 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803b0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803b11:	85 f6                	test   %esi,%esi
  803b13:	74 53                	je     803b68 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803b15:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803b1b:	eb 4b                	jmp    803b68 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803b1d:	85 db                	test   %ebx,%ebx
  803b1f:	74 17                	je     803b38 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803b21:	e8 6e c6 ff ff       	call   800194 <_Z12sys_getenvidv>
  803b26:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b2b:	6b c0 78             	imul   $0x78,%eax,%eax
  803b2e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803b33:	8b 40 60             	mov    0x60(%eax),%eax
  803b36:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803b38:	85 f6                	test   %esi,%esi
  803b3a:	74 17                	je     803b53 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803b3c:	e8 53 c6 ff ff       	call   800194 <_Z12sys_getenvidv>
  803b41:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b46:	6b c0 78             	imul   $0x78,%eax,%eax
  803b49:	05 00 00 00 ef       	add    $0xef000000,%eax
  803b4e:	8b 40 70             	mov    0x70(%eax),%eax
  803b51:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803b53:	e8 3c c6 ff ff       	call   800194 <_Z12sys_getenvidv>
  803b58:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b5d:	6b c0 78             	imul   $0x78,%eax,%eax
  803b60:	05 08 00 00 ef       	add    $0xef000008,%eax
  803b65:	8b 40 60             	mov    0x60(%eax),%eax

}
  803b68:	83 c4 10             	add    $0x10,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5d                   	pop    %ebp
  803b6e:	c3                   	ret    

00803b6f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b6f:	55                   	push   %ebp
  803b70:	89 e5                	mov    %esp,%ebp
  803b72:	57                   	push   %edi
  803b73:	56                   	push   %esi
  803b74:	53                   	push   %ebx
  803b75:	83 ec 1c             	sub    $0x1c,%esp
  803b78:	8b 75 08             	mov    0x8(%ebp),%esi
  803b7b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803b7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803b81:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803b83:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803b88:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  803b8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b92:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b96:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803b9a:	89 34 24             	mov    %esi,(%esp)
  803b9d:	e8 ed c8 ff ff       	call   80048f <_Z16sys_ipc_try_sendijPvi>
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	79 31                	jns    803bd7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803ba6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803ba9:	75 0c                	jne    803bb7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803bab:	90                   	nop
  803bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803bb0:	e8 13 c6 ff ff       	call   8001c8 <_Z9sys_yieldv>
  803bb5:	eb d4                	jmp    803b8b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803bb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bbb:	c7 44 24 08 66 49 80 	movl   $0x804966,0x8(%esp)
  803bc2:	00 
  803bc3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803bca:	00 
  803bcb:	c7 04 24 73 49 80 00 	movl   $0x804973,(%esp)
  803bd2:	e8 b5 f2 ff ff       	call   802e8c <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803bd7:	83 c4 1c             	add    $0x1c,%esp
  803bda:	5b                   	pop    %ebx
  803bdb:	5e                   	pop    %esi
  803bdc:	5f                   	pop    %edi
  803bdd:	5d                   	pop    %ebp
  803bde:	c3                   	ret    
	...

00803be0 <__udivdi3>:
  803be0:	55                   	push   %ebp
  803be1:	89 e5                	mov    %esp,%ebp
  803be3:	57                   	push   %edi
  803be4:	56                   	push   %esi
  803be5:	83 ec 20             	sub    $0x20,%esp
  803be8:	8b 45 14             	mov    0x14(%ebp),%eax
  803beb:	8b 75 08             	mov    0x8(%ebp),%esi
  803bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803bf1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803bf4:	85 c0                	test   %eax,%eax
  803bf6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803bf9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803bfc:	75 3a                	jne    803c38 <__udivdi3+0x58>
  803bfe:	39 f9                	cmp    %edi,%ecx
  803c00:	77 66                	ja     803c68 <__udivdi3+0x88>
  803c02:	85 c9                	test   %ecx,%ecx
  803c04:	75 0b                	jne    803c11 <__udivdi3+0x31>
  803c06:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0b:	31 d2                	xor    %edx,%edx
  803c0d:	f7 f1                	div    %ecx
  803c0f:	89 c1                	mov    %eax,%ecx
  803c11:	89 f8                	mov    %edi,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f1                	div    %ecx
  803c17:	89 c7                	mov    %eax,%edi
  803c19:	89 f0                	mov    %esi,%eax
  803c1b:	f7 f1                	div    %ecx
  803c1d:	89 fa                	mov    %edi,%edx
  803c1f:	89 c6                	mov    %eax,%esi
  803c21:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803c24:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c2d:	83 c4 20             	add    $0x20,%esp
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c38:	31 d2                	xor    %edx,%edx
  803c3a:	31 f6                	xor    %esi,%esi
  803c3c:	39 f8                	cmp    %edi,%eax
  803c3e:	77 e1                	ja     803c21 <__udivdi3+0x41>
  803c40:	0f bd d0             	bsr    %eax,%edx
  803c43:	83 f2 1f             	xor    $0x1f,%edx
  803c46:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803c49:	75 2d                	jne    803c78 <__udivdi3+0x98>
  803c4b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803c4e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803c51:	76 06                	jbe    803c59 <__udivdi3+0x79>
  803c53:	39 f8                	cmp    %edi,%eax
  803c55:	89 f2                	mov    %esi,%edx
  803c57:	73 c8                	jae    803c21 <__udivdi3+0x41>
  803c59:	31 d2                	xor    %edx,%edx
  803c5b:	be 01 00 00 00       	mov    $0x1,%esi
  803c60:	eb bf                	jmp    803c21 <__udivdi3+0x41>
  803c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803c68:	89 f0                	mov    %esi,%eax
  803c6a:	89 fa                	mov    %edi,%edx
  803c6c:	f7 f1                	div    %ecx
  803c6e:	31 d2                	xor    %edx,%edx
  803c70:	89 c6                	mov    %eax,%esi
  803c72:	eb ad                	jmp    803c21 <__udivdi3+0x41>
  803c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c78:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803c7c:	89 c2                	mov    %eax,%edx
  803c7e:	b8 20 00 00 00       	mov    $0x20,%eax
  803c83:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803c86:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803c89:	d3 e2                	shl    %cl,%edx
  803c8b:	89 c1                	mov    %eax,%ecx
  803c8d:	d3 ee                	shr    %cl,%esi
  803c8f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803c93:	09 d6                	or     %edx,%esi
  803c95:	89 fa                	mov    %edi,%edx
  803c97:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  803c9a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803c9d:	d3 e6                	shl    %cl,%esi
  803c9f:	89 c1                	mov    %eax,%ecx
  803ca1:	d3 ea                	shr    %cl,%edx
  803ca3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ca7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803caa:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803cad:	d3 e7                	shl    %cl,%edi
  803caf:	89 c1                	mov    %eax,%ecx
  803cb1:	d3 ee                	shr    %cl,%esi
  803cb3:	09 fe                	or     %edi,%esi
  803cb5:	89 f0                	mov    %esi,%eax
  803cb7:	f7 75 e4             	divl   -0x1c(%ebp)
  803cba:	89 d7                	mov    %edx,%edi
  803cbc:	89 c6                	mov    %eax,%esi
  803cbe:	f7 65 f0             	mull   -0x10(%ebp)
  803cc1:	39 d7                	cmp    %edx,%edi
  803cc3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803cc6:	72 12                	jb     803cda <__udivdi3+0xfa>
  803cc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ccb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ccf:	d3 e2                	shl    %cl,%edx
  803cd1:	39 c2                	cmp    %eax,%edx
  803cd3:	73 08                	jae    803cdd <__udivdi3+0xfd>
  803cd5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  803cd8:	75 03                	jne    803cdd <__udivdi3+0xfd>
  803cda:	83 ee 01             	sub    $0x1,%esi
  803cdd:	31 d2                	xor    %edx,%edx
  803cdf:	e9 3d ff ff ff       	jmp    803c21 <__udivdi3+0x41>
	...

00803cf0 <__umoddi3>:
  803cf0:	55                   	push   %ebp
  803cf1:	89 e5                	mov    %esp,%ebp
  803cf3:	57                   	push   %edi
  803cf4:	56                   	push   %esi
  803cf5:	83 ec 20             	sub    $0x20,%esp
  803cf8:	8b 7d 14             	mov    0x14(%ebp),%edi
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803d01:	8b 75 0c             	mov    0xc(%ebp),%esi
  803d04:	85 ff                	test   %edi,%edi
  803d06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803d09:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d0f:	89 f2                	mov    %esi,%edx
  803d11:	75 15                	jne    803d28 <__umoddi3+0x38>
  803d13:	39 f1                	cmp    %esi,%ecx
  803d15:	76 41                	jbe    803d58 <__umoddi3+0x68>
  803d17:	f7 f1                	div    %ecx
  803d19:	89 d0                	mov    %edx,%eax
  803d1b:	31 d2                	xor    %edx,%edx
  803d1d:	83 c4 20             	add    $0x20,%esp
  803d20:	5e                   	pop    %esi
  803d21:	5f                   	pop    %edi
  803d22:	5d                   	pop    %ebp
  803d23:	c3                   	ret    
  803d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d28:	39 f7                	cmp    %esi,%edi
  803d2a:	77 4c                	ja     803d78 <__umoddi3+0x88>
  803d2c:	0f bd c7             	bsr    %edi,%eax
  803d2f:	83 f0 1f             	xor    $0x1f,%eax
  803d32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d35:	75 51                	jne    803d88 <__umoddi3+0x98>
  803d37:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  803d3a:	0f 87 e8 00 00 00    	ja     803e28 <__umoddi3+0x138>
  803d40:	89 f2                	mov    %esi,%edx
  803d42:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803d45:	29 ce                	sub    %ecx,%esi
  803d47:	19 fa                	sbb    %edi,%edx
  803d49:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4f:	83 c4 20             	add    $0x20,%esp
  803d52:	5e                   	pop    %esi
  803d53:	5f                   	pop    %edi
  803d54:	5d                   	pop    %ebp
  803d55:	c3                   	ret    
  803d56:	66 90                	xchg   %ax,%ax
  803d58:	85 c9                	test   %ecx,%ecx
  803d5a:	75 0b                	jne    803d67 <__umoddi3+0x77>
  803d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  803d61:	31 d2                	xor    %edx,%edx
  803d63:	f7 f1                	div    %ecx
  803d65:	89 c1                	mov    %eax,%ecx
  803d67:	89 f0                	mov    %esi,%eax
  803d69:	31 d2                	xor    %edx,%edx
  803d6b:	f7 f1                	div    %ecx
  803d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d70:	eb a5                	jmp    803d17 <__umoddi3+0x27>
  803d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803d78:	89 f2                	mov    %esi,%edx
  803d7a:	83 c4 20             	add    $0x20,%esp
  803d7d:	5e                   	pop    %esi
  803d7e:	5f                   	pop    %edi
  803d7f:	5d                   	pop    %ebp
  803d80:	c3                   	ret    
  803d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803d88:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d8c:	89 f2                	mov    %esi,%edx
  803d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d91:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  803d98:	29 45 f0             	sub    %eax,-0x10(%ebp)
  803d9b:	d3 e7                	shl    %cl,%edi
  803d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803da4:	d3 e8                	shr    %cl,%eax
  803da6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803daa:	09 f8                	or     %edi,%eax
  803dac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db2:	d3 e0                	shl    %cl,%eax
  803db4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dbe:	d3 ea                	shr    %cl,%edx
  803dc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803dc4:	d3 e6                	shl    %cl,%esi
  803dc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803dca:	d3 e8                	shr    %cl,%eax
  803dcc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803dd0:	09 f0                	or     %esi,%eax
  803dd2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803dd5:	f7 75 e4             	divl   -0x1c(%ebp)
  803dd8:	d3 e6                	shl    %cl,%esi
  803dda:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803ddd:	89 d6                	mov    %edx,%esi
  803ddf:	f7 65 f4             	mull   -0xc(%ebp)
  803de2:	89 d7                	mov    %edx,%edi
  803de4:	89 c2                	mov    %eax,%edx
  803de6:	39 fe                	cmp    %edi,%esi
  803de8:	89 f9                	mov    %edi,%ecx
  803dea:	72 30                	jb     803e1c <__umoddi3+0x12c>
  803dec:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  803def:	72 27                	jb     803e18 <__umoddi3+0x128>
  803df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df4:	29 d0                	sub    %edx,%eax
  803df6:	19 ce                	sbb    %ecx,%esi
  803df8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803dfc:	89 f2                	mov    %esi,%edx
  803dfe:	d3 e8                	shr    %cl,%eax
  803e00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e04:	d3 e2                	shl    %cl,%edx
  803e06:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e0a:	09 d0                	or     %edx,%eax
  803e0c:	89 f2                	mov    %esi,%edx
  803e0e:	d3 ea                	shr    %cl,%edx
  803e10:	83 c4 20             	add    $0x20,%esp
  803e13:	5e                   	pop    %esi
  803e14:	5f                   	pop    %edi
  803e15:	5d                   	pop    %ebp
  803e16:	c3                   	ret    
  803e17:	90                   	nop
  803e18:	39 fe                	cmp    %edi,%esi
  803e1a:	75 d5                	jne    803df1 <__umoddi3+0x101>
  803e1c:	89 f9                	mov    %edi,%ecx
  803e1e:	89 c2                	mov    %eax,%edx
  803e20:	2b 55 f4             	sub    -0xc(%ebp),%edx
  803e23:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  803e26:	eb c9                	jmp    803df1 <__umoddi3+0x101>
  803e28:	39 f7                	cmp    %esi,%edi
  803e2a:	0f 82 10 ff ff ff    	jb     803d40 <__umoddi3+0x50>
  803e30:	e9 17 ff ff ff       	jmp    803d4c <__umoddi3+0x5c>
