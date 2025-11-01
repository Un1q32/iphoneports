#!/bin/sh
. ../../files/lib.sh

(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/hexedit
)

installlicense "$_SRCDIR/COPYING"

builddeb
