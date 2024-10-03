#!/bin/sh

"$_TARGET-cc" -O2 -c -o src/compat.o files/compat.c

mkdir -p src/build
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_EXE_LINKER_FLAGS="$_PKGROOT/src/compat.o"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j1
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" wasm3 2>/dev/null
ldid -S"$_ENT" wasm3
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wasm3.deb
