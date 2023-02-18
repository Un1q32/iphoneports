#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/openssl
"$_TARGET-strip" -x usr/bin/ocspcheck
"$_TARGET-strip" -x usr/lib/libcrypto.50.dylib
"$_TARGET-strip" -x usr/lib/libssl.53.dylib
"$_TARGET-strip" -x usr/lib/libtls.26.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/openssl
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ocspcheck
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libcrypto.50.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libssl.53.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libtls.26.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package libressl-3.6.2.deb
