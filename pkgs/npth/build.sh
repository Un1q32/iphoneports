#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-tests
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/lib/libnpth.0.dylib

installlicense "$_SRCDIR/COPYING".LIB

builddeb
