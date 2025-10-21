#!/bin/sh
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

strip_and_sign pkg/var/usr/lib/libjansson.*.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
