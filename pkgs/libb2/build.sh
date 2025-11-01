#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-native --enable-silent-rules
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/lib/libb2.*.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
