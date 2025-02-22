#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto -o pstree pstree.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pstree "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" pstree 2>/dev/null || true
ldid -S"$_ENT" pstree
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg pstree.deb
