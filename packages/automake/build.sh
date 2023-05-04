#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/info usr/share/man usr/share/doc
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package automake.deb
