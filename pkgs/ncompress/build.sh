#!/bin/sh
. ../../files/lib.sh

(
cd src
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -O3 -flto -o compress compress.c -DUTIME_H -DLSTAT -DUSERMEM=800000 -Wno-deprecated-non-prototype
cp compress "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign compress
ln -s compress uncompress
ln -s compress zcat
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/UNLICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
