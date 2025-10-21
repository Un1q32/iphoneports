#!/bin/sh
. ../../files/lib.sh

(
cd src
for src in main.c io.c buf.c re.c glbl.c undo.c sub.c; do
  "$_TARGET-cc" -c -Os -flto "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ed -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign ed
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
