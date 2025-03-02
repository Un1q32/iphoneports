#pragma once

#include_next <fcntl.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <limits.h>
#include <stdarg.h>
#include <string.h>

#define openat __iphoneports_openat

static inline int openat(int fd, const char *path, int flags, ...) {
  int mode = 0;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  if (fd == AT_FDCWD || path[0] == '/')
    return open(path, flags, mode);

  struct stat st;
  if (stat(fd, &st) == -1 || !S_ISDIR(st.st_mode))
    return -1;

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);

  strcat(fdpath, "/");
  strcat(fdpath, path);
  return open(fdpath, flags, mode);
}

#endif

#ifndef O_CLOEXEC

#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>

#define O_CLOEXEC 0x1000000

static inline int __iphoneports_open(const char *path, int flags, ...) {
  int mode = 0;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }
  bool cloexec = false;
  if (flags & O_CLOEXEC) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
  int fd = open(path, flags, mode);
  if (cloexec && fd != -1)
    fcntl(fd, F_SETFD, FD_CLOEXEC);
  return fd;
}

#define open __iphoneports_open

#endif
