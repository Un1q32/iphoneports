#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/* lib/libpkgconf.*.dylib
ln -s pkgconf bin/pkg-config
)

installlicense "$_SRCDIR/COPYING"

builddeb
