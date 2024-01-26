#!/bin/sh
(
cd src || exit 1
./configure --prefix=/var/usr --disable-static CC="$_TARGET-cc"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
for lib in lib/*.dylib; do
    if [ -f "$lib" ] && [ ! -h "$lib" ]; then
        llvm-strip "$lib"
        ldid -S"$_ENT" "$lib"
    fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lzlib.deb
