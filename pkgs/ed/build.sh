#!/bin/sh
(
cd source || exit 1
./configure --prefix=/usr CC="$_TARGET-clang"
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/ed
ldid -S"$_BSROOT/entitlements.plist" usr/bin/ed
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ed-1.18.deb
