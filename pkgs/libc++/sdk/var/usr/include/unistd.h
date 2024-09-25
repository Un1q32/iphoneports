#ifndef _FAKE_UNISTD_H_
#define _FAKE_UNISTD_H_

#include_next <unistd.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern int unlinkat(int, const char *, int);
__END_DECLS

#endif
