#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc share/man
strip_and_sign bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
