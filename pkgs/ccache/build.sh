#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr"
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ccache 2>/dev/null
ldid -S"$_ENT" ccache
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ccache.deb
