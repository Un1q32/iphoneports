#if MINVER_LT(101300, 110000, 40000)

#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>

#if MINVER_LT(1050, 20000, 0)

#include <errno.h>
#include <limits.h>
#include <string.h>

#else

#include "pthread_chdir.h"

#endif

int setattrlistat(int fd, const char *path, void *a, void *buf, size_t size,
                  uint32_t flags) {

#if MAXVER_GE(101300, 110000, 40000)

  static bool init = false;
  static int (*func)(int, const char *, void *, void *, size_t, uint32_t);

  if (!init) {
    func = (int (*)(int, const char *, void *, void *, size_t, uint32_t))dlsym(
        RTLD_NEXT, "setattrlistat");
    init = true;
  }

  if (func)
    return func(fd, path, a, buf, size, flags);

#endif

  if (fd == AT_FDCWD || path[0] == '/')
    return setattrlist(path, a, buf, size, flags);

#if MINVER_LT(1050, 20000, 0)

  /* the Mac OS X 10.4 / iPhone OS 1 version has a race condition */

  struct stat st;
  if (fstat(fd, &st) == -1)
    return -1;
  if (!S_ISDIR(st.st_mode)) {
    errno = ENOTDIR;
    return -1;
  }

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);
  strcat(fdpath, "/");
  strcat(fdpath, path);

  return setattrlist(fdpath, a, buf, size, flags);

#else

  int cwd = open(".", O_RDONLY);
  if (pthread_fchdir_np(-1) < 0 && cwd != -1) {
    close(cwd);
    cwd = -1;
  }
  if (pthread_fchdir_np(fd) < 0) {
    pthread_fchdir_np(cwd);
    if (cwd != -1)
      close(cwd);
    return -1;
  }

  int ret = setattrlist(path, a, buf, size, flags);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

#endif
