#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct thread thread[NTHREAD];
} ptable;

// MLFQ scheduler
static  struct {
  uint quan[3];
  uint allot[2];
  uint share;
  uint pass;
  uint boosted;
  struct proc *pin;
} mlfq = { {5, 10, 20}, {20, 40}, 100, 0, 0, ptable.proc };

// STRIDE scheduler
static struct {
  uint quan;
} stride = { 5 };

// Operating_Systems_Projects01
// Boosting MLFQ scheduler.
void
boost(void)
{
  struct proc *p;

  if(mlfq.boosted < 200)
    return;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->stype == MLFQ && p->qlev > HQLEV){
      p->qlev = HQLEV;
      p->pass = 0;
    }
  }
  mlfq.boosted = 0;
}

// reduce all pass values.
void
reduce(void)
{
  struct proc *p;

  if(mlfq.pass < MAXPASS)
    return;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->stype == STRIDE && p->pass < MAXPASS)
      return;

  mlfq.pass -= MAXPASS;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->stype == STRIDE)
      p->pass -= MAXPASS;
}
// Find process which have minimum value of pass.
// If there is no process in each scheduling, return 0.
// else return min pass value process.
struct proc *
getstrideproc(void)
{
  struct proc *minproc = 0;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->stype == STRIDE && p->state == RUNNABLE){
      if(!minproc)
        minproc = p;
      else if(p->pass < minproc->pass)
        minproc = p;
    }
  }
  return minproc;
}

struct proc *
getmlfqproc(void)
{
  struct proc *p;

  p = mlfq.pin + 1;
  for(;;){
    for(; p < &ptable.proc[NPROC]; p++){
      if(p->stype == MLFQ && p->state == RUNNABLE)
        return p;
      if(p == mlfq.pin)
        return 0;
    }
    p = ptable.proc;
  }
}

struct proc *
getschedproc(void)
{
  struct proc *p;
  struct proc *p1 = getstrideproc();
  struct proc *p2 = getmlfqproc();

  if(p1 && p2)
    p = p1->pass < mlfq.pass ? p1 : p2;
  else if(p1)
    p = p1;
  else if(p2)
    p = p2;
  else
    p = 0;

  if(p2 && p == p2)
    mlfq.pin = p2;
  return p;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct thread *t;
  struct cpu *c = mycpu();
  c->proc = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    // Reduce pass value.
    reduce();

    // Check whether MLFQ priority boosting should execute or not.
    boost();

    if((p = getschedproc())){
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      if((t = nextthd(p)) == 0)
        panic("no thread in process (scheduler)");

      c->proc = p;
      c->thd = t;
      switchuvm(p);

      p->ticks = 0;
      setstate(p, t, RUNNING);

      swtch(&(c->scheduler), t->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      c->thd = 0;

      if(p->stype == STRIDE)
        p->pass += TICKETS * p->ticks / p->share;
      else{
        mlfq.pass += TICKETS * p->ticks / mlfq.share;
        mlfq.boosted += p->ticks;
      }

      // When MLFQ process' pass is more than time allotment,
      // decrease queue level.
      if(p->stype == MLFQ && p->qlev < LQLEV)
        if(p->pass >= mlfq.allot[p->qlev]) {
          p->qlev++;
          p->pass = 0;
        }
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  uint quan;
  struct thread *t;
  struct proc *curproc = myproc();
  struct thread *curthd = mythd();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(curthd->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");

  curproc->ticks++;
  if(curproc->stype == MLFQ)
    curproc->pass++;

  if(curproc->stype == STRIDE)
    quan = stride.quan;
  else
    quan = mlfq.quan[curproc->qlev];

  if(curproc->state == RUNNABLE && curproc->ticks < quan){
    if((t = nextthd(curproc)) == 0)
      panic("no thread in process (sched)");
    // Thread swtich.
    setstate(curproc, t, RUNNING);

    if(curthd != t){
      intena = mycpu()->intena;
      mycpu()->thd = t;
      pushcli();
      mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
      popcli();
      swtch(&curthd->context, t->context);
      mycpu()->intena = intena;
    }
  }else{
    // Scheduler swtich.
    intena = mycpu()->intena;
    swtch(&curthd->context, mycpu()->scheduler);
    mycpu()->intena = intena;
  }
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  struct thread *t = mythd();

  acquire(&ptable.lock);  //DOC: yieldlock
  setstate(p, t, RUNNABLE);

  sched();
  release(&ptable.lock);
}

// Operating_Systems_Projects01
// Change MLFQ process to Stride scheduling.
int
set_cpu_share(int share)
{
  uint new;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);

  if(share <= 0){
    if(curproc->stype == STRIDE){
      mlfq.share += curproc->share;
      curproc->stype = MLFQ;
      curproc->qlev = HQLEV;
      curproc->share = 0;
      curproc->pass = 0;
    }
    release(&ptable.lock);
    return 0;
  }

  if(curproc->stype == STRIDE)
    new = mlfq.share + curproc->share - share;
  else
    new = mlfq.share - share;

  if(new < 20){
    release(&ptable.lock);
    return -1;
  }

  mlfq.share = new;
  curproc->stype = STRIDE;
  curproc->qlev = 0;
  curproc->share = share;
  curproc->pass = mlfq.pass;

  release(&ptable.lock);
  return 0;
}
