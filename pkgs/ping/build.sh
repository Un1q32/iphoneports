#!/bin/sh
set -e
. ../../lib.sh
(
cd src
"$_TARGET-cc" ping.c -o ping -Os -flto -Wno-deprecated-non-prototype
"$_TARGET-cc" ping6.c md5.c -o ping6 -Os -flto -Wno-deprecated-non-prototype -Wno-format -D__APPLE_USE_RFC_2292
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ping ping6 "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin
strip_and_sign ping ping6
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
