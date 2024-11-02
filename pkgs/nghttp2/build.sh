#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DENABLE_FAILMALLOC=OFF
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
mv lib/libnghttp2.14.*.dylib lib/libnghttp2.14.dylib
"$_INSTALLNAMETOOL" -id /var/usr/lib/libnghttp2.14.dylib lib/libnghttp2.14.dylib
"$_TARGET-strip" lib/libnghttp2.14.dylib 2>/dev/null
ldid -S"$_ENT" lib/libnghttp2.14.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nghttp2.deb
