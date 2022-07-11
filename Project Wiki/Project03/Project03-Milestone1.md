The First Milestone
===================

## Understanding of the Project
#### a) Semaphore/Readers-writer lock
* A semaphore is an object with an integer value that we can manipulate with two routines. In the POSIX standard, these routines are `sem_wait()`, and `sem_post()`.
* To support several operation such as insert and search, reader-writer lock is needed.

#### b) POSIX semaphore
* `sem_t`: single semaphore structure
* `int sem_init(sem_t *sem, int pshared, unsigned int value);`: Initialize single semaphore and set a value.
* `int sem_wait(sem_t *sem);`: Decrement the value of semaphore `sem` by one. Wait if value of semaphore `sem` is negative.
* `int sem_post(sem_t *sem);`: Increment the value of semaphore `sem` by one. If there are one or more threads waiting, wake one.

#### c) POSIX reader-writer lock
* `pthread_rwlock_t`: Basic Reader-writer lock 
* `int pthread_rwlock_init(pthread_rwlock_t* lock, const pthread_rwlockattr attr);`: Initialize reader-writer lock and `sem_init()`.
* `int pthread_rwlock_rdlock(pthread_rwlock_t* lock);`: reader thread earns reader lock to read
* `int pthread_rwlock_wrlock(pthread_rwlock_t* lock);`: writer thread earns writer lock to write
* `int pthread_rwlock_unlock(pthread_rwlock_t* lock);`: free the lock that is initialized
