#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -Os -flto hostname.c -o hostname -D'__FBSDID(x)='
mkdir -p "$_DESTDIR/var/usr/bin"
cp hostname "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign hostname
)

installlicense files/LICENSE

builddeb
