#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PKG_CONFIG_SYSROOT_DIR="$_SDK"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
for dylib in lib/*.dylib; do
    [ -h "$dylib" ] && continue
    "$_TARGET-strip" "$dylib" 2>/dev/null
    ldid -S"$_ENT" "$dylib"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libxcb.deb
