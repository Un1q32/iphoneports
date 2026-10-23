#if MINVER_LT(1090, 70000, 0)

#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>

int proc_pid_rusage(int pid, int flavor, void *buffer) {

#if MAXVER_GE(1090, 70000, 0)

  static bool init = false;
  static int (*func)(int, int, void *);

  if (!init) {
    func = (int (*)(int, int, void *))dlsym(RTLD_NEXT, "proc_pid_rusage");
    init = true;
  }

  if (func)
    return func(pid, flavor, buffer);

#endif

  errno = ENOSYS;
  return -1;
}

#endif
