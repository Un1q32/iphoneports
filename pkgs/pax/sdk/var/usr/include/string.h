#pragma once

#include_next <string.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 40300) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 1070)

#include <stdlib.h>

static inline char *strndup(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  size_t len = end ? end - str : maxlen;
  char *newstr = (char *)malloc(len + 1);
  if (!newstr)
    return NULL;
  memcpy(newstr, str, len);
  newstr[len] = '\0';
  return newstr;
}

#endif
