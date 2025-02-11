#!/bin/sh -e
mkdir -p src/build
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBUILD_SHARED_LIBS=yes -DLIBRESSL_TESTS=OFF
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share etc/ssl/cert.pem include/tls.h bin/ocspcheck lib/pkgconfig/libtls.pc lib/libtls.* lib/cmake/LibreSSL/LibreSSL-TLS*
cryptoabi=55
sslabi=58
mv lib/libcrypto.$cryptoabi.*.dylib lib/libcrypto.$cryptoabi.dylib
mv lib/libssl.$sslabi.*.dylib lib/libssl.$sslabi.dylib
"$_TARGET-strip" bin/openssl lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/openssl lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libressl-$_DPKGARCH.deb"
