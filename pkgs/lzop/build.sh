#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" src/lzop "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/lzop
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lzop
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lzop-1.0.4.deb
