#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-doc --with-included-libtasn1 --without-p11-kit PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PKG_CONFIG_SYSROOT_DIR="$_SDK"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/* lib/libgnutls.30.dylib lib/libgnutlsxx.30.dylib 2>/dev/null
ldid -S"$_ENT" bin/* lib/libgnutls.30.dylib lib/libgnutlsxx.30.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gnutls.deb
