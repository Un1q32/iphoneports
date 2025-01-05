#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DWITH_SYSTEM_LIBUV=ON -DBUILD_NATIVE=OFF -DLIBUV_LIBRARIES= -DLIBUV_INCLUDE_DIR="$_SDK/var/usr/include"
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" wasm3 2>/dev/null
ldid -S"$_ENT" wasm3
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wasm3.deb
