The Third Milestone
===================

Implementation Details
----------------------

Second step: Interaction with other services in xv6
---------------------------------------------------
a) Interaction with system calls in xv6
1. Exit
```c
void
exit(void)
{
	struct proc* curproc = myproc();
	struct proc* p, * tmp;
	int fd;

	if (curproc == initproc)
		panic("init exiting");
	if (curproc->pid != curproc->manager->tid) {
		acquire(&ptable.lock);

		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
			if (p->manager == curproc->manager && p->pid == p->manager->tid) {
				p->killed = 1;
				p->state = RUNNABLE;
				break;
			}
		}

		curproc->state = ZOMBIE;
		sched();
		panic("zombie exit");
	}

	for (int i = 0; i < NPROC; i++) {
		acquire(&ptable.lock);
		tmp = &ptable.proc[i];
		release(&ptable.lock);

		if (tmp->manager->tid != curproc->manager->tid) continue;

		// Close all open files.
		for (fd = 0; fd < NOFILE; fd++) {
			if (tmp->ofile[fd]) {
				fileclose(tmp->ofile[fd]);
				tmp->ofile[fd] = 0;
			}
		}

		begin_op();
		iput(tmp->cwd);
		end_op();
		tmp->cwd = 0;

		acquire(&ptable.lock);
		// Pass abandoned children to init.


		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
			if (p->parent == tmp && p->manager->tid != tmp->manager->tid) {
				p->parent = initproc;
				if (p->state == ZOMBIE)
					wakeup1(initproc);
			}
		}

		// Jump into the scheduler, never to return.
		if (tmp != curproc) {
			kfree(tmp->kstack);
			tmp->kstack = 0;
			tmp->parent = 0;
			tmp->name[0] = 0;
			tmp->killed = 0;
			tmp->state = UNUSED;

			// Clean up LWP user stack..
			tmp->sz = deallocuvm(tmp->pgdir, tmp->bstack, tmp->bstack - 2 * PGSIZE);

			tmp->sz = 0;
			tmp->theap = 0;
			tmp->bstack = 0;
		}
		release(&ptable.lock);
	}

	acquire(&ptable.lock);

	for (struct proc* tmp = ptable.proc; tmp < &ptable.proc[NPROC]; tmp++) {
		if (tmp->manager->tid == curproc->manager->tid && tmp != curproc) {
			tmp->manager = 0;
			tmp->pid = 0;
		}
	}

	curproc->state = ZOMBIE;
	wakeup1(curproc->parent);

	sched();
	panic("zombie exit");
}
```
Remove all lwp and the resources they use related to one manager lwp and exit. Acts as `thread_join` for the threads under the manager lwp.

2. Fork
Fork follows current system call.

3. Kill
```c
int
kill(int pid)
{
        ...
			for (struct proc* tmp = ptable.proc; tmp < &ptable.proc[NPROC]; tmp++) {
				if (tmp->manager == p->manager) {
					tmp->killed = 1;
					// Wake process from sleep if necessary.
					if (tmp->state == SLEEPING)
						tmp->state = RUNNABLE;
				}
			}
	...
}
```
If the manager of one lwp is same as process that called `kill`, then set killed to 1. And `exit` system call will remove those process.