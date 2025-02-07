#pragma once

#include_next <pthread.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#define pthread_setname_np __iphoneports_pthread_setname_np

static inline int pthread_setname_np(const char *name) {
  (void)name;
  return 0;
}

#endif
