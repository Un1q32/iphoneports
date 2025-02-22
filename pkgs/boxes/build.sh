#!/bin/sh -e
(
cd src
"$_MAKE" CC="$_TARGET-cc" GLOBALCONF=/var/usr/etc/boxes-config
mkdir -p "$_PKGROOT/pkg/var/usr/bin" "$_PKGROOT/pkg/var/usr/etc"
cp out/boxes "$_PKGROOT/pkg/var/usr/bin"
cp boxes-config "$_PKGROOT/pkg/var/usr/etc"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" boxes 2>/dev/null || true
ldid -S"$_ENT" boxes
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg boxes.deb
