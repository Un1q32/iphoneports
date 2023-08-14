#!/bin/sh
(
cd src || exit 1
CHOST="$_TARGET" ./configure --prefix=/var/usr --shared
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libz.a
"$_TARGET-strip" lib/libz.1.2.13.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libz.1.2.13.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zlib.deb
