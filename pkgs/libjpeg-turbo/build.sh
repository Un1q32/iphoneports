#!/bin/sh -e
mkdir -p src/build
(
cd src/build
cpu="${_TARGET%%-*}"
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_TARGET-install_name_tool" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DENABLE_STATIC=OFF
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
mv lib/libjpeg.62.*.dylib lib/libjpeg.62.dylib
mv lib/libturbojpeg.0.*.dylib lib/libturbojpeg.0.dylib
"$_TARGET-strip" lib/libjpeg.62.dylib lib/libturbojpeg.0.dylib bin/* 2>/dev/null || true
ldid -S"$_ENT" lib/libjpeg.62.dylib lib/libturbojpeg.0.dylib bin/*
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libjpeg-turbo-$_DPKGARCH.deb"
