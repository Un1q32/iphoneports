#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --prefix=/var/usr
make install DESTDIR="$_DESTDIR"
)

installlicense "$_SRCDIR/COPYING"

builddeb
