#!/bin/sh -e
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -Os -flto "$_PKGROOT/files/getusedmem.c" -o "$_PKGROOT/pkg/var/usr/bin/getusedmem"

"$_TARGET-strip" "$_PKGROOT/pkg/var/usr/bin/getusedmem" 2>/dev/null || true
ldid -S"$_ENT" "$_PKGROOT/pkg/var/usr/bin/getusedmem"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "getusedmem-$_DPKGARCH.deb"
