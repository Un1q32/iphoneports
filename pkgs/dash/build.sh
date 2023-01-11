#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --bindir=/bin
"$_MAKE" -j4
mkdir -p "$_PKGROOT"/package/bin
cp src/dash "$_PKGROOT"/package/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x bin/dash
ldid -S"$_BSROOT/entitlements.plist" bin/dash
)
cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package dash-0.5.12.deb
