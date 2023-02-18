#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" find/find "$_PKGROOT/package/usr/bin"
"$_CP" xargs/xargs "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/find
"$_TARGET-strip" -x usr/bin/xargs
ldid -S"$_BSROOT/entitlements.xml" usr/bin/find
ldid -S"$_BSROOT/entitlements.xml" usr/bin/xargs
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package findutils-4.9.0.deb
