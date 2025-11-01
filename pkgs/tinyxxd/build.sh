#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -std=c11 -O3 -flto -o tinyxxd main.c
mkdir -p "$_DESTDIR/var/usr/bin"
cp tinyxxd "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/tinyxxd"
ln -s tinyxxd "$_DESTDIR/var/usr/bin/xxd"

installlicense "$_SRCDIR/LICENSE"

builddeb
