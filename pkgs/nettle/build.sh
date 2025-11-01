#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-assembler --disable-static
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/* lib/libnettle.8.*.dylib lib/libhogweed.6.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.LESSERv3 "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
