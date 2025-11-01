#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-doc --enable-silent-rules GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/lib/libksba.8.dylib

installlicense "$_SRCDIR/COPYING".*

builddeb
