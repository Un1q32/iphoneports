#!/bin/sh
(
cd src || exit 1
cpu="${_TARGET%%-*}"
export PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
./configure --prefix=/var/usr --cross-prefix="$_TARGET-" --arch="$cpu" --target-os=darwin --stdc=c23 --disable-stripping --disable-debug --disable-doc --disable-avdevice --disable-static --enable-shared --enable-lto --enable-zlib --enable-lzma --enable-bzlib --enable-libxml2 --enable-openssl --enable-libdav1d --enable-libwebp --pkg-config="$(command -v pkg-config)"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ffmpeg bin/ffprobe 2>/dev/null
ldid -S"$_ENT" bin/ffmpeg bin/ffprobe
for lib in lib/*.dylib; do
    if ! [ -h "$lib" ]; then
        "$_TARGET-strip" "$lib" 2>/dev/null
        ldid -S"$_ENT" "$lib"
    fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ffmpeg.deb
