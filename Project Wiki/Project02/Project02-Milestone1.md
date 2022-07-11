The First Milestone
===================

a) Process/Thread
----------------
A process is a program that is executed consecutively in the computer. It is executed in the memory. When executed, it copies total memory and does context switching in whole address space.

A thread is a unit of programmed instructions flow which is executed in the process. Each thread share resources in the process, and has individual user stack to be executed individually. Context switch between threads in same process do not switch whole address space.

b) POSIX Thread
---------------
```c
int pthread_create(pthread_t *thread, const pthread_atr_t *attr, void *(*start_routine)(void*), void *arg);
```
It creates new thread in the process. Parameter `thread` refers to thread id. By using parameter `attr`, it can decide attributes of thread such as stack size. By using `arg` as a argument, `start_routine` function is executed. This function is function pointer of executing thread and it returns 0 when it succeed, and returns error num when it fails.

 ```c
int pthread_join(pthread_t thread, void **ret_val);
```
It waits until the thread which id is equal to parameter `thread` to exit. If this thread gets shut down by `pthread_exit` and meets `pthread_join`, memory gets freed. The return value of this thread is send to `**ret_val`.

```c
void pthread_exit(void *ret_val);
```
It shuts down the thread and returns value by `*ret_val` and the thread which is doing `pthread_join` gets this value.

c) Design Basic LWP Operations for xv6
--------------------------------------
### Understanding of Milestone 2 and 3

* LWP is a program executed in a process, but it allows multitasking by sharing system resources such as address space with other LWPs.
* A set of LWP running in same process is called LWP group, these LWPs share address space but for individual execution, they each have their own stack.
* In LWP group, they use same scheduling policy which is Round Robin. Context switching in LWP group occurs independent to scheduler.
* In LWP group, they share same time quantum and time allotment. So if LWP is scheduled by the MLFQ scheduler, it uses same time quantum with other LWPs in the group.
* If LWP calls `set_cpu_share`, all the LWPs in the group is scheduled in stride scheduler.

### Design for Milestone 2 and 3

##### Basic LWP Operations
**Proc struct**
* To define this process is LWP or not, it needs component which returns its parent process's pid which created this LWP. If this pid is -1 then it is not LWP, just normal process.
* And `lwpid` is needed to show this LWP's id.
* And for `pthread_exit`, to return the value, `ret_val` is also needed in LWP.

**a) Create**
* Normal process(not LWP) calls this function to make first LWP of the process by calling `fork()`. This LWP acts as manager in the process. And everytime calls this manager or other LWP creates new LWP, this new LWP gets same `lwppid` with other LWPs which refers to manager's `lwpid'. We also should add a global counter which keeps track the total number of created LWPs.

**b) Exit**
* Save return value in `ret_val` in the current LWP, and change the STATE to ZOMBIE so process to join will find this LWP.

**c) Join**
* The manager process can only call this. It will return all the resources that are ready to be joined and will add it into LWP group.

##### Interaction with other services in xv6

**a) Interaction with system calls in xv6**
1. Exit
* If this is called by normal process, then it checks the global value which checks the total number of LWP. And if it is not zero, then first exit individual LWPs first and exit current process. If it is called by LWP, then it is removed from the LWP group.

2. Fork
* If this is called from a LWP, then the child process should copy the resource of the LWP that called `fork()` and gets the `lwppid` same as the manager's 'lwpid'.

3. Exec
* If exec is called by LWP, this will turn to normal process and all the other LWP will be killed and be returned.

4. Sbrk
* When this function is called simultaneously by multiple LWPs, we need to take care of the concurrency and prevent the race conditions between the LWPs. So use `growproc()` to increase the manager thread's sz.

5. Kill
* If two and more LWP is killed, all LWPs are needed to be killed. And all the resources should be cleand up.

6. Pipe, Sleep
* It do not need any changing.

**b) Interaction with the schedulers: MLFQ and Stride**
* If LWP is scheduled, during the time quantum, if timer interrupt occurs, it will schedule next LWP in the same group.
* Switching between LWP do not call `swtch` and only change context and sp.
* The time one LWP in the same group possess the CPU in MLFQ will make an increase in the manager LWP's time quantum and time allotment. It will also applied in stride scheduling.
* If one LWP calls `set_cpu_share`, then the manager LWP will move to stride scheduling with taking the desired proportion called from `set_cpu_share`. 