#pragma once

#include_next <string.h>

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
