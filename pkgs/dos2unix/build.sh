#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" STRIP=touch CPP="$_TARGET-clang -E" DESTDIR="$_PKGROOT/package" prefix=/usr ENABLE_NLS= install -j4
# "$_MAKE" DESTDIR="$_PKGROOT/package" prefix=/usr install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/dos2unix
"$_TARGET-strip" -x usr/bin/unix2dos
ldid -S"$_BSROOT/entitlements.xml" usr/bin/dos2unix
ldid -S"$_BSROOT/entitlements.xml" usr/bin/unix2dos
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package dos2unix-7.4.4.deb
