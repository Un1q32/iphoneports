#pragma once

#include_next <stdlib.h>

#include <stdint.h>

#define arc4random_buf __iphoneports_arc4random_buf

static inline void arc4random_buf(void *buf, size_t n) {
  char *cbuf = (char *)buf;
  while (n >= sizeof(uint32_t)) {
    *(uint32_t *)cbuf = arc4random();
    cbuf += sizeof(uint32_t);
    n -= sizeof(uint32_t);
  }

  if (n > 0) {
    uint32_t num = arc4random();
    char *nump = (char *)&num;
    do {
      *cbuf++ = *nump++;
    } while (--n);
  }
}
