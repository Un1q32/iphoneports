#pragma once

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#define openat __unused_libc_openat
#include_next <fcntl.h>
#undef openat

#endif

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif
#ifndef O_CLOEXEC
#include <stdbool.h>
#define O_CLOEXEC 0x1000000
#define __NO_O_CLOEXEC
#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <limits.h>
#include <stdarg.h>
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>

static inline int __iphoneports_openat(int fd, const char *path, int flags,
                                       mode_t mode, bool passmode) {
#ifdef __NO_O_CLOEXEC
  bool cloexec = false;
  if (__builtin_expect(flags & O_CLOEXEC, 0)) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
#endif

  if (fd == AT_FDCWD || path[0] == '/') {
    int ret;
    if (passmode)
      ret = open(path, flags, mode);
    else
      ret = open(path, flags);
#ifdef __NO_O_CLOEXEC
    if (cloexec && __builtin_expect(ret != -1, 1))
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
  int ret;
  if (passmode)
    ret = open(fdpath, flags, mode);
  else
    ret = open(fdpath, flags);
#ifdef __NO_O_CLOEXEC
  if (cloexec && __builtin_expect(ret != -1, 1))
    fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif
  return ret;
}

#define __ARGSTEST(arg1, arg2, arg3, ...) arg3

#define openat(fd, path, flags, ...)                                           \
  __iphoneports_openat(fd, path, flags, __ARGSTEST(0, 0, ##__VA_ARGS__, 0),    \
                       __ARGSTEST(0, ##__VA_ARGS__, true, false))

#endif
