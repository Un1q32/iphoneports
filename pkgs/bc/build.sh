#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" bc/bc "$_PKGROOT/package/usr/bin"
"$_CP" dc/dc "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/bc
"$_TARGET-strip" -x usr/bin/dc
ldid -S"$_BSROOT/entitlements.xml" usr/bin/bc
ldid -S"$_BSROOT/entitlements.xml" usr/bin/dc
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bc-1.07.1.deb
