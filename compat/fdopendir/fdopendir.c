#if MINVER_LT(101000,80000,0)

#define fdopendir __dont_define_fdopendir
#define opendir __dont_define_opendir
#include <dirent.h>
#undef fdopendir
#undef opendir
#include <dlfcn.h>
#include <fcntl.h>
#include <stdbool.h>
#include <unistd.h>

static DIR *_fdopendir(int fd, DIR *(*func)(const char *)) {
  DIR *ret = func("/");
  if (!ret)
    return NULL;

  close(*(int *)ret);
  *(int *)ret = fd;

  lseek(fd, 0, SEEK_SET);
  fcntl(fd, F_SETFD, FD_CLOEXEC);

  return ret;
}

DIR *opendir(const char *) __asm("_opendir");
DIR *fdopendir(int fd) __asm("_fdopendir");
DIR *fdopendir(int fd) {

#if MAXVER_GE(101000,80000,0)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir");
    init = true;
  }

  if (func)
    return func(fd);

#endif /* MAXVER_GE(101000,80000,0) */

  return _fdopendir(fd, opendir);
}

#ifdef HAS_UNIX03_SYMBOLS

DIR *opendir_unix03(const char *) __asm("_opendir$UNIX2003");
DIR *fdopendir_unix03(int fd) __asm("_fdopendir$UNIX2003");
DIR *fdopendir_unix03(int fd) {

#if MAXVER_GE(101000,80000,0)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$UNIX2003");
    init = true;
  }

  if (func)
    return func(fd);

#endif /* MAXVER_GE(101000,80000,0) */

  return _fdopendir(fd, opendir_unix03);
}

#endif /* HAS_UNIX03_SYMBOLS */

#ifdef HAS_INODE64_SYMBOLS

DIR *opendir_ino64(const char *) __asm("_opendir$INODE64");
DIR *fdopendir_ino64(int fd) __asm("_fdopendir$INODE64");
DIR *fdopendir_ino64(int fd) {

#if MAXVER_GE(101000,80000,0)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$INODE64");
    init = true;
  }

  if (func)
    return func(fd);

#endif /* MAXVER_GE(101000,80000,0) */

  return _fdopendir(fd, opendir_ino64);
}

#ifdef HAS_UNIX03_SYMBOLS

DIR *opendir_ino64_unix03(const char *) __asm("_opendir$INODE64$UNIX2003");
DIR *fdopendir_ino64_unix03(int fd) __asm("_fdopendir$INODE64$UNIX2003");
DIR *fdopendir_ino64_unix03(int fd) {

#if MAXVER_GE(101000,80000,0)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$INODE64$UNIX2003");
    init = true;
  }

  if (func)
    return func(fd);

#endif /* MAXVER_GE(101000,80000,0) */

  return _fdopendir(fd, opendir_ino64_unix03);
}

#endif /* HAS_UNIX03_SYMBOLS */

#endif /* HAS_INODE64_SYMBOLS */

#endif /* MINVER_LT(101000,80000,0) */
