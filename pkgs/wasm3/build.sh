#!/bin/sh
. ../../files/lib.sh

(
export PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$_SDK"
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_SYSTEM_PROCESSOR="$_CPU" \
    -DBUILD_NATIVE=OFF \
    -DCMAKE_MODULE_PATH="$_PKGROOT/files"
DESTDIR="$_DESTDIR" ninja install
)

strip_and_sign "$_DESTDIR/var/usr/bin/wasm3"

installlicense "$_SRCDIR/LICENSE"

builddeb
