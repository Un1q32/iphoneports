#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-libidn2
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
llvm-strip bin/curl lib/libcurl.4.dylib
ldid -S"$_ENT" bin/curl lib/libcurl.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg curl.deb
