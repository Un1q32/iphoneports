#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/pngfix bin/png-fix-itxt lib/libpng16.16.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
