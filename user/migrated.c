// Daemon for receiving requests to migrate processes

#include <inc/lib.h>
#include <inc/migrate.h>
#include <inc/connect.h>

void
umain(int argc, char **argv)
{
    assert(thisenv->env_id == ENVID_MIGRATED);
    int f, r;
    // TODO: bind a socket.
    int writesock, readsock;

    if(mach_connect(&writesock, &readsock) < 0)
        panic("Could not connect with remote machine");

    while (1) {
        if ((r = migrate_spawn(readsock)) < 0)
            panic("migrate_spawn: %e\n", r);
    }
    // for now, the link between machines is never closed
    // close(f);
}
