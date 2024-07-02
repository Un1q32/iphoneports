#!/bin/sh
(
cd src || exit 1
CHOST="$_TARGET" ./configure --prefix=/var/usr --zlib-compat
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libz.a
for lib in lib/*.dylib; do
    if [ -f "$lib" ] && [ ! -h "$lib" ]; then
        "$_INSTALLNAMETOOL" -id /var/usr/lib/libz.1.dylib "$lib"
        llvm-strip "$lib"
        ldid -S"$_ENT" "$lib"
    fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zlib.deb
