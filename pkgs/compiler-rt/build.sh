#!/bin/sh
. ../../files/lib.sh

(
read -r llvmver < "$_SRCDIR/iphoneports-llvmversion.txt"
mkdir -p "$_SRCDIR/compiler-rt/build" "$_DESTDIR/var/usr/lib/clang/$llvmver/lib/darwin"
cd "$_SRCDIR/compiler-rt/build"

x64srcs="emutls.c eprintf.c int_util.c extendhfsf2.c truncsfhf2.c truncdfhf2.c truncxfhf2.c"
x32srcs="$x64srcs atomic.c"

arm64srcs="emutls.c"
armv7ssrcs="$arm64srcs atomic.c extendhfsf2.c truncsfhf2.c truncdfhf2.c"
armv7srcs="$armv7ssrcs"
armv6srcs="$armv7srcs floatundisf.c floatundidf.c"

cc() {
    printf " \033[1;32mCC\033[0m %s\n" "$2"
    command -v ccache >/dev/null && ccache=ccache
    $ccache clang "$@"
}

for src in $armv6srcs; do
    cc -o "armv6-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target armv6-apple-ios1 "../lib/builtins/$src" -c -O3 &
done
for src in $armv7srcs; do
    cc -o "armv7-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target armv7-apple-ios3 "../lib/builtins/$src" -c -O3 &
done
for src in $armv7ssrcs; do
    cc -o "armv7s-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target armv7s-apple-ios6 "../lib/builtins/$src" -c -O3 &
done
for src in $arm64srcs; do
    cc -o "arm64-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target arm64-apple-ios7 "../lib/builtins/$src" -c -O3 &
done
cc -o nothing.o -target arm64e-apple-ios14 -xc /dev/null -c &
wait

"$_TARGET-libtool" -static -o libclang_rt.ios.a ./*.o 2>/dev/null
rm ./*.o

for src in $x32srcs; do
    cc -o "i386-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target i386-apple-macos10.4 "../lib/builtins/$src" -c -O3 &
done
for src in $x64srcs; do
    cc -o "x86_64-${src%\.c}.o" -isysroot "$_PKGROOT/sysroot" -target x86_64-apple-macos10.4 "../lib/builtins/$src" -c -O3 &
done
cc -o nothing.o -target arm64-apple-macos11.0 -arch arm64 -arch arm64e -xc /dev/null -c &
wait

"$_TARGET-libtool" -static -o libclang_rt.osx.a ./*.o 2>/dev/null
rm ./*.o

cp ./*.a "$_DESTDIR/var/usr/lib/clang/$llvmver/lib/darwin"
)

installlicense "$_SRCDIR/compiler-rt/LICENSE.TXT"

builddeb
