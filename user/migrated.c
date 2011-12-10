// Daemon for receviing requests to migrate processes.

#include <inc/lib.h>
#include <inc/migrate.h>

void
umain(int argc, char **argv)
{
	assert(thisenv->env_id == ENVID_MIGRATED);
	int f, r;
	uint32_t buffer_word;
	envid_t src_envid;
	// TODO: bind a socket.
	cprintf("migrated is running\n");
	while (1) {
		cprintf("migrated: waiting for pipe ipc\n");
		f = pipe_ipc_recv_read(&src_envid);
		if (f < 0) panic("pipe_ipc_recv_read: %e", f);
		
		if ((r = read(f, &buffer_word, sizeof(uint32_t))) != sizeof(uint32_t)) {
			panic("migrate_spawn: read: %e", r < 0 ? r : - E_IO);
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
		}
		close(f);
	}
}
