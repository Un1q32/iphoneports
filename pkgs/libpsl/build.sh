#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/psl-make-dafsa
strip_and_sign bin/psl lib/libpsl.5.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
