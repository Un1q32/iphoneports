#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ping.c -o ping -Os -flto -Wno-deprecated-non-prototype
"$_TARGET-cc" ping6.c md5.c -o ping6 -Os -flto -Wno-deprecated-non-prototype -Wno-format -D__APPLE_USE_RFC_2292
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ping ping6 "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin || exit 1
"$_TARGET-strip" ping ping6 2>/dev/null
ldid -S"$_ENT" ping ping6
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ping.deb
