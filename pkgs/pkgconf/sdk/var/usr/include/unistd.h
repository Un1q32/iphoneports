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

  struct stat st;
  if (fstat(fd, &st) == -1 || !S_ISDIR(st.st_mode))
    return -1;

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);

  if (path[0] != '\0') {
    strcat(fdpath, "/");
    strcat(fdpath, path);
  }
  return readlink(fdpath, buf, bufsize);
}

#endif
