#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc CC="$_TARGET-clang -fheinous-gnu-extensions"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
# rm -rf usr/share
"$_TARGET-strip" -x usr/bin/gpg
ldid -S"$_BSROOT/entitlements.xml" usr/bin/gpg
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package gnupg-1.4.23.deb
