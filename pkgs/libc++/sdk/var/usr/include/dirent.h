#pragma once

#include_next <dirent.h>

#include <fcntl.h>
#include <limits.h>
#include <stdlib.h>

#define fdopendir __iphoneports_fdopendir

static inline DIR *fdopendir(int fd) {
  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return NULL;

  return opendir(fdpath);
}
