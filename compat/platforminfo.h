#pragma once

#define MINVER __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__

/* The maximum os version a platform can ever be on at runtime */
#if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)

#if defined(__ppc__)
/* Lion dropped support for 32-bit PowerPC in rosetta */
#define MAXVER 1069
#elif defined(__ppc64__)
/* 64-bit PowerPC couldn't run in Rosetta, dropped with Snow Leopard */
#define MAXVER 1059
#elif defined(__i386__)
/* macOS 10.15 dropped support for i386 binaries */
#define MAXVER 101499
#elif defined(__x86_64__)
/* macOS 28 plans to drop support for x86_64 binaries */
#define MAXVER 279999
#endif

#elif defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

#if __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 20000
/* iOS 2.0 changed the ABI, so binaries made for older iOS versions cannot run
 * on 2.0 or newer */
#define MAXVER 19999
#elif defined(__arm__)
/* 32-bit ARM was dropped with iOS 11 */
#define MAXVER 109999
#endif

#endif

#ifndef MAXVER
#define MAXVER 999999
#endif

#if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__)
#define MINVER_LT(mac, ios, watch) (MINVER < mac)
#define MAXVER_LT(mac, ios, watch) (MAXVER < mac)
#define MINVER_GE(mac, ios, watch) (MINVER >= mac)
#define MAXVER_GE(mac, ios, watch) (MAXVER >= mac)
#elif defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
    defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)
#define MINVER_LT(mac, ios, watch) (MINVER < ios)
#define MAXVER_LT(mac, ios, watch) (MAXVER < ios)
#define MINVER_GE(mac, ios, watch) (MINVER >= ios)
#define MAXVER_GE(mac, ios, watch) (MAXVER >= ios)
#elif defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__)
#define MINVER_LT(mac, ios, watch) (MINVER < watch)
#define MAXVER_LT(mac, ios, watch) (MAXVER < watch)
#define MINVER_GE(mac, ios, watch) (MINVER >= watch)
#define MAXVER_GE(mac, ios, watch) (MAXVER >= watch)
#else
#error unknown darwin subsystem
#endif

#if (defined(__i386__) || defined(__ppc__)) && MINVER_GE(1040, 999999, 999999)
#define HAS_UNIX03_SYMBOLS
#endif
#if (defined(__i386__) || defined(__ppc__) || defined(__x86_64__) ||           \
     defined(__ppc64__)) &&                                                    \
    MINVER_GE(1050, 999999, 999999)
#define HAS_INODE64_SYMBOLS
#endif
