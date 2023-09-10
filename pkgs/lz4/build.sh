#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr TARGET_OS=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr TARGET_OS=Darwin install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/liblz4.a
"$_TARGET-strip" bin/lz4 > /dev/null 2>&1
"$_TARGET-strip" lib/liblz4.1.9.4.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/lz4
ldid -S"$_ENT" lib/liblz4.1.9.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lz4.deb
