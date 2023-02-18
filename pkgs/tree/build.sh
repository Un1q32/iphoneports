#!/bin/sh
(
cd source || exit 1
"$_MAKE" PREFIX=/usr CC="$_TARGET-clang" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" tree "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/tree
ldid -S"$_BSROOT/entitlements.xml" usr/bin/tree
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package tree-2.1.0.deb
