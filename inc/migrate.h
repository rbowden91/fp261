// Public header file for process migration code.
// Includes core definitions.

#ifndef JOS_INC_MIGRATE_H
#define JOS_INC_MIGRATE_H 1

#include <inc/lib.h>

// XXX: Should there be a way to assign these at runtime/somewhere in
// configuration-space, rather than code-space?
// The port to use for receiving migration requests (see user/migrated.c)
#define RECV_PORT 4333
// The port to use for sending migration requests (see lib/migrate.c)
#define SEND_PORT 4242 

#define MIGRATE_MAGIC 0x1EFACADE
#define MIGRATE_PG_MAGIC 0XDECADE42

struct MigrateSuperHeader {
	uint32_t msh_magic; // must equal MIGRATE_MAGIC
    uintptr_t msh_pgfault_upcall;
	uint32_t msh_n_pages;
	struct Trapframe msh_tf;
}__attribute__((packed));

struct MigratePageHeader {
	uint32_t mph_magic; // must equal MIGRATE_PG_MAGIC
	void *mph_addr;
	int mph_perm;
}__attribute__((packed));

int migrate_spawn(int f);
int migrate();
int migrate_locally(void (*callback)(void));

#endif	// !JOS_INC_MIGRATE_H
