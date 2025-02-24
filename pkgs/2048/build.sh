#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto -o 2048 2048.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp 2048 "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" 2048 2>/dev/null || true
ldid -S"$_ENT" 2048
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
