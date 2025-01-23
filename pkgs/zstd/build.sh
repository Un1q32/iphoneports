#!/bin/sh -e
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr UNAME=Darwin -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr UNAME=Darwin install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libzstd.a
"$_TARGET-strip" bin/zstd lib/libzstd.1.5.6.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/zstd lib/libzstd.1.5.6.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zstd.deb
