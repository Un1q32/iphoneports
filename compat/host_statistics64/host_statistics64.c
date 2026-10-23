#if MINVER_LT(1060, 30000, 0)

#define host_statistics64 __dont_define_host_statistics64
#include <mach/mach_host.h>
#undef host_statistics64
#include <dlfcn.h>
#include <stdbool.h>

kern_return_t host_statistics64(host_t host_priv, host_flavor_t flavor,
                                host_info_t host_info64_out,
                                mach_msg_type_number_t *host_info64_outCnt) {

#if MAXVER_GE(1060, 30000, 0)

  static bool init = false;
  static kern_return_t (*func)(host_t, host_flavor_t, host_info_t,
                               mach_msg_type_number_t *);

  if (!init) {
    func =
        (kern_return_t (*)(host_t, host_flavor_t, host_info_t,
                           mach_msg_type_number_t *))dlsym(RTLD_NEXT,
                                                           "host_statistics64");
    init = true;
  }

  if (func)
    return func(host_priv, flavor, host_info64_out, host_info64_outCnt);

#endif

  return host_statistics(host_priv, flavor, host_info64_out,
                         host_info64_outCnt);
}

#endif
