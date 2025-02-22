#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto time.c -o time -Wno-deprecated-non-prototype -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp time "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" time 2>/dev/null || true
ldid -S"$_ENT" time
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg time.deb
