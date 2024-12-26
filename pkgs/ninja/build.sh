#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER="$_TARGET-c++" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DCMAKE_CXX_COMPILER_AR="$(command -v "$_TARGET-ar")" -DCMAKE_CXX_COMPILER_RANLIB="$(command -v "$_TARGET-ranlib")" -DBUILD_TESTING=OFF
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ninja 2>/dev/null
ldid -S"$_ENT" ninja
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ninja.deb
