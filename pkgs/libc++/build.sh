#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
cmake -GNinja ../runtimes \
    -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi' \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DLLVM_ENABLE_LTO=ON \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXXABI_USE_LLVM_UNWINDER=OFF \
    -DLIBCXX_ENABLE_STATIC=OFF \
    -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
    -DCMAKE_OSX_ARCHITECTURES="$_CPU"
DESTDIR="$_DESTDIR" ninja install-cxx install-cxxabi-headers
)

(
cd "$_DESTDIR/var/usr/lib"
rm -rf libc++experimental.a ../include/c++/v1/experimental
strip_and_sign libc++.1.0.dylib
)

installlicense "$_SRCDIR/libcxx/LICENSE.TXT"

builddeb
