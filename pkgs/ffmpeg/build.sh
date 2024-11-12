#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O3 -flto extendhfsf2.c truncsfhf2.c -c
cpu="${_TARGET%%-*}"
./configure --prefix=/var/usr --cross-prefix="$_TARGET-" --arch="$cpu" --target-os=darwin --stdc=c23 --disable-stripping --disable-debug --disable-doc --disable-avdevice --extra-libs="$_PKGROOT/src/extendhfsf2.o $_PKGROOT/src/truncsfhf2.o" --disable-static --enable-shared --enable-lto --enable-zlib --enable-lzma --enable-bzlib --enable-libxml2 --enable-openssl --enable-libdav1d --enable-libwebp --pkg-config="$_PKGROOT/files/pc"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ffmpeg bin/ffprobe 2>/dev/null
ldid -S"$_ENT" bin/ffmpeg bin/ffprobe

cd lib || exit 1
for lib in pkgconfig/*.pc; do
  lib="${lib%.pc*}"
  lib="${lib##*/}"

  "$_TARGET-strip" "$(readlink "$lib.dylib")" 2>/dev/null
  ldid -S"$_ENT" "$(readlink "$lib.dylib")"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ffmpeg.deb
