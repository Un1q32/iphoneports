#!/bin/sh
mkdir -p src/build
cp files/compat.c src/libcxx/src/filesystem
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake -GNinja ../runtimes -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLIBCXX_INCLUDE_BENCHMARKS=no -DLIBCXXABI_USE_LLVM_UNWINDER=no -DLIBCXX_ENABLE_STATIC=no -DLIBCXXABI_ENABLE_STATIC=no -DLLVM_ENABLE_LTO=FULL -DCMAKE_OSX_ARCHITECTURES="$cpu"
DESTDIR="$_PKGROOT/pkg" ninja install-cxx install-cxxabi -j8
)

(
cd pkg/var/usr/lib || exit 1
rm -rf libc++experimental.a ../include/c++/v1/experimental
"$_TARGET-strip" libc++.1.0.dylib libc++abi.1.0.dylib 2>/dev/null 2>/dev/null
ldid -S"$_ENT" libc++.1.0.dylib libc++abi.1.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libc++.deb
