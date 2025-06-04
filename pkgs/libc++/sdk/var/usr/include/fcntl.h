#pragma once

#include_next <fcntl.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif
#ifndef O_CLOEXEC
#define O_CLOEXEC 0x1000000
#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <stdbool.h>

#define __NO_O_CLOEXEC

#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <string.h>
#include <sys/stat.h>

#define openat __iphoneports_openat

static inline int openat(int fd, const char *path, int flags, ...) {
  int mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

#ifdef __NO_O_CLOEXEC
  bool cloexec = false;
  if (flags & O_CLOEXEC) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
#endif

  if (fd == AT_FDCWD || path[0] == '/') {
    int ret = open(path, flags, mode);
#ifdef __NO_O_CLOEXEC
    if (cloexec && ret != -1)
      fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif
    return ret;
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
  int ret = open(fdpath, flags, mode);
#ifdef __NO_O_CLOEXEC
  if (cloexec && ret != -1)
    fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif
  return ret;
}

#endif
