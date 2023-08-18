#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 "$_PKGROOT/files/getusedmem.c" -o getusedmem
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" getusedmem "$_PKGROOT/pkg/var/usr/bin"
"$_CP" neofetch "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" getusedmem > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" getusedmem
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg neofetch.deb
