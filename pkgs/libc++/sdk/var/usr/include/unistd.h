#pragma once

#include_next <unistd.h>

#include <fcntl.h>
#include <limits.h>
#include <string.h>

#define unlinkat __iphoneports_unlinkat

static inline int unlinkat(int fd, const char *path, int flags) {
  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_REMOVEDIR)
      return rmdir(path);
    return unlink(path);
  }

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 1];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  if (flags & AT_REMOVEDIR)
    return rmdir(new_path);
  return unlink(new_path);
}
