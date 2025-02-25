#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto killall.c -o killall -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp killall "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" killall 2>/dev/null || true
ldid -S"$_ENT" killall
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
