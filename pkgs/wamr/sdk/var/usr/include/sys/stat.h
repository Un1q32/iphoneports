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

#include <string.h>
#include <sys/attr.h>

#define futimens __iphoneports_futimens
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

static int futimens(int fd, const struct timespec times[2]) {
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

  return fsetattrlist(fd, &a, &times_out, attrbuf_size, 0);
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

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

#include <errno.h>
#include <limits.h>

#else

#include <iphoneports/pthread_chdir.h>

#endif

#define fstatat __iphoneports_fstatat
#define mkdirat __iphoneports_mkdirat

static int fstatat(int fd, const char *path, struct stat *statbuf, int flags) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(int, const char *, struct stat *, int);

  if (!init) {
    func = (int (*)(int, const char *, struct stat *, int))dlsym(RTLD_NEXT,
                                                                 "fstatat");
    init = true;
  }

  if (func)
    return func(fd, path, statbuf, flags);

#endif

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_SYMLINK_NOFOLLOW)
      return lstat(path, statbuf);
    return stat(path, statbuf);
  }

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

  if (flags & AT_SYMLINK_NOFOLLOW)
    return lstat(fdpath, statbuf);
  return stat(fdpath, statbuf);

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

  int ret;
  if (flags & AT_SYMLINK_NOFOLLOW)
    ret = lstat(path, statbuf);
  else
    ret = stat(path, statbuf);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

static int mkdirat(int fd, const char *path, mode_t mode) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(int, const char *, mode_t);

  if (!init) {
    func = (int (*)(int, const char *, mode_t))dlsym(RTLD_NEXT, "mkdirat");
    init = true;
  }

  if (func)
    return func(fd, path, mode);

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

  return mkdir(fdpath, mode);

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

  int ret = mkdir(path, mode);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

#endif
