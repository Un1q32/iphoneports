#!/bin/sh
. ../../files/lib.sh

(
cd src
grep -q kUSBDeviceSpeedSuper "$_SDK/System/Library/Frameworks/IOKit.framework/Headers/usb/USB.h" || superspeeddef='CPPFLAGS=-DkUSBDeviceSpeedSuper=3'
./configure --host="$_TARGET" --prefix=/var/usr --disable-static "$superspeeddef"
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"/lib
strip_and_sign libusb-1.0.0.dylib
)

ln -s libusb-1.0/libusb.h pkg/var/usr/include/libusb.h

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
