#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -Os -flto -o pstree pstree.c
mkdir -p "$_DESTDIR/var/usr/bin"
cp pstree "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/pstree"

installlicense "$_SRCDIR/LICENSE"

builddeb
