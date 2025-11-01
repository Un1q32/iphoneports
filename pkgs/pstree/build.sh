#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -Os -flto -o pstree pstree.c
mkdir -p "$_DESTDIR/var/usr/bin"
cp pstree "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/pstree"

mkdir -p "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
cp "$_SRCDIR/LICENSE" "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"

builddeb
