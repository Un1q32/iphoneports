#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER="$_TARGET-c++" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_CXX_COMPILER_AR="$(command -v "$_TARGET-ar")" \
    -DCMAKE_CXX_COMPILER_RANLIB="$(command -v "$_TARGET-ranlib")" \
    -DBUILD_TESTING=OFF
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

strip_and_sign "$_DESTDIR/var/usr/bin/ninja"

installlicense "$_SRCDIR/COPYING"

builddeb
