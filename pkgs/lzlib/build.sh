#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr --disable-static CC="$_TARGET-cc"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" lib/liblz.1.13.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/liblz.1.13.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzlib.deb
