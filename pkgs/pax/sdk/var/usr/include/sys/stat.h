#pragma once

#include_next <sys/stat.h>

#if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                  \
    __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050

#include <dlfcn.h>
#include <stdbool.h>
#include <sys/attr.h>
#include <unistd.h>

static int lchmod(const char *path, mode_t mode) {
  static bool init = false;
  static int (*func)(const char *, mode_t);

  if (!init) {
    func = (int (*)(const char *, mode_t))dlsym(RTLD_NEXT, "lchmod");
    init = true;
  }

  if (func)
    return func(path, mode);

  struct stat st;
  if (lstat(path, &st) < 0)
    return -1;
  if ((st.st_mode & S_IFMT) != S_IFLNK)
    return chmod(path, mode);
  struct attrlist attr;
  bzero(&attr, sizeof(attr));
  attr.bitmapcount = ATTR_BIT_MAP_COUNT;
  attr.commonattr = ATTR_CMN_ACCESSMASK;
  return setattrlist(path, &attr, &mode, sizeof(int), FSOPT_NOFOLLOW);
}

#endif
