#pragma once

#include_next <string.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <stdlib.h>

#define strndup __iphoneports_strndup

static inline char *strndup(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  size_t len = end ? end - str : maxlen;
  char *newstr = (char *)malloc(len + 1);
  if (__builtin_expect(!newstr, 0))
    return NULL;
  memcpy(newstr, str, len);
  newstr[len] = '\0';
  return newstr;
}

#endif
