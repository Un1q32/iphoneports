#!/bin/sh -e
(
cd src
grep -q kUSBDeviceSpeedSuper "$_SDK/System/Library/Frameworks/IOKit.framework/Headers/usb/USB.h" || superspeeddef='CPPFLAGS=-DkUSBDeviceSpeedSuper=3'
./configure --host="$_TARGET" --prefix=/var/usr --disable-static "$superspeeddef"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib
strip_sign libusb-1.0.0.dylib
)

ln -s libusb-1.0/libusb.h pkg/var/usr/include/libusb.h

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
