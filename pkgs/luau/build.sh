#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

bins='luau luau-analyze luau-ast luau-bytecode luau-compile luau-reduce'

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_CXX_COMPILER="$_TARGET-c++" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DLUAU_BUILD_TESTS=OFF
DESTDIR="$_DESTDIR" ninja -j"$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
mv $bins "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign $bins
)

mv "$_SRCDIR/extern/isocline/LICENSE" "$_SRCDIR/isocline-LICENSE.txt"

installlicense "$_SRCDIR/LICENSE.txt" "$_SRCDIR/isocline-LICENSE.txt"

builddeb
