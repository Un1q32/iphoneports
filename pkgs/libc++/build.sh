#!/bin/sh
mkdir -p src/build
cp files/compat.c src/libcxx/src/filesystem
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
"$_TARGET-cc" ../compiler-rt/lib/builtins/emutls.c -O3 -c
cmake -GNinja ../runtimes -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi' -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLIBCXX_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=OFF -DLIBCXX_ENABLE_STATIC=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON -DCMAKE_OSX_ARCHITECTURES="$cpu" -DCMAKE_CXX_STANDARD_LIBRARIES="$(realpath .)/emutls.o"
DESTDIR="$_PKGROOT/pkg" ninja install-cxx -j8
)

(
cd pkg/var/usr/lib || exit 1
rm -rf libc++experimental.a ../include/c++/v1/experimental
"$_TARGET-strip" libc++.1.0.dylib 2>/dev/null
ldid -S"$_ENT" libc++.1.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libc++.deb
