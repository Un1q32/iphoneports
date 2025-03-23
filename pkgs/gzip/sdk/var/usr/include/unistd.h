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

static inline int fgetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned long options) {
  char fdpath[PATH_MAX];
  if (__builtin_expect(fcntl(fd, F_GETPATH, fdpath) == -1, 0))
    return -1;

  return getattrlist(fdpath, attrList, attrBuf, attrBufSize, options);
}

static inline int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned long options) {
  char fdpath[PATH_MAX];
  if (__builtin_expect(fcntl(fd, F_GETPATH, fdpath) == -1, 0))
    return -1;

  return setattrlist(fdpath, attrList, attrBuf, attrBufSize, options);
}

#endif
