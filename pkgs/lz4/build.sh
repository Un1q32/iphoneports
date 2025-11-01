#!/bin/sh
. ../../files/lib.sh

(
cd src
make CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr DESTDIR="$_DESTDIR" BUILD_STATIC=no TARGET_OS=Darwin install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/lz4 lib/liblz4.1.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
