#pragma once

#include_next <unistd.h>

__BEGIN_DECLS
extern int unlinkat(int, const char *, int);
__END_DECLS
