#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -Os -flto which.c -o which -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp which "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" which 2>/dev/null
ldid -S"$_ENT" which
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg which.deb
