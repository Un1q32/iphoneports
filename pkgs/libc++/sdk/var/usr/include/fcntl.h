#ifndef _FAKE_FCNTL_H_
#define _FAKE_FCNTL_H_

#include_next <fcntl.h>
#include <sys/cdefs.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif

__BEGIN_DECLS
extern int openat(int, const char *, int, ...);
__END_DECLS

#endif
