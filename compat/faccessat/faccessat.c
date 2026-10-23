#if MINVER_LT(101000, 80000, 0)

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <unistd.h>

#if MINVER_LT(1050, 20000, 0)

#include <limits.h>
#include <string.h>
#include <sys/stat.h>

#else

#include "pthread_chdir.h"

#endif

int faccessat(int fd, const char *path, int mode, int flags) {

#if MAXVER_GE(101000, 80000, 0)

  static bool init = false;
  static int (*func)(int, const char *, int, int);

  if (!init) {
    func = (int (*)(int, const char *, int, int))dlsym(RTLD_NEXT, "faccessat");
    init = true;
  }

  if (func)
    return func(fd, path, mode, flags);

#endif

  if (flags & ~AT_EACCESS) {
    errno = EINVAL;
    return -1;
  }

  uid_t ruid = getuid(), euid = geteuid();
  gid_t rgid = getgid(), egid = getegid();
  int check_euid = ruid != euid && (flags & AT_EACCESS);
  int check_egid = rgid != egid && (flags & AT_EACCESS);
  if (check_euid)
    setreuid(euid, ruid);
  if (check_egid)
    setregid(egid, rgid);

  if (fd == AT_FDCWD || path[0] == '/') {
    int ret = access(path, mode);
    int errnobak = errno;
    if (check_euid)
      setreuid(ruid, euid);
    if (check_egid)
      setregid(rgid, egid);
    errno = errnobak;
    return ret;
  }

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

  int ret = access(fdpath, mode);
  int errnobak = errno;
  if (check_euid)
    setreuid(ruid, euid);
  if (check_egid)
    setregid(rgid, egid);
  errno = errnobak;
  return ret;

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

  int ret = access(path, mode);
  int errnobak = errno;
  if (check_euid)
    setreuid(ruid, euid);
  if (check_egid)
    setregid(rgid, egid);
  errno = errnobak;

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

#endif
