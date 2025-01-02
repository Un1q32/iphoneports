#!/bin/sh
mkdir -p src/build pkg/var/usr/lib/clang/19/lib/darwin
(
cd src/build || exit 1
clang="$(command -v "$_TARGET-sdkpath")"
clang="${clang%/*}/../share/iphoneports/bin/clang"

ios7srcs="emutls.c extendhfsf2.c truncsfhf2.c"
ios6srcs="$ios7srcs atomic.c"
ios3srcs="$ios6srcs"
ios2srcs="$ios3srcs"

for src in $ios2srcs; do
    while [ "$(pgrep clang | wc -l)" -ge 8 ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv6-apple-ios2 "../lib/builtins/$src" -c -O3 -o "armv6-${src%\.c}.o" &
done
for src in $ios3srcs; do
    while [ "$(pgrep clang | wc -l)" -ge 8 ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv7-apple-ios3 "../lib/builtins/$src" -c -O3 -o "armv7-${src%\.c}.o" &
done
for src in $ios6srcs; do
    while [ "$(pgrep clang | wc -l)" -ge 8 ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv7s-apple-ios6 "../lib/builtins/$src" -c -O3 -o "armv7s-${src%\.c}.o" &
done
for src in $ios7srcs; do
    while [ "$(pgrep clang | wc -l)" -ge 8 ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target arm64-apple-ios7 "../lib/builtins/$src" -c -O3 -o "arm64-${src%\.c}.o" &
done
wait

"$_TARGET-libtool" -static -o libclang_rt.ios.a ./*.o
cp libclang_rt.ios.a "$_PKGROOT/pkg/var/usr/lib/clang/19/lib/darwin"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg compiler-rt.deb
