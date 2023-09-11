#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" whois.c -o whois -O2 -Wno-string-plus-int -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp whois "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" whois > /dev/null 2>&1
ldid -S"$_ENT" whois
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg whois.deb
