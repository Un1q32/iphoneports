#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules CC="$_TARGET-cc"
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/libmpfr.6.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
