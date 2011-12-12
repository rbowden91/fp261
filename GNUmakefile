#
# This makefile system follows the structuring conventions
# recommended by Peter Miller in his excellent paper:
#
#	Recursive Make Considered Harmful
#	http://aegis.sourceforge.net/auug97.pdf
#

OBJDIR := obj

# Run 'make V=1' to turn on verbose commands, or 'make V=0' to turn them off.
ifeq ($(V),1)
override V =
endif
ifeq ($(V),0)
override V = @
endif

-include conf/lab.mk

-include conf/env.mk

LABSETUP ?= ./

TOP = .

# Cross-compiler jos toolchain
#
# This Makefile will automatically use the cross-compiler toolchain
# installed as 'i386-jos-elf-*', if one exists.  If the host tools ('gcc',
# 'objdump', and so forth) compile for a 32-bit x86 ELF target, that will
# be detected as well.  If you have the right compiler toolchain installed
# using a different name, set GCCPREFIX explicitly in conf/env.mk

# try to infer the correct GCCPREFIX
GCCPREFIX ?= $(shell if i386-jos-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	then echo "i386-jos-elf-"; exit; fi; \
	if objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; then echo ""; exit; fi; \
	echo "FAIL")
ifeq ($(GCCPREFIX),FAIL)
GCCCHECK := report-bad-gcc
endif

# try to infer the correct QEMU
QEMU ?= $(shell if which qemu > /dev/null; then echo qemu; exit; fi; \
	qemu=/Applications/Q.app/Contents/MacOS/i386-softmmu.app/Contents/MacOS/i386-softmmu; \
	if test -x $$qemu; then echo $$qemu; exit; fi; \
	echo "FAIL")
ifeq ($(QEMU),FAIL)
QEMUCHECK := report-bad-qemu
endif


CC	:= $(GCCPREFIX)gcc -pipe
AS	:= $(GCCPREFIX)as
AR	:= $(GCCPREFIX)ar
LD	:= $(GCCPREFIX)ld
OBJCOPY	:= $(GCCPREFIX)objcopy
OBJDUMP	:= $(GCCPREFIX)objdump
NM	:= $(GCCPREFIX)nm

# Native commands
NCC	:= gcc $(CC_VER) -pipe
TAR	:= gtar
PERL	:= perl

# Compiler flags
# -fno-builtin is required to avoid refs to undefined functions in the kernel.
# Only optimize to -O1 to discourage inlining, which complicates backtraces.
CFLAGS := $(CFLAGS) $(DEFS) $(LABDEFS) -O1 -fno-builtin -I$(TOP) -MD
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs -m32

CFLAGS += -I$(TOP)/net/lwip/include -I$(TOP)/net/lwip/include/ipv4 -I$(TOP)/net/lwip/jos

# Host compiler flags
# Programs that run on the build host, rather than the VM, may require a
# different compiler, and thus different compiler flags.
HOST_CFLAGS := $(CFLAGS)

# Add -fno-stack-protector if the option exists.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
HOST_CFLAGS += $(shell $(NCC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)


# Common linker flags
LDFLAGS := -m elf_i386

# Linker flags for JOS user programs
ULDFLAGS := -T user/user.ld

# libgcc defines some necessary functions
GCC_LIB := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name 2>/dev/null)

# Lists that the */Makefrag makefile fragments will add to
OBJDIRS :=

# Make sure that 'all' is the first target

all: 

# Eliminate default suffix rules
.SUFFIXES:

# Delete target files if there is an error (or make is interrupted)
.DELETE_ON_ERROR:

# make it so that no intermediate .o files are ever deleted
.PRECIOUS: %.o $(OBJDIR)/boot/%.o $(OBJDIR)/kern/%.o \
	   $(OBJDIR)/lib/%.o $(OBJDIR)/fs/%.o $(OBJDIR)/net/%.o \
	   $(OBJDIR)/user/%.o

KERN_CFLAGS := $(CFLAGS) -DJOS_KERNEL -gstabs
USER_CFLAGS := $(CFLAGS) -DJOS_USER -gstabs


# C++ compiler flags
CXX := $(GCCPREFIX)c++ -pipe
KERN_CXXFLAGS := $(KERN_CFLAGS) -fno-exceptions -fno-rtti -Wno-non-virtual-dtor
USER_CXXFLAGS := $(USER_CFLAGS) -fno-exceptions -fno-rtti -Wno-non-virtual-dtor

