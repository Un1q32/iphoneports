#pragma once

#include_next <stdlib.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <dlfcn.h>
#include <stdbool.h>
#include <string.h>

#define arc4random_buf __iphoneports_arc4random_buf

static void arc4random_buf(void *buf, size_t size) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static void (*func)(void *, size_t);

  if (!init) {
    func = (void (*)(void *, size_t))dlsym(RTLD_NEXT, "arc4random_buf");
    init = true;
  }

  if (func) {
    func(buf, size);
    return;
  }

#endif

  uint32_t *cbuf = (uint32_t *)buf;
  while (size >= sizeof(uint32_t)) {
    *cbuf++ = arc4random();
    size -= sizeof(uint32_t);
  }
  if (size != 0) {
    uint32_t random = arc4random();
    memcpy(cbuf, &random, size);
  }
}

#endif
