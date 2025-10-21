#!/bin/sh
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static CC="$_TARGET-cc"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/plistutil lib/libplist-2.0.4.dylib lib/libplist++-2.0.4.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
