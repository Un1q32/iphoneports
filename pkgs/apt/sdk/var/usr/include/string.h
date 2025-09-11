#pragma once

#include_next <string.h>

#define strchrnul __iphoneports_strchrnul
#define memrchr __iphoneports_memrchr

static inline char *strchrnul(const char *s, int c) {
  --s;
  while (*++s && (*s != ((char)c)))
    ;
  return (char *)s;
}

static inline void *memrchr(const void *s, int c, size_t n) {
  const unsigned char *r = (unsigned char *)s + n;
  while (n--)
    if (*--r == ((unsigned char)c))
      return (void *)r;
  return NULL;
}

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
  if (!newstr)
    return NULL;
  memcpy(newstr, str, len);
  newstr[len] = '\0';
  return newstr;
}

#endif
