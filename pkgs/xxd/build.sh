#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O3 -flto -DUNIX -o xxd xxd.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp xxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" xxd 2>/dev/null
ldid -S"$_ENT" xxd
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xxd.deb
