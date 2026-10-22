#if MINVER_LT(1070, 40300, 0)

#include <string.h>

size_t strnlen(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  return end ? (size_t)(end - str) : maxlen;
}

#endif
