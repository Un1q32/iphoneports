#pragma once

#include_next <string.h>

#include <stdint.h>
#include <stdlib.h>
#include <sys/types.h>

#define memrchr __iphoneports_memrchr

static inline void *memrchr(const void *s, int c, size_t n) {
  const unsigned char *cp;

  if (n != 0) {
    cp = (unsigned char *)s + n;
    do {
      if (*(--cp) == (unsigned char)c)
        return (void *)cp;
    } while (--n != 0);
  }
  return NULL;
}

#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 180400) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 150400) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 110400)

#define strchrnul __iphoneports_strchrnul

static inline char *strchrnul(const char *s, int c) {
  c = (unsigned char)c;
  if (!c)
    return (char *)s + strlen(s);

  for (; *s && *(unsigned char *)s != c; s++)
    ;
  return (char *)s;
}

#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

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
