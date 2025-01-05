#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --enable-silent-rules --prefix=/var/usr --with-openssl --with-zlib --with-bzip2 --with-brotli --with-zstd --with-lua --with-sqlite --with-webdav-props --with-xxhash PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so 2>/dev/null
ldid -S"$_ENT" sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lighttpd.deb
