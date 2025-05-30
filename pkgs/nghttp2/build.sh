#!/bin/sh
set -e
. ../../lib.sh
mkdir -p src/build
(
cd src/build
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_TARGET-install_name_tool" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DENABLE_FAILMALLOC=OFF
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
rm -rf share
mv lib/libnghttp2.14.*.dylib lib/libnghttp2.14.dylib
"$_TARGET-install_name_tool" -id /var/usr/lib/libnghttp2.14.dylib lib/libnghttp2.14.dylib
strip_and_sign lib/libnghttp2.14.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
