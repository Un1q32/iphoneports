#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -Os -flto -o 2048 2048.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp 2048 "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" 2048 2>/dev/null
ldid -S"$_ENT" 2048
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg 2048.deb
