#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" src/patch "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/patch
ldid -S"$_BSROOT/entitlements.xml" usr/bin/patch
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package patch-2.7.6.deb
