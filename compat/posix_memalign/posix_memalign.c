#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>

int posix_memalign(void **memptr, size_t align, size_t size) {

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
  int err = errno;
  if (align <= 16)
    mem = malloc(size); /* Darwin malloc always aligns to 16 bytes */
  else {
    static long pagesize = 0;
    if (pagesize == 0) {
      pagesize = sysconf(_SC_PAGESIZE);
      if (pagesize < 1) {
        pagesize = 0;
        errno = err;
        return ENOMEM;
      }
    }
    if (align <= (size_t)pagesize)
      mem = valloc(size); /* page aligned allocation */
    else
      return ENOMEM;
  }

  if (!mem) {
    errno = err;
    return ENOMEM;
  } else {
    *memptr = mem;
    return 0;
  }
}

#endif