CXXFILT := $(GCCPREFIX)c++filt



# Include Makefrags for subdirectories
include boot/Makefrag
include kern/Makefrag
include lib/Makefrag
include user/Makefrag
include fs/Makefrag
include net/Makefrag

# define some "unique" ports for QEMU to listen on; we need up to 4

BASEPORT ?= $(shell expr "(" `id -u` % 1750 ")" "*" 4 + 25000)


PORT7 	:= $(shell expr $(BASEPORT) + 1)
PORT80	:= $(shell expr $(BASEPORT) + 2)




# define QEMU options
QEMUOPTS := -hda $(OBJDIR)/kernel.img  -net user -net nic,model=e1000 -redir tcp:$(PORT7)::7 -redir tcp:$(PORT80)::80 
	 		
IMAGES := $(OBJDIR)/kernel.img
QEMUGRAPHICOPTS := -serial stdio
QEMUNOGRAPHICOPTS := -serial mon:stdio

QEMUOPTS += -hdb $(OBJDIR)/fs.img
IMAGES += $(OBJDIR)/fs.img



ifdef VNC
QEMUGRAPHICOPTS += -k en-us -vnc localhost:$(VNC),reverse
endif

# For test runs
ifeq ($(O),1)
QEMUOPTS += -parallel stdio
endif

ifndef GDB
GDB ?= $(BASEPORT)
else ifeq ($(GDB),1)
GDB ?= $(BASEPORT)
endif
QEMUGDBOPTS = $(shell if $(QEMU) -nographic -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDB)"; else echo "-s -p $(GDB)"; fi)

.gdbinit: .gdbinit.tmpl
	sed "s/localhost:1234/localhost:$(GDB)/" < $^ > $@

run qemu: $(QEMUCHECK) $(IMAGES)
	$(QEMU) $(QEMUOPTS) $(QEMUGRAPHICOPTS)

run-nox qemu-nox: $(QEMUCHECK) $(IMAGES)
	@echo "***"
	@echo "*** Use Ctrl-a x to exit qemu"
	@echo "***"
	$(QEMU) -nographic $(QEMUOPTS) $(QEMUNOGRAPHICOPTS)

run-gdb qemu-gdb: $(QEMUCHECK) $(IMAGES) .gdbinit
	@echo "***"
	@echo "*** Now run 'gdb'." 1>&2
	@echo "***"
	$(QEMU) $(QEMUOPTS) $(QEMUGRAPHICOPTS) -S $(QEMUGDBOPTS)

run-nox-gdb qemu-nox-gdb: $(QEMUCHECK) $(IMAGES) .gdbinit
	@echo "***"
	@echo "*** Now run 'gdb'." 1>&2
	@echo "***"
	$(QEMU) -nographic $(QEMUOPTS) $(QEMUNOGRAPHICOPTS) -S $(QEMUGDBOPTS)

# For test runs
run-nox-%: $(QEMUCHECK)
	$(V)rm -f $(OBJDIR)/kern/init.o $(IMAGES)
	$(V)$(MAKE) "DEFS=-DTEST=_binary_obj_user_$*_start -DTESTSIZE=_binary_obj_user_$*_size" $(IMAGES)
	$(V)rm -f $(OBJDIR)/kern/init.o
	@echo "***"
	@echo "*** Use Ctrl-a x to exit"
	@echo "***"
	$(QEMU) -nographic $(QEMUOPTS) $(QEMUNOGRAPHICOPTS)

# For GDB runs
run-gdb-%: $(QEMUCHECK) .gdbinit
	$(V)rm -f $(OBJDIR)/kern/init.o $(IMAGES)
	$(V)$(MAKE) "DEFS=-DTEST=_binary_obj_user_$*_start -DTESTSIZE=_binary_obj_user_$*_size" $(IMAGES)
	$(V)rm -f $(OBJDIR)/kern/init.o
	@echo "***"
	@echo "*** Now run '$(GCCPREFIX)gdb'." 1>&2
	@echo "***"
	$(QEMU) $(QEMUOPTS) $(QEMUGRAPHICOPTS) -S $(QEMUGDBOPTS)

# For normal runs
run-%: $(QEMUCHECK)
	$(V)rm -f $(OBJDIR)/kern/init.o $(IMAGES)
	$(V)$(MAKE) "DEFS=-DTEST=_binary_obj_user_$*_start -DTESTSIZE=_binary_obj_user_$*_size" $(IMAGES)
	$(V)rm -f $(OBJDIR)/kern/init.o
	@echo "QEMU command:"
	@echo $(QEMU) $(QEMUOPTS) $(QEMUGRAPHICOPTS)
	@echo "-----"
	$(QEMU) $(QEMUOPTS) $(QEMUGRAPHICOPTS)

