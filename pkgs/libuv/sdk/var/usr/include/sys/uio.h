#pragma once

#include_next <sys/uio.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 140000) ||               \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 110000) ||                \
    (defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__) &&                    \
     __ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__ < 140000) ||                   \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 70000)

#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define preadv __iphoneports_preadv
#define pwritev __iphoneports_pwritev

static inline ssize_t preadv(int fd, const struct iovec *iov, int iovcnt,
                             off_t offset) {
  size_t bytes = 0;
  int i;
  for (i = 0; i < iovcnt; ++i)
    bytes += iov[i].iov_len;

  char *buf = (char *)malloc(bytes);
  if (!buf)
    return -1;

  ssize_t readret = pread(fd, buf, bytes, offset);
  if (readret < 0)
    return -1;

  bytes = readret;
  void *fbuf = buf;
  for (i = 0; i < iovcnt; ++i) {
    size_t copy = bytes < iov[i].iov_len ? bytes : iov[i].iov_len;
    memcpy(iov[i].iov_base, buf, copy);
    buf += copy;
    bytes -= copy;
    if (bytes == 0)
      break;
  }
  free(fbuf);

  return readret;
}

static inline ssize_t pwritev(int fd, const struct iovec *iov, int iovcnt,
                              off_t offset) {
  size_t bytes = 0;
  int i;
  for (i = 0; i < iovcnt; ++i)
    bytes += iov[i].iov_len;

  char *buf = (char *)malloc(bytes);
  if (!buf)
    return -1;

  void *fbuf = buf;
  for (i = 0; i < iovcnt; ++i) {
    memcpy(buf, iov[i].iov_base, iov[i].iov_len);
    buf += iov[i].iov_len;
  }

  ssize_t writeret = pwrite(fd, buf, bytes, offset);
  free(fbuf);
  return writeret;
}

#endif
