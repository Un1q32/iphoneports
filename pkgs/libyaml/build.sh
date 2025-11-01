#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign lib/libyaml-0.2.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/License "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
