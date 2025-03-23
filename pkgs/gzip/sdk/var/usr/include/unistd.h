#pragma once

#include_next <unistd.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <limits.h>
#include <sys/attr.h>
#include <sys/fcntl.h>

#define fgetattrlist __iphoneports_fgetattrlist
#define fsetattrlist __iphoneports_fsetattrlist

#ifdef __LP64__
#define FLAGSTYPE int
#else
#define FLAGSTYPE long
#endif

static inline int fgetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned FLAGSTYPE flags) {
  char fdpath[PATH_MAX];
  if (__builtin_expect(fcntl(fd, F_GETPATH, fdpath) == -1, 0))
    return -1;

  return getattrlist(fdpath, attrList, attrBuf, attrBufSize, flags);
}

static inline int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned FLAGSTYPE flags) {
  char fdpath[PATH_MAX];
  if (__builtin_expect(fcntl(fd, F_GETPATH, fdpath) == -1, 0))
    return -1;

  return setattrlist(fdpath, attrList, attrBuf, attrBufSize, flags);
}

#endif
