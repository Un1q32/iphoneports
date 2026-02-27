#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/inetcat bin/iproxy lib/libusbmuxd-2.0.7.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