print-c++filt: $(GCCCHECK)
	@if which $(CXXFILT) >/dev/null; then echo $(CXXFILT); else echo cat; fi

print-qemu: $(QEMUCHECK)
	@echo $(QEMU)

print-gdbport:
	@echo $(GDB)

print-qemugdb: $(QEMUCHECK)
	@echo $(QEMUGDBOPTS)

# For network connections
which-ports:
	@echo "Local port $(PORT7) forwards to JOS port 7 (echo server)"
	@echo "Local port $(PORT80) forwards to JOS port 80 (web server)"

nc-80:
	nc localhost $(PORT80)

nc-7:
	nc localhost $(PORT7)

telnet-80:
	telnet localhost $(PORT80)

telnet-7:
	telnet localhost $(PORT7)

# For deleting the build
clean:
	rm -rf $(OBJDIR) .gdbinit jos.in kern/programs.c

realclean: clean
	rm -rf lab$(LAB).tar.gz jos.out jos.out.*

distclean: realclean
	rm -rf conf/gcc.mk

ifneq ($(V),@)
GRADEFLAGS += -v
endif

grade: always $(QEMUCHECK) $(LABSETUP)grade-lab$(LAB).sh $(LABSETUP)grade-functions.sh
	
	@echo $(MAKE) clean

	@$(MAKE) clean || \
	  (echo "'make clean' failed.  HINT: Do you have another running instance of JOS?" && exit 1)
	$(MAKE) all
	#ifeq($(LAB),6)
	./grade-lab$(LAB).py $(GRADEFLAGS)
	#else
	#sh $(LABSETUP)grade-lab$(LAB).sh $(GRADEFLAGS)
	#echo "not hello"
	
	
grade-lab%: always $(QEMUCHECK) $(LABSETUP)grade-lab%.sh $(LABSETUP)grade-functions.sh
	@echo $(MAKE) clean
	@$(MAKE) clean || \
	  (echo "'make clean' failed.  HINT: Do you have another running instance of JOS?" && exit 1)
	$(MAKE) all
	sh $(LABSETUP)$@.sh $(GRADEFLAGS)

tarball: realclean
	tar cf - `find . -type f | grep -v '^\.*$$' | grep -v '/CVS/' | grep -v '/\.svn/' | grep -v '/\.git/' | grep -v 'lab[0-9].*\.tar\.gz'` | gzip > lab$(LAB)-handin.tar.gz

# This magic automatically generates makefile dependencies
# for header files included from C source files we compile,
# and keeps those dependencies up-to-date every time we recompile.
# See 'mergedep.pl' for more information.
$(OBJDIR)/.deps: $(foreach dir, $(OBJDIRS), $(wildcard $(OBJDIR)/$(dir)/*.d))
	@mkdir -p $(@D)
	@$(PERL) mergedep.pl $@ $^

-include $(OBJDIR)/.deps

always:
	@:


report-bad-gcc:
	@echo "***" 1>&2
	@echo "*** Error: Couldn't find an i386-*-elf version of GCC/binutils." 1>&2
	@echo "*** Is the directory with i386-jos-elf-gcc in your PATH?" 1>&2
	@echo "*** If your i386-*-elf toolchain is installed with a command" 1>&2
	@echo "*** prefix other than 'i386-jos-elf-', set your GCCPREFIX" 1>&2
	@echo "*** environment variable to that prefix and run 'make' again." 1>&2
	@echo "*** To turn off this error, run 'gmake GCCPREFIX= ...'." 1>&2
	@echo "***" 1>&2
	@exit 1

report-bad-qemu:
	@echo "***" 1>&2
	@echo "*** Error: Couldn't find a working QEMU executable." 1>&2
	@echo "*** Is the directory containing the qemu binary in your PATH" 1>&2
	@echo "*** or have you tried setting the QEMU variable in conf/env.mk?" 1>&2
	@echo "***" 1>&2
	@exit 1

.PHONY: all always \
	handin tarball clean realclean distclean grade \
	qemu qemu-nox qemu-gdb qemu-nox-gdb \
	run run-nox run-gdb run-nox-gdb \
	report-bad-gcc report-bad-qemu
