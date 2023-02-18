#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" src/m4 "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/m4
ldid -S"$_BSROOT/entitlements.xml" usr/bin/m4
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package m4-1.4.19.deb
