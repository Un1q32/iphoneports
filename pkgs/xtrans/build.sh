#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PKG_CONFIG_SYSROOT_DIR="$_SDK"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

rm -rf pkg/var/usr/share/doc
mv pkg/var/usr/share pkg/var/usr/lib

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xtrans.deb
