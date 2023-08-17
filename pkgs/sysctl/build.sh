#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" sysctl.c -o sysctl -O2
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" sysctl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" sysctl > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" sysctl
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sysctl.deb
