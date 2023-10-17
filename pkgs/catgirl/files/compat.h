#include <sys/types.h>

#define AT_FDCWD -2

extern void explicit_bzero(void *d, size_t n);
extern int mkdirat(int dirfd, const char *pathname, mode_t mode);
extern int openat(int dirfd, const char *pathname, int flags, ...);
