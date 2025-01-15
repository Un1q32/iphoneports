#pragma once

#include_next <pthread.h>

#define pthread_setname_np __iphoneports_pthread_setname_np

static inline int pthread_setname_np(const char *name) {
  (void)name;
  return 0;
}
