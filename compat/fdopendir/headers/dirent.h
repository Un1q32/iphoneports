#include <platforminfo.h>
__BEGIN_DECLS
#if defined(HAS_UNIX03_SYMBOLS) && __DARWIN_UNIX03
#if defined(HAS_INODE64_SYMBOLS) && __DARWIN_64_BIT_INO_T
#define _FDOPENDIR_SYMBOL "_fdopendir$INODE64$UNIX2003"
#else
#define _FDOPENDIR_SYMBOL "_fdopendir$UNIX2003"
#endif
#else
#if defined(HAS_INODE64_SYMBOLS) && __DARWIN_64_BIT_INO_T
#define _FDOPENDIR_SYMBOL "_fdopendir$INODE64"
#else
#define _FDOPENDIR_SYMBOL "_fdopendir"
#endif
#endif
DIR *fdopendir(int) __asm(_FDOPENDIR_SYMBOL);
#undef _FDOPENDIR_SYMBOL
__END_DECLS
