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
"$_TARGET-strip" usr/bin/psl
"$_TARGET-strip" -x usr/lib/libpsl.5.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/psl
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libpsl.5.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libpsl-0.21.2.deb
