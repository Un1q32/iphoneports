#!/bin/sh -e
mkdir -p src/build
(
cd src/build
cmake -GNinja ../runtimes -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi' -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_TARGET-install_name_tool" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_LTO=ON -DLIBCXX_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=OFF -DLIBCXX_ENABLE_STATIC=OFF -DLIBCXXABI_ENABLE_STATIC=OFF -DCMAKE_OSX_ARCHITECTURES="$_CPU"
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install-cxx install-cxxabi
)

(
cd pkg/var/usr/lib
rm -rf libc++experimental.a ../include/c++/v1/experimental
strip_sign libc++.1.0.dylib libc++abi.1.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/libcxx/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
