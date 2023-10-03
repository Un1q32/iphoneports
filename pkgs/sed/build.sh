#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -o sed main.c compile.c misc.c process.c -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" sed > /dev/null 2>&1
ldid -S"$_ENT" sed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sed.deb
