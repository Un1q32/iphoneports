#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share etc/ssl/cert.pem
"$_TARGET-strip" bin/openssl bin/ocspcheck lib/libcrypto.52.dylib lib/libssl.55.dylib lib/libtls.28.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/openssl bin/ocspcheck lib/libcrypto.52.dylib lib/libssl.55.dylib lib/libtls.28.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libressl.deb
