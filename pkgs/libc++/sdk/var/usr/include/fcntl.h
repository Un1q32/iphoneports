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

#define __NO_O_CLOEXEC

#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>

#include <iphoneports/pthread_chdir.h>

#define openat __iphoneports_openat

static int openat(int fd, const char *path, int flags, ...) {
  int mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  static bool init = false;
  static int (*func)(int, const char *, int, ...);

  if (!init) {
    func = (int (*)(int, const char *, int, ...))dlsym(RTLD_NEXT, "openat");
    init = true;
  }

  if (func)
    return func(fd, path, flags, mode);

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

  int cwd = open(".", O_RDONLY);
  if (pthread_fchdir_np(-1) < 0 && cwd != -1) {
    close(cwd);
    cwd = -1;
  }
  if (pthread_fchdir_np(fd) < 0) {
    pthread_fchdir_np(cwd);
    if (cwd != -1)
      close(cwd);
    return -1;
  }

  int ret = open(path, flags, mode);
#ifdef __NO_O_CLOEXEC
  if (cloexec && ret != -1)
    fcntl(ret, F_SETFD, FD_CLOEXEC);
#endif

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;
}

#endif
