#include <inc/connect.h>
#include <inc/lib.h>
#include <lwip/sockets.h>
#include <lwip/inet.h>

#define IPADDR "10.0.2.2"
#define TOPORT1 1233
#define TOPORT2 1235
#define FROMPORT1 1234
#define FROMPORT2 1236

static int to_mach_sock = -1, from_mach_sock = -1;

int
mach_connect(int *writesock, int *readsock)
{
	struct sockaddr_in server;

    if(!(writesock && readsock))
        return -1;

    // for now, only one connection is allowed, so if it has already been made
    // return it
    if(to_mach_sock != -1)
    {
        *writesock = to_mach_sock;
        *readsock = from_mach_sock;
        return 0;
    }

    for (int i = 0; i < 2; i++)
    {
	    int sock, port;
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
		    return -1;
	    
        // Construct the server sockaddr_in structure
        memset(&server, 0, sizeof(server));       // Clear struct
        server.sin_family = AF_INET;                  // Internet/IP
        server.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
        
        switch(MACHINE + 2 * i)
        {
            case 0: port = TOPORT1; break;
            case 1: port = FROMPORT1; break;
            case 2: port = FROMPORT2; break;
            case 3: port = TOPORT2; break;
            default: port = 0; return -1;
        }

        server.sin_port = htons(port);  // server port

        // Establish connection
        if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
            return -1;

        cprintf("connected to server\n");
        switch(MACHINE + 2 * i)
        {
            case 0: to_mach_sock = sock; break;
            case 1: from_mach_sock = sock; break;
            case 2: from_mach_sock = sock; break;
            case 3: to_mach_sock = sock; break;
        }
    }
    *writesock = to_mach_sock;
    *readsock = from_mach_sock;
    return 0;
}
