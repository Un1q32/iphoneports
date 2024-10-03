#!/bin/sh

cp files/configure.h src/cctools/ld64/src
cp "$_SDK/var/usr/include/llvm-c/lto.h" "$_SDK/var/usr/include/llvm-c/ExternC.h" src/cctools/include/llvm-c

(
cd src/cctools || exit 1
rm include/foreign/machine/_structs.h
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr LLVM_INCLUDE_DIR="$_SDK/var/usr/include" LLVM_LIB_DIR="$_SDK/var/usr/lib"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/* libexec/as/*/as 2>/dev/null
ldid -S"$_ENT" bin/* libexec/as/*/as
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg cctools.deb
