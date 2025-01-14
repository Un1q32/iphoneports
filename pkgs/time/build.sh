#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -Os -flto time.c -o time -Wno-deprecated-non-prototype -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp time "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" time 2>/dev/null
ldid -S"$_ENT" time
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg time.deb
