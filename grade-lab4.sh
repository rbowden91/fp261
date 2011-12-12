#!/bin/sh

qemuopts="-hda obj/kernel.img"
. ./grade-functions.sh


$make $make_args

timeout=10

if test -f user/mapperm.c; then
runtest1 mapperm \
	'.0000100[01]. free env 0000100[01]' \
	'first write/read succeeded' \
	'.0000100[01]. user fault va 00401000.*' \
	! 'remapped write succeeded inappropriately'
fi

runtest1 faultread \
	! 'I read ........ from location 0!' \
	'.00001001. user fault va 00000000 ip 008.....' \
	'Trap frame at 0xf.......' \
	'  trap 0x0000000e Page Fault.*' \
	'  err  0x00000004.*' \
	'.00001001. free env 00001001'

runtest1 faultwrite \
	'.00001001. user fault va 00000000 ip 008.....' \
	'Trap frame at 0xf.......' \
	'  trap 0x0000000e Page Fault.*' \
	'  err  0x00000006.*' \
	'.00001001. free env 00001001'

runtest1 faultregs \
	'Registers in UTrapframe OK' \
	! 'Registers in UTrapframe MISMATCH' \
	'Registers after page-fault OK' \
	! 'Registers after page-fault MISMATCH'

runtest1 faultalloc \
	'fault deadbeef' \
	'this string was faulted in at deadbeef' \
	'fault cafebffe' \
	'fault cafec000' \
	'this string was faulted in at cafebffe' \
	'.00001001. exiting gracefully' \
	'.00001001. free env 00001001'

runtest1 faultallocbad \
	'.00001001.*user_mem_check assertion failure for va deadbeef.*' \
	'.00001001. free env 00001001' 

runtest1 faultnostack \
	'.00001001.*user_mem_check assertion failure for va eefff....*' \
	'.00001001. free env 00001001'

runtest1 faultbadhandler \
	'.00001001.*user_mem_check assertion failure for va (deadb|eeffe)....*' \
	'.00001001. free env 00001001'

runtest1 faultevilhandler \
	'.00001001..*user_mem_check assertion failure for va (f0100|eeffe)....*' \
	'.00001001. free env 00001001'

pts=20
if test -f user/mapperm.c; then pts=15; fi

runtest1 forktree \
	'....: I am .0.' \
	'....: I am .1.' \
	'....: I am .000.' \
	'....: I am .100.' \
	'....: I am .110.' \
	'....: I am .111.' \
	'....: I am .011.' \
	'....: I am .001.' \
	'.00001001. exiting gracefully' \
	'.00001002. exiting gracefully' \
	'.0000200.. exiting gracefully' \
	'.0000200.. free env 0000200.' \
	! 'fork not implemented, falling back to dumbfork'

showpart A

pts=10

runtest1 spin \
	'.00000000. new env 00001000' \
	'.00000000. new env 00001001' \
	'I am the parent.  Forking the child...' \
	'.00001001. new env 00001002' \
	'I am the parent.  Running the child...' \
	'I am the child.  Spinning...' \
	'I am the parent.  Killing the child...' \
	'.00001001. destroying 00001002' \
	'.00001001. free env 00001002' \
	'.00001001. exiting gracefully' \
	'.00001001. free env 00001001'

runtest1 pingpong \
	'.00000000. new env 00001000' \
	'.00000000. new env 00001001' \
	'.00001001. new env 00001002' \
	'send 0 from 1001 to 1002' \
	'1002 got 0 from 1001' \
	'1001 got 1 from 1002' \
	'1002 got 8 from 1001' \
	'1001 got 9 from 1002' \
	'1002 got 10 from 1001' \
	'.00001001. exiting gracefully' \
	'.00001001. free env 00001001' \
	'.00001002. exiting gracefully' \
	'.00001002. free env 00001002' \

timeout=20
runtest1 primes \
	'.00000000. new env 00001000' \
	'.00000000. new env 00001001' \
	'.00001001. new env 00001002' \
	'2 .00001002. new env 00001003' \
	'3 .00001003. new env 00001004' \
	'5 .00001004. new env 00001005' \
	'7 .00001005. new env 00001006' \
	'11 .00001006. new env 00001007' 

showpart B

pts=5

runtest1 programread \
	'sys_program_read works .[123456789].'

runtest1 settrapframe \
	'sys_env_set_trapframe works' \
	! 'should not be reached'

runtest1 evilsettrapframe \
	'  trap 0x0000000(d General Protection|e Page Fault.*0xf.*)' \
	! 'sys_env_set_trapframe works inappropriately'

pts=15

runtest1 spawnhello \
	'.00000000. new env 00001001' \
	'i am parent environment 00001001' \
	'.00001001. new env 00001002' \
	'hello, world' \
	'i am environment 00001002' \
	'.00001002. exiting gracefully'

runtest1 spawninit \
	'.00000000. new env 00001001' \
	'i am parent environment 00001001' \
	'.00001001. new env 00001002' \
	'init: running' \
	'init: data seems okay' \
	'init: bss seems okay' \
	'init: args: .init. .one. .two.' \
	'init: exiting' \
	'.00001002. exiting gracefully'

pts=5

runtest1 spawnreadonlytext \
	'i am parent environment 00001001' \
	'program text is read-only' \
	! 'should not be reached'

showfinal
