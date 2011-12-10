// Daemon for receviing requests to migrate processes.

#include <inc/lib.h>
#include <inc/connect.h>
#include <inc/migrate.h>

#define BUFSIZE 1024

void
umain(int argc, char **argv)
{
	char buf[BUFSIZE];
	assert(thisenv->env_id == ENVID_MIGRATED);
	int f, r, p[2];
	size_t size;
	int total_size, size_remaining, size_to_read, amount_read;
	uint32_t buffer_word;
	envid_t src_envid;
	envid_t from_env;
	// TODO: bind a socket.
    int writesock, readsock;

    if(mach_connect(&writesock, &readsock) < 0)
        panic("Could not connect with remote machine");

	envid_t envid = fork();
	// We are the child.
	if (envid == 0) {
		int ws = writesock;
		cprintf("migrate client is running\n");
		while (1) {
			cprintf("migrate client: waiting for pipe ipc\n");
			f = pipe_ipc_recv_read(&from_env);
			if (f < 0) panic("pipe_ipc_recv_read: %e", f);
			cprintf("migrate client: got pipe ipc\n");

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
			close(f);
		}
		return;
	}

	// Otherwise, we are the parent.
	// Assert that we forked something that will identified as the migrate
	// client.
	assert(envid == ENVID_MIGRATE_CLIENT);

	f = readsock;
	cprintf("migrated is running\n");
	while (1) {
		cprintf("migrated trying to read from fd %0x\n", f);
		if ((r = readn(f, &buffer_word, sizeof(uint32_t))) != sizeof(uint32_t)) {
			panic("migrated: read: %e", r < 0 ? r : - E_IO);
		}
		cprintf("migrated: read something\n");
		switch (buffer_word) {
			case MIGRATE_MAGIC:
				cprintf("calling migrate_spawn\n");
				migrate_spawn(f);
				break;
			case MIGRATE_PG_REQUEST_MAGIC:
				cprintf("MIGRATED: calling migrate_process_page_request\n");
				migrate_process_page_request(f);
				break;
			case MIGRATE_RESPONSE_MAGIC:
				struct MigrateResponseHeader header;
				size = sizeof(struct MigrateResponseHeader) - 4;
				if ((r = readn(f, ((char*)&header) + 4, size)) != size) {
					panic("migrate client: read: %e", r < 0 ? r : -E_IO);
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
				close(p[0]);
				cprintf("successfully established pipe ipc with recipient env\n");

				// We know that this is going to be a PageRequestResponse,
				// so we send exactly those many bytes over to our child
				// process.
				total_size =
					sizeof(struct MigratePageRequestResponseHeader) + PGSIZE;
				size_remaining = total_size;
				while (size_remaining > 0) {
					size_to_read = MIN(size_remaining, BUFSIZE);
					amount_read = readn(f, &buf, size_to_read);
					cprintf("migrated: amount_read: %x\n", amount_read);
					if (amount_read != size_to_read) {
						panic("migrated: read: %e", (r < 0 ? r : -E_IO));
					}
					if ((r = write(p[1], &buf, amount_read)) != amount_read) {
						panic("migrated: write: %e", (r < 0 ? r : -E_IO));
					}
					size_remaining -= amount_read;
				}
				cprintf("migrated: wrote out contents of pipe.\n");
				
				// Done with this pipe.
				close(p[0]);
				close(p[1]);
			default:
				panic("migrated: buffer word is not magic: %x", buffer_word);
		}
	}
}
