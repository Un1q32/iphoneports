#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/idevicerestore > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/idevicerestore
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg idevicerestore.deb
