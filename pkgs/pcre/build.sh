#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --enable-utf
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/pcretest
"$_TARGET-strip" -x usr/bin/pcregrep
"$_TARGET-strip" -x usr/lib/libpcre.1.dylib
"$_TARGET-strip" -x usr/lib/libpcrecpp.0.dylib
"$_TARGET-strip" -x usr/lib/libpcreposix.0.dylib
ldid -S"$_BSROOT/entitlements.plist" usr/bin/pcretest
ldid -S"$_BSROOT/entitlements.plist" usr/bin/pcregrep
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package pcre-8.45.deb
