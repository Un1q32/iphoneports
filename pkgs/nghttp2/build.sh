#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-examples --with-openssl --with-zlib --with-libxml2 --without-systemd --without-jansson --without-libevent-openssl --without-libcares --without-libev --without-cunit --without-mruby --without-neverbleed --without-libbpf --without-libngtcp2 --without-libnghttp3
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin
"$_TARGET-strip" lib/libnghttp2.14.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libnghttp2.14.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nghttp2.deb
