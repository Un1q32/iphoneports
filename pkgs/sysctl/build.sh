#!/bin/sh -e
(
cd src
"$_TARGET-cc" sysctl.c -o sysctl -Os -flto -D'__FBSDID(x)=' -Wno-pointer-sign
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sysctl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" sysctl 2>/dev/null || true
ldid -S"$_ENT" sysctl
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "sysctl-$_CPU-$_SUBSYSTEM.deb"
