#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ifconfig.c ifmedia.c -o ifconfig -O2 -DUSE_IF_MEDIA -DINET6 -DNO_IPX -Wno-deprecated-non-prototype -Wno-extra-tokens
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ifconfig "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin || exit 1
llvm-strip ifconfig
ldid -S"$_ENT" ifconfig
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ifconfig.deb
