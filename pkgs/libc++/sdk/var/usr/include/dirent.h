#ifndef _FAKE_DIRENT_H_
#define _FAKE_DIRENT_H_

#include_next <dirent.h>
#include <sys/cdefs.h>

__BEGIN_DECLS
extern DIR *fdopendir(int);
__END_DECLS

#endif
