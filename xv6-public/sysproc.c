#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

// Operating_Systems_Projects01
int
sys_yield(void)
{
  yield();
  return 0;
}

int
sys_getlev(void)
{
  if(myproc()->stype == MLFQ)
    return myproc()->qlev;

  return -1;
}

int
sys_set_cpu_share(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
  return set_cpu_share(n);
}


// Operating_Systems_Projects02
int
sys_thread_create(void)
{
  int i, argv[3];
  for (i = 0; i < 3; i++)
    if (argint(i, &argv[i]) < 0)
      return -1;
  return thread_create((thread_t*)argv[0], (void* (*)(void*))argv[1], (void*) argv[2]);
}

int
sys_thread_exit(void)
{
  int n;
    if (argint(0, &n) < 0)
      return -1;
  thread_exit((void*)n);
  return 0;
}

int
sys_thread_join(void)
{
  int i, argv[2];
  for (i = 0; i < 2; i++)
    if (argint(i, &argv[i]) < 0)
      return -1;
  return thread_join((thread_t)argv[0], (void**)argv[1]);
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
//    if(myproc()->killed){
    if(myproc()->killed || myproc()->exited){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
