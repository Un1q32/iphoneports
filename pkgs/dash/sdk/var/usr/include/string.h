#pragma once

#include_next <string.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                              \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                              \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                               \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#define stpncpy __iphoneports_stpncpy

static inline char *stpncpy(char *restrict s1, const char *restrict s2, size_t n) {
  char *s = s1;
  const char *p = s2;

  while (n) {
    if ((*s = *s2))
      s2++;
    ++s;
    --n;
  }
  return s1 + (s2 - p);
}

#endif
