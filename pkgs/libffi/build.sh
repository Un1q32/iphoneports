#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/libffi.*.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
