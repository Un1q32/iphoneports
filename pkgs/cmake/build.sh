#!/bin/sh
set -e
. ../../files/lib.sh
mkdir -p src/build
(
cd src/build
if [ "$_SUBSYSTEM" = "macos" ]; then
    hascoreservices=ON
    [ "$_TRUEOSVER" -lt 1050 ] && export LDFLAGS='-framework ApplicationServices'
fi
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_USE_SYSTEM_LIBUV=ON \
    -DCMAKE_USE_SYSTEM_LIBARCHIVE=ON \
    -DHAVE_CoreServices="${hascoreservices:-OFF}" \
    -DBUILD_TESTING=OFF
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
rm -rf doc share/cmake-*/Help
strip_and_sign bin/*
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.rst "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
