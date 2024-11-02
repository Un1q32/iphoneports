#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBUILD_SHARED_LIBS=yes -DENABLE_NC=yes -DLIBRESSL_TESTS=OFF
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share etc/ssl/cert.pem
ln -s nc bin/netcat
cryptoabi=55
sslabi=58
tlsabi=31
mv lib/libcrypto.$cryptoabi.*.dylib lib/libcrypto.$cryptoabi.dylib
mv lib/libssl.$sslabi.*.dylib lib/libssl.$sslabi.dylib
mv lib/libtls.$tlsabi.*.dylib lib/libtls.$tlsabi.dylib
"$_TARGET-strip" bin/openssl bin/ocspcheck bin/nc lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib lib/libtls.$tlsabi.dylib 2>/dev/null
ldid -S"$_ENT" bin/openssl bin/ocspcheck bin/nc lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib lib/libtls.$tlsabi.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libressl.deb
