#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

strip_and_sign "$_DESTDIR/var/usr/lib/libtatsu.0.dylib"

installlicense "$_SRCDIR/COPYING"

builddeb
