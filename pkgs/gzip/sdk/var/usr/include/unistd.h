#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <dlfcn.h>
#include <limits.h>
#include <stdbool.h>
#include <sys/attr.h>
#include <sys/fcntl.h>

#define fgetattrlist __iphoneports_fgetattrlist
#define fsetattrlist __iphoneports_fsetattrlist

#ifdef __LP64__
#define FLAGSTYPE int
#else
#define FLAGSTYPE long
#endif

/* these 2 functions have race conditions if the file is moved
 * or deleted between the fcntl call and attrlist call */

static inline int fgetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned FLAGSTYPE flags) {
  static bool init = false;
  static int (*func)(int, struct attrlist *, void *, size_t,
                     unsigned FLAGSTYPE);
  if (!init) {
    func = (int (*)(int, struct attrlist *, void *, size_t,
                    unsigned FLAGSTYPE))dlsym(RTLD_NEXT, "fgetattrlist");
    init = true;
  }

  if (func)
    return func(fd, attrList, attrBuf, attrBufSize, flags);

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  return getattrlist(fdpath, attrList, attrBuf, attrBufSize, flags);
}

static inline int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned FLAGSTYPE flags) {
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

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  return setattrlist(fdpath, attrList, attrBuf, attrBufSize, flags);
}

#endif
