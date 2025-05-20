#pragma once

#include_next <string.h>

#define explicit_bzero __iphoneports_explicit_bzero

static inline void explicit_bzero(void *d, size_t n) {
  d = memset(d, 0, n);
  __asm__ __volatile__("" : : "r"(d) : "memory");
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#define memmem __iphoneports_memmem

static inline void *memmem(const void *haystack, size_t haystacklen,
                           const void *needle, size_t needlelen) {
  if (needlelen > haystacklen)
    return NULL;

  const char *h = haystack;
  const char *n = needle;
  for (size_t i = 0; i <= haystacklen - needlelen; i++)
    if (memcmp(h + i, n, needlelen) == 0)
      return (void *)(h + i);
  return NULL;
}

#endif
