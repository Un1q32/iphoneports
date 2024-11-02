#!/bin/sh

mkdir -p src/build
(
cd src/build || exit 1
version=1300.6.5
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_THREADS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_ENABLE_LIBCXX=ON -DLLVM_DEFAULT_TARGET_TRIPLE="$_TARGET" -DLLVM_ENABLE_PROJECTS='tapi;clang' -DTAPI_REPOSITORY_STRING="$version" -DTAPI_FULL_VERSION="$version"
DESTDIR="$_PKGROOT/pkg" ninja clangBasic -j8
DESTDIR="$_PKGROOT/pkg" ninja libtapi -j8
DESTDIR="$_PKGROOT/pkg" ninja install-libtapi install-tapi-headers -j8
)

(
cd pkg/var/usr || exit 1
# rm -rf share
# for file in bin/* lib/*.dylib; do
#   if ! [ -h "$file" ]; then
#     "$_TARGET-strip" "$file" 2>/dev/null
#     ldid -S"$_ENT" "$file"
#   fi
# done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libtapi.deb
