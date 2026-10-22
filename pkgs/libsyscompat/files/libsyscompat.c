#ifdef __i386__
#include <sys/wait.h>
// AFAIK wait4 never actually had a UNIX2003 variant, but hyperfine fails to
// link without it so oh well.
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options,
                     struct rusage *rusage) __asm("_wait4$UNIX2003");
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options,
                     struct rusage *rusage) {
  return wait4(pid, stat_loc, options, rusage);
}
#endif

#include <stdlib.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

void arc4random_buf(void *, size_t);

int CCRandomGenerateBytes(void *buf, size_t size) {
  arc4random_buf(buf, size);
  return 0;
}

#if (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1090) ||                  \
    (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 70000)

#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
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
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <pthread.h>
#include <stdint.h>

int pthread_threadid_np(pthread_t thread, uint64_t *tid) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(pthread_t, uint64_t *);

  if (!init) {
    func =
        (int (*)(pthread_t, uint64_t *))dlsym(RTLD_NEXT, "pthread_threadid_np");
    init = true;
  }

  if (func)
    return func(thread, tid);

#endif

  if (!tid)
    return EINVAL;

  if (!thread)
    thread = pthread_self();

  mach_port_t native_id = pthread_mach_thread_np(thread);
  if (!native_id)
    return ESRCH;

  *tid = native_id;
  return 0;
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

#endif

#endif
