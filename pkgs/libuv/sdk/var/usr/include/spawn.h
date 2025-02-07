#pragma once

#include_next <spawn.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#define posix_spawn_file_actions_addinherit_np                                 \
  __iphoneports_posix_spawn_file_actions_addinherit_np

static inline int
posix_spawn_file_actions_addinherit_np(posix_spawn_file_actions_t *fa, int fd) {
  (void)fa;
  (void)fd;
  return 0;
}

#endif
