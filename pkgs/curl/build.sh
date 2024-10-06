#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-nghttp3 --with-ngtcp2 --with-libidn2 --with-ca-bundle=/var/usr/etc/ssl/cert.pem
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/curl lib/libcurl.4.dylib 2>/dev/null
ldid -S"$_ENT" bin/curl lib/libcurl.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg curl.deb
