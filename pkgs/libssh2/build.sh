#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --disable-static --disable-examples-build
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/lib/libssh2.1.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libssh2.1.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libssh2-1.10.0.deb
