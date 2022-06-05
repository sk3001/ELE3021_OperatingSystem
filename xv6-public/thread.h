#ifndef _THREAD_H__
#define _THREAD_H__

typedef struct thread_mutex
{
  int flags;
  uint locked;
  void * owner;
} thread_mutex_t;

typedef struct thread_attr
{
  int flags;
  int waiters;
  thread_mutex_t *mutex;
} thread_cond_t;

typedef struct __sem_t {
  int value;
  thread_cond_t cond;
  thread_mutex_t lock;
} sem_t;



#endif
