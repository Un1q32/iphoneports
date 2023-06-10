#!/bin/sh
(
cd source || exit 1
"$_TARGET-clang" -O2 -o 2048 2048.c
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" 2048 "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/2048 > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/2048
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package 2048.deb
