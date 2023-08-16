#!/bin/sh
(
cd src || exit 1
./bootstrap
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
for bin in bin/brotli lib/libbrotlicommon.1.dylib lib/libbrotlidec.1.dylib lib/libbrotlienc.1.dylib; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg brotli.deb
