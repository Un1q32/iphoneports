#!/bin/sh
. ../../files/lib.sh

(
cd src
for src in *.c; do
  "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o pax -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp pax "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign pax
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
