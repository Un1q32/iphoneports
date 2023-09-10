#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/lzip > /dev/null 2>&1
ldid -S"$_ENT" bin/lzip
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzip.deb
