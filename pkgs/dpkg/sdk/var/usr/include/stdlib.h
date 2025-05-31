#pragma once

#include_next <stdlib.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <limits.h>
#include <string.h>

static inline char *__iphoneports_realpath(const char *restrict path,
                                           char *restrict resolved_path) {
  if (!resolved_path) {
    char buf[PATH_MAX];
    char *ret = realpath(path, buf);
    if (!ret)
      return NULL;
    return strdup(ret);
  }
  return realpath(path, resolved_path);
}

#define realpath __iphoneports_realpath

#endif
