// Check whether sys_page_map works when remapping a page's permissions.

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	volatile uint32_t *pg1 = (volatile uint32_t *) UTEMP;
	volatile uint32_t *pg2 = pg1 + PGSIZE / 4;

	// allocate a page at pg1 AND read-only at pg2
	sys_page_alloc(0, (void *) pg1, PTE_P | PTE_U | PTE_W);
	*pg1 = 0x01010101;
	assert(*pg1 == 0x01010101);
	cprintf("first write/read succeeded\n");

	sys_page_map(0, (void *) pg1, 0, (void *) pg2, PTE_P | PTE_U | PTE_W);
	assert(*pg2 == 0x01010101);
	*pg2 = 0x02020202;
	assert(*pg1 == 0x02020202);
	assert(*pg2 == 0x02020202);

	// then make the pg2 version read-only; this must cause a fault
	sys_page_map(0, (void *) pg1, 0, (void *) pg2, PTE_P | PTE_U);
	*pg2 = 0x03030303;
	cprintf("remapped write succeeded inappropriately\n");
}
