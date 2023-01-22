#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX=/usr -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" PREFIX=/usr install
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/zstd
ldid -S"$_BSROOT/entitlements.xml" usr/bin/zstd
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package zstd-1.5.2.deb