The Second Milestone
===================

Implementation Details
----------------------
These were defined in mainly `proc.h` and `proc.c`

#### proc.h
```c
struct proc {
  ...
  //Thread
  struct proc* manager;        // Manager lwp
  int isThread;                // If it is manager LWP then 0, else 1
  thread_t tid;                // To define single lwp ID
  void* ret_val;               // The return value of a thread
  uint theap;                  // Top of heap
  uint bstack;                 // Bottom of stack
};
```
`isThread` is used to detect every proc struct if it is Manager LWP or not.

`Manager` is used for LWPs those are not manager. And assign this variable to the manager LWP of these LWPs. calling `thread_exit()` makes return value and save it to `ret_val`. And if the manager calls `thread_join()` this value is sent to the manager.

`tid` is to define single LWP id.

To seperate heap and stack, used `theap` and `bstack`.


#### a) Thread_create
```c
int thread_create(thread_t* thread, void* (*start_routine)(void*), void* arg) {

	struct proc* np, * p;
	struct proc* curproc = myproc();
	uint sp, ustack[3];

	if ((np = allocproc()) == 0) {
		return -1;
	}

	// Allocate LWP stack
	if (growproc(2 * PGSIZE) != 0) {
		kfree(np->kstack);
		np->kstack = 0;
		np->state = UNUSED;
		return -1;
	}

	acquire(&ptable.lock);

	clearpteu(curproc->pgdir, (char*)(curproc->sz - 2 * PGSIZE));
	sp = curproc->sz;
	np->bstack = sp;
	np->theap = sp - 2 * PGSIZE;

	ustack[0] = 0xffffffff; // fake return PC
	ustack[1] = (uint)arg; // argument

	sp -= 8;
	if (copyout(curproc->pgdir, sp, ustack, 8) < 0) return -1;

	// Share resources with master process
	np->pgdir = curproc->pgdir;
	*np->tf = *curproc->tf;
	np->tid = nexttid++;
	*thread = np->tid;

	np->tf->eip = (uint)start_routine;
	np->tf->esp = sp;

	if (curproc->tid == 0) {
		// curproc is normal process
		np->manager->tid = curproc->pid;
	}
	else {
		// curproc is lwp
		np->manager->tid = curproc->manager->tid;
	}

	// share sz

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p->manager == curproc->manager) p->sz = curproc->sz;
	}

	release(&ptable.lock);

	np->parent = curproc;

	for (int i = 0; i < NOFILE; i++)
		if (curproc->ofile[i])
			np->ofile[i] = filedup(curproc->ofile[i]);
	np->cwd = idup(curproc->cwd);


	safestrcpy(np->name, curproc->name, sizeof(curproc->name));

	acquire(&ptable.lock);
	np->state = RUNNABLE;
	release(&ptable.lock);

	return 0;
}
```
It creates new LWP. It can be called by both normal LWP and manager LWP. LWPs share the same resources except stack. It is similar to `fork()` because by calling this, it is same as forking to a lwp. If it succeed it returns 0, if failure occurs then return other thing besides 0.

#### b) Thread_exit
```c
void thread_exit(void* retval){
        ...
	// Save retval value to LWP ret_val
	curproc->ret_val = retval;

	// Manager process might be sleeping in wait().
	wakeup1(curproc->manager);
        ...
}
```
Similar to `exit()`, this system call makes LWP into a zombie process. This function returns `retval` to use in `thread_join()`.

#### c) Thread_join
```c
int thread_join(thread_t thread, void** retval){
        ... 
	if (curproc->isThread)
		panic("If it is not manager, cannot call thread_join()");
        ...  
		// Wait for normal thread to exit
		sleep(curproc, &ptable.lock);
	}
}
```
It only can be called by manager LWP. If this function is called, then manager waits until other LWP exit and restore the resource they used. It is similar to `wait()` because manager acts as parent and other normal LWPs act as child in this function. By successfully executing this function by `retval` that `thread_exit()` has sent, it returns 0. Otherwise it returns other things besides 0. 