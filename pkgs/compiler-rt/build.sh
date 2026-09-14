#!/bin/sh
. ../../files/lib.sh

(
read -r llvmver < "$_SRCDIR/iphoneports-llvmversion.txt"
mkdir -p "$_SRCDIR/compiler-rt/build" "$_DESTDIR/var/usr/lib/clang/$llvmver/lib/darwin"
cd "$_SRCDIR/compiler-rt/build"

macarm64srcs="emutls.c"
x64srcs="$macarm64srcs eprintf.c int_util.c extendhfsf2.c truncsfhf2.c truncdfhf2.c truncxfhf2.c"
x32srcs="$x64srcs atomic.c"

arm64esrcs="emutls.c"
arm64srcs="$arm64esrcs"
armv7ssrcs="$arm64srcs atomic.c extendhfsf2.c truncsfhf2.c truncdfhf2.c"
armv7srcs="$armv7ssrcs"
armv6srcs="$armv7srcs floatundisf.c floatundidf.c"

cc() {
    printf " \033[1;32mCC\033[0m %s\n" "$2"
    command -v ccache >/dev/null && ccache=ccache
    $ccache clang -isysroot "$_PKGROOT/../../toolchain/buildsrc/sysroot" -O3 "$@"
}

for src in $armv6srcs; do
    cc -o "armv6-${src%\.c}.o" -target armv6-apple-ios1 "../lib/builtins/$src" -c &
done
for src in $armv7srcs; do
    cc -o "armv7-${src%\.c}.o" -target armv7-apple-ios3 "../lib/builtins/$src" -c &
done
for src in $armv7ssrcs; do
    cc -o "armv7s-${src%\.c}.o" -target armv7s-apple-ios6 "../lib/builtins/$src" -c &
done
for src in $arm64srcs; do
    cc -o "arm64-${src%\.c}.o" -target arm64-apple-ios7 "../lib/builtins/$src" -c &
done
for src in $arm64esrcs; do
    cc -o "arm64e-${src%\.c}.o" -target arm64e-apple-ios14 "../lib/builtins/$src" -c &
done
wait

"$_TARGET-libtool" -static -o libclang_rt.ios.a ./*.o 2>/dev/null
rm ./*.o

for src in $x32srcs; do
    cc -o "i386-${src%\.c}.o" -target i386-apple-macos10.4 "../lib/builtins/$src" -c &
done
for src in $x64srcs; do
    cc -o "x86_64-${src%\.c}.o" -target x86_64-apple-macos10.4 "../lib/builtins/$src" -c &
done
for src in $macarm64srcs; do
    cc -o "arm64-${src%\.c}.o" -target arm64-apple-macos11.0 -arch arm64 -arch arm64e "../lib/builtins/$src" -c &
done
wait

"$_TARGET-libtool" -static -o libclang_rt.osx.a ./*.o 2>/dev/null
rm ./*.o

for src in $arm64srcs; do
    cc -o "arm64-${src%\.c}.o" -target arm64-apple-tvos9 "../lib/builtins/$src" -c &
done
for src in $arm64esrcs; do
    cc -o "arm64e-${src%\.c}.o" -target arm64e-apple-tvos14 "../lib/builtins/$src" -c &
done
wait

"$_TARGET-libtool" -static -o libclang_rt.tvos.a ./*.o 2>/dev/null
rm ./*.o

ios-cc() {
    cc "$@" \
        -target unknown-apple-ios \
        -arch armv6 -Xarch_armv6 -mios-version-min=1.0 \
        -arch armv7 -Xarch_armv7 -mios-version-min=3.0 \
        -arch armv7s -Xarch_armv7s -mios-version-min=6.0 \
        -arch arm64 -Xarch_arm64 -mios-version-min=7.0 \
        -arch arm64e -Xarch_arm64e -mios-version-min=14.0
}

macos-cc() {
    cc "$@" \
        -target unknown-apple-macos \
        -arch i386 -Xarch_i386 -mmacos-version-min=10.4 \
        -arch x86_64 -Xarch_x86_64 -mmacos-version-min=10.4 \
        -arch arm64 -Xarch_arm64 -mmacos-version-min=11.0 \
        -arch arm64e -Xarch_arm64e -mmacos-version-min=11.0
}

tvos-cc() {
    cc "$@" \
        -target unknown-apple-tvos \
        -arch arm64 -Xarch_arm64 -mtvos-version-min=9.0 \
        -arch arm64e -Xarch_arm64e -mtvos-version-min=14.0
}

ios-cc -o ubsan_minimal_ios.o ../lib/ubsan_minimal/ubsan_minimal_handlers.cpp -I../lib -c &
macos-cc -o ubsan_minimal_osx.o ../lib/ubsan_minimal/ubsan_minimal_handlers.cpp -I../lib -c &
tvos-cc -o ubsan_minimal_tvos.o ../lib/ubsan_minimal/ubsan_minimal_handlers.cpp -I../lib -c &

ios-cc -o ubsan_ios.o ../ubsan/ubsan.c -c &
macos-cc -o ubsan_osx.o ../ubsan/ubsan.c -c &
tvos-cc -o ubsan_tvos.o ../ubsan/ubsan.c -c &

wait

"$_TARGET-libtool" -static -o libclang_rt.ubsan_minimal_ios.a ubsan_minimal_ios.o
"$_TARGET-libtool" -static -o libclang_rt.ubsan_minimal_osx.a ubsan_minimal_osx.o
"$_TARGET-libtool" -static -o libclang_rt.ubsan_minimal_tvos.a ubsan_minimal_tvos.o
"$_TARGET-libtool" -static -o libclang_rt.ubsan_ios.a ubsan_ios.o
"$_TARGET-libtool" -static -o libclang_rt.ubsan_osx.a ubsan_osx.o
"$_TARGET-libtool" -static -o libclang_rt.ubsan_tvos.a ubsan_tvos.o
rm ./*.o

profilesrcs="
GCDAProfiling.c
InstrProfiling.c
InstrProfilingInternal.c
InstrProfilingValue.c
InstrProfilingBuffer.c
InstrProfilingFile.c
InstrProfilingMerge.c
InstrProfilingMergeFile.c
InstrProfilingNameVar.c
InstrProfilingVersionVar.c
InstrProfilingWriter.c
InstrProfilingPlatformDarwin.c
InstrProfilingRuntime.cpp
InstrProfilingUtil.c
"

for src in $profilesrcs; do
    ios-cc -o "${src}.o" "../lib/profile/$src" -I../include -DCOMPILER_RT_HAS_FCNTL_LCK -DCOMPILER_RT_HAS_UNAME -DCOMPILER_RT_HAS_ATOMICS -c &
done
wait
"$_TARGET-libtool" -static -o libclang_rt.profile_ios.a ./*.o
rm ./*.o

for src in $profilesrcs; do
    macos-cc -o "${src}.o" "../lib/profile/$src" -I../include -DCOMPILER_RT_HAS_FCNTL_LCK -DCOMPILER_RT_HAS_UNAME -DCOMPILER_RT_HAS_ATOMICS -c &
done
wait
"$_TARGET-libtool" -static -o libclang_rt.profile_osx.a ./*.o
rm ./*.o

for src in $profilesrcs; do
    tvos-cc -o "${src}.o" "../lib/profile/$src" -I../include -DCOMPILER_RT_HAS_FCNTL_LCK -DCOMPILER_RT_HAS_UNAME -DCOMPILER_RT_HAS_ATOMICS -c &
done
wait
"$_TARGET-libtool" -static -o libclang_rt.profile_tvos.a ./*.o
rm ./*.o

cp ./*.a "$_DESTDIR/var/usr/lib/clang/$llvmver/lib/darwin"
)

installlicense "$_SRCDIR/compiler-rt/LICENSE.TXT"

builddeb
