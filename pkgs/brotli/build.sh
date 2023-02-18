#!/bin/sh
(
cd source || exit 1
./bootstrap
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/brotli
"$_TARGET-strip" -x usr/lib/libbrotlicommon.1.dylib
"$_TARGET-strip" -x usr/lib/libbrotlidec.1.dylib
"$_TARGET-strip" -x usr/lib/libbrotlienc.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/brotli
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlicommon.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlidec.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlienc.1.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package brotli-1.0.9.deb
