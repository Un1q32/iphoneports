#pragma once

#include_next <string.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 40300) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 1070)

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
