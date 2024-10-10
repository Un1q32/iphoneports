#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" GLOBALCONF=/var/usr/etc/boxes-config
mkdir -p "$_PKGROOT/pkg/var/usr/bin" "$_PKGROOT/pkg/var/usr/etc"
cp out/boxes "$_PKGROOT/pkg/var/usr/bin"
cp boxes-config "$_PKGROOT/pkg/var/usr/etc"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" boxes 2>/dev/null
ldid -S"$_ENT" boxes
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg boxes.deb
