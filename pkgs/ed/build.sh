#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -o ed -O2 main.c io.c buf.c re.c glbl.c undo.c sub.c -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip ed
ldid -S"$_ENT" ed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ed.deb
