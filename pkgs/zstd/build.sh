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
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DZSTD_ZLIB_SUPPORT=ON \
    -DZSTD_LZMA_SUPPORT=ON \
    -DZSTD_LZ4_SUPPORT=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DZSTD_PROGRAMS_LINK_SHARED=ON \
    -DZSTD_BUILD_STATIC=OFF
DESTDIR="$_DESTDIR" ninja install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/zstd lib/libzstd.1.*.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
