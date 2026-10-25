#if MINVER_LT(1060, 30200, 0)

#define realpath __dont_define_realpath
#include <stdlib.h>
#undef realpath

#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <string.h>

static char *_realpath(const char *restrict path, char *restrict resolved_path,
                       char *(*func)(const char *restrict, char *restrict)) {
  if (!path) {
    errno = EINVAL;
    return NULL;
  }
  if (path[0] == '\0') {
    errno = ENOENT;
    return NULL;
  }
  if (!resolved_path) {
    char buf[PATH_MAX];
    char *ret = func(path, buf);
    if (!ret)
      return NULL;
    return strdup(ret);
  }
  return func(path, resolved_path);
}

char *realpath(const char *restrict path,
               char *restrict resolved_path) __asm("_realpath");
char *realpath(const char *restrict path, char *restrict resolved_path) {
  static char *(*func)(const char *restrict, char *restrict) = NULL;
  if (!func)
    func = (char *(*)(const char *restrict, char *restrict))dlsym(RTLD_NEXT,
                                                                  "realpath");

  return _realpath(path, resolved_path, func);
}

#if MINVER_GE(1050, 0, 0)

char *
realpath_extsn(const char *restrict path,
               char *restrict resolved_path) __asm("_realpath$DARWIN_EXTSN");
char *realpath_extsn(const char *restrict path, char *restrict resolved_path) {
  static char *(*func)(const char *restrict, char *restrict) = NULL;
  if (!func)
    func = (char *(*)(const char *restrict, char *restrict))dlsym(
        RTLD_NEXT, "realpath$DARWIN_EXTSN");

  return _realpath(path, resolved_path, func);
}

#endif

#ifdef HAS_UNIX03_SYMBOLS

char *realpath_unix03(const char *restrict path,
                      char *restrict resolved_path) __asm("_realpath$UNIX2003");
char *realpath_unix03(const char *restrict path, char *restrict resolved_path) {
  static char *(*func)(const char *restrict, char *restrict) = NULL;
  if (!func)
    func = (char *(*)(const char *restrict, char *restrict))dlsym(
        RTLD_NEXT, "realpath$UNIX2003");

  return _realpath(path, resolved_path, func);
}

#endif

#endif
