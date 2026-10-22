#pragma once

#if MINVER_LT(101200, 100000, 30000)

#include <sys/syscall.h>

#define pthread_fchdir_np __iphoneports_pthread_fchdir_np

static inline int pthread_fchdir_np(int fd) {
  return syscall(SYS___pthread_fchdir, fd);
}

#else

extern int pthread_fchdir_np(int);

#endif
