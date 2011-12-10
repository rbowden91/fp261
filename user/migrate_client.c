// Client for sending requests to migrate processes.

#include <inc/lib.h>
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
	cprintf("migrate client is running\n");
	while (1) {
		cprintf("migrate client: waiting for pipe ipc\n");
		f = pipe_ipc_recv_read(&from_env);
		if (f < 0) panic("pipe_ipc_recv_read: %e", f);


		cprintf("migrate client: got pipe ipc\n");
		// If we're dealing with a response from the migrate daemon.
		if (from_env == ENVID_MIGRATED) {
			cprintf("migrate client: pipe ipc from migrate daemon\n");
			struct MigrateResponseHeader header;
			if ((r = read(f, &header, sizeof(struct MigrateResponseHeader)))
						!= sizeof(struct MigrateResponseHeader)) {
				panic("migrate client: read: %e", r < 0 ? r : -E_IO);
			}
			if (header.mr_magic != MIGRATE_RESPONSE_MAGIC) {
				panic("migrate client: malformed migrate response");
			}
			
			if ((r = pipe(p)) < 0) {
				panic("pipe: %e", r);
			}
			cprintf("sending ipc to recipient envid %x\n",
					header.mr_recipient_envid);
			assert(header.mr_recipient_envid != 0);
			if ((r = pipe_ipc_send(header.mr_recipient_envid, p[0])) < 0) {
				panic("migrate client: pipe_ipc_send: %e", r);
			}
			cprintf("successfully established pipe ipc with recipient env\n");

			/* Read from f and write to p[1], until EOF. */
			while ((amount_read = read(f, &buf, BUFSIZE)) > 0) {
				if ((r = write(p[1], &buf, amount_read)) != amount_read) {
					panic("migrate client: write: %e", (r < 0 ? r : -E_IO));
				}
			}
			if (amount_read < 0) {
				panic("migrate client: read: %e", amount_read);
			}
			cprintf("migrate client: wrote out contents of pipe.\n");
			
			// Otherwise, we've succeeded, but we've reached EOF.
			close(p[0]);
			close(p[1]);
			close(f);
		}
		// Otherwise, we're going to be sending to the migrate daemon.
		else {
			if ((r = pipe(p)) < 0) {
				panic("pipe: %e", r);
			}

			if ((r = pipe_ipc_send(ENVID_MIGRATED, p[0])) < 0) 	{
				panic("migrate client: pipe_ipc_send: %e", r);
			}

			/* Read from f and write to p[1], until EOF. */
			while ((amount_read = read(f, &buf, BUFSIZE)) > 0) {
				if ((r = write(p[1], &buf, amount_read)) != amount_read) {
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
}
