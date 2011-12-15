verbose=false; out=/dev/null; err=/dev/null
make_args=

while [ -n "$1" ]; do
    case "$1" in
	-v|V=1)
	    verbose=true; out=/dev/stdout; err=/dev/stderr
	    make_args="$make_args V=1";;
	*=*)
	    eval "$1"; make_args="$make_args $1";;
    esac
    shift
done

if gmake --version >/dev/null 2>&1; then make=gmake; else make=make; fi

#
# QEMU
#

timeout=30
monitor_timeout=10
preservefs=n
qemu=`$make $make_args -s --no-print-directory print-qemu`
gdbport=`$make $make_args -s --no-print-directory print-gdbport`
qemugdb=`$make $make_args -s --no-print-directory print-qemugdb`
cxxfilt=`$make $make_args -s --no-print-directory print-c++filt`
brkfn=readline
keystrokes=
keystrokes_post="exit;exit;exit;exit;exit;exit;exit;exit;exit;exit;exit;exit;"

# Pick a new GDB port if the current one appears open
# (can happen if one user is grading two labs in parallel on one machine)
while ( netstat -t -n -l || echo ) | grep "tcp.*:$gdbport[^0-9]" >/dev/null 2>&1; do
    newgdbport=`expr $gdbport + 1`
    qemugdb=`echo "$qemugdb" | sed "s/$gdbport/$newgdbport/"`
    gdbport="$newgdbport"
done

echo_n () {
	# suns can't echo -n, and Mac OS X can't echo "x\c"
	# assume argument has no doublequotes
	awk 'BEGIN { printf("'"$*"'"); }' </dev/null
}

psleep () {
	# solaris "sleep" doesn't take fractions
	perl -e "select(undef, undef, undef, $1);"
}

# Run QEMU with serial output redirected to jos.out.  If $brkfn is
# non-empty, wait until $brkfn is reached or $timeout expires, then
# kill QEMU.
run () {
	qemuextra=
	if [ -n "$brkfn" -a -z "$keystrokes" ]; then
		qemuextra="-monitor null -S $qemugdb"

		# Check that gdb exists
		if [ -n "$GDBX" ]; then
			:
		elif i386-jos-elf-gdb --help >/dev/null 2>&1; then
			GDBX=i386-jos-elf-gdb
		elif gdb --help >/dev/null 2>&1; then
			GDBX=gdb
		else
			echo 1>&2
			echo "*** Cannot find a working gdb; stopping." 1>&2
			echo "*** Try 'GDBX=path-to-gdb make grade'." 1>&2
			exit 1
		fi
	else
		qemuextra="-monitor telnet::$gdbport,server,nowait"
	fi

	qemucommand="$qemu -nographic $qemuopts -serial file:jos.out -no-reboot $qemuextra"
	if $verbose; then
		echo $qemucommand 1>&2
	fi

	t0=`date +%s.%N 2>/dev/null`
	rm -f jos.out
	PID=`ulimit -t $timeout; $qemucommand >$out 2>$err & echo $!`

	# Enforce the timout more than one way
	TIMEOUTPID=`sh -c "sleep $timeout; kill $PID" >/dev/null 2>&1 & echo $!`

	# Wait for QEMU to start
	sleep 1

	if [ -n "$brkfn" -a -z "$keystrokes" ]; then
		# Find the address of the kernel $brkfn function,
		# which is typically what the kernel monitor uses to
		# read commands interactively.
		brkaddr=`grep " $brkfn\$" obj/kernel.sym | sed -e's/ .*$//g'`
		if [ -z "$brkaddr" ]; then
			# Perhaps the symbol was mangled.
			brkaddr=`$cxxfilt < obj/kernel.sym | grep " $brkfn(" | sed -e's/ .*$//g'`
		fi

		(
			echo "target remote localhost:$gdbport"
			echo "br *0x$brkaddr"
			echo c
		) > jos.in
		$GDBX -batch -nx -x jos.in > /dev/null 2>&1
	else
		# Wait until "Welcome to the JOS kernel monitor" is printed
		# (or $monitor_timeout, whichever comes first).
		WELCOMETIMEOUTPID=`sh -c "sleep $monitor_timeout; echo >> jos.out; echo 'Welcome to the JOS kernel monitor TIMEOUT' >> jos.out" >/dev/null 2>&1 & echo $!`

		while ! grep -l -q "^Welcome to the JOS kernel monitor" jos.out >/dev/null 2>&1; do
			psleep 0.1
		done

		kill $WELCOMETIMEOUTPID > /dev/null 2>&1
		if grep -l -q "^Welcome to the JOS kernel monitor TIMEOUT" jos.out >/dev/null 2>&1; then
			echo 1>&2
			echo "*** Warning: Your monitor() did not print out the expected line:" 1>&2
			echo "Welcome to the JOS kernel monitor!" 1>&2
			echo "*** The grading script depends on that line." 1>&2
			echo 1>&2
		fi

		(
		keystrokes_next="$keystrokes_post"
		keystroke_timeout=0.05
		while [ -n "$keystrokes" ]; do
			firstchar=`echo "$keystrokes" | sed -e 's/^\(.\).*/\1/'`
			keystrokes=`echo "$keystrokes" | sed -e 's/^.//'`
			if [ "$firstchar" = ';' ]; then
				echo "sendkey ret"
			elif [ "$firstchar" = ' ' ]; then
				echo "sendkey spc"
			else
				echo "sendkey $firstchar"
			fi
			psleep $keystroke_timeout

			# Some QEMUs (maybe 0.15.0) can buffer their
			# output, leading to false grading errors. We
			# encourage them to output what we need by feeding
			# them a bunch of "exit"s to generate output.
			if [ -z "$keystrokes" ]; then
				keystrokes="$keystrokes_next"
				keystrokes_next=
				keystroke_timeout=0.0001
			fi
		done

		psleep 0.2
		echo "quit"
		psleep 1
		) | telnet localhost $gdbport >/dev/null 2>$err
	fi

	# Make sure QEMU is dead.  On OS X, exiting gdb
	# doesn't always exit QEMU.
	kill $PID > /dev/null 2>&1
	kill $TIMEOUTPID > /dev/null 2>&1
}

