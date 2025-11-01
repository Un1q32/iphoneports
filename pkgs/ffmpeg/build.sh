#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; then
    printf 'ffmpeg requires at least Mac OS X 10.5\n'
    mkdir pkg
    exit 0
fi

(
cd src
export PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
./configure \
    --prefix=/var/usr \
    --cross-prefix="$_TARGET-" \
    --arch="$_CPU" \
    --target-os=darwin \
    --stdc=c23 \
    --disable-stripping \
    --disable-debug \
    --disable-doc \
    --disable-avdevice \
    --disable-static \
    --enable-shared \
    --enable-lto \
    --enable-zlib \
    --enable-lzma \
    --enable-bzlib \
    --enable-libxml2 \
    --enable-openssl \
    --enable-libdav1d \
    --enable-libwebp \
    --pkg-config='pkg-config' \
    --enable-gpl \
    --enable-version3
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/ffmpeg bin/ffprobe
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

installlicense "$_SRCDIR/COPYING".GPLv3

builddeb
