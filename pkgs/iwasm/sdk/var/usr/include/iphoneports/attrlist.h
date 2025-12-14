#pragma once

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

#include <errno.h>
#include <limits.h>

#else

#include <iphoneports/pthread_chdir.h>

#endif

#define setattrlistat __iphoneports_setattrlistat

static int setattrlistat(int fd, const char *path, void *a, void *buf,
                         size_t size, uint32_t flags) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

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

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <limits.h>
#include <sys/attr.h>

#ifdef __LP64__
#define FLAGSTYPE int
#else
#define FLAGSTYPE long
#endif

/* This has a race condition if the file is moved or
 * deleted between the fcntl call and setattrlist call */

#define fsetattrlist __iphoneports_fsetattrlist

static int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                        size_t attrBufSize, unsigned FLAGSTYPE flags) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, struct attrlist *, void *, size_t,
                     unsigned FLAGSTYPE);
  if (!init) {
    func = (int (*)(int, struct attrlist *, void *, size_t,
                    unsigned FLAGSTYPE))dlsym(RTLD_NEXT, "fsetattrlist");
    init = true;
  }

  if (func)
    return func(fd, attrList, attrBuf, attrBufSize, flags);

#endif

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  return setattrlist(fdpath, attrList, attrBuf, attrBufSize,
                     flags | FSOPT_NOFOLLOW);
}

#endif
