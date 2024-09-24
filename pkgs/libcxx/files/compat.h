#ifndef _IPHONEPORTS_COMPAT_H_
#define _IPHONEPORTS_COMPAT_H_

#include <dirent.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/cdefs.h>

#define AT_FDCWD -2
#define AT_REMOVEDIR 0x0080

__BEGIN_DECLS
extern DIR *fdopendir(int);
extern int openat(int, const char *, int, ...);
extern int unlinkat(int, const char *, int);
__END_DECLS

#endif
