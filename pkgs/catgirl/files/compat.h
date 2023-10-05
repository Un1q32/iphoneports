#include <sys/types.h>

extern int memset_s(void *dest, size_t destsz, int ch, size_t count);
extern int mkdirat(int dirfd, const char *pathname, mode_t mode);
extern int openat(int dirfd, const char *pathname, int flags, mode_t mode);
