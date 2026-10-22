#if MINVER_LT(0, 30000, 0)

#include <dlfcn.h>
#include <stdbool.h>
#include <unwind.h>

_Unwind_Ptr _Unwind_GetIPInfo(struct _Unwind_Context *context, int *ipbefore) {
  static bool init = false;
  static _Unwind_Ptr (*func)(struct _Unwind_Context *, int *);
  if (!init) {
    func = (_Unwind_Ptr (*)(struct _Unwind_Context *, int *))dlsym(
        RTLD_NEXT, "_Unwind_GetIPInfo");
    init = true;
  }

  if (func)
    return func(context, ipbefore);

  abort();
}

#endif
