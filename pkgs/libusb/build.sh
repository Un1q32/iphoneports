#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
grep -q kUSBDeviceSpeedSuper "$_SDK/System/Library/Frameworks/IOKit.framework/Headers/usb/USB.h" || superspeeddef='CPPFLAGS=-DkUSBDeviceSpeedSuper=3'
./configure --host="$_TARGET" --prefix=/var/usr --disable-static "$superspeeddef"
make
make install DESTDIR="$_DESTDIR"
)

strip_and_sign "$_DESTDIR/var/usr/lib/libusb-1.0.0.dylib"

ln -s libusb-1.0/libusb.h "$_DESTDIR/var/usr/include/libusb.h"

installlicense "$_SRCDIR/COPYING"

builddeb
