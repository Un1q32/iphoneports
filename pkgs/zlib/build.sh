#!/bin/sh
(
cd src || exit 1
CHOST="$_TARGET" ./configure --prefix=/var/usr --shared
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libz.a
llvm-strip lib/libz.1.3.dylib
ldid -S"$_ENT" lib/libz.1.3.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zlib.deb
