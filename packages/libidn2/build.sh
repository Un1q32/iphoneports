#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/idn2 > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libidn2.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/idn2
ldid -S"$_BSROOT/ent.xml" usr/lib/libidn2.0.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libidn2.deb
