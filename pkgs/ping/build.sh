#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ping.c -o ping -O2 -Wno-deprecated-non-prototype
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ping "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin || exit 1
"$_TARGET-strip" ping > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" ping
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ping.deb
