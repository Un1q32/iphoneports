#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/man
"$_TARGET-strip" -x usr/bin/file
"$_TARGET-strip" -x usr/lib/libmagic.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/file
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libmagic.1.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package file-5.44.deb
