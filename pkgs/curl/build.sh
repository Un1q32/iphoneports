#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-libidn2 LIBS="-framework SystemConfiguration"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/curl > /dev/null 2>&1
"$_TARGET-strip" lib/libcurl.4.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/curl
ldid -S"$_BSROOT/ent.xml" lib/libcurl.4.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg curl.deb
