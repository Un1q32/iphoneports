#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-md2man --with-included-zlib=no
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/rsync
)

installlicense "$_SRCDIR/COPYING"

builddeb
