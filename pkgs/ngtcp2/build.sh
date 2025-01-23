#!/bin/sh -e
mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DENABLE_STATIC_LIB=OFF -DENABLE_OPENSSL=ON
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
mv lib/libngtcp2.16.*.dylib lib/libngtcp2.16.dylib
mv lib/libngtcp2_crypto_quictls.2.*.dylib lib/libngtcp2_crypto_quictls.2.dylib
"$_TARGET-strip" lib/libngtcp2.16.dylib lib/libngtcp2_crypto_quictls.2.dylib 2>/dev/null || true
ldid -S"$_ENT" lib/libngtcp2.16.dylib lib/libngtcp2_crypto_quictls.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ngtcp2.deb
