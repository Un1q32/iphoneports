#!/bin/sh -e
mkdir -p src/build
(
cd src/build
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_TARGET-install_name_tool" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_SYSTEM_PROCESSOR="$_CPU" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBUILD_SHARED_LIBS=yes -DLIBRESSL_TESTS=OFF -DLIBRESSL_APPS=OFF
DESTDIR="$_PKGROOT/pkg" ninja tls/install include/install -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/lib/pkgconfig"
cp pkgconfig/libtls.pc "$_PKGROOT/pkg/var/usr/lib/pkgconfig"
)

(
cd pkg/var/usr
rm -rf include/openssl
tlsabi=31
mv lib/libtls.$tlsabi.*.dylib lib/libtls.$tlsabi.dylib
"$_TARGET-strip" lib/libtls.$tlsabi.dylib 2>/dev/null || true
ldid -S"$_ENT" lib/libtls.$tlsabi.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg libtls.deb
