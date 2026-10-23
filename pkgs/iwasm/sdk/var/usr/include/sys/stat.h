#pragma once

#include_next <sys/stat.h>

#ifndef UTIME_NOW
#define UTIME_NOW -1
#endif
#ifndef UTIME_OMIT
#define UTIME_OMIT -2
#endif

#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 110000) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101300) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 40000)

#include <fcntl.h>
#include <string.h>
#include <sys/attr.h>
#include <unistd.h>

#define utimensat __iphoneports_utimensat

#define prepare_times_array_and_attrs                                          \
  __iphoneports_prepare_times_array_and_attrs
#define times_now __iphoneports_times_now

static struct timespec times_now[2] = {{.tv_nsec = UTIME_NOW},
                                       {.tv_nsec = UTIME_NOW}};

static int prepare_times_array_and_attrs(struct timespec times_in[2],
                                         struct timespec times_out[2],
                                         size_t *times_out_size) {
  if (times_in[0].tv_nsec == UTIME_OMIT && times_in[1].tv_nsec == UTIME_OMIT)
    return 0;

  if (times_in[0].tv_nsec == UTIME_NOW || times_in[1].tv_nsec == UTIME_NOW) {
    struct timespec now;
    struct timeval nowtv;
    gettimeofday(&nowtv, NULL);
    now.tv_sec = nowtv.tv_sec;
    now.tv_nsec = nowtv.tv_usec * 1000;

    if (times_in[0].tv_nsec == UTIME_NOW)
      times_in[0] = now;
    if (times_in[1].tv_nsec == UTIME_NOW)
      times_in[1] = now;
  }

  int attrs = 0;
  *times_out_size = 0;
  struct timespec *times_cursor = times_out;
  if (times_in[1].tv_nsec != UTIME_OMIT) {
    attrs |= ATTR_CMN_MODTIME;
    *times_cursor++ = times_in[1];
    *times_out_size += sizeof(struct timespec);
  }
  if (times_in[0].tv_nsec != UTIME_OMIT) {
    attrs |= ATTR_CMN_ACCTIME;
    *times_cursor = times_in[0];
    *times_out_size += sizeof(struct timespec);
  }
  return attrs;
}

static int utimensat(int fd, const char *path, const struct timespec times[2],
                     int flags) {
  struct timespec times_in[2];
  if (times)
    memcpy(&times_in, times, sizeof(times_in));
  else
    memcpy(&times_in, times_now, sizeof(times_in));

  size_t attrbuf_size = 0;
  struct timespec times_out[2];
  struct attrlist a = {.bitmapcount = ATTR_BIT_MAP_COUNT};
  a.commonattr =
      prepare_times_array_and_attrs(times_in, times_out, &attrbuf_size);

  int flags_out = 0;
  if (flags & AT_SYMLINK_NOFOLLOW)
    flags_out |= FSOPT_NOFOLLOW;

  return setattrlistat(fd, path, &a, &times_out, attrbuf_size, flags_out);
}

#undef prepare_times_array_and_attrs
#undef times_now

#endif
