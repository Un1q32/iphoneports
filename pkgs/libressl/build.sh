#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/openssl > /dev/null 2>1
"$_TARGET-strip" usr/bin/ocspcheck > /dev/null 2>1
"$_TARGET-strip" usr/lib/libcrypto.50.dylib > /dev/null 2>1
"$_TARGET-strip" usr/lib/libssl.53.dylib > /dev/null 2>1
"$_TARGET-strip" usr/lib/libtls.26.dylib > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/openssl
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ocspcheck
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libcrypto.50.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libssl.53.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libtls.26.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libressl-3.6.2.deb
