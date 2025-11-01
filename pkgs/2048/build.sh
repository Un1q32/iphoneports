#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -std=c99 -Os -flto -o 2048 2048.c
mkdir -p "$_DESTDIR/var/usr/bin"
cp 2048 "$_DESTDIR/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/2048

installlicense "$_SRCDIR/LICENSE"

builddeb
