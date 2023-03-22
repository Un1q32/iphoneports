#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-libidn2
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/man
"$_TARGET-strip" usr/bin/curl
"$_TARGET-strip" usr/lib/libcurl.4.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/curl
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libcurl.4.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package curl-8.0.1.deb
