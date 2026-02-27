#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-install-examples --disable-static
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin
strip_and_sign lib/libhistory.8.*.dylib lib/libreadline.8.*.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
