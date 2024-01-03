#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "compat.h"

void explicit_bzero(void *d, size_t n) {
    d = memset(d, 0, n);
    __asm__ __volatile__ ("" : : "r"(d) : "memory");
}

char* _atfunc(int fd, const char* pathname) {
    if (fd == AT_FDCWD || pathname[0] == '/')
        return strdup(pathname);

    char fdpath[PATH_MAX];
    if (fcntl(fd, F_GETPATH, fdpath) == -1)
        return NULL;

    char path[strlen(fdpath) + strlen(pathname) + 2];
    strcpy(path, fdpath);
    strcat(path, "/");
    strcat(path, pathname);
    return strdup(path);
}

int mkdirat(int fd, const char* pathname, mode_t mode) {
    char* path = _atfunc(fd, pathname);
    if (path == NULL)
        return -1;

    int ret = mkdir(path, mode);
    free(path);
    return ret;
}

int openat(int fd, const char* pathname, int flags, ...) {
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, int);
        va_end(ap);
    }

    char* path = _atfunc(fd, pathname);
    if (path == NULL)
        return -1;

    int ret = open(path, flags, mode);
    free(path);
    return ret;
}
