#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" -Os -flto hostname.c -o hostname -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp hostname "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" hostname 2>/dev/null || true
ldid -S"$_ENT" hostname
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg hostname.deb
