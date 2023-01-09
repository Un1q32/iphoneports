#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr
make -j4
make DESTDIR="$_PKGROOT/package" install
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
