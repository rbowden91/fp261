// Client for sending requests to migrate processes.

#include <inc/lib.h>
#include <inc/connect.h>
#include <inc/migrate.h>

#define BUFSIZE 1024

void
umain(int argc, char **argv)
{
	char buf[BUFSIZE];
	assert(thisenv->env_id == ENVID_MIGRATE_CLIENT);
	int f, amount_read, r;
	envid_t from_env;
	uint32_t word_buf;
    int writesock, readsock;

	while (sys_get_network_connection(&writesock, &readsock) < 0) {
		sys_yield();
	}
	int ws = writesock;

	cprintf("migrate client is running\n");
	while (1) {
		cprintf("migrate client: waiting for pipe ipc\n");
		f = pipe_ipc_recv_read(&from_env);
		if (f < 0) panic("pipe_ipc_recv_read: %e", f);
		cprintf("migrate client: got pipe ipc\n");

		/* Read from f and write to p[1], until EOF. */
		while ((amount_read = read(f, &buf, BUFSIZE)) > 0) {
			cprintf("reading %d bytes\n", amount_read);
			cprintf("ws: %d\n", ws);
			if ((r = write(ws, &buf, amount_read)) != amount_read) {
				panic("migrate client: write: %e", (r < 0 ? r : -E_IO));
			}
		}
		if (amount_read < 0) {
			panic("migrate client: read: %e", amount_read);
		}
		
		// Otherwise, we've succeeded, but we've reached EOF.
		close(f);
	}
}
