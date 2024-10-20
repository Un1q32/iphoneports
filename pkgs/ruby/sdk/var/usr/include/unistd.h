#pragma once

#include_next <unistd.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern int fgetattrlist(int, struct attrlist *, void *, size_t, unsigned long);
__END_DECLS
