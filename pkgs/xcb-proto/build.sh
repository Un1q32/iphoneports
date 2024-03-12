#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

mv pkg/var/usr/share/pkgconfig pkg/var/usr/lib

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xcb-proto.deb
