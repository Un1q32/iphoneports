#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 10200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <dlfcn.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int SecRandomCopyBytes(void *rnd, size_t size, void *buf) {

#ifndef __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__

  static bool init = false;
  static int (*func)(void *, size_t, void *);

  if (!init) {
    func =
        (int (*)(void *, size_t, void *))dlsym(RTLD_NEXT, "SecRandomCopyBytes");
    if (!func) {
      void *handle = dlopen(
          "/System/Library/Frameworks/Security.framework/Security", RTLD_LAZY);
      if (handle)
        func = (int (*)(void *, size_t, void *))dlsym(handle,
                                                      "SecRandomCopyBytes");
      if (!func)
        dlclose(handle);
    }
    init = true;
  }

  if (func)
    return func(rnd, size, buf);

#else

  (void)rnd;

#endif

  uint32_t *cbuf = buf;
  while (size >= sizeof(uint32_t)) {
    *cbuf++ = arc4random();
    size -= sizeof(uint32_t);
  }
  if (size != 0) {
    uint32_t random = arc4random();
    memcpy(cbuf, &random, size);
  }
  return 0;
}

#endif
