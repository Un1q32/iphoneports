#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>

#define unlinkat __iphoneports_unlinkat

static inline int unlinkat(int fd, const char *path, int flags) {
  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_REMOVEDIR)
      return rmdir(path);
    return unlink(path);
  }

  struct stat st;
  if (fstat(fd, &st) == -1 || !S_ISDIR(st.st_mode)) {
    errno = ENOTDIR;
    return -1;
  }

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);

  strcat(fdpath, "/");
  strcat(fdpath, path);
  if (flags & AT_REMOVEDIR)
    return rmdir(fdpath);
  return unlink(fdpath);
}

#endif
