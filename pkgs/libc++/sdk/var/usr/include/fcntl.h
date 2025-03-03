#pragma once

#include_next <fcntl.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif
#ifndef O_CLOEXEC
#include <stdbool.h>
#define O_CLOEXEC 0x1000000
#define __USE_OPEN_WRAPPER
#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <limits.h>
#include <stdarg.h>
#include <string.h>
#include <sys/stat.h>

#define openat __iphoneports_openat

static inline int openat(int fd, const char *path, int flags, ...) {
  int mode = 0;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

#ifdef __USE_OPEN_WRAPPER
  bool cloexec = false;
  if (__builtin_expect(flags & O_CLOEXEC, 0)) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
#endif

  int ret;
  if (fd == AT_FDCWD || path[0] == '/') {
    ret = open(path, flags, mode);
#ifdef __USE_OPEN_WRAPPER
    if (cloexec && __builtin_expect(fd != -1, 1))
      fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif
    return ret;
  }

  struct stat st;
  if (__builtin_expect(fstat(fd, &st) == -1 || !S_ISDIR(st.st_mode), 0))
    return -1;

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);

  strcat(fdpath, "/");
  strcat(fdpath, path);
  ret = open(fdpath, flags, mode);
#ifdef __USE_OPEN_WRAPPER
  if (cloexec && __builtin_expect(fd != -1, 1))
    fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif
  return ret;
}

#endif

#ifdef __USE_OPEN_WRAPPER

#include <stdarg.h>
#include <unistd.h>

static inline int __iphoneports_open(const char *path, int flags, ...) {
  int mode = 0;
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
