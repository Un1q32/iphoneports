#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp a.out "$_PKGROOT/pkg/var/usr/bin/awk"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" awk > /dev/null 2>&1
ldid -S"$_ENT" awk
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg awk.deb
