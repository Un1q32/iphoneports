// implement fake functions for compatibility with old darwin
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

int memset_s(void *dest, size_t destsz, int ch, size_t count) {
    if (destsz < count) {
        return EINVAL;
    }
    memset(dest, ch, count);
    return 0;
}

int mkdirat(int dirfd, const char *pathname, mode_t mode) {
    if (pathname[0] == '/')
        return mkdir(pathname, mode);
    else if ((getenv("HOME") == NULL) && (getenv("XDG_DATA_HOME") == NULL))
        return -1;
    char data[256];
    if (getenv("XDG_DATA_HOME") != NULL)
        snprintf(data, 256, "%s", getenv("XDG_DATA_HOME"));
    else
        snprintf(data, 256, "%s/.local/share", getenv("HOME"));
    char path[256];
    snprintf(path, 256, "%s/catgirl/log/%s", data, pathname);
    return mkdir(path, mode);
}

int openat(int dirfd, const char *pathname, int flags, mode_t mode) {
    if (pathname[0] == '/')
        return open(pathname, flags, mode);
    else if ((getenv("HOME") == NULL) && (getenv("XDG_DATA_HOME") == NULL))
        return -1;
    char data[256];
    if (getenv("XDG_DATA_HOME") != NULL)
        snprintf(data, 256, "%s", getenv("XDG_DATA_HOME"));
    else
        snprintf(data, 256, "%s/.local/share", getenv("HOME"));
    char path[256];
    snprintf(path, 256, "%s/catgirl/log/%s", data, pathname);
    return open(path, flags, mode);
}
