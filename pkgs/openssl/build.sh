#!/bin/sh
(
cd src || exit 1
./Configure ios-cross no-shared --prefix=/var/usr --openssldir=/var/usr/etc/ssl --cross-compile-prefix="$_TARGET-"
"$_MAKE" CNF_CFLAGS='-fno-common -DBROKEN_CLANG_ATOMICS' -j8
"$_MAKE" CNF_CFLAGS='-fno-common -DBROKEN_CLANG_ATOMICS' DESTDIR="$_PKGROOT/pkg" install_sw
)

rm -rf pkg/var/usr/bin pkg/var/usr/lib/ossl-modules
