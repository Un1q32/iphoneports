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

installlicense "$_SRCDIR/COPYING"

builddeb
