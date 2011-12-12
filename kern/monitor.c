// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/env.h>
#include <kern/pmap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line

struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display the current backtrace of the stack", mon_backtrace },
	{ "exit", "Exit the kernel monitor", mon_exit },
    { "blue_on_red", "Change colors of the window to blue on red", mon_bor },
};
#define NCOMMANDS ((int) (sizeof(commands)/sizeof(commands[0])))

unsigned read_eip() __attribute__((noinline));

extern pte_t *kern_pgdir;

/***** Implementations of basic kernel monitor commands *****/

int 
mon_exit(int argc, char **argv, struct Trapframe *tf)
{
    return -1;
}

// A silly test function to make sure that the console changes colors correctly
int 
mon_bor(int argc, char **argv, struct Trapframe *tf)
{
	cprintf("%c[41%c[34", 0x1b, 0x1b);
	return 0;
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	uint32_t *ebp;				// the base pointer for this stack frame
	uint32_t eip = 0;		    // the return address of the callee
	int frame_num = 0;			// the number of frames we've traversed
	struct Eipdebuginfo info;	// handy stabs info
    bool user_break = false;

	// make sure the font background isn't a disgusting color
	FONT_COLOR(ANSI_BG_BLACK);

	cprintf("Stack backtrace:\n");
	


    // If we are coming from a breakpoint, we need to use the eip and ebp
    // from our stackframe
    if (tf && tf->tf_trapno == T_BRKPT)
    {
        
		eip = tf->tf_eip;
        ebp = (uint32_t *)tf->tf_regs.reg_ebp;
        user_break = true;
    }
    else
        ebp = (uint32_t *)read_ebp();

	// keep following ebp, printing function info, until it hits 0
	// at which point we can't go any further back
    while(ebp != 0) {
        // print the frame number that we are on
		FONT_COLOR(ANSI_RED);
		cprintf("  %d: ", frame_num);

        if(!user_break || frame_num) {
            // print the address of the current base pointer
            FONT_COLOR(ANSI_CYAN);
            cprintf("ebp %08x  ", ebp);

            // print the callee's return address
            FONT_COLOR(ANSI_GREEN);
            if(user_break && user_mem_check(curenv, (uintptr_t)ebp + 1, sizeof (*ebp), PTE_W) < 0)
            {
                cprintf("eip ?  ", eip);
                eip = 0;
            }
            else
            {
                eip = *(ebp+1);
                cprintf("eip %08x  ", eip);
            }
            // print the four 4-byte blocks above the return address, which 
            // may or may not be actual arguments to the function
            FONT_COLOR(ANSI_BLUE);
            cprintf("args");
            for(int i = 2; i < 6; i++)
            {
                if(user_break && user_mem_check(curenv, (uintptr_t)(ebp + i), sizeof (*ebp), PTE_W) < 0)
                    cprintf(" ?");
                else
                    cprintf(" %08x", *(ebp+i));
            }
            cprintf("\n");
        }
        else
        {
            FONT_COLOR(ANSI_GREEN);
            cprintf("eip %08x\n", eip);
        }
		// grab the stab info about the caller's stack frame
        if(debuginfo_eip(eip, &info))
        {
            if(!user_break || frame_num)
            {
                ebp = (uint32_t *)(*ebp);
            }
            frame_num++;
            continue;;
        }
		// copy over the non-null-terminated caller function name
		char fun_name[info.eip_fn_namelen+1];
		fun_name[info.eip_fn_namelen] = '\0';
		strncpy(fun_name, info.eip_fn_name, info.eip_fn_namelen);

		// print the filename and line number of the caller
		FONT_COLOR(ANSI_YELLOW);
		cprintf("     %s:%d: ", info.eip_file, info.eip_line);

		// print the function name and number of bytes into the caller function
		FONT_COLOR(ANSI_MAGENTA);
		cprintf("%s+%x ",fun_name, eip - info.eip_fn_addr);

		// print the number of arguments that the caller takes
		FONT_COLOR(ANSI_WHITE);
		cprintf("(%d arg)\n", info.eip_fn_narg);

		// move up the stack frame
        if(!user_break || frame_num)
        {
            if(user_break && user_mem_check(curenv, (uintptr_t)ebp, sizeof *ebp, PTE_W) < 0)
                break;
            else
                ebp = (uint32_t *)(*ebp);
	    }

		frame_num++;
    }
    FONT_COLOR(ANSI_WHITE);
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

// Return EIP of caller.  Does not work if inlined.
unsigned
read_eip()
{
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
	return callerpc;
}
