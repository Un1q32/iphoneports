#!/bin/sh -e
(
cd src
"$_TARGET-cc" -O3 -flto -DUNIX -o xxd xxd.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp xxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" xxd 2>/dev/null || true
ldid -S"$_ENT" xxd
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "xxd-$_CPU-$_SUBSYSTEM.deb"
