#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

rm -rf pkg/var/usr/share/doc
mv pkg/var/usr/share pkg/var/usr/lib

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xorgproto.deb
