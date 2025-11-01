#!/bin/sh
. ../../files/lib.sh

(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS=-Wno-incompatible-function-pointer-types
make install DESTDIR="$_DESTDIR" -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"/lib
strip_and_sign libuv.1.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
