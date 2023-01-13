#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p "$_PKGROOT"/package/usr/bin
cp src/m4 "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/m4
ldid -S"$_BSROOT/entitlements.plist" usr/bin/m4
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package m4-1.4.19.deb
