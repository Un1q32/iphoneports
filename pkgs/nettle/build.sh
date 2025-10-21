#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-assembler --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/* lib/libnettle.8.*.dylib lib/libhogweed.6.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.LESSERv3 "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
