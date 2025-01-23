#!/bin/sh -e
(
cd src || exit 1
autoreconf -f
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --with-openssl --with-lzma --with-bzip2 --without-gpgme --disable-static CPPFLAGS='-Wno-unknown-attributes' PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin/wget2_noinstall
"$_TARGET-strip" bin/wget2 lib/libwget.3.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/wget2 lib/libwget.3.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wget2.deb
