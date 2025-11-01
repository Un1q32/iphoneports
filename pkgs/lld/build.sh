#!/bin/sh
. ../../files/lib.sh

(
mkdir -p src/build
cd src/build
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
    -DLLVM_TABLEGEN_EXE="$(command -v llvm-tblgen)" \
    -DLLVM_ENABLE_LTO=Thin
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf include lib
strip_and_sign bin/lld
for link in ld.lld ld64.lld lld-link wasm-ld; do
    ln -sf lld "bin/$link"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/lld/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
