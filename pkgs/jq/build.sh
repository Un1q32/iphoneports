#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-docs
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc share/man
strip_and_sign bin/jq lib/libjq.*.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
