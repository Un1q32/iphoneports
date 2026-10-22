#if MINVER_LT(101000, 80000, 0)

#define fstatat64 __dont_define_fstatat64
#define fstatat __dont_define_fstatat
#define lstat __dont_define_lstat
#define stat __dont_define_stat
#include <sys/stat.h>
#undef fstatat64
#undef fstatat
#undef lstat
#undef stat
#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>

#if MINVER_LT(1050, 20000, 0)

#include <errno.h>
#include <limits.h>
#include <string.h>

#else

#include "pthread_chdir.h"

#endif

typedef struct __dont_define_stat stat_t;

static int _fstatat(int fd, const char *path, stat_t *statbuf, int flags,
                    int (*stat)(const char *, stat_t *),
                    int (*lstat)(const char *, stat_t *)) {
  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_SYMLINK_NOFOLLOW)
      return lstat(path, statbuf);
    return stat(path, statbuf);
  }

#if MINVER_LT(1050, 20000, 0)

  /* the Mac OS X 10.4 / iPhone OS 1 version has a race condition */

  stat_t st;
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

int _stat(const char *, stat_t *) __asm("_stat");
int _lstat(const char *, stat_t *) __asm("_lstat");
int fstatat(int fd, const char *path, stat_t *statbuf,
            int flags) __asm("_fstatat");
int fstatat(int fd, const char *path, stat_t *statbuf, int flags) {

#if MAXVER_GE(101000, 80000, 0)

  static bool init = false;
  static int (*func)(int, const char *, stat_t *, int);

  if (!init) {
    func =
        (int (*)(int, const char *, stat_t *, int))dlsym(RTLD_NEXT, "fstatat");
    init = true;
  }

  if (func)
    return func(fd, path, statbuf, flags);

#endif

  return _fstatat(fd, path, statbuf, flags, _stat, _lstat);
}

#if defined(HAS_INODE64_SYMBOLS) || MINVER_LT(0, 20000, 0)

int _stat64(const char *, stat_t *) __asm("_stat64");
int _lstat64(const char *, stat_t *) __asm("_lstat64");
int fstatat64(int fd, const char *path, stat_t *statbuf,
              int flags) __asm("_fstatat64");
int fstatat64(int fd, const char *path, stat_t *statbuf, int flags) {

#if MAXVER_GE(101000, 80000, 0)

  static bool init = false;
  static int (*func)(int, const char *, stat_t *, int);

  if (!init) {
    func = (int (*)(int, const char *, stat_t *, int))dlsym(RTLD_NEXT,
                                                            "fstatat64");
    init = true;
  }

  if (func)
    return func(fd, path, statbuf, flags);

#endif

  return _fstatat(fd, path, statbuf, flags, _stat64, _lstat64);
}

#ifdef HAS_INODE64_SYMBOLS

int fstatat_ino64(int fd, const char *path, stat_t *statbuf,
                  int flags) __asm("_fstatat$INODE64");
int fstatat_ino64(int fd, const char *path, stat_t *statbuf, int flags) {
  return fstatat64(fd, path, statbuf, flags);
}

#endif

#endif

#endif
