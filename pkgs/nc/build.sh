#!/bin/sh -e
mkdir -p src/build
(
cd src/build
cpu="${_TARGET%%-*}"
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBUILD_SHARED_LIBS=yes -DLIBRESSL_TESTS=OFF -DENABLE_NC=ON
DESTDIR="$_PKGROOT/pkg" ninja apps/nc/install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/nc 2>/dev/null || true
ldid -S"$_ENT" bin/nc
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "nc-$_DPKGARCH.deb"
