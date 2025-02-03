#pragma once

#include_next <stdio.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 110000) ||                             \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 101300)

static inline FILE *open_memstream(char **, size_t *) { return NULL; }

#endif
