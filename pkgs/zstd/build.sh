#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX=/usr UNAME=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" PREFIX=/usr UNAME=Darwin install
)

(
cd package || exit 1
rm -rf usr/share usr/lib/libzstd.a
"$_TARGET-strip" -x usr/bin/zstd
"$_TARGET-strip" -x usr/lib/libzstd.1.5.4.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/zstd
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libzstd.1.5.4.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package zstd-1.5.4.deb
