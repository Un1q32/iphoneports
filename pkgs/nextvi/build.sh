#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -std=c99 -Os -flto -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE vi.c -o vi
mkdir -p "$_DESTDIR/var/usr/bin"
cp vi "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/vi"

installlicense "$_SRCDIR/LICENSE"

builddeb
