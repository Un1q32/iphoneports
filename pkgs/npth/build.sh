#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-tests
make
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/lib/libnpth.0.dylib"

installlicense "$_SRCDIR/COPYING.LIB"

builddeb
