#include <platforminfo.h>
__BEGIN_DECLS
#if defined(HAS_INODE64_SYMBOLS) || MINVER_LT(0, 20000, 0)
int fstatat64(int, const char *, struct stat64 *, int);
#endif
int fstatat(int, const char *, struct stat *, int)
#if defined(HAS_INODE64_SYMBOLS) && __DARWIN_64_BIT_INO_T
__asm("_fstatat$INODE64")
#endif
;
__END_DECLS
