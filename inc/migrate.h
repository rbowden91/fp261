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

#define MEM_BARRIER asm volatile("" : : : "memory")

#define MIGRATE_MAGIC 0x1EFACADE
#define MIGRATE_PG_MAGIC 0xDECADE42
#define MIGRATE_RESPONSE_MAGIC 0xD15EA5E
#define MIGRATE_PG_REQUEST_MAGIC 0xCAFEBABE
#define MIGRATE_PG_REQUEST_RESPONSE_MAGIC 0xDEADFACE

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
	bool mph_mapped_remote_src; // for Page.pp_exists_on_remote_machine
}__attribute__((packed));

struct MigratePageRequest {
	uint32_t mpr_magic; // must equal MIGRATE_PG_REQUEST_MAGIC
	envid_t mpr_src_envid;
	physaddr_t mpr_physaddr;
	physaddr_t mpr_physaddr_on_requesting_machine;
}__attribute__((packed));

struct MigrateResponseHeader {
	uint32_t mr_magic; // must equal MIGRATE_RESPONSE_MAGIC
	envid_t mr_recipient_envid;
}__attribute__((packed));


struct MigratePageRequestResponseHeader {
	uint32_t mprr_magic; // must equal MIGRATE_PG_REQUEST_RESPONSE_MAGIC
	physaddr_t mprr_physaddr;
}__attribute__((packed));

int migrate_spawn(int f);
int migrate_locally(void (*callback)(void));
int migrate();



int migrate_process_page_request(int f);

#endif	// !JOS_INC_MIGRATE_H
