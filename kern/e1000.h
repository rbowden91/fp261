#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#define MAXPACKETLEN 2048
#define NUM_TDESCS 64
#define NUM_RDESCS 64
#define ENVID_QLEN 64
#define IOMEMBASE 0xFFC00000
#define RS 8
#define DD 1 
#define RXT0 (1<<7)

#define EN 0x2
#define SECRC (1<<26)

#define E1000_DEBUG "TX,TXERR"

#include <inc/types.h>



int e1000_attach(struct pci_func *f);
int e1000_transmit(void *buffer, size_t len);
int e1000_receive(void *buffer);
void e1000_trap_handler();

struct tx_desc
{
    uint64_t addr;
    uint16_t length;
    uint8_t cso;
    uint8_t cmd;
    uint8_t status;
    uint8_t css;
    uint16_t special;
};

struct rx_desc
{
    uint64_t addr;
    uint16_t length;
    uint16_t pcs;
    uint8_t status;
    uint8_t errors;
    uint16_t special;
};

#endif	// JOS_KERN_E1000_H
