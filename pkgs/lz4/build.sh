#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" BUILD_STATIC=no TARGET_OS=Darwin install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/lz4 lib/liblz4.1.*.dylib
ldid -S"$_ENT" bin/lz4 lib/liblz4.1.*.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lz4.deb
