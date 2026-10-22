#if MINVER_LT(1060, 30200, 0)

#include <dlfcn.h>
#include <errno.h>
#include <pthread.h>
#include <stdbool.h>

int pthread_threadid_np(pthread_t thread, uint64_t *tid) {

#if MAXVER_GE(1060, 30200, 0)

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

#endif
