#if MINVER_LT(101000, 80000, 0)

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int linkat(int olddirfd, const char *oldpath, int newdirfd, const char *newpath,
           int flags) {

#if MAXVER_GE(101000, 80000, 0)

  static bool init = false;
  static int (*func)(int, const char *, int, const char *, int);

  if (!init) {
    func = (int (*)(int, const char *, int, const char *, int))dlsym(RTLD_NEXT,
                                                                     "linkat");
    init = true;
  }

  if (func)
    return func(olddirfd, oldpath, newdirfd, newpath, flags);

#endif

  /*
   * This has race conditions, they could be mitigated by using pthread_fchdir,
   * but that would require writing a really long function and I don't wanna do
   * that.
   */
  if (oldpath[0] != '/' && olddirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(olddirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char oldfdpath[PATH_MAX + strlen(oldpath) + 2];
    fcntl(olddirfd, F_GETPATH, oldfdpath);
    strcat(oldfdpath, "/");
    strcat(oldfdpath, oldpath);
    oldpath = oldfdpath;
  }
  /* I don't know any way to emulate linkat with AT_SYMLINK_FOLLOW properly */
  if (flags & AT_SYMLINK_FOLLOW) {
    struct stat _st;
    if (lstat(oldpath, &_st) == -1)
      return -1;
    if (S_ISLNK(_st.st_mode)) {
      errno = EINVAL;
      return -1;
    }
  }
  if (newpath[0] != '/' && newdirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(newdirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char newfdpath[PATH_MAX + strlen(newpath) + 2];
    fcntl(newdirfd, F_GETPATH, newfdpath);
    strcat(newfdpath, "/");
    strcat(newfdpath, newpath);
    newpath = newfdpath;
  }
  return link(oldpath, newpath);
}

#endif
