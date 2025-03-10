#!/bin/sh -e
mkdir -p src/build
(
cd src/build
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_SYSTEM_PROCESSOR="$_CPU" -DWITH_SYSTEM_LIBUV=ON -DBUILD_NATIVE=OFF -DLIBUV_LIBRARIES= -DLIBUV_INCLUDE_DIR="$_SDK/var/usr/include"
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" wasm3 2>/dev/null || true
ldid -S"$_ENT" wasm3
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
