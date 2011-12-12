#include <inc/lib.h>
#include <inc/elf.h>

void
umain(int argc, char **argv)
{
	unsigned char elf_buf[512];
	struct Elf *elf = (struct Elf *) &elf_buf;
	char buf[512];

	int progid, i, r, amount, nchecks = 0;
	struct Proghdr *ph;

	// Compare results of "sys_program_read" with our own memory.
	if ((progid = sys_program_lookup("programread", 11)) < 0)
		return;
	memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
	memset(buf, 0, sizeof(buf));
	if (sys_program_read(0, elf_buf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return;
	}

	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		amount = MIN(ph->p_filesz, sizeof(buf));
		if ((r = sys_program_read(0, buf, progid, ph->p_offset, amount)) < 0) {
			cprintf("sys_program_read error %e\n", r);
			return;
		} else if (memcmp(buf, (void *) ph->p_va, amount) != 0) {
			cprintf("sys_program_read bad data at %08x\n", ph->p_va);
			return;
		} else
			++nchecks;
	}

	cprintf("sys_program_read works (%d)\n", nchecks);
}
