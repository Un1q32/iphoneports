#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --prefix=/var/usr CXX="$_TARGET-c++"
make DESTDIR="$_DESTDIR" install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/lzip
)

installlicense "$_SRCDIR/COPYING"

builddeb
