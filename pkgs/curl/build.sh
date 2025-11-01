#!/bin/sh -e
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    ipv6='--disable-ipv6'
fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-openssl \
    --with-ca-fallback \
    --disable-static \
    --with-nghttp2 \
    --with-nghttp3 \
    --with-ngtcp2 \
    --with-libidn2 \
    --with-ca-bundle=/var/usr/etc/ssl/cert.pem \
    $ipv6 \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/man
strip_and_sign bin/curl lib/libcurl.4.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