#
# Scoring
#

pts=5
part=0
partpos=0
total=0
totalpos=0

showpart () {
	echo "Part $1 score: $part/$partpos"
	echo
	total=`expr $total + $part`
	totalpos=`expr $totalpos + $partpos`
	part=0
	partpos=0
}

showfinal () {
	total=`expr $total + $part`
	totalpos=`expr $totalpos + $partpos`
	echo "Score: $total/$totalpos"
	if [ $total -lt $totalpos ]; then
		exit 1
	fi
}

passfailmsg () {
	msg="$1"
	shift
	if [ $# -gt 0 ]; then
		msg="$msg,"
	fi

	t1=`date +%s.%N 2>/dev/null`
	time=`echo "scale=1; ($t1-$t0)/1" | sed 's/.N/.0/g' | bc 2>/dev/null`

	echo $msg "$@" "(${time}s)"
}

pass () {
	passfailmsg OK "$@"
	part=`expr $part + $pts`
	partpos=`expr $partpos + $pts`
}

fail () {
	passfailmsg WRONG "$@"
	partpos=`expr $partpos + $pts`
	if $verbose; then
		exit 1
	fi
}


#
# User tests
#

# Usage: runtest <tagname> <defs> <check fn> <check args...>
runtest () {
	tag="$1"
	perl -e "print '$tag: '"
	rm -f obj/kern/init.o obj/kernel obj/kern/kernel obj/kernel.img
	[ "$preservefs" = y ] || rm -f obj/fs.img
	if $verbose
	then
		echo "$make$make_args $2... "
	fi
	$make $make_args $2 >$out
	if [ $? -ne 0 ]
	then
		rm -f obj/kern/init.o
		echo $make$make_args $2 failed
		exit 1
	fi
	# We just built a weird init.o that runs a specific test.  As
	# a result, 'make qemu' will run the last graded test and
	# 'make clean; make qemu' will run the user-specified
	# environment.  Remove our weird init.o to fix this.
	rm -f obj/kern/init.o
	run

	# Give qemu some more time to run (for asynchronous mode).
	# This way, we get the small 1 second wait for most tests
	# and a longer wait (5 seconds) in case qemu needs that
	# time to load.
	if [ ! -s jos.out ]
	then
		sleep 4
	fi

	if [ ! -s jos.out ]
	then
		fail > /dev/null   # Still increment number of possible points
		echo 'no jos.out'
	else
		shift
		shift
		check=$1
		shift
		$check "$tag" "$@"
	fi
}

quicktest () {
	perl -e "print '$1: '"
	shift
	checkregexps "" "$@"
}

checkregexps () {
	okay=yes
	tag="$1"
	shift

	not=false
	for i
	do
		if [ "x$i" = "x!" ]
		then
			not=true
		elif $not
		then
			if egrep "^$i\$" jos.out >/dev/null
			then
				echo "got unexpected line '$i'"
				okay=no
			fi
			not=false
		else
			egrep "^$i\$" jos.out >/dev/null
			if [ $? -ne 0 ]
			then
				echo "missing '$i'"
				okay=no
			fi
			not=false
		fi
	done
	if [ "$okay" = "yes" ]
	then
		pass
	else
		fail
		if [ -n "$tag" ]; then
			modtag=`echo "$tag" | tr -d '\012' | tr -cs A-Za-z0-9_.- _`
			cp jos.out jos.out.$modtag
			echo "        => Saving QEMU output in jos.out.$modtag"
		fi
	fi
}

# Usage: runtest1 [-tag <tagname>] [-dir <dirname>] <progname> [-Ddef...] [-check checkfn] checkargs...
runtest1 () {
	tag=
	dir=user
	check=checkregexps
	while true; do
		if [ $1 = -tag ]
		then
			tag=$2
		elif [ $1 = -dir ]
		then
			dir=$2
		else
			break
		fi
		shift
		shift
	done
	prog=$1
	shift
	if [ "x$tag" = x ]
	then
		tag=$prog
	fi
	runtest1_defs=
	while expr "x$1" : 'x-D.*' >/dev/null; do
		runtest1_defs="DEFS+='$1' $runtest1_defs"
		shift
	done
	if [ "x$1" = "x-check" ]; then
		check=$2
		shift
		shift
	fi
	runtest "$tag" "DEFS='-DTEST=_binary_obj_${dir}_${prog}_start' DEFS+='-DTESTSIZE=_binary_obj_${dir}_${prog}_size' $runtest1_defs" "$check" "$@"
}

