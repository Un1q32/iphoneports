#if MINVER_LT(1070, 40300, 0)

#define open __dont_define_open
#include <fcntl.h>
#undef open

#include <dlfcn.h>
#include <errno.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include <sys/utsname.h>

enum version { VERSION_UNSET, VERSION_TIGER, VERSION_LEOPARD, VERSION_LION };

static int _open(const char *path, int flags, int mode,
                 int (*func)(const char *, int, ...)) {
#if MAXVER_LT(1050, 20000, 0)
  enum version ver = VERSION_TIGER;
#elif MAXVER_LT(1070, 40300, 0) && MINVER_GE(1050, 20000, 0)
  enum version ver = VERSION_LEOPARD;
#else
  static enum version ver = VERSION_UNSET;
  if (ver == VERSION_UNSET) {
    struct utsname u;
    int tmp = errno;
    int ret = uname(&u);
    errno = tmp;
    if (ret == -1)
      ver = MINVER;
    else {
      long ver = strtol(u.release, NULL, 10);
#if MAXVER_LT(1070, 40300, 0)
      if (ver >= 11)
        ver = 10;
#elif MINVER_GE(1050, 20000, 0)
      if (ver < 9)
        ver = 9;
#endif
      if (ver >= 11)
        ver = VERSION_LION;
      else if (ver >= 9)
        ver = VERSION_LEOPARD;
      else
        ver = VERSION_TIGER;
    }
  }
#endif
  bool cloexec = false;
  if (ver < VERSION_LION && flags & O_CLOEXEC) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
  if (ver == VERSION_TIGER && flags & O_SYMLINK) {
    flags &= ~O_SYMLINK;
    flags |= O_NOFOLLOW;
  }
  int fd = func(path, flags, mode);
  if (cloexec && fd != -1)
    fcntl(fd, F_SETFD, FD_CLOEXEC);
  return fd;
}

int open(const char *path, int flags, ...) __asm("_open");
int open(const char *path, int flags, ...) {
  static int (*func)(const char *, int, ...) = NULL;

  if (!func)
    func = (int (*)(const char *, int, ...))dlsym(RTLD_NEXT, "open");

  int mode = mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  return _open(path, flags, mode, func);
}

#if defined(HAS_UNIX03_SYMBOLS) && MINVER_GE(1050, 0, 0)

int open_unix03(const char *path, int flags, ...) __asm("_open$UNIX2003");
int open_unix03(const char *path, int flags, ...) {
  static int (*func)(const char *, int, ...) = NULL;

  if (!func)
    func = (int (*)(const char *, int, ...))dlsym(RTLD_NEXT, "open$UNIX2003");

  int mode = mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  return _open(path, flags, mode, func);
}

#endif

#endif
