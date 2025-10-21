#!/bin/sh
set -e
. ../../files/lib.sh

(
mkdir -p src/build
cd src/build
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr;$_SDK/usr" \
    -DBUILD_TESTS=OFF \
    -DREGEX_BACKEND=pcre2
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

strip_and_sign pkg/var/usr/bin/git2 "pkg/var/usr/lib/$(readlink pkg/var/usr/lib/libgit2.dylib)"

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
