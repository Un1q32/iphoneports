#if MINVER_LT(1050, 0, 0)

#include <dlfcn.h>
#include <stdbool.h>
#include <stddef.h>

void sys_icache_invalidate(void *start, size_t len) {
  static bool init = false;
  static void (*func)(void *, size_t);

  if (!init) {
    func = (void (*)(void *, size_t))dlsym(RTLD_NEXT, "sys_icache_invalidate");
    init = true;
  }

  if (func)
    func(start, len);

  /* No known way to emulate this, do nothing and hope for the best */
  (void)start;
  (void)len;
}

#endif
