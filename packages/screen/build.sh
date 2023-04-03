#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/info usr/share/man usr/bin/screen
mv usr/bin/screen-4.9.0 usr/bin/screen
"$_TARGET-strip" usr/bin/screen > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/screen
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package screen-4.9.0.deb
