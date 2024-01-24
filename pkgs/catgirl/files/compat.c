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

char* _atfunc(int fd, const char* path) {
    if (fd == AT_FDCWD || path[0] == '/')
        return strdup(path);

    char fdpath[PATH_MAX];
    if (fcntl(fd, F_GETPATH, fdpath) == -1)
        return NULL;

    char new_path[strlen(fdpath) + strlen(path) + 2];
    strcpy(new_path, fdpath);
    strcat(new_path, "/");
    strcat(new_path, path);
    return strdup(new_path);
}

int mkdirat(int fd, const char* path, mode_t mode) {
    char* new_path = _atfunc(fd, path);
    if (new_path == NULL)
        return -1;

    int ret = mkdir(new_path, mode);
    free(new_path);
    return ret;
}

int openat(int fd, const char* path, int flags, ...) {
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list ap;
        va_start(ap, flags);
        mode = va_arg(ap, int);
        va_end(ap);
    }

    char* new_path = _atfunc(fd, path);
    if (new_path == NULL)
        return -1;

    int ret = open(new_path, flags, mode);
    free(new_path);
    return ret;
}
