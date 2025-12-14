#!/bin/sh
. ../../files/lib.sh

(
case $_CPU in
    (x86_64*) target=X86_64  ;;
    (i386)    target=X86_32  ;;
    (arm64*)  target=AARCH64 ;;
    (armv7*)  target=ARMV7   ;;
    (armv6*)  target=ARMV6   ;;
    (*)
        echo "Unsupported architecture"
        exit 1
    ;;
esac

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
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DWAMR_BUILD_PLATFORM=darwin \
    -DWAMR_BUILD_TARGET="$target"
DESTDIR="$_DESTDIR" ninja -j"$_JOBS" install
)

# (
# cd "$_DESTDIR/var/usr"
# rm -rf share
# mv lib/libnghttp2.14.*.dylib lib/libnghttp2.14.dylib
# strip_and_sign lib/libnghttp2.14.dylib
# )

installlicense "$_SRCDIR/LICENSE"

builddeb
