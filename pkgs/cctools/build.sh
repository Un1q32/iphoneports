#!/bin/sh -e

cp files/configure.h src/cctools/ld64/src
cp "$_SDK/var/usr/include/llvm-c/lto.h" "$_SDK/var/usr/include/llvm-c/ExternC.h" src/cctools/include/llvm-c

(
cd src/cctools || exit 1
rm include/foreign/machine/_structs.h
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr LLVM_INCLUDE_DIR="$_SDK/var/usr/include" LLVM_LIB_DIR="$_SDK/var/usr/lib"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share bin/otool
"$_TARGET-strip" bin/* libexec/as/*/as 2>/dev/null || true
ldid -S"$_ENT" bin/* libexec/as/*/as
ln -s llvm-otool bin/otool
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "cctools-$_DPKGARCH.deb"
