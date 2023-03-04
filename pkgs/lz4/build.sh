#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX=/usr TARGET_OS=Darwin -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" PREFIX=/usr TARGET_OS=Darwin install
)

(
cd package || exit 1
rm -rf usr/share usr/lib/liblz4.a
"$_TARGET-strip" usr/bin/lz4
"$_TARGET-strip" -x usr/lib/liblz4.1.9.4.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lz4
ldid -S"$_BSROOT/entitlements.xml" usr/lib/liblz4.1.9.4.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lz4-1.9.4.deb
