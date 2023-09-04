#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -o ed -O2 main.c io.c buf.c re.c glbl.c undo.c sub.c -D__FBSDID=__RCSID
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ed > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" ed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ed.deb
