#pragma once

#include_next <unistd.h>

#include <limits.h>
#include <sys/attr.h>
#include <sys/fcntl.h>

#define fgetattrlist __iphoneports_fgetattrlist

static inline int fgetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned long options) {
  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;
  return getattrlist(fdpath, attrList, attrBuf, attrBufSize, options);
}

static inline int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                               size_t attrBufSize, unsigned long options) {
  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;
  return setattrlist(fdpath, attrList, attrBuf, attrBufSize, options);
}
