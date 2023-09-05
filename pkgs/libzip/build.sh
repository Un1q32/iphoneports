#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
lib="$("$_TARGET-otool" -D lib/libzip.5.5.dylib | tail -1)"
"$_TARGET-install_name_tool" -id /var/usr/lib/libzip.5.dylib lib/libzip.5.5.dylib
"$_TARGET-strip" lib/libzip.5.5.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libzip.5.5.dylib
for bin in bin/*; do
    "$_TARGET-install_name_tool" -change "$lib" /var/usr/lib/libzip.5.dylib "$bin"
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libzip.deb
