#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --prefix=/var/usr
make install DESTDIR="$_DESTDIR" -j"$_JOBS"
)

installlicense "$_SRCDIR/COPYING"

builddeb
