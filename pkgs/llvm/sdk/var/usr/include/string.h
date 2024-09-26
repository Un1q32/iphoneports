#ifndef _FAKE_STRING_H_
#define _FAKE_STRING_H_

#include_next <string.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern size_t strnlen(const char *, size_t);
__END_DECLS

#endif
