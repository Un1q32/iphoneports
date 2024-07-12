#pragma once

#include_next <spawn.h>

__BEGIN_DECLS
extern int posix_spawn_file_actions_addinherit_np(posix_spawn_file_actions_t *, int);
__END_DECLS
