#ifdef __i386__
#include <sys/wait.h>
// AFAIK wait4 never actually had a UNIX2003 variant, but hyperfine fails to link without it so oh well.
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options, struct rusage *rusage) __asm("_wait4$UNIX2003");
pid_t wait4_unix2003(pid_t pid, int *stat_loc, int options, struct rusage *rusage) {
  return wait4(pid, stat_loc, options, rusage);
}
#endif

#define realpath __dont_define_realpath
#define fstatat __dont_define_fstatat

#define __dd_fd dd_fd
#include <dirent.h>
#undef __dd_fd

#include <fcntl.h>

#include <stdlib.h>
#undef realpath
#undef fstatat

#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 100000) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101200) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 30000)

void arc4random_buf(void *, size_t);

int getentropy(void *buf, size_t size) {
  arc4random_buf(buf, size);
  return 0;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <string.h>
#include <dlfcn.h>
#include <errno.h>
#include <stdbool.h>
#include <limits.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_EACCESS
#define AT_EACCESS 0x0010
#endif
#ifndef AT_SYMLINK_NOFOLLOW
#define AT_SYMLINK_NOFOLLOW 0x0020
#endif
#ifndef AT_SYMLINK_FOLLOW
#define AT_SYMLINK_FOLLOW 0x0040
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
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

ssize_t readlinkat(int fd, const char *path, char *buf, size_t bufsize) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static ssize_t (*func)(int, const char *, char *, size_t);

  if (!init) {
    func = (ssize_t (*)(int, const char *, char *, size_t))dlsym(RTLD_NEXT,
                                                                 "readlinkat");
    init = true;
  }

  if (func)
    return func(fd, path, buf, bufsize);

#endif

  if (fd == AT_FDCWD || path[0] == '/')
    return readlink(path, buf, bufsize);

  if (path[0] == '\0') {
    /* there is a race condition here between the fcntl and readlink calls */
    char fdpath[PATH_MAX + strlen(path) + 2];
    if (fcntl(fd, F_GETPATH, fdpath) == -1)
      return -1;
    return readlink(fdpath, buf, bufsize);
  }

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
  if (path[0] != '\0') {
    strcat(fdpath, "/");
    strcat(fdpath, path);
  }
  return readlink(fdpath, buf, bufsize);

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

  ssize_t ret = readlink(path, buf, bufsize);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
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

#if defined(__DARWIN_64_BIT_INO_T) && __DARWIN_64_BIT_INO_T &&                 \
    (!defined(__DARWIN_ONLY_64_BIT_INO_T) || !__DARWIN_ONLY_64_BIT_INO_T)
int fstatat(int fd, const char *path, struct stat *statbuf,
            int flags) __asm("_fstatat$INODE64");
#endif
int fstatat(int fd, const char *path, struct stat *statbuf, int flags) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(int, const char *, struct stat *, int);

  if (!init) {
    func = (int (*)(int, const char *, struct stat *, int))dlsym(RTLD_NEXT,
                                                                 "fstatat"
#if defined(__DARWIN_64_BIT_INO_T) && __DARWIN_64_BIT_INO_T &&                 \
    (!defined(__DARWIN_ONLY_64_BIT_INO_T) || !__DARWIN_ONLY_64_BIT_INO_T)
                                                                 "$INODE64"
#endif
    );
    init = true;
  }

  if (func)
    return func(fd, path, statbuf, flags);

#endif

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_SYMLINK_NOFOLLOW)
      return lstat(path, statbuf);
    return stat(path, statbuf);
  }

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

  if (flags & AT_SYMLINK_NOFOLLOW)
    return lstat(fdpath, statbuf);
  return stat(fdpath, statbuf);

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

  int ret;
  if (flags & AT_SYMLINK_NOFOLLOW)
    ret = lstat(path, statbuf);
  else
    ret = stat(path, statbuf);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

int faccessat(int fd, const char *path, int mode, int flags) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(int, const char *, int, int);

  if (!init) {
    func = (int (*)(int, const char *, int, int))dlsym(RTLD_NEXT, "faccessat");
    init = true;
  }

  if (func)
    return func(fd, path, mode, flags);

