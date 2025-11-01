#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" vm_stat.c -o vm_stat -Os -flto -Wno-format
mkdir -p "$_DESTDIR/var/usr/bin"
cp vm_stat "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign vm_stat
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
