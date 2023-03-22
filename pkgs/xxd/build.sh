#!/bin/sh
(
cd source || exit 1
"$_TARGET-clang" -O2 -DUNIX -o xxd xxd.c
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" xxd "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/xxd > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xxd
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package xxd-9.0.1383.deb
