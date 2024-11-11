#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/doc share/man
"$_TARGET-strip" bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib 2>/dev/null
ldid -S"$_ENT" bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg imagemagick.deb
