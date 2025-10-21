#!/bin/sh
. ../../files/lib.sh
mkdir -p src/build
(
cd src/build
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SYSTEM_PROCESSOR="$_CPU" \
    -DCMAKE_SKIP_RPATH=ON \
    -DENABLE_STATIC=OFF
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
rm -rf share
mv lib/libjpeg.62.*.dylib lib/libjpeg.62.dylib
mv lib/libturbojpeg.0.*.dylib lib/libturbojpeg.0.dylib
strip_and_sign lib/libjpeg.62.dylib lib/libturbojpeg.0.dylib bin/*
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
