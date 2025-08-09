#pragma once

#include_next <sys/stat.h>

#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 110000) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101300) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 40000)

#include <errno.h>
#include <stddef.h>
#include <sys/stat.h>
#include <sys/time.h>

#ifndef UTIME_NOW
#define UTIME_NOW -1
#endif
#ifndef UTIME_OMIT
#define UTIME_OMIT -2
#endif

static int futimens(int fd, const struct timespec times[2]) {
  if (!times ||
      (times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec == UTIME_NOW))
    return futimes(fd, NULL);

  if (times[0].tv_nsec == UTIME_OMIT && times[1].tv_nsec == UTIME_OMIT)
    return 0;

  struct timeval tv[2];

  if (times[0].tv_nsec == UTIME_OMIT || times[1].tv_nsec == UTIME_OMIT) {
    struct stat st;
    if (fstat(fd, &st) == -1)
      return -1;
    if (times[0].tv_nsec == UTIME_OMIT) {
      tv[0].tv_sec = st.st_atimespec.tv_sec;
      tv[0].tv_usec = st.st_atimespec.tv_nsec / 1000;
    }
    if (times[1].tv_nsec == UTIME_OMIT) {
      tv[1].tv_sec = st.st_mtimespec.tv_sec;
      tv[1].tv_usec = st.st_mtimespec.tv_nsec / 1000;
    }
    return futimes(fd, tv);
  }

  if (((times[0].tv_nsec < 0 || times[0].tv_nsec > 999999999) &&
       times[0].tv_nsec != UTIME_NOW) ||
      ((times[1].tv_nsec < 0 || times[1].tv_nsec > 999999999) &&
       times[1].tv_nsec != UTIME_NOW)) {
    errno = EINVAL;
    return -1;
  }
  tv[0].tv_sec = times[0].tv_sec;
  tv[0].tv_usec = times[0].tv_nsec / 1000;
  tv[1].tv_sec = times[1].tv_sec;
  tv[1].tv_usec = times[1].tv_nsec / 1000;
  if (times[0].tv_nsec == UTIME_NOW || times[1].tv_nsec == UTIME_NOW) {
    struct timeval now;
    if (gettimeofday(&now, NULL) == -1)
      return -1;
    if (times[0].tv_nsec == UTIME_NOW)
      tv[0] = now;
    if (times[1].tv_nsec == UTIME_NOW)
      tv[1] = now;
  }
  return futimes(fd, tv);
}

#endif
