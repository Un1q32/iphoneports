#!/bin/sh
. ../../files/lib.sh

(
mkdir -p src/build
cd src/build
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DDISABLE_TESTS=ON \
    -DENABLE_NUGET=OFF
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

for lib in pkg/var/usr/lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done

installlicense "$_SRCDIR/COPYING"

builddeb
