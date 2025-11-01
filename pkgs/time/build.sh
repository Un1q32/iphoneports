#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -Os -flto time.c -o time -Wno-deprecated-non-prototype -D'__FBSDID(x)='
mkdir -p "$_DESTDIR/var/usr/bin"
cp time "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign time
)

installlicense files/LICENSE

builddeb
