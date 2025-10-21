#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    --disable-nls \
    --disable-doc \
    --with-included-libtasn1 \
    --without-tpm2 \
    --without-p11-kit \
    --with-default-trust-store-file=/var/usr/etc/ssl/cert.pem \
    ac_cv_func_malloc_0_nonnull=yes \
    ac_cv_func_realloc_0_nonnull=yes
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
strip_and_sign bin/*
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
