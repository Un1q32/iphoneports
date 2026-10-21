#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

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

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir");
    init = true;
  }

  if (func)
    return func(fd);

#endif

  return _fdopendir(fd, opendir);
}

#if defined(__i386__) || defined(__ppc__)

DIR *opendir_unix03(const char *) __asm("_opendir$UNIX2003");
DIR *fdopendir_unix03(int fd) __asm("_fdopendir$UNIX2003");
DIR *fdopendir_unix03(int fd) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$UNIX2003");
    init = true;
  }

  if (func)
    return func(fd);

#endif

  return _fdopendir(fd, opendir_unix03);
}

#endif

#if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                  \
    __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050

#if defined(__i386__) || defined(__ppc__)

DIR *opendir_ino64_unix03(const char *) __asm("_opendir$INODE64$UNIX2003");
DIR *fdopendir_ino64_unix03(int fd) __asm("_fdopendir$INODE64$UNIX2003");
DIR *fdopendir_ino64_unix03(int fd) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$INODE64$UNIX2003");
    init = true;
  }

  if (func)
    return func(fd);

#endif

  return _fdopendir(fd, opendir_ino64_unix03);
}

#endif

#if defined(__x86_64__) || defined(__ppc64__)

DIR *opendir_ino64(const char *) __asm("_opendir$INODE64");
DIR *fdopendir_ino64(int fd) __asm("_fdopendir$INODE64");
DIR *fdopendir_ino64(int fd) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static DIR *(*func)(int);

  if (!init) {
    func = (DIR * (*)(int)) dlsym(RTLD_NEXT, "fdopendir$INODE64");
    init = true;
  }

  if (func)
    return func(fd);

#endif

  return _fdopendir(fd, opendir_ino64);
}

#endif

#endif

#endif
