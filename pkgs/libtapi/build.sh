#!/bin/sh -e
mkdir -p src/src/build
(
cd src/src/build || exit 1
tapiversion=1300.6.5
export PATH="$_PKGROOT/files:$PATH"
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_LTO=ON -DLLVM_ENABLE_PROJECTS='tapi;clang' -DLLVM_INCLUDE_TESTS=OFF -DTAPI_FULL_VERSION="$tapiversion" -DTAPI_REPOSITORY_STRING="$tapiversion" -DCROSS_TOOLCHAIN_FLAGS_NATIVE='-DLLVM_INCLUDE_TESTS=OFF' -DLLVM_ENABLE_LIBCXX=ON
DESTDIR="$_PKGROOT/pkg" ninja install-libtapi install-tapi-headers -j"$_JOBS"
)

(
cd pkg/var/usr/lib || exit 1
"$_INSTALLNAMETOOL" -id /var/usr/lib/libtapi.dylib libtapi.dylib
"$_TARGET-strip" libtapi.dylib 2>/dev/null || true
ldid -S"$_ENT" libtapi.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libtapi-$_DPKGARCH.deb"
