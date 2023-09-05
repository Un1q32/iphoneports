#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-examples --with-openssl --with-zlib --with-libxml2 --without-libcares PKG_CONFIG_SYSROOT_DIR="$_SDK" PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin
"$_TARGET-strip" lib/libnghttp2.14.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libnghttp2.14.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nghttp2.deb
