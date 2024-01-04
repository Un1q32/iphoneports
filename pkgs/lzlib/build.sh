#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr --disable-static CC="$_TARGET-cc"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip lib/liblz.1.13.dylib
ldid -S"$_ENT" lib/liblz.1.13.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzlib.deb
