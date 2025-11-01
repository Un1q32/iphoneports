#!/bin/sh
. ../../files/lib.sh

(
mkdir -p src/build
cd src/build
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DBROTLI_DISABLE_TESTS=ON
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

for bin in pkg/var/usr/bin/brotli pkg/var/usr/lib/*.dylib; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
