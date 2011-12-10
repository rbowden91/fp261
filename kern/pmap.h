/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_PMAP_H
#define JOS_KERN_PMAP_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/memlayout.h>
#include <inc/assert.h>
struct Env;

// For sharing pages with remote machines.
#define PTE_REMOTE 0x400

/* This macro takes a kernel virtual address -- an address that points above
 * KERNBASE, where the machine's maximum 256MB of physical memory is mapped --
 * and returns the corresponding physical address.  It panics if you pass it a
 * non-kernel virtual address.
 */
#define PADDR(kva)						\
({								\
	physaddr_t __m_kva = (physaddr_t) (kva);		\
	if (__m_kva < KERNBASE)					\
		panic("PADDR called with invalid kva %08lx", __m_kva);\
	__m_kva - KERNBASE;					\
})

/* This macro takes a physical address and returns the corresponding kernel
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa)						\
({								\
	physaddr_t __m_pa = (pa);				\
	uint32_t __m_ppn = PGNUM(__m_pa);			\
	if (__m_ppn >= npages)					\
		panic("KADDR called with invalid pa %08lx", __m_pa);\
	(void*) (__m_pa + KERNBASE);				\
})


// Page structures.
// Each Page describes one physical page.
// The pages[] array keeps track of the state of physical memory.
// Entry pages[N] holds information about physical page #N.
// The machine has 'npages' pages of physical memory space.
extern struct Page *pages;
extern size_t npages;

struct Page {
	// Next page on the free list.
	Page *pp_link;

	// Count of pointers to this page (usually in page table entries).
	// Reserved pages may not have valid reference counts.
	uint16_t pp_ref;

	// For process migration
	uint32_t pp_remote_network_addr;
	physaddr_t pp_remote_page_physaddr;
	bool pp_exists_on_remote_machine;
};

extern pde_t *kern_pgdir;

void	mem_init(void);

void	page_init(void);
struct Page *page_alloc(void);
void	page_free(struct Page *pp);
int	page_insert(pde_t *pgdir, struct Page *pp, uintptr_t va, pte_t perm);
void	page_remove(pde_t *pgdir, uintptr_t va);
struct Page *page_lookup(pde_t *pgdir, uintptr_t va, pte_t **pte_store);
void	page_decref(struct Page *pp);

void	tlb_invalidate(pde_t *pgdir, uintptr_t va);

int	user_mem_check(struct Env *env, uintptr_t va, size_t len, pte_t perm);
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
}

static inline struct Page *
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
}

static inline struct Page *
kva2page(void *kva)
{
	return pa2page(PADDR(kva));
}

pte_t *pgdir_walk(pde_t *pgdir, uintptr_t va, bool create);


void page_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm, bool ps_bit = 0);

#endif /* !JOS_KERN_PMAP_H */
