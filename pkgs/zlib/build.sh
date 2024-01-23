#!/bin/sh
(
cd src || exit 1
CHOST="$_TARGET" ./configure --prefix=/var/usr --shared
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libz.a
for file in lib/*.dylib; do
    if [ -f "$file" ] && [ ! -h "$file" ]; then
        llvm-strip "$file"
        ldid -S"$_ENT" "$file"
        break
    fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zlib.deb
