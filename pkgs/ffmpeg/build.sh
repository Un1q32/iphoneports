#!/bin/sh
set -e
. ../../files/lib.sh

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
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/ffmpeg bin/ffprobe
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.GPLv3 "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
