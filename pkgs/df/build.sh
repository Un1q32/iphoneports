#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 df.c -o df -D'__FBSDID(x)=' -lutil -lxo
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp df "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" df > /dev/null 2>&1
ldid -S"$_ENT" df
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg df.deb
