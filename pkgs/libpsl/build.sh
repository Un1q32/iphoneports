#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/psl-make-dafsa
strip_and_sign bin/psl lib/libpsl.5.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
