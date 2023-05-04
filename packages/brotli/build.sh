#!/bin/sh
(
cd source || exit 1
./bootstrap
./configure --host="$_TARGET" --prefix=/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/brotli > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libbrotlicommon.1.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libbrotlidec.1.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libbrotlienc.1.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/brotli
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlicommon.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlidec.1.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libbrotlienc.1.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package brotli.deb
