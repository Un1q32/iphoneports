#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-nls \
    --disable-doc
make
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/bin/yash"

installlicense "$_SRCDIR/COPYING"

builddeb
