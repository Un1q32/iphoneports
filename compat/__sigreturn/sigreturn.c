/*
 * The symbol has been in libSystem since Leopard, but the libSystem dylib in
 * the SDKs didn't have it until 10.11 for some reason, iOS does not have this
 * issue
 */

#if MINVER_LT(101100, 20000, 0)

#include <sys/syscall.h>
#include <unistd.h>

int __sigreturn(void *p, int i) { return syscall(SYS_sigreturn, p, i); }

#endif
