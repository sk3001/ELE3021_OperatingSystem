The Second Milestone
===================

Implementation
==============

void scheduler(void)
--------------------
1. In `proc.h`, proc struct need some extra components to be scheduled in both MLFQ and stride.
```c
struct proc {
  //pre_assigned components

  //MLFQ scheduling
  int lv_MLFQ; //Highest : 0, Lowest : 2
  int ticks; //to send down to lower queues
  //Stride scheduling
  float current_pass; 
  float stride;
  int cpu_share;

  //Do a Round Robin in MLFQ
  int proc_order;

  int state_check;             // 0: stride, 1: MLFQ
};
```
2. Define requirements for MLFQ scheduling, and preventing over-possesing of CPU portion by Stride scheduler in `proc.h`.
```c++
#define H_QUEUE_QUANTUM 1
#define M_QUEUE_QUANTUM 2
#define L_QUEUE_QUANTUM 4

#define H_QUEUE_ALLOTMENT 5
#define M_QUEUE_ALLOTMENT 10

#define PRIORITY_BOOST_TIME 100

#define MAX_STRIDE_PORTION 80
```

3. As mentioned in Milestone 1, to give at least 20 percent of CPU, whole MLFQ scheduler is assumed as a process in stride defined in `proc.c`.
```c
struct {
  int cpu_percentage; //total percentage
  int checker_tick; //for priority boost

  //to assume MLFQ as a process in stride
  float current_pass;
  float stride;

}total_MLFQ;
```

4. In `allocproc(void)`, set proc struct components' initial value.
```c
  p->lv_MLFQ = 0;
  p->ticks = 0;
  p->current_pass = 0;
  p->stride = 0;
  p->cpu_share = 0;
  p->proc_order = 0;

  p->state_check = 0;
```

5. In `void scheduler(void)`, set current minimum pass as MLFQ's pass. And search through processes and find out pass of process which is less than MLFQ's pass.
```c
int count = 0; //count process in scheduler
// Loop over process table looking for process to run.
acquire(&ptable.lock);
    
tmp = 0;
float min_pass = total_MLFQ.current_pass;

for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  if(p->state != RUNNABLE)
    continue;
      
  count += 1;

  //to run stride scheduler starting from minimum pass process
  if(p->state_check == 0 && p->current_pass < min_pass){
    min_pass = p->current_pass;
    tmp = p;
  }
}
```

6. If minimum pass remained same after the search then according to code `tmp = p`, `tmp` will have the value 0 according to initial state. So `tmp == 0` means that MLFQ has the lowest pass and the scheduling will be held in MLFQ structures.
```c
    //if tmp remains 0 it equals MLFQ process has the minimum pass
    //so do a MLFQ scheduling
    if(tmp == 0){
    // ...
    // ...
    // ...
    // ...
        if(count == 0){
            total_MLFQ.current_pass = 0; //
        }
    }
```

7. Do a priority boost after 100 ticks and move all process to highest MLFQ and reset components that need to be used.
```c
//priority boosting
if (total_MLFQ.checker_tick == PRIORITY_BOOST_TIME) {
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != RUNNABLE)
            continue;

        p->lv_MLFQ = 0;
        p->ticks = 0;
        p->proc_order = 0;
    }
    total_MLFQ.checker_tick = 0;
    current_order = 0;
}
```

8. Send down process to lower level MLFQ, after pre-assigned time quantum.
```c
if (p->lv_MLFQ == 0) {
    if (p->ticks >= H_QUEUE_ALLOTMENT) {
        p->ticks = 0;
        p->lv_MLFQ += 1;
    }
    else if (p->ticks % H_QUEUE_QUANTUM == 0) {
        p->proc_order = current_order + 1;
    }

}

else if (p->lv_MLFQ == 1) {
    if (p->ticks >= M_QUEUE_ALLOTMENT) {
        p->ticks = 0;
        p->lv_MLFQ += 1;
    }
    else if (p->ticks % M_QUEUE_QUANTUM == 0) {
        p->proc_order = current_order + 1;
    }
}

else if (p->lv_MLFQ == 2) {
    if (p->ticks >= L_QUEUE_QUANTUM) {
        p->proc_order = current_order + 1;
    }
}
```
9. After every ticks, recalculate whole MLFQ's stride
```c
total_MLFQ.current_pass += (float)(1000 / (float)100 - total_MLFQ.cpu_percentage);
```
10. In step 6, if `p == tmp` then do stride scheduling and reset the pass of process by adding stride of the process every time when scheduled.
```c
  else if (p == tmp) {
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();

    p->current_pass += p->stride;

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;
  }
```

int getlev(void)
----------------
```c
int getlev(void) {
    struct proc* p = myproc();
    if (p == 0) //abnormal input
        return -1;

    return p->lv_MLFQ;
}
```

int set_cpu_share(int portion)
------------------------------
By setting the option in the code, it prevents stride scheduler having more than 80% of total CPU portion. 
```c
int set_cpu_share(int portion) {
    struct proc* p = myproc();

    acquire(&ptable.lock);

    //additional portion needed from stride scheduler,
    //if it exceeds 80, will return -1
    if (total_MLFQ.cpu_percentage + portion > MAX_STRIDE_PORTION) {
        release(&ptable.lock);
        return -1;
    }

    total_MLFQ.cpu_percentage += portion;
    p->cpu_share = portion;
    p->stride = (float)(1000 / (float)portion);
    p->state_check = 0;
    
    total_MLFQ.current_pass = 0;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != RUNNABLE || p->state_check == 1)
            continue;
        p->current_pass = 0;
    }

    release(&ptable.lock);
    return 0;
}
```

Test scheduler
--------------
Unfortunately, unreasonable errors occur in the code and it stops in the state of the below image when `make CPUS=1 qemu-nox` is executed. So couldn't get the analyzed result of this scheduler.


![화면_캡처_2022-04-19_235458](uploads/37852f7bf1186ec87c5b7ae8638aeb85/화면_캡처_2022-04-19_235458.png)
