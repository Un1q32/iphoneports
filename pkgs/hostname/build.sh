#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 hostname.c -o hostname -D__FBSDID=__RCSID
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp hostname "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" hostname > /dev/null 2>&1
ldid -S"$_ENT" hostname
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg hostname.deb
