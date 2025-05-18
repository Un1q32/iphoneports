#!/bin/sh -e
(
cd src
export PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
./configure --prefix=/var/usr --cross-prefix="$_TARGET-" --arch="$_CPU" --target-os=darwin --stdc=c23 --disable-stripping --disable-debug --disable-doc --disable-avdevice --disable-static --enable-shared --enable-lto --enable-zlib --enable-lzma --enable-bzlib --enable-libxml2 --enable-openssl --enable-libdav1d --enable-libwebp --pkg-config='pkg-config'
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_sign bin/ffmpeg bin/ffprobe
for lib in lib/*.dylib; do
    if ! [ -h "$lib" ]; then
        strip_and_sign "$lib"
    fi
done
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
