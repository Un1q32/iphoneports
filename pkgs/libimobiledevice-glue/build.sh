#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign lib/libimobiledevice-glue-1.0.0.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
