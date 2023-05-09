#!/bin/sh
(
cd source || exit 1
./configure --prefix=/usr CXX="$_TARGET-clang++"
"$_MAKE" DESTDIR="$_PKGROOT/package" install -j8
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/lzip > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/lzip
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lzip.deb
