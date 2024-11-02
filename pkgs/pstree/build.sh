#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -Os -flto -o pstree pstree.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pstree "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" pstree 2>/dev/null
ldid -S"$_ENT" pstree
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pstree.deb
