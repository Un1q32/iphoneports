#pragma once

#include_next <spawn.h>

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 40300) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 1070)

static inline int
posix_spawn_file_actions_addinherit_np(posix_spawn_file_actions_t *fa, int fd) {
  (void)fa;
  (void)fd;
  return 0;
}

#endif
