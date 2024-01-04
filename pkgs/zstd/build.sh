#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr UNAME=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr UNAME=Darwin install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libzstd.a
llvm-strip bin/zstd lib/libzstd.1.5.5.dylib
ldid -S"$_ENT" bin/zstd lib/libzstd.1.5.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zstd.deb
