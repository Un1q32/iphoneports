#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib || exit 1
"$_TARGET-strip" libusb-1.0.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" libusb-1.0.0.dylib
)

ln -s libusb-1.0/libusb.h pkg/var/usr/include/libusb.h

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libusb.deb
