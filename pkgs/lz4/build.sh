#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr TARGET_OS=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr TARGET_OS=Darwin install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/liblz4.a
llvm-strip bin/lz4 lib/liblz4.1.9.4.dylib
ldid -S"$_ENT" bin/lz4 lib/liblz4.1.9.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lz4.deb
