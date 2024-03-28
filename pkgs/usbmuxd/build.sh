#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PACKAGE_VERSION=360619c5f721f93f0b9d8af1a2df0b926fbcf281
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip sbin/usbmuxd
ldid -S"$_ENT" sbin/usbmuxd
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg usbmuxd.deb
