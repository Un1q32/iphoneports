#if MINVER_LT(101200,100000,30000)

#include <dlfcn.h>
#include <stdbool.h>
#include <stdlib.h>

int getentropy(void *buf, size_t size) {

#if MAXVER_GE(101200,100000,30000)

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
