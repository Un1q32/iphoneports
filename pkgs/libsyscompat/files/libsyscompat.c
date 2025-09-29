#define realpath __dont_define_realpath

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)
#define open __dont_define_open
#include <fcntl.h>
#undef open
int open(const char *path, int flags, ...)
#ifdef __i386__
    __asm("_open$UNIX2003")
#endif
        ;
#endif
#include <fcntl.h>

#include <stdlib.h>
#undef realpath

#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 100000) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101200) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 30000)

#include <dlfcn.h>
#include <errno.h>
#include <mach/mach_init.h>
#include <mach/mach_port.h>
#include <mach/mach_time.h>
#include <mach/thread_act.h>
#include <stdbool.h>
#include <sys/resource.h>
#include <sys/time.h>

#ifndef CLOCK_REALTIME
#define CLOCK_REALTIME 0
#endif
#ifndef CLOCK_MONOTONIC_RAW
#define CLOCK_MONOTONIC_RAW 4
#endif
#ifndef CLOCK_MONOTONIC_RAW_APROX
#define CLOCK_MONOTONIC_RAW_APROX 5
#endif
#ifndef CLOCK_MONOTONIC
#define CLOCK_MONOTONIC 6
#endif
#ifndef CLOCK_UPTIME_RAW
#define CLOCK_UPTIME_RAW 8
#endif
#ifndef CLOCK_UPTIME_RAW_APROX
#define CLOCK_UPTIME_RAW_APROX 9
#endif
#ifndef CLOCK_PROCESS_CPUTIME_ID
#define CLOCK_PROCESS_CPUTIME_ID 12
#endif
#ifndef CLOCK_THREAD_CPUTIME_ID
#define CLOCK_THREAD_CPUTIME_ID 16
#endif

extern uint64_t __thread_selfusage(void);

int clock_gettime(int clockid, struct timespec *ts) {
  static bool init = false;
  static int (*func)(int, struct timespec *);

  if (!init) {
    func = (int (*)(int, struct timespec *))dlsym(RTLD_NEXT, "clock_gettime");
    init = true;
  }

  if (func)
    return func(clockid, ts);

  uint64_t mach_time;

  switch (clockid) {
  case CLOCK_REALTIME: {
    struct timeval tv;
    int ret = gettimeofday(&tv, NULL);
    if (ret == -1)
      return -1;
    ts->tv_sec = tv.tv_sec;
    ts->tv_nsec = tv.tv_usec * 1000;
    return 0;
  }
  case CLOCK_PROCESS_CPUTIME_ID: {
    struct rusage ru;
    int ret = getrusage(RUSAGE_SELF, &ru);
    timeradd(&ru.ru_utime, &ru.ru_stime, &ru.ru_utime);
    ts->tv_sec = ru.ru_utime.tv_sec;
    ts->tv_nsec = ru.ru_utime.tv_usec * 1000;
    return ret;
  }
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 80000) ||               \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 101000) ||               \
    defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__) ||                     \
    defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__)
  case CLOCK_THREAD_CPUTIME_ID:
    mach_time = __thread_selfusage();
    break;
  case CLOCK_MONOTONIC_RAW_APROX:
  case CLOCK_UPTIME_RAW_APROX:
    mach_time = mach_approximate_time();
    break;
#else
  case CLOCK_THREAD_CPUTIME_ID: {
    thread_basic_info_data_t info;
    mach_msg_type_number_t count = THREAD_BASIC_INFO_COUNT;
    thread_port_t thread = mach_thread_self();
    int thread_info_ret =
        thread_info(thread, THREAD_BASIC_INFO, (thread_info_t)(&info), &count);
    mach_port_deallocate(mach_task_self(), thread);
    if (thread_info_ret != 0)
      return -1;

    ts->tv_sec = info.user_time.seconds + info.system_time.seconds;
    ts->tv_nsec =
        (info.user_time.microseconds + info.system_time.microseconds) * 1000;
    if (ts->tv_nsec >= 1000000000) {
      ts->tv_sec += 1;
      ts->tv_nsec -= 1000000000;
    }
    if (ts->tv_sec == 0 && ts->tv_nsec == 0)
      ts->tv_nsec = 1;

    return 0;
  }
  case CLOCK_MONOTONIC_RAW_APROX:
  case CLOCK_UPTIME_RAW_APROX:
#endif
  case CLOCK_MONOTONIC:
  case CLOCK_MONOTONIC_RAW:
  case CLOCK_UPTIME_RAW:
    mach_time = mach_absolute_time();
    break;
  default:
    errno = EINVAL;
    return -1;
  }

  mach_timebase_info_data_t machinfo;
  if (mach_timebase_info(&machinfo) != KERN_SUCCESS)
    return -1;
  uint64_t nsec;
  if (machinfo.numer == machinfo.denom)
    nsec = mach_time;
  else
    nsec = mach_time * (double)((double)machinfo.numer / machinfo.denom);
  ts->tv_sec = nsec / 1000000000;
  ts->tv_nsec = nsec % 1000000000;
  return 0;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

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

