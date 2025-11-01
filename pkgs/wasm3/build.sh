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
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_SYSTEM_PROCESSOR="$_CPU" \
    -DWITH_SYSTEM_LIBUV=ON \
    -DBUILD_NATIVE=OFF \
    -DLIBUV_LIBRARIES= \
    -DLIBUV_INCLUDE_DIR="$_SDK/var/usr/include"
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign wasm3
)

installlicense "$_SRCDIR/LICENSE"

builddeb
