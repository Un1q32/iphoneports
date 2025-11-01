#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS=-Wno-incompatible-function-pointer-types
make install DESTDIR="$_DESTDIR" -j"$_JOBS"
)

strip_and_sign "$_DESTDIR/var/usr/lib/libuv.1.dylib"

installlicense "$_SRCDIR/LICENSE"

builddeb
