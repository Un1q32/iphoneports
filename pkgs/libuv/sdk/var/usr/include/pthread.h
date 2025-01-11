#pragma once

#include_next <pthread.h>

static inline int pthread_setname_np(const char *name) {
  (void)name;
  return 0;
}
