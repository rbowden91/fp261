#include <kern/e1000.h>
#include <kern/pci.h>
#include <kern/pmap.h>
#include <kern/sched.h>
#include <kern/trap.h>
#include <kern/picirq.h>
#include <inc/env.h>
#include <inc/x86.h>
#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
 // LAB 6: Your driver code here

static struct pci_func e1000;
static struct rx_desc rdesc_list[NUM_RDESCS] __attribute__ ((aligned (16)));
static struct tx_desc tdesc_list[NUM_TDESCS] __attribute__ ((aligned (16)));
static struct { char p[MAXPACKETLEN]; } tpackets[NUM_TDESCS] __attribute__ ((aligned (PGSIZE)));
static struct { char p[MAXPACKETLEN]; } rbuffer[NUM_RDESCS] __attribute__ ((aligned (PGSIZE)));
static uint32_t td_idx = 0;
static uint32_t rd_idx = 0;
extern pde_t *kern_pgdir;
extern struct Env *curenv;
extern struct Env envs[];


static void
e1000_write(uint32_t offset, uint32_t val)
{
    *((uint32_t *)IOMEMBASE + (offset / sizeof(uint32_t))) = (uint32_t)val;
}

static void
e1000_init_tring(void)
{
    for(int i = 0; i < NUM_TDESCS; i++)
    {
        tdesc_list[i].addr = (uint64_t)PADDR(&tpackets[i].p);
        tdesc_list[i].length = 0;
        tdesc_list[i].cso = 0;
        tdesc_list[i].cmd = RS;
        tdesc_list[i].status = DD;
        tdesc_list[i].css = 0;
        tdesc_list[i].special = 0;
    }    
}

static void
e1000_init_rring(void)
{
    for(int i = 0; i < NUM_RDESCS; i++)
    {
        rdesc_list[i].addr = (uint64_t)PADDR(&rbuffer[i]);
        rdesc_list[i].length = 0;
        rdesc_list[i].pcs = 0;
        rdesc_list[i].status = 0;
        rdesc_list[i].errors = 0;
        rdesc_list[i].special = 0;
    }
}

static void
e1000_tinit(void)
{
    e1000_init_tring();
    // TDBAL
    e1000_write(0x3800, (uint32_t)PADDR(tdesc_list));// (uint32_t)tdesc_list);
    // TDBAH
    e1000_write(0x3804, 0);
    // TDLEN
    e1000_write(0x3808, sizeof tdesc_list);
    // TDH
    e1000_write(0x3810, 0);
    // TDT
    e1000_write(0x3818, 0);
    // TCTL
    e1000_write(0x400, 0x2|0x8|(0x40<<12));
    // TIPG
    e1000_write(0x410, 0x60200A);
}

static void
e1000_rinit(void)
{
    e1000_init_rring();
    // RAL
    e1000_write(0x5400, 0x12005452);
    // RAH
    e1000_write(0x5404, 0x5634 + (1<<31));
    // MTA
    for(uint32_t i = 0; i < 128; i++)
        e1000_write(0x5200 + 4 * i, 0);
    // IMS
    e1000_write(0xD0, RXT0);
    // RDBAL
    e1000_write(0x2800, (uint32_t)PADDR(rdesc_list));
    // RDBAH
    e1000_write(0x2804, 0);
    // RDLEN
    e1000_write(0x2808, sizeof rdesc_list);
    // RDH
    e1000_write(0x2810, 0);
   // RDT
    e1000_write(0x2818, 0);
    // Set RDTR Delay Time to 0 (just to make sure)
    e1000_write(0x2820, 0x0);
    // RCTL
    e1000_write(0x100, EN|SECRC); 
}

int
e1000_attach(struct pci_func *f)
{
    pci_func_enable(f);
    e1000 = *f;
    page_map_segment(kern_pgdir, IOMEMBASE, e1000.reg_size[0], e1000.reg_base[0], PTE_W|PTE_PCD|PTE_PWT|PTE_P);
    set_e1000_irqno(e1000.irq_line);
    SETGATE(idt[IRQ_OFFSET + e1000.irq_line], 0, 0x8, e1000_trap_handler, 0);
    e1000_tinit();
    e1000_rinit();
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
    tdesc_list[td_idx].length = len;
    // EOP
    tdesc_list[td_idx].cmd |= 1;
    memcpy((void *)KADDR(tdesc_list[td_idx].addr), buffer, len);
    if(++td_idx == NUM_TDESCS)
        td_idx = 0;
    lcr3((uint32_t)PADDR(kern_pgdir));
    e1000_write(0x3818, td_idx);
    lcr3((uint32_t)PADDR(curenv->env_pgdir));
    return 0;
}

static envid_t recv_q[ENVID_QLEN];
static unsigned int q_start = 0;
static unsigned int q_end = 0;

int
e1000_receive(void *dst)
{
    struct rx_desc *cur;
    size_t len;
    cur = &rdesc_list[rd_idx];
    if(!(cur->status & DD))
    {
        if(1 || (q_end + 1) % ENVID_QLEN == q_start)
            return -1;
        curenv->env_tf.tf_regs.reg_eax = -1;
        curenv->env_status = ENV_NOT_RUNNABLE;
        sched_yield();
    } 
    else
    {
        len = cur->length;
        user_mem_assert(curenv, (uintptr_t)dst, len, PTE_P|PTE_U|PTE_W);
        memcpy(dst, (void *)KADDR(cur->addr), len);
        cur->status = 0;
        if(++rd_idx == NUM_RDESCS)
            rd_idx = 0;
        // RDT
        lcr3((uint32_t)PADDR(kern_pgdir));
        e1000_write(0x2818, rd_idx);
        lcr3((uint32_t)PADDR(curenv->env_pgdir));
        return len;
    }
    // shouldn't reach
    return 0;
}


//XXX have to handle this in trap.c???
void
e1000_trap_handler()
{
    cprintf("inside interrupt\n");
    if(q_start != q_end)
    {
        envs[ENVX(recv_q[q_start])].env_status = ENV_RUNNABLE;
        q_start = (q_start + 1) % ENVID_QLEN;
    }
    
    // reset e1000 interrupt
    e1000_write(0xC0, 0);
}
