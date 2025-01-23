#!/bin/sh -e
(
cd src || exit 1
for src in *.c; do
  "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o pax -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pax "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" pax 2>/dev/null || true
ldid -S"$_ENT" pax
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pax.deb
