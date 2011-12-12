#include <kern/e1000.h>
#include <kern/pci.h>
#include <kern/pmap.h>
#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
// LAB 6: Your driver code here

static struct pci_func e1000;
static struct tx_desc tdesc_list[NUM_TDESCS] __attribute__ ((aligned (16)));
static struct { char p[MAXPACKETLEN]; } packets[NUM_TDESCS];
static uint32_t td_idx = 0;
extern pde_t *kern_pgdir;

int
e1000_attach(struct pci_func *f)
{
    pci_func_enable(f);
    e1000 = *f;
    page_map_segment(kern_pgdir, IOMEMBASE, e1000.reg_size[0], e1000.reg_base[0], PTE_W|PTE_PCD|PTE_PWT|PTE_P);
    // TDBAL
    *((uint32_t *)IOMEMBASE + (0x3800 / sizeof(uint32_t))) = (uint32_t)tdesc_list;
    // TDBAH
    *((uint32_t *)IOMEMBASE + (0x3804 / sizeof(uint32_t))) = 0;
    // TDLEN
    *((uint32_t *)IOMEMBASE + (0x3808 / sizeof(uint32_t))) = sizeof tdesc_list;
    // TCTL
    *((uint32_t *)IOMEMBASE + (0x400 / sizeof(uint32_t))) = 0x4000A;
    // TIPG
    *((uint32_t *)IOMEMBASE + (0x410 / sizeof(uint32_t))) = 0x60200A;

    return 1;
}

int
e1000_transmit(void *buffer, size_t len)
{
    if (len > MAXPACKETLEN)
        return -E_INVAL;
    if(!(tdesc_list[td_idx].status & DD))
        return -E_AGAIN;
    tdesc_list[td_idx].status &= ~DD;
    tdesc_list[td_idx].cmd |= RS;
    tdesc_list[td_idx].addr = (uint64_t)(&packets[td_idx].p);
    tdesc_list[td_idx].length = len;
    memcpy((void *)tdesc_list[td_idx].addr, buffer, len);
    *((uint32_t *)IOMEMBASE + (0x3818 / sizeof(uint32_t))) = td_idx;
    if(++td_idx == NUM_TDESCS)
        td_idx = 0;
    return 0;
    
}
