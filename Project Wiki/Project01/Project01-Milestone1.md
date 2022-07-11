The First Milestone
===================

First step: MLFQ
----------------
### Requirements
 * 3-level feedback queue
 * Each level of queue adopts a Round Robin policy with different time quantum
 * To prevent starvation, priority boost is required
 * Lower level queue is selected only if upper level queue is empty
 * Each level adopts the Round Roibn policy with different time quantum.
   + The highest priority queue: 1 tick
   + Middle priority queue: 2 ticks
   + The lowest priority queue: 4 ticks
 * Each queue has a different time allotment.
   + The highest priority queue: 5 ticks
   + Middle priority queue: 10 ticks
 * MLFQ should always occupy at least 20% of the CPU share.

### Flow
 1. If process enters the MLFQ, its it first gets into the highest priority queue.
 2. To check the current state, process has `int current state` variable. This variable is 0 while scheduled, else -1. And has `int lv_MLFQ` variable to check the priority level of MLFQ, which is 0 at the initial state and 2 at the lowest queue, and -1 if it is not current. Finally, to check the ticks to move the process into different queue, `int ticks` checks the current ticks of the process.
 3. For every tick, check the current level of by system call `int getlev()` with variable `int lv_MLFQ` and use it to schedule the current queue by Round Robin policy.
 4. After the time alloted for current queue has past, it gets down to lower priority queue. This applies until it gets to the lowest priority queue. 
 5. After every 100 ticks, all process in middle and lowest queue boost up to highest queue. And reset all the values of process same as its initial state.

Second step: Combine the *stride scheduling* algorithm with MLFQ
----------------------------------------------------------------
### Requirements
 * Make a system call (i.e. set_cpu_share) that requests a portion of CPU and guarantees the calling process to be allocated that much of a CPU time.
 * The total amount of stride processes are able to get at most 80% of the CPU time. Exception handling is required for exceeding requests.
 * The rest of the CPU time (20%) should run for the MLFQ scheduling which is the default scheduling policy in this project

### Flow
 1. The basic scheduler is MLFQ, and *Stride scheduling* is executed by calling `set_cpu_share(int)`.
 2. Set the total tickets 100 and calculate the stride by parameter int from `set_cpu_share(int)`.
 3. Set global variable which has value 80, and every time `set_cpu_share(int)` is called, compare with the global value and if it exceeds 80(which equals it exceeds 80% of CPU share), then the system call throw an exception and returns -1 and do not run stride scheduling, else 0. Returned 0, allocate remain proportion to MLFQ. For this to happen, consider the MLFQ as process that has 20 tickets fixed to ensure MLFQ at least 20% of entire CPU.
 4. If returned 0, the process is in stride scheduling. Calculate the stride of a process by the parameter of a `set_cpu_share(int)` which refers to tickets of the process. And every process possess the value of stride and current pass. Then do the stride scheduling by this stride. In previous step, MLFQ is defined as process having 20 tickets. So, by updating current pass, we can select from MLFQ or stride scheduling to execute for every tick.
 5. After every ticks, update the current pass of every process running in the queue. And if new process comes in the queue, it gets the lowest pass of the current processes running in the queue. This helps to prevent one process possessing most of time of CPU.
 6. By calling `int sys_yield()` next process is executed.
 7. Same as MLFQ, if process finishes, it returns -1.