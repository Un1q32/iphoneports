#!/bin/sh -e
(
cd src
for src in *.c; do
  "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o pax -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pax "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" pax 2>/dev/null || true
ldid -S"$_ENT" pax
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "pax-$_DPKGARCH.deb"
