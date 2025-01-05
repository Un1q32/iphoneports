#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" BUILD_STATIC=no TARGET_OS=Darwin install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/lz4 lib/liblz4.1.*.dylib 2>/dev/null
ldid -S"$_ENT" bin/lz4 lib/liblz4.1.*.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lz4.deb
