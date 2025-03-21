#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <fcntl.h>
#include <limits.h>
#include <string.h>

#define readlinkat __iphoneports_readlinkat

static inline ssize_t readlinkat(int fd, const char *path, char *buf,
                                 size_t bufsize) {
  if (fd == AT_FDCWD || path[0] == '/')
    return readlink(path, buf, bufsize);

  char fdpath[PATH_MAX + strlen(path) + 2];
  if (__builtin_expect(fcntl(fd, F_GETPATH, fdpath) == -1, 0))
    return -1;

  if (__builtin_expect(path[0] != '\0', 1)) {
    strcat(fdpath, "/");
    strcat(fdpath, path);
  }
  return readlink(fdpath, buf, bufsize);
}

#endif
