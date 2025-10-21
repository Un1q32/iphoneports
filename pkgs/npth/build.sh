#!/bin/sh
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-tests
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

strip_and_sign pkg/var/usr/lib/libnpth.0.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.LIB "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
