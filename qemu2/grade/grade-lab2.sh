#!/bin/sh

qemuopts="-hda obj/kernel.img"
. ./grade-functions.sh
brkfn=
keystrokes="backtrace;exit;"


$make $make_args

check () {
	pts=20
	echo_n "Physical page allocator: "
	if grep "check_page_alloc() succeeded!" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	pts=20
	echo_n "Page management: "
	if grep "check_page() succeeded!" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	pts=20
	echo_n "Kernel page directory: "
	if grep "check_kern_pgdir() succeeded!" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	pts=10
	echo_n "Page management 2: "
	if grep "check_page_installed_pgdir() succeeded!" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	pts=10
	echo_n "Kernel breakpoint interrupt: "
	if grep "^Trap frame at 0x" jos.out >/dev/null \
	    && grep "  trap 0x00000003 Breakpoint" jos.out >/dev/null
	then
		pass
	else
		fail
	fi

	echo_n "Kernel breakpoint backtrace: "
	syms=`$cxxfilt < jos.out | grep "kern/init.c:[0-9]*:  *test_kernel_breakpoint[(+]"`
	badsyms=`$cxxfilt < jos.out | grep "kern/trap.c:[0-9]*:  *trap[(+]"`
	if [ -n "$syms" -a -z "$badsyms" ]; then
		pass
	elif [ -z "$syms" ]; then
		fail "found no symbols"
	else
		fail "found wrong symbols ($badsyms)"
	fi

	echo_n "Returning from breakpoint interrupt: "
	if grep "Breakpoint succeeded" jos.out >/dev/null
	then
		pass
	else
		fail
	fi
}

run
check

showfinal
