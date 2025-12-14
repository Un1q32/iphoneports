#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>

#if !((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&              \
       __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||              \
      (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&               \
       __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050))

#include <iphoneports/pthread_chdir.h>

#endif

#define linkat __iphoneports_linkat
#define unlinkat __iphoneports_unlinkat
#define symlinkat __iphoneports_symlinkat
#define readlinkat __iphoneports_readlinkat

static int linkat(int olddirfd, const char *oldpath, int newdirfd,
                  const char *newpath, int flags) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, const char *, int, const char *, int);

  if (!init) {
    func = (int (*)(int, const char *, int, const char *, int))dlsym(RTLD_NEXT,
                                                                     "linkat");
    init = true;
  }

  if (func)
    return func(olddirfd, oldpath, newdirfd, newpath, flags);

#endif

  /*
   * This has race conditions, they could be mitigated by using pthread_fchdir,
   * but that would require writing a really long function and I don't wanna do
   * that.
   */
  if (oldpath[0] != '/' && olddirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(olddirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char oldfdpath[PATH_MAX + strlen(oldpath) + 2];
    fcntl(olddirfd, F_GETPATH, oldfdpath);
    strcat(oldfdpath, "/");
    strcat(oldfdpath, oldpath);
    oldpath = oldfdpath;
  }
  /* I don't know any way to emulate linkat with AT_SYMLINK_FOLLOW properly */
  if (flags & AT_SYMLINK_FOLLOW) {
    struct stat _st;
    if (lstat(oldpath, &_st) == -1)
      return -1;
    if (S_ISLNK(_st.st_mode)) {
      errno = EINVAL;
      return -1;
    }
  }
  if (newpath[0] != '/' && newdirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(newdirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char newfdpath[PATH_MAX + strlen(newpath) + 2];
    fcntl(newdirfd, F_GETPATH, newfdpath);
    strcat(newfdpath, "/");
    strcat(newfdpath, newpath);
    newpath = newfdpath;
  }
  return link(oldpath, newpath);
}

static int unlinkat(int fd, const char *path, int flags) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, const char *, int);

  if (!init) {
    func = (int (*)(int, const char *, int))dlsym(RTLD_NEXT, "unlinkat");
    init = true;
  }

  if (func)
    return func(fd, path, flags);

#endif

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_REMOVEDIR)
      return rmdir(path);
    return unlink(path);
  }

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

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

  if (flags & AT_REMOVEDIR)
    return rmdir(fdpath);
  return unlink(fdpath);

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

  int ret;
  if (flags & AT_REMOVEDIR)
    ret = rmdir(path);
  else
    ret = unlink(path);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

static int symlinkat(const char *target, int fd, const char *path) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

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

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

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

static ssize_t readlinkat(int fd, const char *path, char *buf, size_t bufsize) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static ssize_t (*func)(int, const char *, char *, size_t);

  if (!init) {
    func = (ssize_t (*)(int, const char *, char *, size_t))dlsym(RTLD_NEXT,
                                                                 "readlinkat");
    init = true;
  }

  if (func)
    return func(fd, path, buf, bufsize);

#endif

  if (fd == AT_FDCWD || path[0] == '/')
    return readlink(path, buf, bufsize);

  if (path[0] == '\0') {
    /* there is a race condition here between the fcntl and readlink calls */
    char fdpath[PATH_MAX + strlen(path) + 2];
    if (fcntl(fd, F_GETPATH, fdpath) == -1)
      return -1;
    return readlink(fdpath, buf, bufsize);
  }

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

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
  if (path[0] != '\0') {
    strcat(fdpath, "/");
    strcat(fdpath, path);
  }
  return readlink(fdpath, buf, bufsize);

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

  ssize_t ret = readlink(path, buf, bufsize);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

#endif
