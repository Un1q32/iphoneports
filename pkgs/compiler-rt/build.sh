#!/bin/sh -e
mkdir -p src/build pkg/var/usr/lib/clang/19/lib/darwin
(
cd src/build || exit 1
clang="$(command -v "$_TARGET-sdkpath")"
clang="${clang%/*}/../share/iphoneports/bin/clang"

x64srcs="emutls.c"
x32srcs="$x64srcs atomic.c"
arm64srcs="emutls.c"
armv7ssrcs="$arm64srcs atomic.c extendhfsf2.c truncsfhf2.c"
armv7srcs="$armv7ssrcs"
armv6srcs="$armv7srcs"

for src in $armv6srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/iossysroot" -target armv6-apple-ios2 "../lib/builtins/$src" -c -O3 -o "armv6-${src%\.c}.o" &
done
for src in $armv7srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/iossysroot" -target armv7-apple-ios3 "../lib/builtins/$src" -c -O3 -o "armv7-${src%\.c}.o" &
done
for src in $armv7ssrcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/iossysroot" -target armv7s-apple-ios6 "../lib/builtins/$src" -c -O3 -o "armv7s-${src%\.c}.o" &
done
for src in $arm64srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/iossysroot" -target arm64-apple-ios7 "../lib/builtins/$src" -c -O3 -o "arm64-${src%\.c}.o" &
done
"$clang" -isysroot "$_PKGROOT/iossysroot" -target arm64e-apple-ios12 -xc /dev/null -c -O3 -o nothing.o &
wait

"$_TARGET-libtool" -static -o libclang_rt.ios.a ./*.o 2>/dev/null
rm ./*.o

for src in $x32srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/macsysroot" -target i386-apple-macos10.4 "../lib/builtins/$src" -c -O3 -o "i386-${src%\.c}.o" &
done
for src in $x64srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    "$clang" -isysroot "$_PKGROOT/macsysroot" -target x86_64-apple-macos10.4 "../lib/builtins/$src" -c -O3 -o "x86_64-${src%\.c}.o" &
done
"$clang" -isysroot "$_PKGROOT/macsysroot" -target unknown-apple-macos11.0 -arch arm64 -arch arm64e -xc /dev/null -c -O3 -o nothing.o &
wait

"$_TARGET-libtool" -static -o libclang_rt.osx.a ./*.o 2>/dev/null
rm ./*.o

cp ./*.a "$_PKGROOT/pkg/var/usr/lib/clang/19/lib/darwin"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg compiler-rt.deb
