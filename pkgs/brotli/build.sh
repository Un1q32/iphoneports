#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DBROTLI_DISABLE_TESTS=ON
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

for bin in "$_DESTDIR/var/usr/bin/brotli" "$_DESTDIR/var/usr/lib"/*.dylib; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done

installlicense "$_SRCDIR/LICENSE"

builddeb
