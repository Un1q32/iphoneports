#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 60000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1080)

#include <dirent.h>
#include <errno.h>

int dirfd(DIR *dirp) {
  int ret = -1;
  if (!dirp || dirp->dd_fd < 0)
    errno = EINVAL;
  else
    ret = dirp->dd_fd;
  return ret;
}

#endif
