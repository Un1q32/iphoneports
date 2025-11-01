#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --prefix=/var/usr
make install DESTDIR="$_DESTDIR" -j"$_JOBS"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
