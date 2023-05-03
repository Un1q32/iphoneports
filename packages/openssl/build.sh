#!/bin/sh
(
cd package || exit 1
rm -rf etc usr/bin/openssl usr/lib/pkgconfig usr/include
chmod u+w usr/lib/libcrypto.0.9.8.dylib usr/lib/libssl.0.9.8.dylib
"$_TARGET-strip" -x usr/lib/libssl.0.9.8.dylib > /dev/null 2>&1
"$_TARGET-strip" -x usr/lib/libcrypto.0.9.8.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libssl.0.9.8.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libcrypto.0.9.8.dylib
chmod u-w usr/lib/libcrypto.0.9.8.dylib usr/lib/libssl.0.9.8.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package openssl-0.9.8zg.deb
