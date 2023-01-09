#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr --without-fonts
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/cmatrix
ldid -S"$_BSROOT/entitlements.plist" usr/bin/cmatrix
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cmatrix-2.0.deb
