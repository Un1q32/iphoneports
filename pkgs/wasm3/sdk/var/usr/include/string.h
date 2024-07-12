#pragma once

#include <stddef.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern size_t strnlen(const char *, size_t);
__END_DECLS

#include_next <string.h>
