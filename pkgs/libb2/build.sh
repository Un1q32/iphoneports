#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-native --enable-silent-rules
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

strip_and_sign pkg/var/usr/lib/libb2.*.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
