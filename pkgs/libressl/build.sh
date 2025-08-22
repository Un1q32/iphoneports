#!/bin/sh
set -e
. ../../lib.sh
mkdir -p src/build
(
cd src/build
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_SYSTEM_PROCESSOR="$_CPU" \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DBUILD_SHARED_LIBS=yes \
    -DLIBRESSL_TESTS=OFF \
    -DOPENSSLDIR=/var/usr/etc/ssl
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
rm -rf share etc/ssl/cert.pem include/tls.h bin/ocspcheck lib/pkgconfig/libtls.pc lib/libtls.* lib/cmake/LibreSSL/LibreSSL-TLS*
cryptoabi=56
sslabi=59
mv lib/libcrypto.$cryptoabi.*.dylib lib/libcrypto.$cryptoabi.dylib
mv lib/libssl.$sslabi.*.dylib lib/libssl.$sslabi.dylib
strip_and_sign bin/openssl lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
