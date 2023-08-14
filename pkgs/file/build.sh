#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib --enable-lzlib
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/file > /dev/null 2>&1
"$_TARGET-strip" lib/libmagic.1.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/file
ldid -S"$_BSROOT/ent.xml" lib/libmagic.1.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg file.deb
