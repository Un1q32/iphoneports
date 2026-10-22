#if MINVER_LT(101000, 80000, 0)

#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>
#include <unistd.h>

#if MINVER_LT(1050, 20000, 0)

#include <errno.h>
#include <limits.h>
#include <string.h>
#include <sys/stat.h>

#else

#include "pthread_chdir.h"

#endif

int symlinkat(const char *target, int fd, const char *path) {

#if MAXVER_GE(101000, 80000, 0)

  static bool init = false;
  static int (*func)(const char *, int, const char *);

  if (!init) {
    func =
        (int (*)(const char *, int, const char *))dlsym(RTLD_NEXT, "symlinkat");
    init = true;
  }

  if (func)
    return func(target, fd, path);

#endif

  if (fd == AT_FDCWD || path[0] == '/')
    return symlink(target, path);

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

  return symlink(target, fdpath);

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

  int ret = symlink(target, path);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

#endif
