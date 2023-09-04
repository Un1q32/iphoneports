#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" vm_stat.c -o vm_stat -O2
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vm_stat "$_PKGROOT/pkg/var/usr/bin/vm_stat.real"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" vm_stat.real > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" vm_stat.real
)

cp files/vm_stat pkg/var/usr/bin/vm_stat

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg vm_stat.deb
