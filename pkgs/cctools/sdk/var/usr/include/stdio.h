#ifndef _FAKE_STDIO_H_
#define _FAKE_STDIO_H_

#include_next <stdio.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
static inline FILE *open_memstream(char **, size_t *) {
  return NULL;
}
__END_DECLS

#endif
