#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/hexedit
)

installlicense "$_SRCDIR/COPYING"

builddeb
