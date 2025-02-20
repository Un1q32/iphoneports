#!/bin/sh -e

cp files/configure.h src/cctools/ld64/src
cp "$_SDK/var/usr/include/llvm-c/lto.h" "$_SDK/var/usr/include/llvm-c/ExternC.h" src/cctools/include/llvm-c

(
cd src/cctools
rm include/foreign/machine/_structs.h
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr LLVM_INCLUDE_DIR="$_SDK/var/usr/include" LLVM_LIB_DIR="$_SDK/var/usr/lib"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share libexec
"$_TARGET-strip" bin/* 2>/dev/null || true
ldid -S"$_ENT" bin/*
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "cctools-$_CPU-$_SUBSYSTEM.deb"
