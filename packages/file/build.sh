#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib --enable-lzlib
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/man
"$_TARGET-strip" usr/bin/file > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libmagic.1.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/file
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libmagic.1.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package file.deb
