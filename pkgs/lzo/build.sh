#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-shared
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/liblzo2.2.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
