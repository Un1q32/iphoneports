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
"$_TARGET-strip" usr/bin/idn2
"$_TARGET-strip" -x usr/lib/libidn2.0.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/idn2
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libidn2.0.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libidn2-2.3.4.deb
