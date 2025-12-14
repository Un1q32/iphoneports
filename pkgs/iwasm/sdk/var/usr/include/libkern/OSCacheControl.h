#pragma once

#if __has_include_next(<libkern/OSCacheControl.h>)
#include_next <libkern/OSCacheControl.h>
#endif

#if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                  \
    __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050

#include <dlfcn.h>
#include <stdbool.h>
#include <stddef.h>

static void sys_icache_invalidate(void *start, size_t len) {
  static bool init = false;
  static int (*func)(void *, size_t);

  if (!init) {
    func = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "sys_icache_invalidate");
    init = true;
  }

  if (func)
    return func(start, len);

  /* No known way to emulate this, do nothing and hope for the best */
  (void)start;
  (void)len;
}

#endif
