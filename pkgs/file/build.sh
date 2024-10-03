#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/file lib/libmagic.1.dylib 2>/dev/null
ldid -S"$_ENT" bin/file lib/libmagic.1.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg file.deb
