The Second Milestone
===================

## Implementation Details
```c
typedef struct __xem_t {
    int value;
    int active; //to check the state of semaphore
    struct spinlock lock;
} xem_t;

typedef struct __rwlock_t {
    xem_t lock;      // Basic lock
    xem_t writelock; // Allow One writer/Several Reader
    int readers;     // Number of readers doing reading
} rwlock_t;
```
```c
int xem_init(xem_t* semaphore) {
    acquire(&semaphore.lock);

    if (semaphore->active = 0) {
        semaphore->active = 1;
        semaphore->value = 1;
    }
    else {
        return -1;
    }

    release(&semaphore.lock);
    return 0;
}

int xem_wait(xem_t* semaphore) {
    acquire(&semaphore.lock);

    if (semaphore->value >= 1)
        semaphore->value -= 1;
    else {
        while (semaphore->value < 1)
            sleep(&semaphore, &semaphore.lock);
        semaphore->value -= 1;
    }
}

int xem_unlock(xem_t* semaphore) {
    acquire(&semaphore.lock);
    semaphore->active = 0;
    release(&semaphore.lock);

    return 0;
}
```
`xem_init` initializes semaphore and `xem_wait` controls the value of the semaphore. And by calling `xem_unlock` this semaphore gets freed.

```c
int rwlock_init(rwlock_t* rwlock) {
    rwlock->readers = 0;
    xem_init(&rwlock->lock);
    xem_init(&rwlock->writelock);
}

int rwlock_acquire_readlock(rwlock_t* rwlock) {
    xem_wait(&rwlock->lock);
    rwlock->readers++;
    if (rwlock->readers == 1)
        xem_wait(&rwlock->writelock);
    xem_unlock(&rwlock->lock);
}

int rwlock_acquire_writelock(rwlock_t* rwlock) {
    xem_wait(&rwlock->writelock);
}

int rwlock_release_readlock(rwlock_t* rwlock) {
    xem_wait(&rwlock->lock);
    rw->readers--;
    if (rwlock->readers == 0)
        xem_unlock(&rwlock->writelock);
    xem_unlock(&rwlock->lock);
}

int rwlock_relaese_writelock(rwlock_t* rwlock) {
    xem_unlock(&rwlock->writelock);
}
```
`rwlock_init` initializes reader-writer lock. `rwlock_acquire_readlock`/`rwlock_acquire_writelock` each of them earns read/write lock for doing operations. `rwlock_release_readlock`/`rwlock_release_writelock` frees read/write lock by calling `xem_unlock`.