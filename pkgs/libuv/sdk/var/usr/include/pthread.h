#pragma once

#include_next <pthread.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 30200) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 1060)

#define pthread_setname_np __iphoneports_pthread_setname_np

static inline int pthread_setname_np(const char *name) {
  (void)name;
  return 0;
}

#endif
