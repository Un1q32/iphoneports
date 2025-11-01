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
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DBUILD_SHARED_LIBS=ON \
    -DFMT_DOC=OFF \
    -DFMT_TEST=OFF
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

for lib in "$_DESTDIR/var/usr/lib"/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done

installlicense "$_SRCDIR/LICENSE"

builddeb
