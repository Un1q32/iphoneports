#pragma once

#include_next <dirent.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 80000) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 101000)

#include <fcntl.h>
#include <limits.h>
#include <stdlib.h>

static inline DIR *fdopendir(int fd) {
  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return NULL;

  return opendir(fdpath);
}

#endif
