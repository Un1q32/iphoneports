#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>

#include <iphoneports/pthread_chdir.h>

#define faccessat __iphoneports_faccessat
#define unlinkat __iphoneports_unlinkat

static int faccessat(int fd, const char *path, int mode, int flags) {
  static bool init = false;
  static int (*func)(int, const char *, int, int);

  if (!init) {
    func = (int (*)(int, const char *, int, int))dlsym(RTLD_NEXT, "faccessat");
    init = true;
  }

  if (func)
    return func(fd, path, mode, flags);

  if (flags & ~AT_EACCESS != 0) {
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
}

static int unlinkat(int fd, const char *path, int flags) {
  static bool init = false;
  static int (*func)(int, const char *, int);

  if (!init) {
    func = (int (*)(int, const char *, int))dlsym(RTLD_NEXT, "unlinkat");
    init = true;
  }

  if (func)
    return func(fd, path, flags);

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_REMOVEDIR)
      return rmdir(path);
    return unlink(path);
  }

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

  int ret;
  if (flags & AT_REMOVEDIR)
    ret = rmdir(path);
  else
    ret = unlink(path);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;
}

#endif
