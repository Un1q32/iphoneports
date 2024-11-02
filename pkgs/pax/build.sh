#!/bin/sh
(
cd src || exit 1
for src in *.c; do
  "$_TARGET-cc" -O3 -flto -c "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o pax -O3 -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pax "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" pax 2>/dev/null
ldid -S"$_ENT" pax
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pax.deb
