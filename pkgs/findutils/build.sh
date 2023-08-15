#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/find > /dev/null 2>&1
"$_TARGET-strip" bin/xargs > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/find
ldid -S"$_BSROOT/ent.xml" bin/xargs
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg findutils.deb
