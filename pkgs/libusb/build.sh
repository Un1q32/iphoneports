#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS='-DkUSBDeviceSpeedSuper=3'
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib || exit 1
llvm-strip libusb-1.0.0.dylib
ldid -S"$_ENT" libusb-1.0.0.dylib
)

ln -s libusb-1.0/libusb.h pkg/var/usr/include/libusb.h

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libusb.deb
