#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 100000) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101200) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 30000)

#include <dlfcn.h>
#include <stdbool.h>
#include <stdlib.h>

int getentropy(void *buf, size_t size) {
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(void *, size_t);

  if (!init) {
    func = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "getentropy");
    init = true;
  }

  if (func)
    return func(buf, size);

#endif

  arc4random_buf(buf, size);
  return 0;
}

#endif
