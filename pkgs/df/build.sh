#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -I. df.c vfslist.c -o df -lutil -O2
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" df "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" df > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" df
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg df.deb