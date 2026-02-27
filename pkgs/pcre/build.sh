#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
[ "$_SUBSYSTEM" = "macos" ] && jit=--enable-jit
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-utf \
    --disable-static \
    --enable-pcretest-libreadline \
    --enable-pcregrep-libbz2 \
    --enable-pcregrep-libz \
    --disable-cpp \
    $jit
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/pcretest bin/pcregrep lib/libpcre.1.dylib lib/libpcreposix.0.dylib
)

installlicense "$_SRCDIR/LICENCE"

builddeb
