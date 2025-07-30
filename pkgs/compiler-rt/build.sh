#!/bin/sh
set -e
. ../../lib.sh
read -r llvmver < src/iphoneports-llvmversion.txt
mkdir -p src/compiler-rt/build "pkg/var/usr/lib/clang/$llvmver/lib/darwin"
(
cd src/compiler-rt/build

x64srcs="emutls.c eprintf.c int_util.c"
x32srcs="$x64srcs atomic.c"

arm64srcs="emutls.c"
armv7ssrcs="$arm64srcs atomic.c extendhfsf2.c truncsfhf2.c"
armv7srcs="$armv7ssrcs"
armv6srcs="$armv7srcs floatundidf.c floatundisf.c"

for src in $armv6srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/iossysroot" -target armv6-apple-ios1 "../lib/builtins/$src" -c -O3 -o "armv6-${src%\.c}.o" &
done
for src in $armv7srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/iossysroot" -target armv7-apple-ios3 "../lib/builtins/$src" -c -O3 -o "armv7-${src%\.c}.o" &
done
for src in $armv7ssrcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/iossysroot" -target armv7s-apple-ios6 "../lib/builtins/$src" -c -O3 -o "armv7s-${src%\.c}.o" &
done
for src in $arm64srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/iossysroot" -target arm64-apple-ios7 "../lib/builtins/$src" -c -O3 -o "arm64-${src%\.c}.o" &
done
clang -target arm64e-apple-ios12 -xc /dev/null -c -o nothing.o &
wait

"$_TARGET-libtool" -static -o libclang_rt.ios.a ./*.o 2>/dev/null
rm ./*.o

for src in $x32srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/macsysroot" -target i386-apple-macos10.4 "../lib/builtins/$src" -c -O3 -o "i386-${src%\.c}.o" &
done
for src in $x64srcs; do
    while [ "$(pgrep clang | wc -l)" -ge "$_JOBS" ]; do
        sleep 0.1
    done
    clang -isysroot "$_PKGROOT/macsysroot" -target x86_64-apple-macos10.4 "../lib/builtins/$src" -c -O3 -o "x86_64-${src%\.c}.o" &
done
clang -target arm64-apple-macos11.0 -arch arm64 -arch arm64e -xc /dev/null -c -o nothing.o &
wait

"$_TARGET-libtool" -static -o libclang_rt.osx.a ./*.o 2>/dev/null
rm ./*.o

cp ./*.a "$_PKGROOT/pkg/var/usr/lib/clang/$llvmver/lib/darwin"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/compiler-rt/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
