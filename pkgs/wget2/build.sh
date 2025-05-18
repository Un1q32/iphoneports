#!/bin/sh
set -e
(
cd src
autoreconf -f
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --with-openssl --with-lzma --with-bzip2 --without-gpgme --disable-static CPPFLAGS='-Wno-unknown-attributes' PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share bin/wget2_noinstall
strip_and_sign bin/wget2 lib/libwget.3.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
