#!/bin/sh
set -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-ca-fallback --disable-static --with-libssh2 --with-nghttp2 --with-nghttp3 --with-ngtcp2 --with-libidn2 --with-ca-bundle=/var/usr/etc/ssl/cert.pem LIBS=-lngtcp2_crypto_quictls PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/man
strip_and_sign bin/curl lib/libcurl.4.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
