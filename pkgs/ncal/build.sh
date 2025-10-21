#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
for src in ncal.c calendar.c easter.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -I. -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ncal -Os -flto -lncurses ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign ncal
ln -s ncal cal
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
