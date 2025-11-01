#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-assembler --disable-static
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/* lib/libnettle.8.*.dylib lib/libhogweed.6.*.dylib
)

installlicense "$_SRCDIR/COPYING.LESSERv3"

builddeb
