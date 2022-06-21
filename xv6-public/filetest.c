#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define NUM_STRESS      4
#define FILESIZE        (16*1024*1024)  // 16 MB
#define BUF_PER_FILE    ((FILESIZE) / (512))
char data[FILESIZE];
char buf[FILESIZE];


int
main(int argc, char* argv[])
{
    int fd, i, j;
    int r;
    int total;
    char* path = (argc > 1) ? argv[1] : "hugefile";

    printf(1, "filetest starting\n");
    const int sz = sizeof(data);
    for (i = 0; i < sz; i++) {
        data[i] = i % 128;
    }

    printf(1, "1. Create test\n");
    fd = open(path, O_CREATE | O_WRONLY);
    for (i = 0; i < FILESIZE / 512; i++) {
        if (i % 100 == 0) {
            printf(1, "%d bytes written\n", i * (FILESIZE / 512));
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)) {
            printf(1, "Write returned %d : failed\n", r);
            exit();
        }
    }
    close(fd);

    printf(1, "2. Read test\n");
    fd = open(path, O_RDONLY);
    for (i = 0; i < BUF_PER_FILE; i++) {
        if (i % 100 == 0) {
            printf(1, "%d bytes read\n", (FILESIZE / 512));
        }
        if ((r = read(fd, buf, sizeof(data))) != sizeof(data)) {
            printf(1, "Read returned %d : failed\n", r);
            exit();
        }
        for (j = 0; j < sz; j++) {
            if (buf[j] != data[j]) {
                printf(1, "Data inconsistency detected\n");
                exit();
            }
        }
    }
    close(fd);
    unlink(path);

    printf(1, "3. stress test\n");
    total = 0;
    for (i = 0; i < 4; i++) {
        printf(1, "Stress test...%d \n", i);
        if (unlink(path) < 0) {
            printf(1, "rm: %s failed to delete\n", path);
            exit();
        }

        fd = open(path, O_CREATE | O_WRONLY);
        for (j = 0; j < FILESIZE / 512; j++) {
            if (j % 100 == 0) {
                printf(1, "%d bytes totally written\n", total);
            }
            if ((r = write(fd, data, sizeof(data))) != sizeof(data)) {
                printf(1, "write returned %d : failed\n", r);
                exit();
            }
            total += sizeof(data);
        }
        printf(1, "%d bytes written\n", total);
        close(fd);
        unlink(path);
    }

    exit();
}
