#ifndef _FAKE_STRING_H_
#define _FAKE_STRING_H_

#include <stdlib.h>
#include_next <string.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
static inline size_t strnlen(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  return end ? (size_t)(end - str) : maxlen;
}

static inline char *strndup(const char *str, size_t maxlen) {
  size_t len = strnlen(str, maxlen);
  char *newstr = (char *)malloc(len + 1);
  if (!newstr)
    return NULL;
  memcpy(newstr, str, len);
  newstr[len] = '\0';
  return newstr;
}
__END_DECLS

#endif
