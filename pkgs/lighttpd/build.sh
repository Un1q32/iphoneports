#!/bin/sh
set -e
. ../../lib.sh
(
cd src
./autogen.sh
./configure --host="$_TARGET" --enable-silent-rules --prefix=/var/usr --with-openssl --with-zlib --with-bzip2 --with-brotli --with-zstd --with-lua --with-sqlite --with-webdav-props --with-xxhash PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
