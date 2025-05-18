#!/bin/sh
set -e
(
cd src
"$_MAKE" CC="$_TARGET-cc" GLOBALCONF=/var/usr/etc/boxes-config
mkdir -p "$_PKGROOT/pkg/var/usr/bin" "$_PKGROOT/pkg/var/usr/etc"
cp out/boxes "$_PKGROOT/pkg/var/usr/bin"
cp boxes-config "$_PKGROOT/pkg/var/usr/etc"
)

(
cd pkg/var/usr/bin
strip_and_sign boxes
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
