#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/pngfix
"$_TARGET-strip" -x usr/bin/png-fix-itxt
"$_TARGET-strip" -x usr/lib/libpng16.16.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/pngfix
ldid -S"$_BSROOT/entitlements.xml" usr/bin/png-fix-itxt
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libpng16.16.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libpng-1.6.39.deb
