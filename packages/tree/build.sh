#!/bin/sh
(
cd source || exit 1
"$_MAKE" PREFIX=/usr CC="$_TARGET-clang" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" tree "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/tree > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/tree
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package tree.deb
