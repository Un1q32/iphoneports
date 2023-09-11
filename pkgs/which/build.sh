#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 which.c -o which -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp which "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" which > /dev/null 2>&1
ldid -S"$_ENT" which
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg which.deb
