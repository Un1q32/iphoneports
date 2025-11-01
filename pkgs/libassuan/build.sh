#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    --disable-doc \
    GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/lib/libassuan.9.dylib

installlicense "$_SRCDIR/COPYING".LIB

builddeb
