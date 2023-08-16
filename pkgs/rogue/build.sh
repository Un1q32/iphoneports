#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-scorefile=/var/usr/share/rogue/scores
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/doc share/man
"$_TARGET-strip" bin/rogue > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/rogue
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg rogue.deb
