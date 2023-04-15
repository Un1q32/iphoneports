#!/bin/sh
(
cd source || exit 1
./configure --prefix=/usr --disable-static CC="$_TARGET-clang"
"$_MAKE" DESTDIR="$_PKGROOT/package" install -j8
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/lib/liblz.1.13.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/lib/liblz.1.13.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lzlib-1.13.deb
