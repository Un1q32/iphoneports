#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-doc --enable-silent-rules GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
make
make DESTDIR="$_DESTDIR" install
)

strip_and_sign "$_DESTDIR/var/usr/lib/libksba.8.dylib"

installlicense "$_SRCDIR"/COPYING.*

builddeb
