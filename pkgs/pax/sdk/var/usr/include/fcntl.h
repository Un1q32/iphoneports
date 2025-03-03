#pragma once

#include_next <fcntl.h>

#ifndef O_CLOEXEC

#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>

#define O_CLOEXEC 0x1000000

static inline int __iphoneports_open(const char *path, int flags, ...) {
  int mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }
  bool cloexec = false;
  if (__builtin_expect(flags & O_CLOEXEC, 0)) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
  int fd = open(path, flags, mode);
  if (cloexec && __builtin_expect(fd != -1, 1))
    fcntl(fd, F_SETFD, FD_CLOEXEC);
  return fd;
}

#define open __iphoneports_open

#endif
