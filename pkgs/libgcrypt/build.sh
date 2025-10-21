#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
if [ "$_CPU" = "i386" ]; then
    disable=--disable-avx2-support
fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-doc --enable-silent-rules $disable
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
strip_and_sign bin/*
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
