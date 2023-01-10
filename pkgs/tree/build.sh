#!/bin/sh
(
cd source || exit 1
make PREFIX=/usr CC="$_TARGET-clang" -j4
mkdir -p "$_PKGROOT"/package/usr/bin
cp tree "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/tree
ldid -S"$_BSROOT/entitlements.plist" usr/bin/tree
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package tree-2.1.0.deb