#endif

  if (flags & ~AT_EACCESS) {
    errno = EINVAL;
    return -1;
  }

  uid_t ruid = getuid(), euid = geteuid();
  gid_t rgid = getgid(), egid = getegid();
  int check_euid = ruid != euid && (flags & AT_EACCESS);
  int check_egid = rgid != egid && (flags & AT_EACCESS);
  if (check_euid)
    setreuid(euid, ruid);
  if (check_egid)
    setregid(egid, rgid);

  if (fd == AT_FDCWD || path[0] == '/') {
    int ret = access(path, mode);
    int errnobak = errno;
    if (check_euid)
      setreuid(ruid, euid);
    if (check_egid)
      setregid(rgid, egid);
    errno = errnobak;
    return ret;
  }

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

  int ret = access(fdpath, mode);
  int errnobak = errno;
  if (check_euid)
    setreuid(ruid, euid);
  if (check_egid)
    setregid(rgid, egid);
  errno = errnobak;
  return ret;

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

  int ret = access(path, mode);
  int errnobak = errno;
  if (check_euid)
    setreuid(ruid, euid);
  if (check_egid)
    setregid(rgid, egid);
  errno = errnobak;

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;

#endif
}

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
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <stdint.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 12000) ||                \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)

int SecRandomCopyBytes(void *rnd, size_t size, void *buf) {

#ifndef __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__

  static bool init = false;
  static int (*func)(void *, size_t, void *);

  if (!init) {
    func =
        (int (*)(void *, size_t, void *))dlsym(RTLD_NEXT, "SecRandomCopyBytes");
    if (!func) {
      void *handle = dlopen(
          "/System/Library/Frameworks/Security.framework/Security", RTLD_LAZY);
      if (handle)
        func = (int (*)(void *, size_t, void *))dlsym(handle,
                                                      "SecRandomCopyBytes");
      if (!func)
        dlclose(handle);
    }
    init = true;
  }

  if (func)
    return func(rnd, size, buf);

#else

  (void)rnd;

#endif

  uint32_t *cbuf = buf;
  while (size >= sizeof(uint32_t)) {
    *cbuf++ = arc4random();
    size -= sizeof(uint32_t);
  }
  if (size != 0) {
    uint32_t random = arc4random();
    memcpy(cbuf, &random, size);
  }
  return 0;
}

#endif

void arc4random_buf(void *buf, size_t size) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static void (*func)(void *, size_t);

  if (!init) {
    func = (void (*)(void *, size_t))dlsym(RTLD_NEXT, "arc4random_buf");
    init = true;
  }

  if (func) {
    func(buf, size);
    return;
  }

#endif

  uint32_t *cbuf = buf;
  while (size >= sizeof(uint32_t)) {
    *cbuf++ = arc4random();
    size -= sizeof(uint32_t);
  }
  if (size != 0) {
    uint32_t random = arc4random();
    memcpy(cbuf, &random, size);
  }
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30200) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1060)

#include <pthread.h>

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

int posix_memalign(void **memptr, size_t align, size_t size) {

#if !(defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&               \
      __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000)

  static bool init = false;
  static int (*func)(void **, size_t, size_t);

  if (!init) {
    func = (int (*)(void **, size_t, size_t))dlsym(RTLD_NEXT, "posix_memalign");
    init = true;
  }

  if (func)
    return func(memptr, align, size);

#endif

  if (align < sizeof(void *) || (align & (align - 1)) != 0)
    return EINVAL;

  void *mem;
  if (align <= 16)
    mem = malloc(size); /* Darwin malloc always aligns to 16 bytes */
  else
    mem = valloc(size); /* page aligned allocation */

  if (!mem)
    return ENOMEM;
  else {
    *memptr = mem;
    return 0;
  }
}

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

#ifdef __arm__

#include <unwind.h>

_Unwind_Ptr _Unwind_GetIPInfo(struct _Unwind_Context *context, int *ipbefore) {
  static bool init = false;
  static _Unwind_Ptr (*func)(struct _Unwind_Context *, int *);
  if (!init) {
    func = (_Unwind_Ptr (*)(struct _Unwind_Context *, int *))dlsym(
        RTLD_NEXT, "_Unwind_GetIPInfo");
    init = true;
  }

  if (func)
    return func(context, ipbefore);

  abort();
}

#endif

#endif

#endif

#endif

#endif

#endif

#endif
