#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <dlfcn.h>
#include <stdbool.h>

int pthread_setname_np(const char *name) {
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(const char *);

  if (!init) {
    func = (int (*)(const char *))dlsym(RTLD_NEXT, "pthread_setname_np");
    init = true;
  }

  if (func)
    return func(name);

#endif
  (void)name;
  return 0;
}

#endif
