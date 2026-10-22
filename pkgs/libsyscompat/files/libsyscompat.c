#ifdef __i386__
#include <sys/wait.h>
// AFAIK wait4 never actually had a UNIX2003 variant, but hyperfine fails to
// link without it so oh well.
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options,
                     struct rusage *rusage) __asm("_wait4$UNIX2003");
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options,
                     struct rusage *rusage) {
  return wait4(pid, stat_loc, options, rusage);
}
#endif

#include <dirent.h>
#include <fcntl.h>
#include <stdlib.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_SYMLINK_FOLLOW
#define AT_SYMLINK_FOLLOW 0x0040
#endif

#if !((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&              \
       __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||              \
      (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&               \
       __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050))

static inline int pthread_fchdir_np(int fd) {
  return syscall(SYS___pthread_fchdir, fd);
}

#endif

int linkat(int olddirfd, const char *oldpath, int newdirfd, const char *newpath,
           int flags) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

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

int renameat(int olddirfd, const char *oldpath, int newdirfd,
             const char *newpath) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, const char *, int, const char *);

  if (!init) {
    func = (int (*)(int, const char *, int, const char *))dlsym(RTLD_NEXT,
                                                                "renameat");
    init = true;
  }

  if (func)
    return func(olddirfd, oldpath, newdirfd, newpath);

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
  return rename(oldpath, newpath);
}

int mkdirat(int fd, const char *path, mode_t mode) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(int, const char *, mode_t);

  if (!init) {
    func = (int (*)(int, const char *, mode_t))dlsym(RTLD_NEXT, "mkdirat");
    init = true;
  }

  if (func)
    return func(fd, path, mode);

#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

  /* the Mac OS X 10.4 / iPhone OS 1 version has a race condition */

  struct stat st;
  if (fstat(fd, &st) == -1)
    return -1;
  if (!S_ISDIR(st.st_mode)) {
    errno = ENOTDIR;
    return -1;
  }

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);
  strcat(fdpath, "/");
  strcat(fdpath, path);

  return mkdir(fdpath, mode);

#else

  int cwd = open(".", O_RDONLY);
  if (pthread_fchdir_np(-1) < 0 && cwd != -1) {
    close(cwd);
    cwd = -1;
  }
  if (pthread_fchdir_np(fd) < 0) {
    pthread_fchdir_np(cwd);
    if (cwd != -1)
      close(cwd);
    return -1;
  }

  int ret = mkdir(path, mode);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

int symlinkat(const char *target, int fd, const char *path) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(const char *, int, const char *);

  if (!init) {
    func =
        (int (*)(const char *, int, const char *))dlsym(RTLD_NEXT, "symlinkat");
    init = true;
  }

  if (func)
    return func(target, fd, path);

#endif

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050)

  /* the Mac OS X 10.4 / iPhone OS 1 version has a race condition */

  struct stat st;
  if (fstat(fd, &st) == -1)
    return -1;
  if (!S_ISDIR(st.st_mode)) {
    errno = ENOTDIR;
    return -1;
  }

  char fdpath[PATH_MAX + strlen(path) + 2];
  fcntl(fd, F_GETPATH, fdpath);
  strcat(fdpath, "/");
  strcat(fdpath, path);

  return symlink(target, fdpath);

#else

  int cwd = open(".", O_RDONLY);
  if (pthread_fchdir_np(-1) < 0 && cwd != -1) {
    close(cwd);
    cwd = -1;
  }
  if (pthread_fchdir_np(fd) < 0) {
    pthread_fchdir_np(cwd);
    if (cwd != -1)
      close(cwd);
    return -1;
  }

  int ret = symlink(target, path);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

void arc4random_buf(void *, size_t);

int CCRandomGenerateBytes(void *buf, size_t size) {
  arc4random_buf(buf, size);
  return 0;
}

#if (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1090) ||                  \
    (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 70000)

int proc_pid_rusage(int pid, int flavor, void *buffer) {
  static bool rusage_init = false;
  static int (*real_proc_pid_rusage)(int, int, void *) = NULL;

  if (!rusage_init) {
    real_proc_pid_rusage =
        (int (*)(int, int, void *))dlsym(RTLD_NEXT, "proc_pid_rusage");
    rusage_init = true;
  }
  if (real_proc_pid_rusage)
    return real_proc_pid_rusage(pid, flavor, buffer);

  errno = ENOSYS;
  return -1;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <pthread.h>
#include <stdint.h>

int pthread_threadid_np(pthread_t thread, uint64_t *tid) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(pthread_t, uint64_t *);

  if (!init) {
    func =
        (int (*)(pthread_t, uint64_t *))dlsym(RTLD_NEXT, "pthread_threadid_np");
    init = true;
  }

  if (func)
    return func(thread, tid);

#endif

  if (!tid)
    return EINVAL;

  if (!thread)
    thread = pthread_self();

  mach_port_t native_id = pthread_mach_thread_np(thread);
  if (!native_id)
    return ESRCH;

  *tid = native_id;
  return 0;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)

#include <limits.h>
#include <mach/mach_host.h>
#include <sys/attr.h>

#ifdef __LP64__
#define FLAGSTYPE int
#else
#define FLAGSTYPE long
#endif

int fsetattrlist(int fd, struct attrlist *attrList, void *attrBuf,
                 size_t attrBufSize, unsigned FLAGSTYPE flags) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, struct attrlist *, void *, size_t,
                     unsigned FLAGSTYPE);
  if (!init) {
    func = (int (*)(int, struct attrlist *, void *, size_t,
                    unsigned FLAGSTYPE))dlsym(RTLD_NEXT, "fsetattrlist");
    init = true;
  }

  if (func)
    return func(fd, attrList, attrBuf, attrBufSize, flags);

#endif

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  return setattrlist(fdpath, attrList, attrBuf, attrBufSize,
                     flags | FSOPT_NOFOLLOW);
}

kern_return_t host_statistics64(host_t host_priv, host_flavor_t flavor,
                                host_info_t host_info64_out,
                                mach_msg_type_number_t *host_info64_outCnt) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static kern_return_t (*func)(host_t, host_flavor_t, host_info_t,
                               mach_msg_type_number_t *);

  if (!init) {
    func =
        (kern_return_t (*)(host_t, host_flavor_t, host_info_t,
                           mach_msg_type_number_t *))dlsym(RTLD_NEXT,
                                                           "host_statistics64");
    init = true;
  }

  if (func)
    return func(host_priv, flavor, host_info64_out, host_info64_outCnt);

#endif

  return host_statistics(host_priv, flavor, host_info64_out,
                         host_info64_outCnt);
}

#endif

#endif

#endif

#endif
