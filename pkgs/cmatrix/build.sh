#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr --without-fonts
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/usr/bin"
cp cmatrix "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/cmatrix
ldid -S"$_BSROOT/entitlements.xml" usr/bin/cmatrix
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cmatrix-2.0.deb
