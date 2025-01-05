#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/lzip 2>/dev/null
ldid -S"$_ENT" bin/lzip
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzip.deb
