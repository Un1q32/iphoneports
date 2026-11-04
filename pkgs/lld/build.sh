#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/build" "$_SRCDIR/build-native"

cd "$_SRCDIR/build-native"
cmake -GNinja ../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=hostcc \
    -DCMAKE_CXX_COMPILER=hostc++ \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_ENABLE_ZLIB=OFF \
    -DLLVM_ENABLE_ZSTD=OFF \
    -DLLVM_ENABLE_LIBXML2=OFF
ninja llvm-tblgen

cd ../build
cmake -GNinja ../lld \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_RANLIB="$(command -v "$_TARGET-ranlib")" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN_EXE="$PWD/../build-native/bin/llvm-tblgen" \
    -DLLVM_ENABLE_LTO=ON
DESTDIR="$_DESTDIR" ninja install
)

(
cd "$_DESTDIR/var/usr"
rm -rf include lib
strip_and_sign bin/lld
for link in ld.lld ld64.lld lld-link wasm-ld; do
    ln -sf lld "bin/$link"
done
)

installlicense "$_SRCDIR/lld/LICENSE.TXT"

builddeb
