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

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 2];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  return mkdir(new_path, mode);
}

#endif
