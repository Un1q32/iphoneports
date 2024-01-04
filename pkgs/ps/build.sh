#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -o ps ps.c print.c nlist.c tasks.c keyword.c -D'__FBSDID(x)=' -Wno-deprecated-non-prototype -Wno-#warnings
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ps "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip ps
ldid -S"$_PKGROOT/files/ent.xml" ps
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ps.deb
