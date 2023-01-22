#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX=/usr -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" PREFIX=/usr install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/lz4
"$_TARGET-strip" -x usr/lib/liblz4.1.9.4.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lz4
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lz4-1.9.4.deb
