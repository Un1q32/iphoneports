#if MINVER_LT(1070, 20000, 0)

#include <dlfcn.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int SecRandomCopyBytes(void *rnd, size_t size, void *buf) {

#if MAXVER_GE(1070, 20000, 0)

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
