#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/usr
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/hexedit
ldid -S"$_BSROOT/entitlements.plist" usr/bin/hexedit
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package hexedit-1.6.deb
