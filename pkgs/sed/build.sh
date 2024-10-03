#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/sed 2>/dev/null
ldid -S"$_ENT" bin/sed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sed.deb
