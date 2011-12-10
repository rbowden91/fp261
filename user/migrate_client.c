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
	int f, amount_read, r, p[2];
	envid_t from_env;
	uint32_t word_buf;
    int writesock, readsock;

    if(mach_connect(&writesock, &readsock) < 0)
        panic("Could not connect with remote machine");
	int ws = writesock;

	cprintf("migrate client is running\n");
	while (1) {
		cprintf("migrate client: waiting for pipe ipc\n");
		f = pipe_ipc_recv_read(&from_env);
		if (f < 0) panic("pipe_ipc_recv_read: %e", f);

		if ((r = pipe(p)) < 0) {
			panic("pipe: %e", r);
		}

		if ((r = pipe_ipc_send(ENVID_MIGRATED, p[0])) < 0) 	{
			panic("migrate client: pipe_ipc_send: %e", r);
		}

		/* Read from f and write to p[1], until EOF. */
		while ((amount_read = read(f, &buf, BUFSIZE)) > 0) {
			if ((r = write(ws, &buf, amount_read)) != amount_read) {
				panic("migrate client: write: %e", (r < 0 ? r : -E_IO));
			}
		}
		if (amount_read < 0) {
			panic("migrate client: read: %e", amount_read);
		}
		
		// Otherwise, we've succeeded, but we've reached EOF.
		close(p[0]);
		close(p[1]);
		close(f);
	}
}
