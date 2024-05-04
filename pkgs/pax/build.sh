#!/bin/sh
(
cd src || exit 1
for src in *.c; do
    "$_TARGET-cc" -O2 -c "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o pax -O2 ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pax "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip pax
ldid -S"$_ENT" pax
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pax.deb
