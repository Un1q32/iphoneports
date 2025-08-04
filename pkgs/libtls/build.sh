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
    -DCMAKE_INSTALL_NAME_TOOL="$_TARGET-install_name_tool" \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_SYSTEM_PROCESSOR="$_CPU" \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DBUILD_SHARED_LIBS=yes \
    -DLIBRESSL_TESTS=OFF \
    -DLIBRESSL_APPS=OFF \
    -DOPENSSLDIR=/var/usr/etc/ssl
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" tls/install include/install
mkdir -p "$_PKGROOT/pkg/var/usr/lib/pkgconfig"
cp pkgconfig/libtls.pc "$_PKGROOT/pkg/var/usr/lib/pkgconfig"
)

(
cd pkg/var/usr
rm -rf include/openssl
tlsabi=32
mv lib/libtls.$tlsabi.*.dylib lib/libtls.$tlsabi.dylib
strip_and_sign lib/libtls.$tlsabi.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
