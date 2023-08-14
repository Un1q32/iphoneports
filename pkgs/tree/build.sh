#!/bin/sh
(
cd src || exit 1
"$_MAKE" PREFIX=/usr CC="$_TARGET-cc" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" tree "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" tree > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" tree
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg tree.deb
