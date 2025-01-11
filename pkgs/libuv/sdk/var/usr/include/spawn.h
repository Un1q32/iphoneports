#pragma once

#include_next <spawn.h>

static inline int
posix_spawn_file_actions_addinherit_np(posix_spawn_file_actions_t *fa, int fd) {
  (void)fa;
  (void)fd;
  return 0;
}
