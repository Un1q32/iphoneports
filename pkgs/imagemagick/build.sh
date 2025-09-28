#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
[ -d "$_SDK/usr/include/c++" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/man
strip_and_sign bin/magick lib/libMagick++-7.Q16HDRI.5.dylib lib/libMagickCore-7.Q16HDRI.10.dylib lib/libMagickWand-7.Q16HDRI.10.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
