#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR" "$_DESTDIR/var/usr/lib"
cd "$_SRCDIR"
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -O3 -flto -c ../files/libsyscompat.c
"$_TARGET-ar" rcs "$_DESTDIR/var/usr/lib/libsyscompat.a" ./*.o
)
