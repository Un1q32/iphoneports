#!/bin/sh
(
cd source || exit 1
"$_TARGET-clang" -O2 "$_PKGROOT/files/getusedmem.c" -o getusedmem
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" getusedmem "$_PKGROOT/package/usr/bin/getusedmem"
"$_CP" neofetch "$_PKGROOT/package/usr/bin/neofetch"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/getusedmem > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/getusedmem
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package neofetch.deb
