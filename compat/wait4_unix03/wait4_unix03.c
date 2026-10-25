#ifdef HAVE_UNIX03_SYMBOLS

/*
 * AFAIK wait4 never actually had a UNIX2003 variant,
 * but hyperfine fails to link without it so oh well.
 */

#include <sys/wait.h>

pid_t wait4_unix03(pid_t pid, int *stat_loc, int options,
                   struct rusage *rusage) __asm("_wait4$UNIX2003");
pid_t wait4_unix03(pid_t pid, int *stat_loc, int options,
                   struct rusage *rusage) {
  return wait4(pid, stat_loc, options, rusage);
}

#endif
