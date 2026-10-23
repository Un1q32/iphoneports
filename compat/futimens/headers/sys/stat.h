#ifndef UTIME_NOW
#define UTIME_NOW -1
#endif
#ifndef UTIME_OMIT
#define UTIME_OMIT -2
#endif

__BEGIN_DECLS
int futimens(int, const struct timespec t[2]);
__END_DECLS
