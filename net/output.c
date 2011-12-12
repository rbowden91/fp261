#include "ns.h"

#define PKTMAP		0x10000000

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";
    envid_t envid;
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
    while(1)
    {
        
        ipc_recv(&envid, 
        if (envid != NS_ENVID)
            continue;
        struct jif_pkt *jp = (struct jif_pkt *)UTEMP;
        while(sys_e1000_transmit(jp->jp_len, jp->jp_data) < 0)
            sched_yield();
    }
}
