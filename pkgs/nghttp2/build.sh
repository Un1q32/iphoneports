#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DENABLE_FAILMALLOC=OFF
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-install_name_tool" -id /var/usr/lib/libnghttp2.14.dylib lib/libnghttp2.14.24.4.dylib
"$_TARGET-strip" lib/libnghttp2.14.24.4.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libnghttp2.14.24.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nghttp2.deb
