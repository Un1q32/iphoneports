#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/psl > /dev/null 2>&1
"$_TARGET-strip" lib/libpsl.5.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/psl
ldid -S"$_ENT" lib/libpsl.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libpsl.deb
