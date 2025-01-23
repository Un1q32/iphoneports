#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" vm_stat.c -o vm_stat -Os -flto
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vm_stat "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" vm_stat 2>/dev/null || true
ldid -S"$_ENT" vm_stat
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg vm_stat.deb
