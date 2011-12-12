#!/bin/sh

qemuopts="-hda obj/kernel.img -hdb obj/fs.img"
. ./grade-functions.sh


$make $make_args

runtest1 -tag 'bufcache I/O [fs]' hello \
	'bufcache can do I/O' \
	! 'idle loop can do I/O' \

runtest1 -tag 'bcache_pgfault_handler [testfile]' testfile \
	'initial fsck is good'

quicktest 'open [testfile]' \
	'open not-found is good' \
	'open root is good' \
	'open is good' \
	'file_stat is good'

quicktest 'read [testfile]' \
	'file_read is good' \
	'file_close is good'

quicktest 'read across a block boundary [testfile]' \
	'file_read across a block boundary is good'

quicktest 'write [testfile]' \
	'file_write is good'

quicktest 'file_read after file_write [testfile]' \
	'file_read after file_write is good'

quicktest 'unlink [testfile]' \
	'open after unlink is good' \
	'file_read after unlink is good'

pts=10
quicktest 'fsck [testfile]' \
	'final fsck is good'

pts=10
runtest1 -tag 'motd display [writemotd]' writemotd \
	'OLD MOTD' \
	'This is /motd, the message of the day.' \
	'NEW MOTD' \
	'This is the NEW message of the day!' \

preservefs=y
runtest1 -tag 'motd change [writemotd]' writemotd \
	'OLD MOTD' \
	'This is the NEW message of the day!' \
	'NEW MOTD' \
	! 'This is /motd, the message of the day.' \

showpart A

pts=25
preservefs=n
runtest1 -tag 'spawn via icode [icode]' icode \
	'icode: read /motd' \
	'This is /motd, the message of the day.' \
	'icode: spawn /init' \
	'init: running' \
	'init: data seems okay' \
	'icode: exiting' \
	'init: bss seems okay' \
	"init: args: 'init' 'initarg1' 'initarg2'" \
	'init: exiting' \

pts=10
runtest1 -tag 'PTE_SHARE [testpteshare]' testpteshare \
	'fork handles PTE_SHARE right' \
	'spawn handles PTE_SHARE right' \

pts=10
runtest1 -tag 'fd sharing [testfdsharing]' testfdsharing \
	'read in parent succeeded' \
	'read in child succeeded'

showpart B

# 10 points - run-testpipe
pts=10
runtest1 -tag 'pipe [testpipe]' testpipe \
	'pipe read closed properly' \
	'pipe write closed properly' \

# 10 points - run-testpiperace2
pts=10
runtest1 -tag 'pipe race [testpiperace2]' testpiperace2 \
	! 'RACE: pipe appears closed' \
	! 'child detected race' \
	"race didn't happen" \

# 10 points - run-primespipe
pts=10
timeout=120
echo 'The primespipe test has up to 2 minutes to complete.  Be patient.'
runtest1 -tag 'primespipe' primespipe \
	! 1 2 3 ! 4 5 ! 6 7 ! 8 ! 9 \
	! 10 11 ! 12 13 ! 14 ! 15 ! 16 17 ! 18 19 \
	! 20 ! 21 ! 22 23 ! 24 ! 25 ! 26 ! 27 ! 28 29 \
	! 30 31 ! 32 ! 33 ! 34 ! 35 ! 36 37 ! 38 ! 39 \
	541 1009 1097

# 20 points - run-testshell
pts=20
timeout=60
runtest1 -tag 'shell [testshell]' testshell \
	'shell ran correctly' \

showpart C

showfinal
