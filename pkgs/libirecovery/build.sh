#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-udev --without-iokit PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign bin/irecovery lib/libirecovery-1.0.5.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
