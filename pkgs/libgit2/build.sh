#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
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
    -DREGEX_BACKEND=pcre2 \
    -DCMAKE_C_FLAGS='-Wno-incompatible-pointer-types'
DESTDIR="$_DESTDIR" ninja install
)

strip_and_sign "$_DESTDIR/var/usr/bin/git2" "$(realpath "$_DESTDIR/var/usr/lib/libgit2.dylib")"

installlicense "$_SRCDIR/COPYING"

builddeb
