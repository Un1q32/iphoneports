#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --disable-static --disable-examples --with-openssl --with-zlib --with-xml2 --without-systemd --without-jansson --without-libevent-openssl --without-libcares --without-libev
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share usr/bin
"$_TARGET-strip" -x usr/lib/libnghttp2.14.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libnghttp2.14.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nghttp2-1.52.0.deb
