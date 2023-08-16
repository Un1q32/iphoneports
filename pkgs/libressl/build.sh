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
for bin in bin/openssl bin/ocspcheck lib/libcrypto.50.dylib lib/libssl.53.dylib lib/libtls.26.dylib; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libressl.deb
