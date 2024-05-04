#!/bin/sh
(
cd src || exit 1
for src in main.c io.c buf.c re.c glbl.c undo.c sub.c; do
  "$_TARGET-cc" -c -O2 "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ed -O2 ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip ed
ldid -S"$_ENT" ed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ed.deb
