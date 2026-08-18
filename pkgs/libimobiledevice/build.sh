#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/libimobiledevice-1.0.6.dylib bin/*
)

installlicense "$_SRCDIR/COPYING"

cp -r DEBIAN "$_SRCDIR"
[ "$_SUBSYSTEM" = "macos" ] && sed -i -e 's|iphoneports-usbmuxd, ||' "$_SRCDIR/DEBIAN/control"
debian="$_SRCDIR/DEBIAN" builddeb
