#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto hostname.c -o hostname -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp hostname "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" hostname 2>/dev/null || true
ldid -S"$_ENT" hostname
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "hostname-$_DPKGARCH.deb"
