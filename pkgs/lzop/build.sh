#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/lzop 2>/dev/null
ldid -S"$_ENT" bin/lzop
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzop.deb
