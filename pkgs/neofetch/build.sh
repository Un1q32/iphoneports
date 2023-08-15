#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -ObjC "$_PKGROOT/files/nftool.m" -o nftool -lobjc -framework UIKit
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" nftool "$_PKGROOT/pkg/var/usr/bin"
"$_CP" neofetch "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" nftool > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" nftool
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg neofetch.deb
