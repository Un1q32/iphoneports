#pragma once

#include_next <dirent.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern DIR *fdopendir(int);
__END_DECLS