static inline int pthread_fchdir_np(int fd) {
  return syscall(SYS___pthread_fchdir, fd);
}

int fstatat(int fd, const char *path, struct stat *st, int flags) {
  static bool init = false;
  static int (*func)(int, const char *, struct stat *, int);

  if (!init) {
    func = (int (*)(int, const char *, struct stat *, int))dlsym(RTLD_NEXT,
                                                                 "fstatat");
    init = true;
  }

  if (func)
    return func(fd, path, st, flags);

  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_SYMLINK_NOFOLLOW)
      return lstat(path, st);
    return stat(path, st);
  }

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
    ret = lstat(path, st);
  else
    ret = stat(path, st);

  pthread_fchdir_np(cwd);
  if (cwd != -1)
    close(cwd);

  return ret;
}

int faccessat(int fd, const char *path, int mode, int flags) {
  static bool init = false;
  static int (*func)(int, const char *, int, int);

  if (!init) {
    func = (int (*)(int, const char *, int, int))dlsym(RTLD_NEXT, "faccessat");
    init = true;
  }

  if (func)
    return func(fd, path, mode, flags);

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
}

void arc4random_buf(void *, size_t);

int CCRandomGenerateBytes(void *buf, size_t size) {
  arc4random_buf(buf, size);
  return 0;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 60000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1080)

#include <dirent.h>

/*
 * dirfd exists on old darwins as a macro function, the symbol
 * wasn't added until later, but rust expects the symbol
 */

#undef dirfd

int dirfd(DIR *dirp) {
  int ret = -1;
  if (!dirp || dirp->__dd_fd < 0)
    errno = EINVAL;
  else
    ret = dirp->__dd_fd;
  return ret;
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <string.h>

#ifndef O_CLOEXEC
#define O_CLOEXEC 0x1000000
#endif

int open(const char *path, int flags, ...) {
  static int (*func)(const char *, int, ...) = NULL;

  if (!func)
    func = (int (*)(const char *, int, ...))dlsym(RTLD_NEXT, "open"
#ifdef __i386__
                                                             "$UNIX2003"
#endif
    );

  int mode = mode;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }
  bool cloexec = false;
  if (flags & O_CLOEXEC) {
    flags &= ~O_CLOEXEC;
    cloexec = true;
  }
  int fd = func(path, flags, mode);
  if (cloexec && fd != -1)
    fcntl(fd, F_SETFD, FD_CLOEXEC);
  return fd;
}

void arc4random_buf(void *buf, size_t size) {
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

int pthread_setname_np(const char *name) {
  static bool init = false;
  static int (*func)(const char *);

  if (!init) {
    func = (int (*)(const char *))dlsym(RTLD_NEXT, "pthread_setname_np");
    init = true;
  }

  if (func)
    return func(name);
  return 0;
}

#include <limits.h>

#ifdef __i386__
char *realpath(const char *restrict path,
               char *restrict resolved_path) __asm("_realpath$UNIX2003");
#endif
char *realpath(const char *restrict path, char *restrict resolved_path) {
  static char *(*func)(const char *, char *) = NULL;

  if (!func)
    func = (char *(*)(const char *, char *))dlsym(RTLD_NEXT, "realpath"
#ifdef __i386__
                                                             "$UNIX2003"
#endif
    );

  if (!resolved_path) {
    char buf[PATH_MAX];
    char *ret = func(path, buf);
    if (!ret)
      return NULL;
    return strdup(ret);
  }
  return func(path, resolved_path);
}

char *
realpath_extsn(const char *restrict path,
               char *restrict resolved_path) __asm("_realpath$DARWIN_EXTSN");
char *realpath_extsn(const char *restrict path, char *restrict resolved_path) {
  static char *(*func)(const char *, char *) = NULL;

  if (!func)
    func = (char *(*)(const char *, char *))dlsym(RTLD_NEXT,
                                                  "realpath$DARWIN_EXTSN");

  if (!resolved_path) {
    char buf[PATH_MAX];
    char *ret = func(path, buf);
    if (!ret)
      return NULL;
    return strdup(ret);
  }
  return func(path, resolved_path);
}

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 30000) ||                \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)

int posix_memalign(void **memptr, size_t align, size_t size) {
  static bool init = false;
  static int (*func)(void **, size_t, size_t);

  if (!init) {
    func = (int (*)(void **, size_t, size_t))dlsym(RTLD_NEXT, "posix_memalign");
    init = true;
  }

  if (func)
    return func(memptr, align, size);

  if (align < sizeof(void *) || (align & (align - 1)) != 0)
    return EINVAL;

  void *mem;
  if (align <= 16)
    mem = malloc(size); /* macOS malloc always aligns to 16 bytes */
  else
    mem = valloc(size); /* page aligned allocation */

  if (!mem)
    return ENOMEM;
  else {
    *memptr = mem;
    return 0;
  }
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
