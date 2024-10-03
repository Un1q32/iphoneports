#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" sbin/usbmuxd 2>/dev/null
ldid -S"$_ENT" sbin/usbmuxd
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg usbmuxd.deb
