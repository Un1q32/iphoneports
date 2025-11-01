#!/bin/sh
. ../../files/lib.sh

(
cd src
mkdir -p "$_DESTDIR/var/usr/bin"
"$_TARGET-cc" -O3 -flto -o compress compress.c -DUTIME_H -DLSTAT -DUSERMEM=800000 -Wno-deprecated-non-prototype
cp compress "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/compress"
ln -s compress "$_DESTDIR/var/usr/bin/uncompress"
ln -s compress "$_DESTDIR/var/usr/bin/zcat"

installlicense src/UNLICENSE

builddeb
