#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBROTLI_DISABLE_TESTS=1
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
lib1="$("$_TARGET-otool" -D lib/libbrotlicommon.1.1.0.dylib | tail -1)"
lib2="$("$_TARGET-otool" -D lib/libbrotlidec.1.1.0.dylib | tail -1)"
lib3="$("$_TARGET-otool" -D lib/libbrotlienc.1.1.0.dylib | tail -1)"
"$_TARGET-install_name_tool" -id /var/usr/lib/libbrotlicommon.1.dylib lib/libbrotlicommon.1.1.0.dylib
"$_TARGET-install_name_tool" -id /var/usr/lib/libbrotlidec.1.dylib lib/libbrotlidec.1.1.0.dylib
"$_TARGET-install_name_tool" -id /var/usr/lib/libbrotlienc.1.dylib lib/libbrotlienc.1.1.0.dylib
"$_TARGET-install_name_tool" -change "$lib1" /var/usr/lib/libbrotlicommon.1.dylib lib/libbrotlidec.1.1.0.dylib
"$_TARGET-install_name_tool" -change "$lib1" /var/usr/lib/libbrotlicommon.1.dylib lib/libbrotlienc.1.1.0.dylib
"$_TARGET-install_name_tool" -change "$lib1" /var/usr/lib/libbrotlicommon.1.dylib bin/brotli
"$_TARGET-install_name_tool" -change "$lib2" /var/usr/lib/libbrotlidec.1.dylib bin/brotli
"$_TARGET-install_name_tool" -change "$lib3" /var/usr/lib/libbrotlienc.1.dylib bin/brotli
for bin in bin/brotli lib/libbrotlicommon.1.1.0.dylib lib/libbrotlidec.1.1.0.dylib lib/libbrotlienc.1.1.0.dylib; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg brotli.deb
