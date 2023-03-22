#!/bin/sh
(
cd source || exit 1
./configure --prefix=/usr --bindir=/bin CC="$_TARGET-clang"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr
"$_TARGET-strip" bin/ed > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" bin/ed
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ed-1.19.deb
