#include <inc/lib.h>
#include <inc/elf.h>

static int copy_shared_pages(envid_t child);

//
// Allocate at least len bytes of physical memory for environment env,
// mapped at virtual address 'va' in 'dst_env's address space.
// Pages should be writable and zeroed.
// Return 0 on success, < 0 if an allocation attempt fails.
//
static int
segment_alloc(envid_t dst_env, uintptr_t va, size_t len)
{
    // identical to segment alloc for load_elf!
    int r;

    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(va + len, PGSIZE);

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
        if ((r = sys_page_alloc(dst_env, (void *)i, PTE_P|PTE_U|PTE_W)))
            return -r;
    return 0;
}


//
// Shift an address from the UTEMP page to the corresponding value in the
// normal stack page (top address USTACKTOP).
//
static uintptr_t utemp_addr_to_stack_addr(void *ptr)
{
	uintptr_t addr = (uintptr_t) ptr;
	assert(ptr >= UTEMP && ptr < (char *) UTEMP + PGSIZE);
	return USTACKTOP - PGSIZE + PGOFF(addr);
}

//
// Set up the initial stack page for the new child process with envid 'child'
// using the arguments array pointed to by 'argv',
// which is a null-terminated array of pointers to '\0'-terminated strings.
//
// On success, returns 0 and sets *init_esp to the initial stack pointer
//   with which the child should start.
// Returns < 0 on failure.
//
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;

	// Determine where to place the strings and the argv array.
	// We set up the 'string_store' and 'argv_store' pointers to point
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate a page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	// Store the 'argc' and 'argv' parameters themselves
	// below 'argv_store' on the stack.  These parameters will be passed
	// to umain().
	argv_store[-2] = argc;
	argv_store[-1] = utemp_addr_to_stack_addr(argv_store);


	// Copy the argument strings from 'argv' into UTEMP
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
        {
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
        string_store++;
    }   
    
    // null-terminate the whole argv array
    argv_store[argc] = 0;

	// Set *init_esp to the initial stack pointer for the child:
	// it should point at the "argc" value stored on the stack.
	// set the initial stack to point at argc
    *init_esp = utemp_addr_to_stack_addr(&argv_store[-2]);


	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}


//
// Spawn a new user process running a specified binary.
//
// This function loads all loadable segments from an ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// It also clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file -- i.e., the program's bss section.
//
// This is a lot like load_elf in kern/env.c, and you can reuse a lot of the
// same logic!  But instead of copying directly from an ELF image, you'll
// use the sys_program_read() system call.
//
// This function also maps one page for the program's initial stack.
// Command line arguments go on the stack, so it's not just an empty page;
// see init_stack.
//
// Returns the new environment's ID on success, and < 0 on error.
// If an error occurs, any new environment is destroyed.
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
           size_t len, int fs_read)
{
    int r;
    if(!fs_read)
        return sys_program_read(dst_env, va, programid, offset, len);
    if((r = seek(programid, offset)))
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
    {
        uint32_t bytes = (uint32_t)MIN((uint32_t)va + len - (uint32_t)i, (uint32_t)PGSIZE);
        if((r = sys_page_alloc(0, UTEMP, PTE_U | PTE_P|PTE_W)))
            return r;
        if((r = readn(programid, UTEMP, bytes)) < 0 ||
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
    }
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
{
	unsigned char elf_buf[512];
	struct Elf *elf = (struct Elf *) &elf_buf;

	int progid, i, r;
	struct Proghdr *ph;

	// LAB 5 EXERCISE: If the first character of prog is '/',
	// look up the program using 'open' (not sys_program_lookup)
	// and read from it using 'read' and 'seek' (not sys_program_read).
	//
	// Program IDs returned by sys_program_lookup are greater than
	// or equal to PROGRAM_OFFSET (0x40000000).
	// No file descriptors are that big, so you can use a single variable
	// to hold either the program ID or the file descriptor number.
	//
	// Unfortunately, you cannot 'read' into a child address space,
	// so you'll need to code the 'read' case differently.
	//
	// Also, make sure you close the file descriptor, if any,
	// before returning from spawn().
    int fs_load = prog[0] == '/';
    memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
    if(fs_load)
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
            return -E_NOT_EXEC;
    }
    else
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
            return -E_NOT_EXEC;
    }
    if (elf->e_magic != ELF_MAGIC) {
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
        return -E_NOT_EXEC;
    }
	// Now create the child process, then load the ELF into it!
	// Hints:
	// - Refer to your load_elf.
	// - You can assume that all "struct Proghdr" structures are contained
	//   in the first 512 bytes of the ELF, which you loaded already.
	// - The virtual addresses included in ELF files might not be
	//   page-aligned.  However, ELF guarantees that no two segments
	//   will load different data into the same page.
	//   (ELF also guarantees that PGOFF(ph->p_va) == PGOFF(ph->p_offset),
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    struct Proghdr *eph = ph + elf->e_phnum;
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
               (r = spawn_read(envid, (void *)ph->p_va, progid, ph->p_offset, ph->p_filesz, fs_load)) < 0)
            {
                sys_env_destroy(envid);
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
            {
                sys_env_destroy(envid);
                return r;
            }
                 
        }
    }

    if(fs_load)
        close(progid);
    copy_shared_pages(envid);
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        return r;
    return envid;
}

// Spawn, taking command-line arguments array directly on the stack.
envid_t
spawnl(const char *prog, const char *arg0, ...)
{
	return spawn(prog, &arg0);
}


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
		if (!(vpd[PDX(va)] & PTE_P))
			va = ROUNDUP(va + 1, PTSIZE) - PGSIZE;
		else if ((vpt[PGNUM(va)] & (PTE_P|PTE_SHARE)) == (PTE_P|PTE_SHARE)) {
			r = sys_page_map(0, (void *) va, child, (void *) va,
					 vpt[PGNUM(va)] & PTE_SYSCALL);
			if (r < 0)
				return r;
		}
	return 0;
}
