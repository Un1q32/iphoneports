#pragma once

#include_next <string.h>

#define strnlen __iphoneports_strnlen

static inline size_t strnlen(const char *str, size_t maxlen) {
  const char *end = (const char *)memchr(str, '\0', maxlen);
  return end ? (size_t)(end - str) : maxlen;
}
