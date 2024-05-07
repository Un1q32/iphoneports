#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBROTLI_DISABLE_TESTS=1
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
llvm-strip bin/brotli lib/libbrotlicommon.1.1.0.dylib lib/libbrotlidec.1.1.0.dylib lib/libbrotlienc.1.1.0.dylib
ldid -S"$_ENT" bin/brotli lib/libbrotlicommon.1.1.0.dylib lib/libbrotlidec.1.1.0.dylib lib/libbrotlienc.1.1.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg brotli.deb
