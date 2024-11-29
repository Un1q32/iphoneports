#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O3 -flto emutls.c -c
./configure --host="$_TARGET" --prefix=/var/usr --disable-doc --with-included-libtasn1 --without-p11-kit PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PKG_CONFIG_SYSROOT_DIR="$_SDK" LDFLAGS="$_PKGROOT/src/emutls.o"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/* lib/libgnutls.30.dylib lib/libgnutlsxx.30.dylib 2>/dev/null
ldid -S"$_ENT" bin/* lib/libgnutls.30.dylib lib/libgnutlsxx.30.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gnutls.deb
