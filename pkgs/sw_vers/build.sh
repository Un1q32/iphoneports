#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" sw_vers.c -o sw_vers -Os -flto -framework CoreFoundation
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sw_vers "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" sw_vers 2>/dev/null || true
ldid -S"$_ENT" sw_vers
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sw_vers.deb
