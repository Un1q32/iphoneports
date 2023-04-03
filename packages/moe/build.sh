#!/bin/sh
(
cd source || exit 1
./configure --prefix=/usr --sysconfdir=/etc CXX="$_TARGET-clang++"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/moe > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/moe
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package moe-1.13.deb
