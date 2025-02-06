#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-nghttp3 --with-ngtcp2 --with-libidn2 --with-ca-bundle=/var/usr/etc/ssl/cert.pem LIBS=-lngtcp2_crypto_quictls PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
"$_TARGET-strip" bin/curl lib/libcurl.4.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/curl lib/libcurl.4.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "curl-$_DPKGARCH.deb"
