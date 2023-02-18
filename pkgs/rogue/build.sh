#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)


(
cd package || exit 1
rm -rf usr/share ../packagerogue.scr
"$_TARGET-strip" -x usr/bin/rogue
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rogue
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rogue-5.4.4.deb
