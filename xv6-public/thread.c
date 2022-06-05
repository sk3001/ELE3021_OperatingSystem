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

int nexttid = 1;
extern void forkret(void);
extern void trapret(void);


// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct thread *
allocthd(struct proc *p)
{
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
    if(t->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  t->state = EMBRYO;
  t->tid = nexttid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((t->kstack = kalloc()) == 0){
    t->state = UNUSED;
    return 0;
  }

  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
  t->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
  t->context->eip = (uint)forkret;

  t->mp = p;

  return t;
}

int
allthdexit(void)
{
  int havethds;
  struct thread *t;
  struct proc *curproc = myproc();
  struct thread *curthd = mythd();

  if(curproc->exited)
    return -1;

  curproc->exited = 1;
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
    if(t->mp == curproc && t->state == SLEEPING)
      setstate(curproc, t, RUNNABLE);

  for(;;){
    havethds = 0;
    for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
      if(t == curthd)
        continue;
      if(t->mp == curproc && t->state != ZOMBIE){
        havethds = 1;
        break;
      }
    }

    if(!havethds)
      break;
    if(curproc->killed){
      curproc->exited = 0;
      return -1;
    }
    sleep(curproc, &ptable.lock);
  }
  curproc->exited = 0;
  return 0;
}

// Create thread
int
thread_create(thread_t *thread, void *(start_routine) (void*), void *arg)
{
  uint sp, ustack[2];
  struct thread *nth;
  struct proc *curproc = myproc();
  struct thread *curthd = mythd();

  if ((nth = allocthd(curproc)) == 0)
    return -1;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  if ((sp = ualloc(curproc)) == 0){
    kfree(nth->kstack);
    nth->kstack = 0;
    nth->state = UNUSED;
    return -1;
  }
  nth->usp = sp;

  // Push argument in ustack.
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;

  sp -= 8;
  if(copyout(curproc->pgdir, sp, ustack, 8) < 0){
    kfree(nth->kstack);
    ufree(curproc, nth->usp);
    nth->kstack = 0;
    nth->usp = 0;
    nth->state = UNUSED;
    return -1;
  }

  *nth->tf = *curthd->tf;
  nth->tf->eip = (uint)start_routine;  // function
  nth->tf->esp = sp;

  *thread = (thread_t)nth->tid;

  acquire(&ptable.lock);

  nth->state = RUNNABLE;
  curproc->state = RUNNABLE;

  release(&ptable.lock);
  return 0;
}

// thread exit
void
thread_exit(void *retval)
{
  int havethds;
  struct thread *t;
  struct proc *curproc = myproc();
  struct thread *curthd = mythd();

  acquire(&ptable.lock);
  havethds = 0;
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
    if(t->mp == curproc && t != curthd)
      if(t->state > ZOMBIE){
        havethds = 1;
        break;
      }
  release(&ptable.lock);

  if(!havethds)
    exit();

  // Store result in eax.
  curthd->tf->eax = (uint)retval;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curthd->mp);

  // Jump into the scheduler, never to return.
  setstate(curproc, curthd, ZOMBIE);
  sched();
  panic("zombie thread_exit");
}

int
thread_join(thread_t thread, void **retval)
{
  int havethds;
  struct proc *curproc = myproc();
  struct thread *t;
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited thread.
    havethds = 0;
    for (t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
      if(t->mp != curproc || t->tid != (int)thread)
        continue;
      havethds = 1;
      if(t->state == ZOMBIE){
        // Found one.
        *retval = (void*)t->tf->eax;
        kfree(t->kstack);
        ufree(curproc, t->usp);
        t->kstack = 0;
        t->usp = 0;
        t->state = UNUSED;
        t->tid = 0;
        t->mp = 0;
        release(&ptable.lock);
        return 0;
      }
    }

    // No point waiting if we don't have any thread.
    if(!havethds || myproc()->killed || myproc()->exited){
      release(&ptable.lock);
      return -1;
    }

    // Wait for thread to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

struct thread *
nextthd(struct proc *p)
{
  struct thread *t;

  t = p->pin + 1;
  for(;;){
    for(;t < &ptable.thread[NTHREAD]; t++){
      if(t->mp == p && t->state == RUNNABLE){
        p->pin = t;
        return t;
      }

      if(t == p->pin)
        return 0;
    }
    t = ptable.thread;
  }
}
