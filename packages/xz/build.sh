#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --libdir=/usr/local/lib --disable-lzmadec --disable-lzmainfo --disable-lzma-links --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/xz > /dev/null 2>&1
"$_TARGET-strip" usr/bin/xzdec > /dev/null 2>&1
"$_TARGET-strip" usr/local/lib/liblzma.5.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xz
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xzdec
ldid -S"$_BSROOT/entitlements.xml" usr/local/lib/liblzma.5.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package xz.deb
