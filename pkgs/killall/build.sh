#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 killall.c -o killall -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp killall "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" killall > /dev/null 2>&1
ldid -S"$_ENT" killall
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg killall.deb
