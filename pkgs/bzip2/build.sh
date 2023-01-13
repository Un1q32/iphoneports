#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX="$_PKGROOT/package/usr" libbz2.a bzip2 bzip2recover install -j4
)

(
cd package || exit 1
mv usr/bin .
rm -rf usr/man
"$_TARGET-strip" -x bin/bzip2
"$_TARGET-strip" -x bin/bzip2recover
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2recover
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bzip2-1.0.8.deb
