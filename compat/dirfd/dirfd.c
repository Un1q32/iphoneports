#if MINVER_LT(1080, 60000, 0)

#include <dirent.h>
#include <errno.h>

int dirfd(DIR *dirp) {
  int ret = -1;
  if (!dirp || *(int *)dirp < 0)
    errno = EINVAL;
  else
    ret = *(int *)dirp;
  return ret;
}

#endif
