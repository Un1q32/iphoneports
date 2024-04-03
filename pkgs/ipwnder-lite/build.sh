#!/bin/sh
(
cd src || exit 1
"$_MAKE" MGCC="$_TARGET-cc" CFLAGS='-DIPHONEOS_ARM -Wno-implicit-function-declaration -Wno-format -Wno-unused-but-set-variable'
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ipwnder_macosx "$_PKGROOT/pkg/var/usr/bin/ipwnder"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip ipwnder
ldid -S"$_ENT" ipwnder
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ipwnder-lite.deb
