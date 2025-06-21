#pragma once

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 100000) ||               \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101200)

#include <sys/syscall.h>
#include <unistd.h>

#define pthread_fchdir_np __iphoneports_pthread_fchdir_np

static inline int pthread_fchdir_np(int fd) {
  return syscall(SYS___pthread_fchdir, fd);
}

#else

extern int pthread_fchdir_np(int);

#endif
