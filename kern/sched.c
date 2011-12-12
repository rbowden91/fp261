#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>
#include <kern/sched.h>

static int last_env = 0;

// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

    // if PRIORITY (from sched.h) is true, we do priority scheduling
    
    Env *cur_choice = NULL; // the next candidate
    int match = (last_env?last_env:NENV);
    int cur = (last_env+1)%NENV;
    while(cur != match)
    {
        
        // priority version
        if(PRIORITY)
        {
            if (envs[cur].env_status == ENV_RUNNABLE &&
               (!cur_choice || envs[cur].env_priority<cur_choice->env_priority))
                    cur_choice = &envs[cur]; 
        }

        // round robin version
	    else if (envs[cur].env_status == ENV_RUNNABLE)
        {
            last_env = cur;
		    env_run(&envs[cur]);
        }
        // ids only go up so high, then wrap around
        if(++cur == NENV)
            cur = 1;
    }

    // priority version
    if(PRIORITY)
    {
        // if the env that just yielded is of higher priority, run it again
        if (envs[last_env].env_status == ENV_RUNNABLE && (!cur_choice || envs[last_env].env_priority < cur_choice->env_priority))
            cur_choice = &envs[last_env];
        // run the env
        if(cur_choice)
        {
            env_run(cur_choice);
            last_env = ENVX(cur_choice->env_id);
        }
    }
    // round robin version
    // if there wasn't another env to run, try to run the 
    // previous env that was running
    else if (envs[last_env].env_status == ENV_RUNNABLE)
        env_run(&envs[last_env]);
    cprintf("Idle loop - nothing more to do!\n");
    env_run(&envs[0]);
    while (1)
        monitor(NULL);
}
