#pragma once

#include_next <stdlib.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern void *__compat_aligned_alloc(size_t, size_t);
extern void __compat_aligned_free(void *);
__END_DECLS
