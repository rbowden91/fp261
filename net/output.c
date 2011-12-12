#include "ns.h"

extern union Nsipc nsipcbuf;

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
        ipc_recv(&envid, &nsipcbuf, 0);
        if (envid != ENVID_NS)
            continue;
        while(sys_e1000_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len));
    }
}
