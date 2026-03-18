#pragma once

#include_next <stdlib.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>

#define valloc __iphoneports_valloc
extern void *valloc(size_t) __asm("_valloc"); /* sometimes valloc doesn't get declared */
#ifndef RTLD_NEXT
#define RTLD_NEXT ((void *)-1)
#endif

#define posix_memalign __iphoneports_posix_memalign

static int posix_memalign(void **memptr, size_t align, size_t size) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(void **, size_t, size_t);

  if (!init) {
    func = (int (*)(void **, size_t, size_t))dlsym(RTLD_NEXT, "posix_memalign");
    init = true;
  }

  if (func)
    return func(memptr, align, size);

#endif

  if (align < sizeof(void *) || (align & (align - 1)) != 0)
    return EINVAL;

  void *mem;
  if (align <= 16)
    mem = malloc(size); /* Darwin malloc always aligns to 16 bytes */
  else
    mem = valloc(size); /* page aligned allocation */

  if (!mem)
    return ENOMEM;
  else {
    *memptr = mem;
    return 0;
  }
}

#undef valloc

#endif
