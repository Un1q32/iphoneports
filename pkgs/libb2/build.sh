#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-native --enable-silent-rules
make
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/lib"/libb2.*.dylib

installlicense "$_SRCDIR/COPYING"

builddeb
