#include <inc/lib.h>
#include <inc/migrate.h>

static void
pgfault_handler(UTrapframe *t)
{
    cprintf("Now we're in the upcall!\n");
    exit();
}


static int fact(int n)
{
    if(n == 0)
        return migrate() + 1;
    return n * fact(n-1);
}

void
umain(int argc, char **argv) {
    cprintf("starting in umain\n");
    add_pgfault_handler(pgfault_handler);
    cprintf("%08x\n", thisenv->env_pgfault_upcall);
    cprintf("%d fact\n", fact(11));

    cprintf("[%08x]: Hello from your migrated process!\n", thisenv->env_id);
    int *x = (int *)0xdeadbeef;
    *x = 3;
}
