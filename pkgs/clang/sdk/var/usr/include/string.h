#pragma once

#include_next <string.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 40300) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 1070)

static inline size_t strnlen(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  return end ? (size_t)(end - str) : maxlen;
}

#endif
