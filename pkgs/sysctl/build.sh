#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" sysctl.c -o sysctl -O2 -D'__FBSDID(x)=' -Wno-pointer-sign
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sysctl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" sysctl 2>/dev/null
ldid -S"$_ENT" sysctl
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sysctl.deb
