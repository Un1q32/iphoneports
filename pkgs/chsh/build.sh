#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" "$_PKGROOT/files/iphoneports-chsh.c" -o iphoneports-chsh -O2
mkdir -p "$_PKGROOT/pkg/usr/bin"
"$_CP" iphoneports-chsh "$_PKGROOT/pkg/usr/bin"
)

(
cd pkg/usr/bin || exit 1
"$_TARGET-strip" iphoneports-chsh > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" iphoneports-chsh
chmod 4755 iphoneports-chsh
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg chsh.deb
