#!/bin/sh
(
cd source || exit 1
CHOST="$_TARGET" ./configure --prefix=/usr --shared --libdir=/usr/local/lib
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share usr/local/lib/libz.a
"$_TARGET-strip" usr/local/lib/libz.1.2.13.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/local/lib/libz.1.2.13.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package zlib-1.2.13.deb
