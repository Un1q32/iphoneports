#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
[ "$_SUBSYSTEM" = "macos" ] && jit=--enable-jit
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    --enable-pcre2grep-libbz2 \
    --enable-pcre2grep-libz \
    --enable-pcre2test-libreadline \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    $jit
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/pcre2test bin/pcre2grep lib/libpcre2-8.0.dylib lib/libpcre2-16.0.dylib lib/libpcre2-32.0.dylib lib/libpcre2-posix.3.dylib
)

installlicense src/LICENCE.md

builddeb
