#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/openssl > /dev/null 2>&1
"$_TARGET-strip" bin/ocspcheck > /dev/null 2>&1
"$_TARGET-strip" lib/libcrypto.50.dylib > /dev/null 2>&1
"$_TARGET-strip" lib/libssl.53.dylib > /dev/null 2>&1
"$_TARGET-strip" lib/libtls.26.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/openssl
ldid -S"$_BSROOT/ent.xml" bin/ocspcheck
ldid -S"$_BSROOT/ent.xml" lib/libcrypto.50.dylib
ldid -S"$_BSROOT/ent.xml" lib/libssl.53.dylib
ldid -S"$_BSROOT/ent.xml" lib/libtls.26.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libressl.deb
