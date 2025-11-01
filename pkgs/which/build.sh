#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -Os -flto which.c -o which -D'__FBSDID(x)='
mkdir -p "$_DESTDIR/var/usr/bin"
cp which "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign which
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
