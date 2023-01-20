#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --libdir=/usr/local/lib --disable-lzmadec --disable-lzmainfo --disable-lzma-links
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/xz
"$_TARGET-strip" -x usr/bin/xzdec
"$_TARGET-strip" -x usr/local/lib/liblzma.5.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xz
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package xz-5.4.1.deb
