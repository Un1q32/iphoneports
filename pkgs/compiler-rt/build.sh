#!/bin/sh
mkdir -p src/build pkg/var/usr/lib/clang/19/lib/darwin
(
cd src/build || exit 1
clang="$(command -v "$_TARGET-sdkpath")"
clang="${clang%/*}/../share/iphoneports/bin/clang"

arm64srcs="emutls.c"
armv7ssrcs="$arm64srcs atomic.c extendhfsf2.c truncsfhf2.c"
armv7srcs="$armv7ssrcs"
armv6srcs="$armv7srcs floatundidf.c floatundisf.c"

for src in $armv6srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv6-apple-ios2 "../lib/builtins/$src" -c -O3 -o "armv6-${src%\.c}.o" &
done
for src in $armv7srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv7-apple-ios3 "../lib/builtins/$src" -c -O3 -o "armv7-${src%\.c}.o" &
done
for src in $armv7ssrcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/sysroot" -target armv7s-apple-ios6 "../lib/builtins/$src" -c -O3 -o "armv7s-${src%\.c}.o" &
done
for src in $arm64srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
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
