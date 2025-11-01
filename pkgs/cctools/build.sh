#!/bin/sh
. ../../files/lib.sh

cp files/configure.h "$_SRCDIR/cctools/ld64/src"
cp "$_SDK/var/usr/include/llvm-c/lto.h" "$_SDK/var/usr/include/llvm-c/ExternC.h" "$_SRCDIR/cctools/include/llvm-c"

(
cd "$_SRCDIR/cctools"
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
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/*
)

installlicense "$_SRCDIR/cctools/COPYING"

builddeb
