#!/bin/sh
. ../../files/lib.sh

cp files/configure.h src/cctools/ld64/src
cp "$_SDK/var/usr/include/llvm-c/lto.h" "$_SDK/var/usr/include/llvm-c/ExternC.h" src/cctools/include/llvm-c

(
cd src/cctools
rm include/foreign/machine/_structs.h
./autogen.sh
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-silent-rules \
    LLVM_INCLUDE_DIR="$_SDK/var/usr/include" \
    LLVM_LIB_DIR="$_SDK/var/usr/lib" \
    CFLAGS='-O3 -flto' \
    CXXFLAGS='-O3 -flto=thin'
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/*
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/cctools/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
