#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -Os -flto killall.c -o killall -D'__FBSDID(x)='
mkdir -p "$_DESTDIR/var/usr/bin"
cp killall "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign killall
)

installlicense files/LICENSE

builddeb
