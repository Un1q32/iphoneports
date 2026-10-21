#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#define realpath __dont_define_realpath
#include <stdlib.h>
#undef realpath

#include <dlfcn.h>
#include <limits.h>
#include <string.h>

static char *_realpath(const char *restrict path, char *restrict resolved_path,
                       char *(*func)(const char *restrict, char *restrict)) {
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

#if defined(__i386__) || defined(__ppc__)

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
