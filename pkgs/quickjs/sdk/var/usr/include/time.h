#pragma once

#include_next <time.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 100000) ||               \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101200) ||                \
    (defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__) &&                    \
     __ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__ < 100000) ||                   \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 30000)

#include <dlfcn.h>
#include <errno.h>
#include <mach/mach_time.h>
#include <stdbool.h>
#include <sys/time.h>

#ifndef CLOCK_REALTIME
#define CLOCK_REALTIME 0
#endif
#ifndef CLOCK_MONOTONIC_RAW
#define CLOCK_MONOTONIC_RAW 4
#endif
#ifndef CLOCK_MONOTONIC_RAW_APROX
#define CLOCK_MONOTONIC_RAW_APROX 5
#endif
#ifndef CLOCK_MONOTONIC
#define CLOCK_MONOTONIC 6
#endif
#ifndef CLOCK_UPTIME_RAW
#define CLOCK_UPTIME_RAW 8
#endif
#ifndef CLOCK_UPTIME_RAW_APROX
#define CLOCK_UPTIME_RAW_APROX 9
#endif

#define clock_gettime __iphoneports_clock_gettime

static int clock_gettime(int clockid, struct timespec *ts) {
  static bool init = false;
  static int (*func)(int, struct timespec *);

  if (!init) {
    func = (int (*)(int, struct timespec *))dlsym(RTLD_NEXT, "clock_gettime");
    init = true;
  }

  if (func)
    return func(clockid, ts);

  uint64_t mach_time;

  switch (clockid) {
  case CLOCK_REALTIME: {
    struct timeval tv;
    int ret = gettimeofday(&tv, NULL);
    if (ret == -1)
      return -1;
    ts->tv_sec = tv.tv_sec;
    ts->tv_nsec = tv.tv_usec * 1000;
    return 0;
  }
  case CLOCK_MONOTONIC_RAW_APROX:
  case CLOCK_UPTIME_RAW_APROX:
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 80000) ||               \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 101000)
    mach_time = mach_approximate_time();
    break;
#endif
  case CLOCK_MONOTONIC:
  case CLOCK_MONOTONIC_RAW:
  case CLOCK_UPTIME_RAW:
    mach_time = mach_absolute_time();
    break;
  default:
    errno = EINVAL;
    return -1;
  }

  mach_timebase_info_data_t machinfo;
  mach_timebase_info(&machinfo);
  uint64_t nsec;
  if (machinfo.numer == machinfo.denom)
    nsec = mach_time;
  else
    nsec = mach_time * (double)((double)machinfo.numer / machinfo.denom);
  ts->tv_sec = nsec / 1000000000;
  ts->tv_nsec = nsec % 1000000000;
  return 0;
}

#endif
