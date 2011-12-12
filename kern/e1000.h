#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#define MAXPACKETLEN 1518
#define NUM_TDESCS 64
#define IOMEMBASE 0xFFC00000
#define RS 8
#define DD 1 


#include <inc/types.h>



int e1000_attach(struct pci_func *f);
int e1000_transmit(void *buffer, size_t len);

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


#endif	// JOS_KERN_E1000_H
