#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/lib/libonig.*.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
