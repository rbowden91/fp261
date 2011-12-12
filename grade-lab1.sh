#!/bin/sh

qemuopts="-hda obj/kernel.img"
. ./grade-functions.sh


$make $make_args

check () {
	pts=20
	echo_n "Printf: "
	text="6828 decimal is 15254 octal!"
	if grep "$text" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	pts=10
	echo "Backtrace:"
	args=`grep "ebp f01.* eip f0100.* args" jos.out | \
sed 's/^ *[0-9]*://' | \
awk '{ print $6 }'`
	cnt=`echo $args | grep '^00000000 00000000 00000001 00000002 00000003 00000004 00000005' | wc -w`
	echo_n "   Count "
	if [ $cnt -eq 8 ]
	then
		pass
	else
		fail
	fi

	cnt=`grep "ebp f01.* eip f0100.* args" jos.out | \
sed 's/^ *[0-9]*://' | \
awk 'BEGIN { FS = ORS = " " }
{ print $6 }
END { printf("\n") }' | grep '^00000000 00000000 00000001 00000002 00000003 00000004 00000005' | wc -w`
	echo_n "   Args "
	if [ $cnt -eq 8 ]; then
		pass
	else
		fail "($args)"
	fi

	syms=`$cxxfilt < jos.out | grep "kern/init.c:[0-9]*:  *test_backtrace[(+]"`
	symcnt=`$cxxfilt < jos.out | grep "kern/init.c:[0-9]*:  *test_backtrace[(+]" | wc -l`
	echo_n "   Symbols "
	if [ $symcnt -eq 6 ]; then
		pass
	elif [ $symcnt -eq 0 ]; then
		fail "found no symbols"
	else
		fail "found wrong symbols ($syms)"
	fi
}

run
check

showfinal
