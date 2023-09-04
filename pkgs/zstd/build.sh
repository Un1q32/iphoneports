#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr UNAME=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr UNAME=Darwin install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libzstd.a
"$_TARGET-strip" bin/zstd > /dev/null 2>&1
"$_TARGET-strip" lib/libzstd.1.5.5.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/zstd
ldid -S"$_BSROOT/ent.xml" lib/libzstd.1.5.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zstd.deb
