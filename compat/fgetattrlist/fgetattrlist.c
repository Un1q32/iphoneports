#if MINVER_LT(1060, 30000, 0)

#include <dlfcn.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <sys/attr.h>
#include <unistd.h>

#ifdef __LP64__
#define FLAGSTYPE int
#else
#define FLAGSTYPE long
#endif

/* This has a race condition if the file is moved or
 * deleted between the fcntl call and getattrlist call */

int fgetattrlist(int fd, void *attrList, void *attrBuf, size_t attrBufSize,
                 unsigned FLAGSTYPE flags) {

#if MAXVER_GE(1060, 30000, 0)

  static bool init = false;
  static int (*func)(int, struct attrlist *, void *, size_t,
                     unsigned FLAGSTYPE);
  if (!init) {
    func = (int (*)(int, struct attrlist *, void *, size_t,
                    unsigned FLAGSTYPE))dlsym(RTLD_NEXT, "fgetattrlist");
    init = true;
  }

  if (func)
    return func(fd, attrList, attrBuf, attrBufSize, flags);

#endif

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  return getattrlist(fdpath, attrList, attrBuf, attrBufSize,
                     flags | FSOPT_NOFOLLOW);
}

#endif
