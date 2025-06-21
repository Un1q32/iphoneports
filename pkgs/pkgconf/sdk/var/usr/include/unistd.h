#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <fcntl.h>
#include <iphoneports/pthread_chdir.h>
#include <limits.h>

#define readlinkat __iphoneports_readlinkat

static inline ssize_t readlinkat(int fd, const char *path, char *buf,
                                 size_t bufsize) {
  if (fd == AT_FDCWD || path[0] == '/')
    return readlink(path, buf, bufsize);

  if (path[0] == '\0') {
    /* there is a race condition here between the fcntl and readlink calls */
    char fdpath[PATH_MAX + strlen(path) + 2];
    if (fcntl(fd, F_GETPATH, fdpath) == -1)
      return -1;
    return readlink(fdpath, buf, bufsize);
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

  ssize_t ret = readlink(path, buf, bufsize);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;
}

#endif
