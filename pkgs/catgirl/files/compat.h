#ifndef _IPHONEPORTS_COMPAT_H_
#define _IPHONEPORTS_COMPAT_H_

#include <stdio.h>
#include <sys/types.h>

#define AT_FDCWD -2

extern void explicit_bzero(void *, size_t);
extern int mkdirat(int, const char *, mode_t);
extern int openat(int, const char *, int, ...);
extern void *memmem(const void *, size_t, const void *, size_t);
extern ssize_t getline(char **, size_t *, FILE *);
extern ssize_t getdelim(char **, size_t *, int, FILE *);

#endif
