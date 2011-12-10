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
	uint32_t buffer_word;
	envid_t src_envid;
	// TODO: bind a socket.
    int writesock, readsock;

    if(mach_connect(&writesock, &readsock) < 0)
        panic("Could not connect with remote machine");
	f = readsock;

	cprintf("migrated is running\n");
	while (1) {
		if ((r = read(f, &buffer_word, sizeof(uint32_t))) != sizeof(uint32_t)) {
			panic("migrated: read: %e", r < 0 ? r : - E_IO);
		}
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
				size_t size = sizeof(struct MigrateResponseHeader);
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
				int total_size =
					sizeof(struct MigratePageRequestResponseHeader) + PGSIZE;
				int size_remaining = total_size;
				int size_to_read, amount_read;
				while (size_remaining > 0) {
					size_to_read = MIN(size_remaining, BUFSIZE);
					amount_read = readn(f, &buf, size_to_read);
					if (amount_read != size_to_read) {
						panic("migrated: read: %e", (r < 0 ? r : -E_IO));
					}
					if ((r = write(p[1], &buf, amount_read)) != amount_read) {
						panic("migrate client: write: %e", (r < 0 ? r : -E_IO));
					}
				}
				cprintf("migrated: wrote out contents of pipe.\n");
				
				// Done with this pipe.
				close(p[0]);
				close(p[1]);
		}
		close(f);
	}
}
