#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" != "macos" ]; then
    printf "iwasm doesn't work properly on non-macOS\n"
    mkdir "$_DESTDIR"
    exit 0
fi

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

mkdir -p "$_SRCDIR/product-mini/platforms/darwin/build"
cd "$_SRCDIR/product-mini/platforms/darwin/build"
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DWAMR_BUILD_PLATFORM=darwin \
    -DWAMR_BUILD_TARGET="$target"
DESTDIR="$_DESTDIR" ninja install
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign lib/libiwasm.*.*.dylib bin/iwasm-*
)

installlicense "$_SRCDIR/LICENSE"

builddeb
