#pragma once

#include_next <sys/stat.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <fcntl.h>
#include <limits.h>
#include <string.h>

#define mkdirat __iphoneports_mkdirat

static inline int mkdirat(int fd, const char *path, mode_t mode) {
  if (fd == AT_FDCWD || path[0] == '/')
    return mkdir(path, mode);

  struct stat st;
  if (__builtin_expect(fstat(fd, &st) == -1 || !S_ISDIR(st.st_mode), 0))
    return -1;

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);

  strcat(fdpath, "/");
  strcat(fdpath, path);
  return mkdir(fdpath, mode);
}

#endif
