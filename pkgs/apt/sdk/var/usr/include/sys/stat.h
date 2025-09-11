#pragma once

#include_next <sys/stat.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>

#include <iphoneports/pthread_chdir.h>

#define fstatat __iphoneports_fstatat

static int fstatat(int fd, const char *path, struct stat *st, int flags) {
  static bool init = false;
  static int (*func)(int, const char *, struct stat *, int);

  if (!init) {
    func = (int (*)(int, const char *, struct stat *, int))dlsym(RTLD_NEXT,
                                                                 "fstatat");
    init = true;
  }

  if (func)
    return func(fd, path, st, flags);

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_SYMLINK_NOFOLLOW)
      return lstat(path, st);
    return stat(path, st);
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
  if (flags & AT_SYMLINK_NOFOLLOW)
    ret = lstat(path, st);
  else
    ret = stat(path, st);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;
}

#endif
