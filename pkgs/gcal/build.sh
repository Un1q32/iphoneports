#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
ln -s gcal usr/bin/cal
rm -rf usr/share/info
"$_TARGET-strip" -x usr/bin/gcal
"$_TARGET-strip" -x usr/bin/gcal2txt
"$_TARGET-strip" -x usr/bin/tcal
"$_TARGET-strip" -x usr/bin/txt2gcal
ldid -S"$_BSROOT/entitlements.xml" usr/bin/gcal
ldid -S"$_BSROOT/entitlements.xml" usr/bin/gcal2txt
ldid -S"$_BSROOT/entitlements.xml" usr/bin/tcal
ldid -S"$_BSROOT/entitlements.xml" usr/bin/txt2gcal
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package gcal-4.1.deb
