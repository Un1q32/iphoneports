#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
lib="$("$_OTOOL" -D lib/libzip.5.5.dylib | tail -1)"
"$_INSTALLNAMETOOL" -id /var/usr/lib/libzip.5.dylib lib/libzip.5.5.dylib
"$_INSTALLNAMETOOL" -change "$lib" /var/usr/lib/libzip.5.dylib bin/zipmerge
"$_INSTALLNAMETOOL" -change "$lib" /var/usr/lib/libzip.5.dylib bin/zipcmp
"$_INSTALLNAMETOOL" -change "$lib" /var/usr/lib/libzip.5.dylib bin/ziptool
"$_TARGET-strip" lib/libzip.5.5.dylib bin/* > /dev/null 2>&1
ldid -S"$_ENT" lib/libzip.5.5.dylib bin/*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libzip.deb
