#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --disable-install-examples --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/bin usr/share
"$_TARGET-strip" usr/lib/libhistory.8.2.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/lib/libreadline.8.2.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libhistory.8.2.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libreadline.8.2.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package readline.deb
