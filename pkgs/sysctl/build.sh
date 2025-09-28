#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" sysctl.c -o sysctl -Os -flto -D'__FBSDID(x)=' -Wno-pointer-sign
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sysctl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign sysctl
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
