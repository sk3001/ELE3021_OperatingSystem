/**
 * This program runs various workloads cuncurrently.
 */


#include "types.h"
#include "stat.h"
#include "user.h"

#define LIFETIME		    (1000)	/* (ticks) */
#define COUNT_PERIOD	    (1000000)	/* (iteration) */

#define MLFQ_LEVEL		    (3)	/* Number of level(priority) of MLFQ scheduler */
#define MLFQ_SCHEDULER      (0)
#define STRIDE_SCHEDULER    (1)

#define MAX_WORKLOAD_NUM    (10)
#define MAX_BUF             (1024)
#define READ                (0)
#define WRITE               (1)

struct workload {
	void (*func)(int, int *);
	int arg;
};

/**
 * This function requests portion of CPU resources with given parameter
 * value by calling set_cpu_share() system call.
 * It reports the cnt value which have been accumulated during LIFETIME.
 */
void
test_stride(int portion, int *value)
{
	int cnt = 0;
	int i = 0;
	int start_tick;
	int curr_tick;

	if (set_cpu_share(portion) != 0) {
		printf(1, "FAIL : set_cpu_share(%d)\n", portion);
        goto end;
	}

	/* Get start tick */
	start_tick = uptime();

	for (;;) {
		i++;
		if (i >= COUNT_PERIOD) {
			cnt++;
			i = 0;

			/* Get current tick */
			curr_tick = uptime();

			if (curr_tick - start_tick > LIFETIME) {
				/* Time to terminate */
				break;
			}
		}
	}

end:
    value[0] = STRIDE_SCHEDULER;
    value[1] = portion;
    value[2] = cnt;
    return;
}

/**
 * This function request to make this process scheduled in MLFQ. 
 * MLFQ_NONE			: report only the cnt value
 * MLFQ_LEVCNT			: report the cnt values about each level
 * MLFQ_YIELD			: yield itself, report only the cnt value
 * MLFQ_YIELD_LEVCNT	: yield itself, report the cnt values about each level
 */
enum { MLFQ_NONE, MLFQ_LEVCNT, MLFQ_YIELD, MLFQ_LEVCNT_YIELD };
void
test_mlfq(int type, int *value)
{
	int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
	int cnt = 0;
	int i = 0;
	int curr_mlfq_level;
	int start_tick;
	int curr_tick;

	/* Get start tick */
	start_tick = uptime();

	for (;;) {
		i++;
		if (i >= COUNT_PERIOD) {
			cnt++;
			i = 0;

			if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
				/* Count per level */
				curr_mlfq_level = getlev(); /* getlev : system call */
				cnt_level[curr_mlfq_level]++;
			}

			/* Get current tick */
			curr_tick = uptime();

			if (curr_tick - start_tick > LIFETIME) {
				/* Time to terminate */
				break;
			}

			if (type == MLFQ_YIELD || type == MLFQ_LEVCNT_YIELD) {
				/* Yield process itself, not by timer interrupt */
				yield();
			}
		}
	}

    value[0] = MLFQ_SCHEDULER;
    value[1] = type;
    value[2] = cnt;
    return;
}

/* Report */
void
report(int n, int **list)
{
    int total_cnt, mlfq_cnt, mlfq_share;
    int real_share, loss; // loss = |expected_share - real_share|
    int exp, frac, loss_exp, loss_frac;
    int i;

    total_cnt = mlfq_cnt = 0;
    mlfq_share = 100;

    for (i = 0; i < n; i++) {
        total_cnt += list[i][2];

        if (list[i][0] == STRIDE_SCHEDULER) {
            mlfq_share -= list[i][1];
        } else {
            mlfq_cnt++;
        }
    }

    for (i = 0; i < n; i++) {
        // calcuate real_share and loss.
        real_share = list[i][2] * 1000 / total_cnt;

        if (list[i][0] == STRIDE_SCHEDULER) {
            loss = list[i][1] * 10 - real_share;
        } else {
            loss = (mlfq_share * 10 / mlfq_cnt) - real_share;
        }

        if (loss < 0) { loss *= -1; }

        exp = real_share / 10;
        frac = real_share % 10;
        loss_exp = loss / 10;
        loss_frac = loss % 10;

        if (list[i][0] == STRIDE_SCHEDULER) {
        	printf(1, "| STRIDE(%d%%), real_share : %d.%d%%, loss : %d.%d\n", list[i][1], exp, frac, loss_exp, loss_frac);
        } else {
        	printf(1, "| MLFQ(%s:%d%%), real_share : %d.%d%%, loss : %d.%d\n",
                    list[i][1] == MLFQ_LEVCNT || list[i][1] == MLFQ_NONE ? "compute" : "yield", mlfq_share, exp, frac, loss_exp, loss_frac);
        }
    }

}

void
set_process(int n, struct workload *workloads)
{
    int fd[2];
	int pid, i;

    if (pipe(fd) == -1) {
        printf(1, "FAIL: pipe\n");
        exit();
    }
    
	for (i = 0; i < n; i++) {
		pid = fork();
		if (pid > 0) {
			/* Parent */
			continue;
		} else if (pid == 0) {
			/* Child */
			void (*func)(int, int *) = workloads[i].func;
			int arg = workloads[i].arg;
            int value[3];

			/* Do this workload */
			func(arg, value);
            printf(fd[WRITE], "%d,%d,%d\n", value[0], value[1], value[2]);
            
			exit();
		} else {
			printf(1, "FAIL : fork\n");
			exit();
		}
	}

	for (i = 0; i < n; i++) {
		wait();
	}

    char buf[MAX_BUF];
    char *tmp;
    int **list;

    list = malloc(sizeof(int *) * n);
    for (i = 0; i < n; i++) {
        list[i] = malloc(sizeof(int) * 3);
    }

    read(fd[READ], buf, MAX_BUF);
    tmp = buf;

    for (i = 0; i < n; i++) {
        list[i][0] = atoi(tmp);
        while (*(tmp++) != ',');
        list[i][1] = atoi(tmp);
        while (*(tmp++) != ',');
        list[i][2] = atoi(tmp);
        while (*(tmp++) != '\n');
    }

    report(n, list);

    close(fd[READ]);
    close(fd[WRITE]);

    for (i = 0; i < n; i++) {
        free(list[i]);
    }
    free(list);
    
    return;
}

int
main(int argc, char *argv[])
{
	struct workload *workloads;
    int i, j, k;
    
    workloads = malloc(sizeof(struct workload) * MAX_WORKLOAD_NUM);

    for (i = 1; i < MAX_WORKLOAD_NUM; i++) {
        for (j = 0; j < MAX_WORKLOAD_NUM - i; j++) {
            for (k = 0; k < i; k++) {
                workloads[k].func = test_mlfq;
                workloads[k].arg = MLFQ_NONE;
            }
            for (k = i; k < i + j; k++) {
                workloads[k].func = test_stride;
                workloads[k].arg = 80 / j;
            }

            printf(1, "+-----------------------------------------------------------\n");
            printf(1, "<mlfq(%d) + stride(%d)>\n", i, j);
            set_process(i + j, workloads);
            printf(1, "+-----------------------------------------------------------\n\n");
        }
    }
    printf(1, "\n");

    free(workloads);

	exit();
}
