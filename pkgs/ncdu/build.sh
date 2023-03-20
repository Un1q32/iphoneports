#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" ncdu "$_PKGROOT"/package/usr/bin/ncdu
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/ncdu
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ncdu
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ncdu-1.18.1.deb
