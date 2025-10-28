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
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
for bin in bin/brotli lib/libbrotlicommon.dylib lib/libbrotlidec.dylib lib/libbrotlienc.dylib; do
    strip_and_sign "$(realpath $bin)"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
