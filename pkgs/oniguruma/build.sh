#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-posix-api
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/lib/libonig.5.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libonig.5.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package oniguruma-6.9.8.deb
