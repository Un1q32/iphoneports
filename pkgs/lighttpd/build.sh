#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl --with-zlib --with-brotli --with-zstd --with-lua --with-sqlite --with-pam --with-webdav-props PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so > /dev/null 2>&1
ldid -S"$_ENT" sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lighttpd.deb
