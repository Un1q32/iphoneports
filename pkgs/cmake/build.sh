#!/bin/sh -e
mkdir -p src/build
(
cd src/build || exit 1
[ -d "$_SDK/System/Library/Frameworks/CoreServices.framework" ] && hascoreservices=ON
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DCMAKE_USE_SYSTEM_LIBUV=ON -DCMAKE_USE_SYSTEM_LIBARCHIVE=ON -DHAVE_CoreServices="${hascoreservices:-OFF}"
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf doc share/cmake-*/Help
"$_TARGET-strip" bin/* 2>/dev/null || true
ldid -S"$_ENT" bin/*
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "cmake-$_DPKGARCH.deb"
