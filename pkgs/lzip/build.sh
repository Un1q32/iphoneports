#!/bin/sh
. ../../files/lib.sh
(
cd src
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/lzip
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
