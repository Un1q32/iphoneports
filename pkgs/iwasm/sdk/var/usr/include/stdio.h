#pragma once

#include_next <stdio.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

#define renameat __iphoneports_renameat

static int renameat(int olddirfd, const char *oldpath, int newdirfd,
                    const char *newpath) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, const char *, int, const char *);

  if (!init) {
    func = (int (*)(int, const char *, int, const char *))dlsym(RTLD_NEXT,
                                                                "renameat");
    init = true;
  }

  if (func)
    return func(olddirfd, oldpath, newdirfd, newpath);

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
  return rename(oldpath, newpath);
}

#endif
