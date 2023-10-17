#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
"$_MAKE" LIBTOOL="$_PKGROOT/src/libtool" -j8
"$_MAKE" LIBTOOL="$_PKGROOT/src/libtool" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/xo bin/xopo lib/libxo.0.dylib lib/libxo/encoder/libenc_cbor.0.dylib lib/libxo/encoder/libenc_csv.0.dylib lib/libxo/encoder/libenc_test.0.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/xo bin/xopo lib/libxo.0.dylib lib/libxo/encoder/libenc_cbor.0.dylib lib/libxo/encoder/libenc_csv.0.dylib lib/libxo/encoder/libenc_test.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libxo.deb
