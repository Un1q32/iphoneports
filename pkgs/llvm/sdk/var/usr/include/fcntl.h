#pragma once

#include_next <fcntl.h>

#ifndef O_CLOEXEC
#define O_CLOEXEC 0x1000000
#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <stdarg.h>
#include <stdbool.h>

static inline int __iphoneports_open(const char *path, int flags, ...) {
  int mode = mode;
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
