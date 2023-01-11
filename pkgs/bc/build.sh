#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/usr/bin"
cp bc/bc "$_PKGROOT/package/usr/bin"
cp dc/dc "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/bc
"$_TARGET-strip" -x usr/bin/dc
ldid -S"$_BSROOT/entitlements.plist" usr/bin/bc
ldid -S"$_BSROOT/entitlements.plist" usr/bin/dc
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bc-1.07.1.deb
