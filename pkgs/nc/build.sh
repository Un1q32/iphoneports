#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-libtls-only --disable-static --enable-nc
make -j"$_JOBS" install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf etc share include lib
strip_and_sign bin/nc
)

installlicense "$_SRCDIR/COPYING"

builddeb
