#!/bin/sh
set -e
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -Os -flto "$_PKGROOT/files/getusedmem.c" -o "$_PKGROOT/pkg/var/usr/bin/getusedmem"

strip_and_sign "$_PKGROOT/pkg/var/usr/bin/getusedmem"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
