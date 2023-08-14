#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr CC="$_TARGET-cc"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ed > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/ed
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ed.deb
