#!/bin/sh -e
(
cd src
[ -d "$_SDK/usr/include/c++/4.2.1" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/man
"$_TARGET-strip" bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++/4.2.1" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg imagemagick.deb
