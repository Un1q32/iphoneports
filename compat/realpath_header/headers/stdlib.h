#pragma once

#include_next <stdlib.h>

#include <platforminfo.h>

#if MINVER_LT(1060, 30200, 0)

#include <errno.h>
#include <string.h>

static inline __iphoneports_realpath(const char *__restrict path, char *__restrict resolved_path) {
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
    char *ret = realpath(path, buf);
    if (!ret)
      return NULL;
    return strdup(ret);
  }
  return realpath(path, resolved_path);
}

#define realpath __iphoneports_realpath

#endif
