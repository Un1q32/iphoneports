#!/bin/sh
set -e
. ../../lib.sh
mkdir -p src/src/build
(
cd src/src/build
tapiversion=1300.6.5
export PATH="$_PKGROOT/files:$PATH"
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_LTO=ON -DLLVM_ENABLE_PROJECTS='tapi;clang' -DLLVM_INCLUDE_TESTS=OFF -DTAPI_FULL_VERSION="$tapiversion" -DTAPI_REPOSITORY_STRING="$tapiversion" -DCROSS_TOOLCHAIN_FLAGS_NATIVE='-DLLVM_INCLUDE_TESTS=OFF' -DLLVM_ENABLE_LIBCXX=ON
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install-libtapi install-tapi-headers
)

(
cd pkg/var/usr/lib
"$_TARGET-install_name_tool" -id /var/usr/lib/libtapi.dylib libtapi.dylib
strip_and_sign libtapi.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
