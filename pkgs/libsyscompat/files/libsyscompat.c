#if (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1090) ||                  \
    (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 70000)

#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <sys/stat.h>

int proc_pid_rusage(int pid, int flavor, void *buffer) {
  static bool rusage_init = false;
  static int (*real_proc_pid_rusage)(int, int, void *) = NULL;

  if (!rusage_init) {
    real_proc_pid_rusage =
        (int (*)(int, int, void *))dlsym(RTLD_NEXT, "proc_pid_rusage");
    rusage_init = true;
  }
  if (real_proc_pid_rusage)
    return real_proc_pid_rusage(pid, flavor, buffer);

  errno = ENOSYS;
  return -1;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)

#include <mach/mach_host.h>

kern_return_t host_statistics64(host_t host_priv, host_flavor_t flavor,
                                host_info_t host_info64_out,
                                mach_msg_type_number_t *host_info64_outCnt) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

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

#endif
