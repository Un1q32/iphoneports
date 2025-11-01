#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" sw_vers.c -o sw_vers -Os -flto -framework CoreFoundation
mkdir -p "$_DESTDIR/var/usr/bin"
cp sw_vers "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign sw_vers
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
