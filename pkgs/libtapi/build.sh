#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/src/build"
cd "$_SRCDIR/src/build"
tapiversion=1300.6.5
export PATH="$_PKGROOT/files:$PATH"
cmake -GNinja ../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DLLVM_ENABLE_LTO=ON \
    -DLLVM_ENABLE_PROJECTS='tapi;clang' \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DTAPI_FULL_VERSION="$tapiversion" \
    -DTAPI_REPOSITORY_STRING="$tapiversion" \
    -DCROSS_TOOLCHAIN_FLAGS_NATIVE='-DLLVM_INCLUDE_TESTS=OFF' \
    -DLLVM_ENABLE_LIBCXX=ON
DESTDIR="$_DESTDIR" ninja install-libtapi install-tapi-headers
)

(
cd "$_DESTDIR/var/usr/lib"
install_name_tool -id /var/usr/lib/libtapi.dylib libtapi.dylib
strip_and_sign libtapi.dylib
)

installlicense "$_SRCDIR"/LICENSE.*

builddeb
