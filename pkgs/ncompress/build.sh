#!/bin/sh
. ../../files/lib.sh

(
cd src
mkdir -p "$_DESTDIR/var/usr/bin"
"$_TARGET-cc" -O3 -flto -o compress compress.c -DUTIME_H -DLSTAT -DUSERMEM=800000 -Wno-deprecated-non-prototype
cp compress "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign compress
ln -s compress uncompress
ln -s compress zcat
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/UNLICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
