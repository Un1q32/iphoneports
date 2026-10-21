#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

DIR *fdopendir(int fd) {
  DIR *ret = opendir("/");
  if (!ret)
    return NULL;

  close(*(int *)ret);
  *(int *)ret = fd;

  lseek(fd, 0, SEEK_SET);
  fcntl(fd, F_SETFD, FD_CLOEXEC);

  return ret;
}

#endif
