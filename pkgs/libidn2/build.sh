#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/idn2 > /dev/null 2>&1
"$_TARGET-strip" lib/libidn2.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/idn2
ldid -S"$_BSROOT/ent.xml" lib/libidn2.0.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libidn2.deb
