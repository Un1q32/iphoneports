#!/bin/sh -e
(
cd src
"$_TARGET-cc" vm_stat.c -o vm_stat -Os -flto
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vm_stat "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" vm_stat 2>/dev/null || true
ldid -S"$_ENT" vm_stat
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg vm_stat.deb
