#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -o pstree pstree.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pstree "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" pstree > /dev/null 2>&1
ldid -S"$_ENT" pstree
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pstree.deb
