#pragma once

/*
 * The symbol has been in libSystem since Leopard, but the libSystem dylib in
 * the SDKs didn't have it until 10.11 for some reason, iOS does not have this
 * issue
 */

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101100)

#include <sys/syscall.h>
#include <unistd.h>

#define __sigreturn __iphoneports___sigreturn

static int __sigreturn(void *p, int i) { return syscall(SYS_sigreturn, p, i); }

#else

extern int __sigreturn(void *, int);

#endif
