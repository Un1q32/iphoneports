#if MINVER_LT(1060, 30200, 0)

#include <dlfcn.h>
#include <stdbool.h>

int pthread_setname_np(const char *name) {
#if MAXVER_GE(1060, 30200, 0)

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
