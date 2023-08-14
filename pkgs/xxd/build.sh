#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -DUNIX -o xxd xxd.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
"$_CP" xxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" xxd > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" xxd
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xxd.deb
