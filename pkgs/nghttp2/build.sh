#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --disable-static --disable-examples --with-openssl --with-zlib --with-xml2 --without-systemd --without-jansson --without-libevent-openssl --without-libcares --without-libev --without-cunit --without-mruby --without-neverbleed --without-libbpf --without-libngtcp2 --without-libnghttp3
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share usr/bin
"$_TARGET-strip" usr/lib/libnghttp2.14.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libnghttp2.14.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nghttp2-1.52.0.deb
