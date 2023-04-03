#!/bin/sh
(
cd source || exit 1
"$_TARGET-clang" -O2 -o pstree pstree.c
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" pstree "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/pstree > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/pstree
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package pstree-2.40.deb
