#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/make
ldid -S"$_BSROOT/entitlements.xml" usr/bin/make
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package make-4.4.1.deb
