#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#include "compat.h"

void explicit_bzero(void *d, size_t n) {
    d = memset(d, 0, n);
    __asm__ __volatile__ ("" : : "r"(d) : "memory");
}

int mkdirat(int fd, const char *pathname, mode_t mode) {
    if ((fd == AT_FDCWD) || (pathname[0] == '/'))
        return mkdir(pathname, mode);

    char fdpath[PATH_MAX];
    int fcntl_ret = fcntl(fd, F_GETPATH, fdpath);
    if (fcntl_ret == -1) {
        return -1;
    }

    char path[PATH_MAX];
    snprintf(path, PATH_MAX, "%s/%s", fdpath, pathname);
    return mkdir(path, mode);
}

int openat(int fd, const char *pathname, int flags, ...) {
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, int);
        va_end(ap);
    }

    if ((fd == AT_FDCWD) || (pathname[0] == '/'))
        return open(pathname, flags, mode);

    char fdpath[PATH_MAX];
    int fcntl_ret = fcntl(fd, F_GETPATH, fdpath);
    if (fcntl_ret == -1) {
        return -1;
    }

    char path[PATH_MAX];
    snprintf(path, PATH_MAX, "%s/%s", fdpath, pathname);
    return open(path, flags, mode);
}
